% Optimization, bitch!

%% SITE DATA (Currently copied from main Proj2.m file)

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
2numBends = 1;
2bendAngles = [60]; %degrees


%Site 3
3height = 65; %m
3distRiver = 91.2; %m
3minPipeLen = 114.56; %m
3elevAngle = 45.46; %degrees
3maxArea = 39,760.78; %m^2
3maxVol = 795,215.64; %m^3
3numBends = 1;
3bendAngles = [115]; %degrees

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

%Need to check if mass

