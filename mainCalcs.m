%% Main Function

clc;
clear;

% Input Prompts

%np = input('Pump efficiency: ');
nt = input('Turbine efficiency: ');
diam = input('Pipe diameter in meters: ');
len = input('Pipe length in meters: ');
f = input('Pipe friction factor: ');
depth = input('Reservoir depth in meters: ');
elevation = input('Elevation of bottom of reservoir in meters: ');
%Qpump = input('Volumetric flow rate of pump in m^3/s: ');
Qturbine = input('Volumetric flow rate of turbine in m^3/s: ');
K1 = input('Bend coefficient 1: ');
K2 = input('Bend coefficient 2: ');

% All kinds of crazy calculations
velocityUp = Qpump / pi * pow((D * 0.5), 2);
velocityDown = Qturbine / pi * pow((D * 0.5), 2);
waterVol = waterMass / waterDensity;

Eout = 4.32E+11;
xi = [K1, K2];

massHeights = Masefield(Eout, nt, f, len, xi, Qturbine, diam, elevation);

% Outputs

%fprintf('\nReservoir surface area: %.2f m^2\n', A);
%fprintf('Input energy: %.2f MWh\n', eIn);
%fprintf('System efficiency: %.2f\n', ns);
%fprintf('Time to fill: %.2f hours\n', timeFill);
%fprintf('Time to empty: %.2f hours\n', timeEmpty);

%% User-Defined Functions

%reservoir surface area
function A = reservoirSurfaceArea(waterVol, depth)
    A = waterVol / depth;
end

%time to fill
function timeFill = timeToFill(waterVol, Qpump)
    timeFill = waterVol / Qpump;
end
    
%time to empty 
function timeEmpty = timeToEmpty(waterVol, Qturbine)
    timeEmpty = waterVol / Qturbine;
end

%friction loss in the pipes
function Hdw = frictionLoss(f,len,vel,diam,g)
    Hdw = (f * (len / diam)) * ((vel ^ 2) / (2 * g));
end

%potential energy of water
function u = potentialEnergy(mass, height)
    u = mass * 9.81 * height;
end

%total system efficiency
%function efficiency = totalEfficiency(eIn, eOut)
%    efficiency = eOut/eIn;
%end

%work done by pump
function work = workPump(len, g, angle, fConst)
    work = len * (g * cos(angle) + g * fConst * cos(angle));
    %pretty sure this is work to overcome gravity plus friction
end
    
%energy lost by the turbine, will be positive
function loss = ETurbineLoss(eOut, nT)
    loss = eOut(1/nT - 1);
end

%energy lost by pipe fittings, will be positive
function fits = EFittingLoss(m, xi, V)
    fits = m(xi * (V ^ 2)/ 2);
end

%calculates velocity of fluid using volume flow and pipe diameter
function velocity = FluidVelocity(q, d)
    velocity = 1.273 * (q / (d^2));
end

%input xi as an array for multiple bends
%returns a 2D array of masses and heights and plots it
function massHeight = Masefield(Eout, nT, f, L, xi, q, d, h)
    velocity = FluidVelocity(q, d);
    lossOut = Eout(1/nT);
    heights = [2.5+h:.01:10+h];
    gravH = 9.81 .* heights;
    frictionLoss = (f * L * velocity) / (2 * d);
    for i = 1:length(xi)
        lossBend(i) = xi(i) * (velocity ^ 2) / 2;
    end
    lossBendTotal = sum(lossBend);
    bottom = gravH - frictionLoss - lossBendTotal;
    masses = lossOut ./ bottom;
    plot(heights, masses);
    massHeight = [heights, masses];
end

%input xi as an array for multiple bends
%calculates the energy required to pump up a mass of water
function EIn = EnergyInRequired(m, nP, f, L, xi, q, d, h)
    velocity = FluidVelocity(q, d);
    ePotential = potentialEnergy(m, h);
    frictionLoss = frictionLoss(f,L,velocity,d,m);
    for i = 1:length(xi)
        lossBend(i) = (xi(i) * (velocity ^ 2) / 2) * m;
    end
    lossBendTotal = sum(lossBend);
    top = ePotential + fictionLoss + lossBendTotal;
    EIn = top / (nP);
end