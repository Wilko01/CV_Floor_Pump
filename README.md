# CV-FloorPump
Control the CV floor pump based on the inlet temperature

## OVERZICHTSBESCHRIJVING CV VLOERVERWARMINGSPOMP
De vloerverwarmingspomp gaat automatisch aan en uit door de temperatuur van de CV invoerleiding te meten. De uitvoer temperatuur wordt gemeten, maar wordt niets mee gedaan. Boven een bepaalde temperatuur gaat de pomp aan en onder een bepaalde temperatuur gaat deze uit. Als de pomp draait dan is de groene led aan. Wanneer de temperatuur te hoog wordt dan wordt de pomp uitgeschakeld. Deze temperaturen zijn geprogrammeerd in de code. De 8LEDs op de ESP CV pomp module geven de temperatuur aan waarbij de 2 linker 8LEDs de invoer en de 2 rechter 8LEDs de uitvoer temperatuur weergeven. 
Op het moment dat de temperatuur boven de maximale temperatuur uitkomt, dan wordt de pomp uitgeschakeld en in Home Assistant wordt er een virtuele schakelaar genaamd ‘Floor temp to high’ aan gezet. Wilko krijgt hier een mail van. Deze virtuele schakelaar dient met de schakelaar ‘Reset floor temp to high’ weer uitgezet te worden. Eerder zal de vloerverwarmingspomp niet draaien. 

## 3.5	TECHNISCHE BESCHRIJVING CV VLOERVERWARMINGSPOMP
De ESP CV pomp module is het hart voor het aan en afschakelen van de vloerverwarmingspomp. De temperatuur en dat de invoertemperatuur te heet was worden middels MQTT tussen de ESP CV pomp en Home Assistant uitgewisseld. Zonder MQTT of Home Assistant kan de ESP CV pomp zijn werk doen.


 
Connect NodeMCU with:
•	Temp sensor 01 to read the temperature at the incoming pipe.
•	Temp sensor 02 to read the temperature at the outgoing pipe. Is not used in any logic. For measurement only.
•	A relay to turn the pump on.
•	A led that can be placed at the outside of the box to indicate that the pump is on.
•	Use a LED display TM1637 to indicate the current in and out temperature. 2 most left are CV in. The two most right figures are CV out.

