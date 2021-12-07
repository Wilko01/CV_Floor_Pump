on System#Boot do
    gpio,13,0
    Let,1,[CV_Floor_Pump_Temp_In#Temperature]*100+[CV_Floor_Pump_Temp_Out#Temperature] 
    7don
    7db,1
    7dn,[var#1]
    timerSet,1,60
endon
on Rules#Timer=1 do
 If [%systime%]>06:00:00 and [%systime%]<22:00:00
  Publish,ESP06_CV_Floor_Pump/status/insideOfOperationalHours,on
  Let,1,[CV_Floor_Pump_Temp_In#Temperature]*100+[CV_Floor_Pump_Temp_Out#Temperature]
  if [CV_Floor_Pump_Temp_In#Temperature]>=45
   gpio,13,0
   Publish,ESP06_CV_Floor_Pump/status/TemperatureTooHigh,on
  endif
  if [CV_Floor_Pump_Temp_In#Temperature]>=42 and [CV_Floor_Pump_Temp_In#Temperature]<45
   gpio,13,0
  endif
  if [CV_Floor_Pump_Temp_In#Temperature]>=30 and [CV_Floor_Pump_Temp_In#Temperature]>[CV_Floor_Pump_Temp_Out#Temperature] and [CV_Floor_Pump_Temp_In#Temperature]<42
   gpio,13,1
  endif
  if [CV_Floor_Pump_Temp_In#Temperature]<=22 or [CV_Floor_Pump_Temp_In#Temperature]<[CV_Floor_Pump_Temp_Out#Temperature]
   gpio,13,0
   Publish,ESP06_CV_Floor_Pump/status/TemperatureTooHigh,off
  endif
 else
  gpio,13,0
  Publish,ESP06_CV_Floor_Pump/status/insideOfOperationalHours,off
 endif

 If [%systime%]>20:05:00 and [%systime%]<20:15:00
  if [CV_Floor_Pump_Temp_In#Temperature]<42
   gpio,13,1
   Publish,ESP06_CV_Floor_Pump/status/CV_Floor_Pump_Relay,[CV_Floor_Pump_Relay#State]
  endif
 endif

 7dn,[var#1]
  Publish,ESP06_CV_Floor_Pump/status/CV_Floor_Pump_Temp_In,[CV_Floor_Pump_Temp_In#Temperature]
  Publish,ESP06_CV_Floor_Pump/status/CV_Floor_Pump_Temp_Out,[CV_Floor_Pump_Temp_Out#Temperature]
  Publish,ESP06_CV_Floor_Pump/status/CV_Floor_Pump_Relay,[CV_Floor_Pump_Relay#State]
 timerSet,1,60

endon

