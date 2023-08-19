#Runs on a NodeMCU

esphome:
  name: cv-floor-pump
  platform: ESP8266
  board: nodemcuv2
  on_boot:
    priority: -100 #lowest priority so start last
    then:
      - lambda: id(Relay01).turn_off();
      - lambda: id(CV_Floor_Pump_TemperatureTooHigh).turn_off();

# Enable logging
logger:
  level: DEBUG
  baud_rate: 115200
  id: logToLog

# Enable Home Assistant API
api:

ota:
  password: "7b085fc0fa8e77f3a73a6801ac74836a"

wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password
  reboot_timeout: 20hours # Reboots for the case that there is no wifi for more than 20 hours

  # Enable fallback hotspot (captive portal) in case wifi connection fails
  ap:
    ssid: "Cv-Floor-Pump Fallback Hotspot"
    password: "7oWPhG12698B"

captive_portal:

# Add virtual switch to remotely restart the ESP via HA
# https://esphome.io/components/switch/restart
button:
  - platform: restart
    name: "ESP_cv-floor-pump restart"

sensor:
# Define the temperature sensor. In this case the humidity sensor is not used
# CV_Floor_Pump_Temp_In
  - platform: dht
    pin: D5
    temperature:
      name: "CV_Floor_Pump_Temp_In"
      id: CV_Floor_Pump_Temp_In
    update_interval: 30s

# CV_Floor_Pump_Temp_Out
  - platform: dht
    pin: D6
    temperature:
      name: "CV_Floor_Pump_Temp_Out"
      id: CV_Floor_Pump_Temp_Out
    update_interval: 30s

#CV_Floor_Pump_Relay
switch:
  - platform: gpio
    pin:
      number: D7
      inverted: false
    id: Relay01
    name: CV_Floor_Pump_Relay #by providing a name the Relay01 will become visible in Home Assistant under the name as described by name

#CV_Floor_Pump_TemperatureTooHigh
  - platform: gpio
    pin:
      number: D2 #dummy as there is nothing connected, but needed to automatically create a switch in Home Assistant
    id: CV_Floor_Pump_TemperatureTooHigh
    name: CV_Floor_Pump_TemperatureTooHigh 

# TM1637
display:
    platform: tm1637
    id: tm1637_display
    clk_pin: D4
    dio_pin: D3
    intensity: 0 # Ranging from 0 - 7
    #Make sure that any comment in the lambda code block is started with // as all
    #  code in the block is C++.
    lambda: |-
      if (id(CV_Floor_Pump_Temp_In).has_state()) {
        it.printf(0, "%.0f", id(CV_Floor_Pump_Temp_In).state);
      }
      if (id(CV_Floor_Pump_Temp_Out).has_state()) {
        it.printf(2, "%.0f", id(CV_Floor_Pump_Temp_Out).state);
      }
#end code

#Get value from Helper in Home Assistant
#https://esphome.io/components/binary_sensor/homeassistant.html
binary_sensor:
  - platform: homeassistant
    id: override_from_home_assistant_helper
    entity_id: input_boolean.CV_Floor_Pump_override


#logic:


time:
  - platform: homeassistant
    id: homeassistant_time

    on_time:
      - seconds: /120  # needs to be set, otherwise every second this is triggered!
        minutes: '*'  # Trigger every 2 minutes
        then:
          lambda: !lambda |-
            auto time = id(homeassistant_time).now();
            int t_now = parse_number<int>(id(homeassistant_time).now().strftime("%H%M")).value();
            float temp_in = static_cast<int>(id(CV_Floor_Pump_Temp_In).state);
            float temp_out = static_cast<int>(id(CV_Floor_Pump_Temp_Out).state);
            if ((temp_in) >= 48)
              {
              id(Relay01).turn_off();
              id(CV_Floor_Pump_TemperatureTooHigh).turn_on();
              }
            if ((temp_in) >= 44)
              {
              id(Relay01).turn_off();
            }
            if (((temp_in) >= 43) || ((temp_out) >= 39))
              {
              id(Relay01).turn_off();
              }
            if (id(override_from_home_assistant_helper).state)
              {
                //Do nothing as the override is active which is set in Home Assistant
              }
            else
              {
              if ((t_now >= 600) && (t_now <= 2140))
                {
              	if (((temp_in) >= 25) && ((temp_in) > (temp_out)))
            		  {
            			id(Relay01).turn_on();
            			id(CV_Floor_Pump_TemperatureTooHigh).turn_off();
            			}
            		if (((temp_in) <= 22) || ((temp_in) < (temp_out)))
            		  {
            			id(Relay01).turn_off();
            			id(CV_Floor_Pump_TemperatureTooHigh).turn_off();
            			}
            		 }
              if ((t_now >= 2141) && (t_now <= 2150))
                {
                id(Relay01).turn_on();
                id(CV_Floor_Pump_TemperatureTooHigh).turn_off();
              	}
              if ((t_now >= 2151) && (t_now <= 2200))
                {
                id(Relay01).turn_off();
                id(CV_Floor_Pump_TemperatureTooHigh).turn_off();
                }
              }

