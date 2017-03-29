%calculates velocity of fluid using volume flow and pipe diameter
function velocity = fluidVelocity(q, d)
    velocity = q / (pi * ((d * 0.5)^ 2));
end