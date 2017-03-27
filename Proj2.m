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



%% Input Variables

nt = 0; %turbine efficiency
np = 0; %pump efficiency

D = 0; %pipe inner diameter, m
f = 0; %friction factor
L = 0; %length of pipe, m
Hdw = 0; %head loss of water, m

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
dWater = 1000; %density of water, kg/m^3


%% Main Function

% Input Prompts

np = input('Pump efficiency: ');
nt = input('Turbine efficiency: ');
D = input('Pipe diameter in meters: ');
L = input('Pipe length in meters: ');
f = input('Pipe friction factor: ');
depth = input('Reservoir depth in meters: ');
elevation = input('Elevation of bottom of reservoir in meters: ');
Qpump = input('Volumetric flow rate of pump in m^3/s: ');
Qturb = input('Volumetric flow rate of turbine in m^3/s: ');
K1 = input('Bend coefficient 1: ');
K2 = input('Bend coefficient 2: ');

% All kinds of crazy calculations
velocityUp = Qpump / pi * pow((D * 0.5), 2);
velocityDown = Qturbine / pi * pow((D * 0.5), 2);

% Outputs

fprintf('Reservoir surface area: %.2f m^2\n', A);
fprintf('Input energy: %.2f MWh\n', eIn);
fprintf('System efficiency: %.2f\n', ns);
fprintf('Time to fill: %.2f hours\n', timeFill);
fprintf('Time to empty: %.2f hours\n', timeEmpty);

%% User-Defined Functions

%reservoir surface area

%time to fill

%time to empty 

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
    

