%% Header
% Project 2
% Team 57
% Tyler Stagge, Nicholas Vilbrandt, Jillian Hestle, Emily Schott
%
% Notes:    Dependent on site used; need to decide
%           Do we factor in cost to this program or do we need to 
%           calculate that separately and use it as a justification?
%
% Last Edit: Jillian Hestle Mar 27 5:15 pm



% note: all bend angles assume the pipes go into the reservoir/
%       river at an angle
%% Input Variables

clc;
clear;

nt = 0; %turbine efficiency
np = 0; %pump efficiency

diam = 0; %pipe inner diameter, m
f = 0; %friction factor
len = 0; %length of pipe, m
Hdw = 0; %head of water (friction loss), m

depth = 0; %reservoir depth, m
elevation = 0; %elevation of bottom of reservoir, m

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

velocityUp = 0; %velocity of water in pipes going up, m/s
velocityDown = 0; %velocity of water in pipes going down, m/s
Hdw = 0; %friction loss in pipes

k = 0; %kinetic energy of water, J
u = 0; %potential energy of water, J
massDisp = 0; %mass of water displaced in pipes, kg
work = 0; %work done by pump, J

%% Hard Coded Values

eOut = 120; %MWh
g = 9.81; %gravitational acceleration, m/s^2
waterDensity = 1000; %density of water, kg/m^3

%Site 1
height1 = 30; %m
distRiver1 = 60; %m
minPipeLen1 = 67.08; %m
elevAngle1 = 30; %degrees
maxArea1 = 360000; %m^2
maxVol1 = 7200000; %m^3
numBends1 = 0;
bendAngles1 = [0]; %degrees

%Site 2
height2 = 100; %m
distRiver2 = 130; %m
minPipeLen2 = 253.21; %m
elevAngle2 = 60; %degrees
maxArea2 = 25617.38; %m^2
maxVol2 = 512347.54; %m^3
numBends2 = 1;
bendAngles2 = [60]; %degrees


%Site 3
height3 = 65; %m
distRiver3 = 91.2; %m
minPipeLen3 = 114.56; %m
elevAngle3 = 45.46; %degrees
maxArea3 = 39760.78; %m^2
maxVol3 = 795215.64; %m^3
numBends3 = 1;
bendAngles3 = [115]; %degrees


%% Main Function

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
    efficiency = eOut/eIn;
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

function EIn = EnergyInRequired(m, nP, f, L, xi, q, d, h)
    velocity = FluidVelocity(q, d);
    ePotential = potentialEnergy(m, 9.81, h);
    frictionLoss = frictionLoss(f,L,velocity,d,m);
    for i = 1:length(xi)
        lossBend(i) = (xi(i) * (velocity ^ 2) / 2) * m;
    end
    lossBendTotal = sum(lossBend);
    top = ePotential + fictionLoss + lossBendTotal;
    EIn = top / (nP);
end
