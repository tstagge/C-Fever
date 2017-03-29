%time to empty 
function timeEmpty = timeToEmpty(waterVol, Qturbine)
    timeEmpty = (waterVol / Qturbine) / 3600;
end