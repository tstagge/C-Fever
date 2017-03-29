% PROJECT 2: HYDROELECTRIC ENERGY STORAGE SYSTEM: MANUAL MODEL
% File:    filename.py
% Date:    31 March 2016
% By:      Jillian Hestle [jhestle]
%          Emily Schott [eschott]
%          Tyler Stagge [tstagge]
%          Nicholas Vilbrandt [nvilbran]
% Section  04
% Team:    57
%
% ELECTRONIC SIGNATURE
% Tyler J Stagge
% Aditya Desai
% Chris Schorr
% Alex Han
%
% The electronic signatures above indicate that the program     
% submitted for evaluation is the combined effort of all   
% team members and that each member of the team was an     
% equal participant in its creation.  In addition, each 
% member of the team has a general understanding of                  
% all aspects of the program development and execution.  
%
% This script is the manual version of our model, allowing a user to enter
% case-specific variables for a specific energy storage system -- pump and
% turbine efficiencies, pump and turbine volumetric flow rates, pipe
% length, pipe friction coeffcient, bend angles, bend loss coefficients, 
% reservoir elevation, reservoir height, etc -- and calculating a variety
% of system characteristics -- namely reservoir area, required input
% energy, time-to-fill, time-to-drain, total system efficiency, etc.


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

%% CALCULATIONS

Eout = 4.32E+11; %J
xi = [K1, K2];

%[ [Heights]; [Masses] ]
heightMassArray = masefield(Eout, nt, f, len, xi, Qturbine, diam, elevation);
numHM = length(heightMassArray);

eIns = [];
optEin = 1000000000;
optWaterVol = 0;
optArea = 0;
optTimeFill = 0;
optTimeEmpty = 0;

%mass = 1.07E9;

%WAIT, WAIT, WAIT
for(iHM = 1:numHM)
    if(heightMassArray(2,iHM) > 0) %SANITY CHECK 1; If mass > 0
        waterVol = heightMassArray(2, iHM) / 1000;
        area = reservoirSurfaceArea(waterVol, depth);
        timeFill = timeToFill(waterVol, Qpump); %h
        timeEmpty = timeToEmpty(waterVol, Qturbine); %h
        eInReq = energyInRequired(mass, np, f, len, xi, Qpump, diam, elevation + (depth/2));
        eIns = [eIns, eInReq];
        if(eInReq < optEin)
            optEin = eInReq;
            optWaterVol = waterVol;
            optArea = area;
            optTimeFill = timeFill;
            optTimeEmpty = timeEmpty;
        end
    else
        fprintf('ERROR: These parameters result in an invalid solution.\n');
        fprintf('       Try reducing volumetric flow rates.\n');
    end
end
   
optEfficiency = 120 / optEin; %MWh

%% OUTPUTS

fprintf('\nReservoir surface area: %.2f m^2\n', optArea);
fprintf('Input energy: %.2f MWh\n', optEin);
fprintf('System efficiency: %.2f\n', optEfficiency);
fprintf('Time to fill: %.2f hours\n', optTimeFill);
fprintf('Time to empty: %.2f hours\n', optTimeEmpty);