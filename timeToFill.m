%time to fill
function timeFill = timeToFill(waterVol, Qpump)
    timeFill = (waterVol / Qpump) / 3600;
end