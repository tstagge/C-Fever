%input xi as an array for multiple bends
%returns a 2D array of masses and heights and plots it
function massHeight = masefield(Eout, nT, f, L, xi, q, d, h)
    velocity = fluidVelocity(q, d);
    lossOut = Eout * (1/nT);
    heights = [2.5+h:.01:10+h];
    gravH = 9.81 .* heights;
    frictionLoss1 = (f * L * (velocity ^ 2)) / (2 * d);
    for i = 1:length(xi)
        lossBend(i) = xi(i) * (velocity ^ 2) / 2;
    end
    lossBendTotal = sum(lossBend);
    bottom = gravH - frictionLoss1 - lossBendTotal;
    masses = lossOut ./ bottom;
    massHeight = [heights, masses];
end
