%calculates velocity of fluid using volume flow and pipe diameter
function velocity = fluidVelocity(q, d)
    velocity = 1.273 * (q / (d^2));
end