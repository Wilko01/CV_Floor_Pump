# CV-FloorPump
Control the CV floor pump based on the CV inlet temperature

## Description and operation instructions
De vloerverwarmingspomp gaat automatisch aan en uit door de temperatuur van de CV invoerleiding te meten. De uitvoer temperatuur wordt gemeten, maar wordt niets mee gedaan. Boven een bepaalde temperatuur gaat de pomp aan en onder een bepaalde temperatuur gaat deze uit. Als de pomp draait dan is de groene led aan. Wanneer de temperatuur te hoog wordt dan wordt de pomp uitgeschakeld. Deze temperaturen zijn geprogrammeerd in de code. De 8LEDs op de ESP CV pomp module geven de temperatuur aan waarbij de 2 linker 8LEDs de invoer en de 2 rechter 8LEDs de uitvoer temperatuur weergeven. 
Op het moment dat de temperatuur boven de maximale temperatuur uitkomt, dan wordt de pomp uitgeschakeld en in Home Assistant wordt er een virtuele schakelaar genaamd ‘Floor temp to high’ aan gezet. Wilko krijgt hier een mail van. Deze virtuele schakelaar dient met de schakelaar ‘Reset floor temp to high’ weer uitgezet te worden. Eerder zal de vloerverwarmingspomp niet draaien. 

## Technical description
De ESP CV pomp module is het hart voor het aan en afschakelen van de vloerverwarmingspomp. De temperatuur en dat de invoertemperatuur te heet was worden middels MQTT tussen de ESP CV pomp en Home Assistant uitgewisseld. Zonder MQTT of Home Assistant kan de ESP CV pomp zijn werk doen.

### Parts
..

### Schematic overview
![Schematic overview](Images/Schematic_overview.jpg)
 
Connect NodeMCU with:
•	Temp sensor 01 to read the temperature at the incoming pipe.
•	Temp sensor 02 to read the temperature at the outgoing pipe. Is not used in any logic. For measurement only.
•	A relay to turn the pump on.
•	A led that can be placed at the outside of the box to indicate that the pump is on.
•	Use a LED display TM1637 to indicate the current in and out temperature. 2 most left are CV in. The two most right figures are CV out.

### Interface
#### Home Assistant

### Testing
Test command to turn the relay on: `http://192.168.201.64/control?cmd=gpio,13,1` 13 = D7

### Information
..


### Problems
..

### Wishlist
..

### Code
#### Rules Set 1
`//All annotation is stored in the backup of the script to let the #chars be below 2048!

on System#Boot do
    gpio,13,0
    
    Let,1,[CV_Floor_Temp_In#Temperature]*100+[CV_Floor_Temp_Out#Temperature] 

     
    7don
    7db,1
    7dn,[var#1]
    
    timerSet,1,60
endon

on Rules#Timer=1 do
    If %systime% > 06:00:00
        If %systime% < 20:00:00
            Publish,ESP05_CV_Floor/status/insideOfOperationalHours,on
            Let,1,[CV_Floor_Temp_In#Temperature]*100+[CV_Floor_Temp_Out#Temperature]
            if [CV_Floor_Temp_In#Temperature] > 45
                gpio,13,0 //turn the relais off
                Publish,ESP05_CV_Floor/status/TemperatureTooHigh,on
            endif
            
            if [CV_Floor_Temp_In#Temperature] > 30
                gpio,13,1
            endif
            
            if [CV_Floor_Temp_In#Temperature] < 22
            gpio,13,0
            Publish,ESP05_CV_Floor/status/TemperatureTooHigh,off
            endif
        else
            gpio,13,0
            Publish,ESP05_CV_Floor/status/insideOfOperationalHours,off
        endif
    else
        gpio,13,0
        Publish,ESP05_CV_Floor/status/insideOfOperationalHours,off
  endif
    7dn,[var#1]
    
    Publish,ESP05_CV_Floor/status/CV_Floor_Temp_In,[CV_Floor_Temp_In#Temperature]
    Publish,ESP05_CV_Floor/status/CV_Floor_Temp_Out,[CV_Floor_Temp_Out#Temperature]
    Publish,ESP05_CV_Floor/status/CV_Pump_Relay,[CV_Pump_Relay#State]

    timerSet,1,60
endon`
