%% Header
% Project 2
% Team 57
% Tyler Stagge, Nicholas Vilbrandt, Jillian Hestle, Emily Schott
% note: all bend angles assume the pipes go into the reservoir/
%       river at an angle
%% Input Variables

nt = 0; %turbine efficiency
np = 0; %pump efficiency

D = 0; %pipe inner diameter, m
f = 0; %friction factor
L = 0; %length of pipe, m
Hdw = 0; %head loss (friction loss), m

depth = 0; %reservoir depth, m
H = 0; %elevation of bottom of reservoir, m

Qpump = 0; %volumetric flow rate of pump, m^3/s
Qturbine = 0; %volumetric flow rate of turbine, m^3/s

K1 = 0; %bend coefficeint 1
K2 = 0; %bend coefficient 2

%% Output Varibles

A = 0; %reservoir surface area, m^2
timeFill = 0; %time to fill, h
timeEmpty = 0; %time to empty, h

eIn = 0; %energy in
ntot = 0; %total system efficiency

%% Working Variables

waterVol = 0; %volume of water in reservoir, m^3
waterHeight = 0; %height of water in reservoir, m
waterCM = 0; %center of mass of water in reservoir, m
waterMass = 0; %mass of water in reservoir, kg

velocity = 0; %velocity of water in pipes, m/s
Hdw = 0; %friction loss in pipes

k = 0; %kinetic energy of water, J
u = 0; %potential energy of water, J
massDisp = 0; %mass of water displaced in pipes, kg
work = 0; %work done by pump, J
%% Hard Coded Values

eOut = 120; %MWh
g = 9.81; %gravitational acceleration, m/s^2
dWater = 1000; %density of water, kg/m^3

%Site 1
1height = 30; %m
1distRiver = 60; %m
1minPipeLen = 67.08; %m
1elevAngle = 30; %degrees
1maxArea = 360,000; %m^2
1maxVol = 7,200,000; %m^3
1numBends = 0;
1bendAngles = [0]; %degrees

%Site 2
2height = 100; %m
2distRiver = 130; %m
2minPipeLen = 253.21; %m
2elevAngle = 60; %degrees
2maxArea = 25,617.38; %m^2
2maxVol = 512,347.54; %m^3
2numBends = 0;
2bendAngles = [0]; %degrees


%Site 3
3height = 65; %m
3distRiver = 91.2; %m
3minPipeLen = 114.56; %m
3elevAngle = 45.46; %degrees
3maxArea = 39,760.78; %m^2
3maxVol = 795,215.64; %m^3
3numBends = 1;
3bendAngles = [115]; %degrees


%% Main Function

% Input Prompts

np = input('Pump efficiency: ');
nt = input('Turbine efficiency: ');
D = input('Pipe diameter in meters: ');
L = input('Pipe length in meters: ');
f = input('Pipe friction factor: ');
depth = input('Reservoir depth in meters: ');
H = input('Elevation of bottom of reservoir in meters: ');
Qpump = input('Volumetric flow rate of pump in m^3/s: ');
Qturb = input('Volumetric flow rate of turbine in m^3/s: ');
K1 = input('Bend coefficient 1: ');
K2 = input('Bend coefficient 2: ');

% All kinds of crazy calculations

% Outputs

fprintf('\nReservoir surface area: %.2f m^2\n', A);
fprintf('Input energy: %.2f MWh\n', eIn);
fprintf('System efficiency: %.2f\n', ns);
fprintf('Time to fill: %.2f hours\n', timeFill);
fprintf('Time to empty: %.2f hours\n', timeEmpty);

%% User-Defined Functions

%reservoir surface area

%time to fill

%time to empty 

%friction loss in the pipes
function Hdw = frictionLoss(f,len,vel,diam,mass)
    Hdw = (f * (len)) * (mass) * ((vel ^ 2) / (2 * diam));
end

%kinetic energy of water
function k = kineticEnergy(mass, vel)
    k = 0.5 * mass * vel^2;
end

%potential energy of water
function u = potentialEnergy(mass, g, height)
    u = mass * g * height;
end

%total system efficiency
function efficiency = totalEfficiency(eIn, eOut)
    efficiency  = eOut/eIn;
end

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
    velocity = 1.273*(q / (d^2));
end

%input xi as an array for multiple bends
%returns a 2D array of masses and heights and plots it
function massHeight = Masefield(Eout, nT, f, L, D, xi, q, d, h)
    velocity = FluidVelocity(q, d);
    lossOut = Eout(1/nT);
    heights = [2.5+h:.01:10+h];
    gravH = 9.81 .* heights;
    frictionLoss = (f * L * velocity) / (2 * D);
    for i = 1:length(xi)
        lossBend(i) = xi(i) * (velocity ^ 2) / 2;
    end
    lossBendTotal = sum(lossBend);
    bottom = gravH - frictionLoss - lossBendTotal;
    masses = lossOut ./ bottom;
    plot(heights, masses);
    massHeight = [heights, masses];
end

function EIn = EnergyInRequired(m, nP, f, L, D, xi, q, d, h)
    velocity = FluidVelocity(q, d);
    ePotential = potentialEnergy(m, 9.81, h);
    frictionLoss = frictionLoss(f,L,velocity,d,m);
    for i = 1:length(xi)
        lossBend(i) = (xi(i) * (velocity ^ 2) / 2) * m;
    end
    lossBendTotal = sum(lossBend);
    top = ePotential + fictionLoss + lossBendTotal;
    EIn = top / (-nP);
end