%input xi as an array for multiple bends
%calculates the energy required to pump up a mass of water
%NICK -- what did we say? h is the heightCOM? or the siteHeight? (the
% former, right?)
function EIn = energyInRequired(m, nP, f, L, xi, q, d, h)
    velocity = fluidVelocity(q, d);
    ePotential = potentialEnergy(m, h);
    frictionLoss1 = frictionLoss(f,L,velocity,d,m);
    for i = 1:length(xi)
        lossBend(i) = ((xi(i) * (velocity ^ 2)) / 2) * m;
    end
    lossBendTotal = sum(lossBend);
    top = ePotential + frictionLoss1 + lossBendTotal;
    EInJ = top / (nP);
    EIn = EInJ * 2.7778E-10;
end