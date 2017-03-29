%energy lost by pipe fittings, will be positive
function fits = eFittingLoss(m, xi, V)
    fits = m(xi * (V ^ 2)/ 2);
end