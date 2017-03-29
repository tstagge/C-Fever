%friction loss in the pipes
function Hdw = frictionLoss(f,len,vel,diam,m)
    Hdw = m * ((f * len * (vel ^ 2)) / (2 * diam));
end