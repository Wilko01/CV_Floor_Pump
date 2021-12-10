#CV_Floor_Pump
esphome:
  name: esp06
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
  password: "16c2972e32843010a0ebe73ea5698eca"

wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password
  reboot_timeout: 20hours # Reboots for the case that there is no wifi for more than 20 hours
  
  # Enable fallback hotspot (captive portal) in case wifi connection fails
  ap:
    ssid: "Esp06 Fallback Hotspot"
    password: "gSHMN961CTuf"

captive_portal:


time:
  - platform: homeassistant
    id: homeassistant_time

    on_time:
      - seconds: /30  # needs to be set, otherwise every second this is triggered!
        minutes: '*'  # Trigger every minute
        then:
          lambda: !lambda |-
            auto time = id(homeassistant_time).now();
            int t_now = parse_number<int>(id(homeassistant_time).now().strftime("%H%M")).value();
            float temp_in = static_cast<int>(id(CV_Floor_Pump_Temp_In).state);
            float temp_out = static_cast<int>(id(CV_Floor_Pump_Temp_Out).state);
            if ((temp_in) >= 44)
              {
              id(Relay01).turn_off();
              id(CV_Floor_Pump_TemperatureTooHigh).turn_on();
              }
            if (((temp_in) >= 40) || ((temp_out) >= 40))
              {
              id(Relay01).turn_off();
              }
            else
              {
              if ((t_now >= 600) && (t_now <= 2000))
                {
              	if (((temp_in) >= 27) && ((temp_in) > (temp_out)))
            		  {
            			id(Relay01).turn_on();
            			}
            		if (((temp_in) <= 25) || ((temp_in) < (temp_out)))
            		  {
            			id(Relay01).turn_off();
            			id(CV_Floor_Pump_TemperatureTooHigh).turn_off();
            			}
            		 }
              if ((t_now >= 2030) && (t_now <= 2040))
                {
                id(Relay01).turn_on();
              	}
              if ((t_now >= 2042) && (t_now <= 2100))
                {
                id(Relay01).turn_off();
                }
              }

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

