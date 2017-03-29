% Optimization, bitch!

%% SITE DATA (Currently copied from main Proj2.m file)

%Site 1
site1height = 30; %m
site1distRiver = 60; %m
site1minPipeLen = 67.08; %m
site1elevAngle = 30; %degrees
site1maxArea = 360,000; %m^2
site1maxVol = 7,200,000; %m^3
site1numBends = 0;
site1bendAngles = [0]; %degrees

%Site 2
site2height = 100; %m
site2distRiver = 130; %m
site2minPipeLen = 253.21; %m
site2elevAngle = 60; %degrees
site2maxArea = 25,617.38; %m^2
site2maxVol = 512,347.54; %m^3
site2numBends = 1;
site2bendAngles = [60]; %degrees


%Site 3
site3height = 65; %m
site3distRiver = 91.2; %m
site3minPipeLen = 114.56; %m
site3elevAngle = 45.46; %degrees
site3maxArea = 39,760.78; %m^2
site3maxVol = 795,215.64; %m^3
site3numBends = 1;
site3bendAngles = [115]; %degrees

%% SITE DATA, REDUX

siteNheight = [30, 100, 65]; %m
siteNdistRiver = [60, 130, 91.2]; %m
siteNminPipeL = [67.08, 253.21, 114.56]; %m
siteNelevAngle = [30, 60, 45.46]; %deg
siteNmaxArea = [360000, 25617.38, 39760.78]; %m^2
siteNmaxVol = [7200000, 512347.54, 795215.64]; %m^3
siteNnumBends = [0,1,1];
siteNbendAngles = [[0], [60], [115]]; %deg

%% CATALOG DATA INPUT

%PIPES
pipesRaw = load('catalog_pipes.txt');
pipesRawDim = size(pipesRaw);
pipesNumFric = pipesRawDim(2)-1; %Number of qualities of pipes in catalog

pipesDarcyFric = pipesRaw(1,1:pipesNumFric); %Row array of friction factors corresponding to quality
pipesDiameters = pipesRaw(2:end,1); %Column array of diameters
pipesCosts = pipesRaw(2:end, 2:end); %Rows vary diameter; Columns vary quality

%FITTINGS
fittingsRaw = load('catalog_fittings.txt');
fittingsRawDim = size(fittingsRaw);
fittingsNumAngles = fittingsRawDim(2)-1; %Number of angles of fittings in catalog

fittingsAngles = fittingsRaw(1,1:fittingsNumAngles); %Row array of angles
fittingsLossCoeffs = fittingsRaw(2,1:fittingsNumAngles); %Row array of pipe loss ceofficients
fittingsIDs = fittingsRaw(3:end,1); %Column array of fitting internal diameters
fittingsCost = fittingsRaw(3:end, 2:end); %Rows vary ID; Columns vary angle (and thus efficiency)

%PUMPS
pumpsRaw = load('catalog_pumps.txt');
pumpsRawDim = size(pumpsRaw);
pumpsNumEfficiencies = pumpsRawDim(2)-1; %Number of qualities of pumps in catalog

pumpsEfficiency = pumpsRaw(1,1:pumpsNumEfficiencies); %Row array of efficiencies corresponding to quality
pumpsEPR = pumpsRaw(2:end,1); %Column array of EPRs
pumpsCostPerQ = pumpsRaw(2:end, 2:end); %Rows vary EPR; Columns vary quality

%TURBINES
turbinesRaw = load('catalog_turbines.txt');
turbinesRawDim = size(turbinesRaw);
turbinesNumEfficiencies = turbinesRawDim(2)-1; %Number of qualities of turbines in catalog

turbinesEfficiency = turbinesRaw(1,1:turbinesNumEfficiencies); %Row array of efficiencies corresponding to quality
turbinesEPD = turbinesRaw(2:end,1); %Column array of EPDs
turbinesCostPerQ = turbinesRaw(2:end, 2:end); %Rows vary EPD; Columns vary quality



%% DESIGN ITERATION

% REFERENCE: Function calls
% Masefield(Eout, nT, f, L, D, xi, q, d, h)
% EnergyInRequired(m, nP, f, L, D, xi, q, d, h)

% Site 1
% pipe diameter
% pipe friction factor (quality)
% turbine efficiency
% turbine flow rate (1:1?:500)
% pump efficiency
% pump flowrate