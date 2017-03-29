%% Optimization, bitch!

%% CLEAR COMMANDS
clc; clear;

%% CATALOG DATA INPUT

%PIPES
pipesRaw = load('catalog_pipes.txt');
pipesRawDim = size(pipesRaw);
pipesNumFric = pipesRawDim(2)-1; %Number of qualities of pipes in catalog

pipesDarcyFric = pipesRaw(1,1:pipesNumFric); %Row array of friction factors corresponding to quality
pipesDiameters = pipesRaw(2:end,1); %Column array of diameters
pipesNumDiameters = length(pipesDiameters);
pipesCosts = pipesRaw(2:end, 2:end); %Rows vary diameter; Columns vary quality

%FITTINGS
fittingsRaw = load('catalog_fittings.txt');
fittingsRawDim = size(fittingsRaw);
fittingsNumAngles = fittingsRawDim(2)-1; %Number of angles of fittings in catalog
fittingsNumLossK = fittingsNumAngles;

fittingsAngles = fittingsRaw(1,1:fittingsNumAngles); %Row array of angles
fittingsLossK = fittingsRaw(2,1:fittingsNumAngles); %Row array of pipe loss ceofficients
fittingsIDs = fittingsRaw(3:end,1); %Column array of fitting internal diameters
fittingsCost = fittingsRaw(3:end, 2:end); %Rows vary ID; Columns vary angle (and thus efficiency)

%PUMPS
%FIXME: include pump volumetric flow rate min and max in fileIO
pumpsRaw = load('catalog_pumps.txt');
pumpsRawDim = size(pumpsRaw);
pumpsNumEfficiencies = pumpsRawDim(2)-1; %Number of qualities of pumps in catalog

pumpsEfficiencies = pumpsRaw(1,1:pumpsNumEfficiencies); %Row array of efficiencies corresponding to quality
pumpsEPR = pumpsRaw(2:end,1); %Column array of EPRs
pumpsCostPerQ = pumpsRaw(2:end, 2:end); %Rows vary EPR; Columns vary quality

%TURBINES
%FIXME: include turbine volumetric flow rate min and max in fileIO
turbinesRaw = load('catalog_turbines.txt');
turbinesRawDim = size(turbinesRaw);
turbinesNumEfficiencies = turbinesRawDim(2)-1; %Number of qualities of turbines in catalog

turbinesEfficiencies = turbinesRaw(1,1:turbinesNumEfficiencies); %Row array of efficiencies corresponding to quality
turbinesEPD = turbinesRaw(2:end,1); %Column array of EPDs
turbinesCostPerQ = turbinesRaw(2:end, 2:end); %Rows vary EPD; Columns vary quality

%% SITE DATA
% Might want to redo this as fileIO, but this is fine for now

siteNheight = [30, 100, 65]; %m
siteNdistRiver = [60, 130, 91.2]; %m
siteNminPipeL = [67.08, 253.21, 114.56]; %m
siteNelevAngle = [30, 60, 45.46]; %deg
siteNmaxArea = [360000, 25617.38, 39760.78]; %m^2
siteNmaxVol = [7200000, 512347.54, 795215.64]; %m^3; why not just calculate?
siteNnumBends = [0,1,1];
siteNbendAnglesActual = [[0]; [60]; [25]]; %deg
siteNbendAngleIs = [[0]; [4]; [1]]; %Currently rounding 25 to 20
siteNbendKs = [[]; []; []]; %Will be calculated in data interpretation/calculations section

siteNroadCost = [40000, 100000, 150000];
siteNprepCostPerArea = [0.25, 0.50, 0.90]; %The 0.90 for site 3 includes the added cost of replanting
siteNadditionalCost = [8000, 2000, 0];

siteN = length(siteNheight); %Number of sites

%% DATA INTERPRETATION/CALCULATIONS

siteNbendKs = [];
for(i = 1:siteN)
    if(~(siteNnumBends(i) == 0))
        %fprintf('Hello');
        for(j = 1:siteNnumBends(i))
            %fprintf('%d\n', fittingsLossK(siteNbendAngleIs(i,j)));
            siteNbendKs = [siteNbendKs, fittingsLossK(siteNbendAngleIs(i,j))];
        end
    else
        %fprintf('Goodbye');
        siteNbendKs = [siteNbendKs, 0];
    end
end

%^^^For real program, need to:
% 1)Take actual angles, find closest approximate combination
% 2)^Get those indeces
% 3)Get list of corresponding bend coefficients

%% DESIGN ITERATION

%eOut = 4.32E+11; %J
eOut = 120; %MWh

% Site
% pipe diameter
% pipe friction factor (quality)
% turbine efficiency
% turbine flow rate (1:1?:500)
% pump efficiency
% pump flowrate
% bend diameter = pipe diameter
% bend loss coefficient

