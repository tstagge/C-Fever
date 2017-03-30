% Project 2, Team 57
% HYDROELECTRIC ENERGY STORAGE SYSTEM: MANUAL MODEL 
%
% This script is the manual version of our model, allowing a user to enter
% case-specific variables for a specific energy storage system -- pump and
% turbine efficiencies, pump and turbine volumetric flow rates, pipe
% length, pipe friction coeffcient, bend angles, bend loss coefficients, 
% reservoir elevation, reservoir height, etc -- and calculating a variety
% of system characteristics -- namely reservoir area, required input
% energy, time-to-fill, time-to-drain, total system efficiency, etc.


%% CLEAR COMMANDS
%clc;
clear;

%% MANUAL USER INPUTS

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

%% CALCULATIONS

Eout = 4.32E+11; %J
xi = [K1, K2];

mass = whitman(Eout, nt, f, len, xi, Qturbine, diam, elevation, depth);

if (mass < 0)
    fprintf('ERROR: These parameters result in an invalid solution.\n');
    fprintf('       Try reducing volumetric flow rates.\n');
else
    waterVol = mass / 1000;
    area = reservoirSurfaceArea(waterVol, depth);
    timeFill = timeToFill(waterVol, Qpump); %h
    timeEmpty = timeToEmpty(waterVol, Qturbine); %h
    eInReq = energyInRequired(mass, np, f, len, xi, Qpump, diam, elevation + (depth/2));
    efficiency = 120 / eInReq;
    fprintf('\nReservoir surface area: %.2f m^2\n', area);
    fprintf('Input energy: %.2f MWh\n', eInReq);
    fprintf('System efficiency: %.2f\n', efficiency);
    fprintf('Time to fill: %.2f hours\n', timeFill);
    fprintf('Time to empty: %.2f hours\n', timeEmpty);
end
