%friction loss in the pipes
function Hdw = frictionLoss(f,len,vel,diam,g)
    Hdw = (f * (len / diam)) * ((vel ^ 2) / (2 * g));
end