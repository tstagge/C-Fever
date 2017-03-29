%input xi as an array for multiple bends
%calculates the energy required to pump up a mass of water
function EIn = energyInRequired(m, nP, f, L, xi, q, d, h)
    velocity = FluidVelocity(q, d);
    ePotential = potentialEnergy(m, h);
    frictionLoss1 = frictionLoss(f,L,velocity,d,m);
    for i = 1:length(xi)
        lossBend(i) = (xi(i) * (velocity ^ 2) / 2) * m;
    end
    lossBendTotal = sum(lossBend);
    top = ePotential + fictionLoss + lossBendTotal;
    EIn = top / (nP);
end