numCombos = 0;
numValid = 0;
leastEIn = 100000000000;
optPipeD = 0;
optPipeF = 0;
optTurbN = 0;
optTurbQ = 0;
optPumpN = 0;
optPumpQ = 0;
optBendKs = [];
optSite = 0;
optM = 0;
optHcom = 0;

highestN = 0;
eIns = [];

fprintf('Starting loop from hell...\n');
for(iSite = 1:siteN) %Index
    for(iPipeD = 1:pipesNumDiameters) %Index
        for(iPipeF = 1:pipesNumFric) %Index
            for(iTurbN = 1:turbinesNumEfficiencies) %Index
                for(turbQ = 100:200:500) %Value! (Step will certainly be adjusted)
                    for(iPumpN = 1:pumpsNumEfficiencies) %Index
                        for(pumpQ = 100:200:500) %Value! (Step will certainly be adjusted)
                            %---------VARIABLE ASSIGNMENT-----------
                            pipeD = pipesDiameters(iPipeD);
                            pipeF = pipesDarcyFric(iPipeF);
                            turbN = turbinesEfficiencies(iTurbN);
                            turbQ = turbQ;
                            pumpN = pumpsEfficiencies(iPumpN);
                            pumpQ = pumpQ;
                            %bendD = pipeD; %assumption
                            pipeL = siteNminPipeL(iSite);
                            siteH = siteNheight(iSite);
                            bendKs = siteNbendKs(iSite);

                            %----------ENERGY CALCULATIONS-----------
                            %masefield(Eout, nT, f, L, xi, q, d, h)
                            %energyInRequired(m, nP, f, L, xi, q, d, h)
                            hm = masefield(eOut,turbN,pipeF,pipeL,bendKs,turbQ,pipeD,siteH); %Note: assuming the q in the masefield parameters is turbQ and not pumpQ
                            
                            %heightCOM = hm(1,1); %FIXME: currently just choosing the first height-mass combo
                            %massTot = hm(2,1);
                            
                            numHM = length(hm);
                            for(iHM = 1:numHM)
                                if(hm(2,iHM) > 0) %If mass > 0
                               
                                    waterVol = hm(2, iHM) / 1000;

                                    area = reservoirSurfaceArea(waterVol, (hm(1,iHM) - siteH) * 2);

                                    timeFill = timeToFill(waterVol, pumpQ); %h
                                    timeEmpty = timeToEmpty(waterVol, turbQ); %h
                                    
                                    if ((timeFill < 12) && (timeEmpty < 12) && (area < siteNmaxArea(iSite))) 
                                        eIn = energyInRequired(hm(2,iHM),pumpN,pipeF,pipeL,bendKs,pumpQ,pipeD,hm(1,iHM));
                                        if(eIn < leastEIn) %Temporary until we can actually rank based on TDR
                                            leastEIn = eIn;
                                            optPipeD = pipeD;
                                            optPipeF = pipeF;
                                            optTurbN = turbN;
                                            optTurbQ = turbQ;
                                            optPumpN = pumpN;
                                            optPumpQ = pumpQ;
                                            optSite = iSite;
                                            optBendKs = bendKs;
                                            optHcom = hm(1,iHM);
                                            optM = hm(2,iHM);
                                            efficiency = 120 / leastEIn;
                                        end
                                        numValid = numValid + 1;
                                    end
                                end
                                numCombos = numCombos + 1;
                            end
                            
                            
%                             if((eOut/eIn) > highestN)
%                                 highestN = (eOut/eIn);
%                             end

                            %-----------COST CALCULATIONS-------------
%                             hTopOfRes = siteH + (2*(heightCOM-siteH));
% 
%                             pipeCost = pipeL * pipesCosts(iPipeD, iPipeF);
%                             turbCost = turbQ * turbinesCostPerQ(hTopOfRes, iTurbN);
%                             pumpCost = pumpQ * pumpsCostPerQ(hTopOfRes, iPumpN);
%                             bendCost = 0; %FIXME!!!
%                             siteCost = siteNroadCost(iSite) + siteNadditionalCost(iSite) + (siteNprepCostPerArea(iSite) * 1); %FIXME: where is area calculated?
%                             wallCost = 0; 
%
%                             totalCost = pipeCost + turbCost + pumpCost + bendCost + siteCost + wallCost;
% 
%                             %-----------RATING------------------------
%                             TDR = getTotalDesignRating(eIn, totalCost);
% 
                             
                        end
                    end
                end
            end
        end
    end
end

fprintf('Total design combinations tried: %d\n', numCombos);
fprintf('Total valid designs tried: %d\n', numValid);
fprintf('Percent valid: %f%%\n', ((numValid/numCombos)*100) );
fprintf('Minimum Energy-In found: %f\n', leastEIn);
%fprintf('Highest efficiency found: %f\n', highestN);

