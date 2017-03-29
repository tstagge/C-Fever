%work done by pump
function work = workPump(len, g, angle, fConst)
    work = len * (g * cos(angle) + g * fConst * cos(angle));
    %pretty sure this is work to overcome gravity plus friction
end