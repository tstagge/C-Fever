%% PROJECT 2
% Team 57
% Manual Driver


%% CLEAR COMMANDS
clc;
clear;

%% INPUTS

np = input('Pump efficiency: ');
nt = input('Turbine efficiency: ');
diam = input('Pipe diameter in meters: ');
len = input('Pipe length in meters: ');
f = input('Pipe friction factor: ');
depth = input('Reservoir depth in meters: ');
elevation = input('Elevation of bottom of reservoir in meters: ');
Qpump = input('Volumetric flow rate of pump in m^3/s: ');
Qturbine = input('Volumetric flow rate of turbine in m^3/s: ');
K1 = input('Bend coefficient 1: ');
K2 = input('Bend coefficient 2: ');

% % All kinds of crazy calculations
% velocityUp = Qpump / pi * pow((D * 0.5), 2);
% velocityDown = Qturbine / pi * pow((D * 0.5), 2);
% waterVol = waterMass / waterDensity;

Eout = 4.32E+11; %J
xi = [K1, K2];

massHeights = masefield(Eout, nt, f, len, xi, Qturbine, diam, elevation);

mass = 1.07E9;

eInReq = energyInRequired(mass, np, f, len, xi, Qpump, diam, elevation + (depth/2));

waterVol = mass / 1000;

area = reservoirSurfaceArea(waterVol, depth);

timeFill = timeToFill(waterVol, Qpump); %h
timeEmpty = timeToEmpty(waterVol, Qturbine); %h

efficiency = 120 / eInReq; %MWh

% Outputs

%fprintf('\nReservoir surface area: %.2f m^2\n', A);
%fprintf('Input energy: %.2f MWh\n', eIn);
%fprintf('System efficiency: %.2f\n', ns);
%fprintf('Time to fill: %.2f hours\n', timeFill);
%fprintf('Time to empty: %.2f hours\n', timeEmpty);