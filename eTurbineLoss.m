%energy lost by the turbine, will be positive
function loss = eTurbineLoss(eOut, nT)
    loss = eOut(1/nT - 1);
end