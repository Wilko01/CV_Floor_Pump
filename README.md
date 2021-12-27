# CV_Floor_Pump
Control the CV floor pump based on the CV inlet temperature

## Release notes
[Release notes](Relase_notes.MD)

## Description and operation instructions
The CV floorpump will automatically turn on and off during a predefined timewindow by measuring the inlet temperature. The CV floor pump will be turned on above a defined inlet temperature and turned off below a defined temperature. A green led is on at the moment that the pump is on. When the temperature is above a defined temperature, the pump is turned off to make sure there is no damage to the floor when the temperature would be too high. Additional there will be a trigger towards Home Assistant where NodeRed receives the signal and sends an email and a virtual switch named ‘Floor temp too high’ is triggered. The functionality in Home Assistant is just for visualisation and emailing. The pump operates independently of Home assistant. The virtual switch will be reset once the temperature is below a certain value. The values are hard coded into the code of the ESP CV pump module (NodeMCU). The 7 segment LEDs at the module show the temperature. The 2 most left 7 segments LEDs are the inlet and the 2 most right 7 segments LEDs are the outlet temperature. At a defined time at the end of the day the pump will regularly run to ensure that it will not get stuck when it is not running for a long period. The code to run the pump regularly is hardcoded in the module.

## Technical description
The ESP CV pomp module is the hart to turn the CV floor pump on and off. The temperatures of the in and outlet readings including the 'too high' will be send from the ESP to Home Assistant. NodeRed monitors the too high and sends an email when this happens. The Module can operate without MQTT or Home Assistant, but will reboot once there is no connection to Home Assistant for more than 20 hours. The code is pushed over the air to the NodeMCU via ESPHOME.

### Parts 
1 x NodeMCU

<img src="Images/ESP8266_NodeMCU.jpg" alt="drawing" width="500"/>


2 x DHT11

<img src="Images/DHT11.jpg" alt="drawing" width="150"/>


1 x TM1637

<img src="Images/TM1637.jpg" alt="drawing" width="200"/>


1 x BC547B

<img src="Images/BC547B.jpg" alt="drawing" width="200"/>


1 x Relay

<img src="Images/Relay.jpg" alt="drawing" width="200"/>


1 x Capacitor 1uF
1 x Green Led
1 x 1k Resistor
2 x 30k Resistor
2 x 3 PCB screw connector



### Schematic overview
![Schematic overview](Images/Schematic_overview.jpg)
 
Connect NodeMCU with:
•	Temp sensor 01 to read the temperature at the incoming pipe.
•	Temp sensor 02 to read the temperature at the outgoing pipe. Is not used in any logic. For measurement only.
•	A relay to turn the pump on.
•	A led that can be placed at the outside of the box to indicate that the pump is on.
•	Use a LED display TM1637 to indicate the current in and out temperature. 2 most left are CV in. The two most right figures are CV out.

### ESPHOME installation
See the instructions https://github.com/Wilko01/ESPHome (not listed here)



### Interface 
#### Home Assistant
Home Assistant is connected via ESPHOME.

##### Add identities to HA 
• In Home Assistant click on the notification and add the new device under ESPHOME

##### Create NodeRed flow
• Create the flow to mail when the temperature is too high

##### Dashboard
• Create the dashboard and add the temperature sensors


### Testing
#### Turn on the floor pump
##### Pre condition
- Within timewindow 06:00 - 20:00
##### Test
- Heat up till above 27'
##### Expected result
- The floorpump should run

#### Turn off the floor pump
##### Pre condition
- Within timewindow 06:00 - 20:00
##### Test
- Heat up till above 27' to let the floorpump run
- Cool down till below 25'C
##### Expected result
- The floorpump should stop

#### Turn off the floor pump
##### Pre condition
- Within timewindow 06:00 - 20:00
- The floorpump is running
- The temp_in is above 28'C
##### Test
- Heat up till above 40'
##### Expected result
- The floorpump should stop

### Information
- [ESPHOME](https://esphome.io)
- [ESPHOME Automation](https://esphome.io/guides/automations.html#config-lambda)

Generic
- [Markdown Cheat Sheet](https://www.markdownguide.org/cheat-sheet/)


### Problems
..

### Wishlist
..


### Code
[Code in ESPHOME](code.vbs)