%IN(notes) xi as an array for multiple bends
% h is the elevation of the reservoir? (the bottom?) -- NICK, COMMENT ON
% THIS
%returns a 2D array of masses and heights
%takes in height of center of mass - height of resevoir
function mass = whitman(Eout, nT, f, L, xi, q, d, h, depth)
    Eout = 4.32E11;
    velocity = fluidVelocity(q, d);
    lossOut = Eout * (1/nT);
    height = h + (depth/2);
    gravH = 9.81 * height;
    frictionLoss1 = (f * L * (velocity ^ 2)) / (2 * d);
    for i = 1:length(xi)
        lossBend(i) = xi(i) * (velocity ^ 2) / 2;
    end
    lossBendTotal = sum(lossBend);
    bottom = gravH - frictionLoss1 - lossBendTotal;
    mass = lossOut / bottom;
end
