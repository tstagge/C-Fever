% Project 2, Team 57
% HYDROELECTRIC ENERGY STORAGE SYSTEM: AUTOMATIC OPTIMIZATION MODEL 
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
pumpsNumEPR = length(pumpsEPR);
pumpsCostPerQ = pumpsRaw(2:end, 2:end); %Rows vary EPR; Columns vary quality

%TURBINES
%FIXME: include turbine volumetric flow rate min and max in fileIO
turbinesRaw = load('catalog_turbines.txt');
turbinesRawDim = size(turbinesRaw);
turbinesNumEfficiencies = turbinesRawDim(2)-1; %Number of qualities of turbines in catalog

turbinesEfficiencies = turbinesRaw(1,1:turbinesNumEfficiencies); %Row array of efficiencies corresponding to quality
turbinesEPD = turbinesRaw(2:end,1); %Column array of EPDs
turbinesNumEPD = length(turbinesEPD);
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

eOut = 120; %MWh; 4.32E+11 in J

numCombos = 0;
numValid = 0;

allCosts = [];
allEfficiencies = [];

maxTDR = 0;
maxEff = 0;
minCost = 10000000000000000;

%Record Arrays Legend
% 1-Cheapest Solution; 2-Best Solution(TDR); 3-Highest Efficiency Solution
optPipeD = [0; 0; 0];
optPipeF = [0; 0; 0];
optTurbN = [0; 0; 0];
optTurbQ = [0; 0; 0];
optPumpN = [0; 0; 0];
optPumpQ = [0; 0; 0];
optBendKs = [[];[];[]];
optSite = [0; 0; 0];
optM = [0; 0; 0];
optHWall = [0; 0; 0];
optCost = [0; 0; 0];
optArea = [0; 0; 0];
optTimeFill = [0; 0; 0];
optTimeEmpty = [0; 0; 0];
optEin = [0; 0; 0];

fprintf('Calculating.');
for(iSite = 1:siteN) %Index
    for(iPipeD = 1:pipesNumDiameters) %Index
        for(iPipeF = 1:pipesNumFric) %Index
            for(iTurbN = 1:turbinesNumEfficiencies) %Index
                for(turbQ = 100:100:500) %Value! (Step will certainly be adjusted)
                    for(iPumpN = 1:pumpsNumEfficiencies) %Index
                        for(pumpQ = 100:100:500) %Value! (Step will certainly be adjusted)
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
                            hm = masefield(eOut,turbN,pipeF,pipeL,bendKs,turbQ,pipeD,siteH);
                            numHM = length(hm);
                            for(iHM = 1:numHM)
                                if(hm(2,iHM) > 0) %SANITY CHECK 1; If mass > 0
                               
                                    waterVol = hm(2, iHM) / 1000;
                                    area = reservoirSurfaceArea(waterVol, (hm(1,iHM) - siteH) * 2);
                                    timeFill = timeToFill(waterVol, pumpQ); %h
                                    timeEmpty = timeToEmpty(waterVol, turbQ); %h
                                    
                                    if ((timeFill < 12) && (timeEmpty < 12) && (area < siteNmaxArea(iSite))) %SANITY CHECK 2 and 3
                                        eIn = energyInRequired(hm(2,iHM),pumpN,pipeF,pipeL,bendKs,pumpQ,pipeD,hm(1,iHM));
                                        
                                        %%-----------COST CALCULATIONS-------------
                                        hTopOfRes = siteH + (2*(hm(1,iHM)-siteH));
                                        hWall = 2*(hm(1,iHM)-siteH);
                                        
                                        %Find indices for pumpEPR and turbEPD
                                        i = 1;
                                        while((pumpsEPR(i) < hTopOfRes) && (i < pumpsNumEPR))
                                            i = i + 1;
                                        end
                                        iPumpEPR = i;
                                        i = 1;
                                        while((turbinesEPD(i) < hTopOfRes) && (i < turbinesNumEPD))
                                            i = i + 1;
                                        end
                                        iTurbEPD = i;

                                        pipeCost = pipeL * pipesCosts(iPipeD, iPipeF);
                                        turbCost = turbQ * turbinesCostPerQ(iTurbEPD, iTurbN);
                                        pumpCost = pumpQ * pumpsCostPerQ(iPumpEPR, iPumpN);
                                        bendCost = 0; %FIXME!!!
                                        siteCost = siteNroadCost(iSite) + siteNadditionalCost(iSite) + (siteNprepCostPerArea(iSite) * area); %FIXME: where is area calculated?
                                        wallCost = costOfWall(hWall, (2 * pi) * sqrt(area / pi)); 

                                        totalCost = pipeCost + turbCost + pumpCost + bendCost + siteCost + wallCost;

                                        %-----------RATING------------------------
                                        eff = 120 / eIn;
                                        TDR = getTotalDesignRating(eIn, totalCost);
                                        
                                        %------------RECORDING------------
                                        if (totalCost < minCost) %CHEAPEST
                                            minCost = totalCost;
                                            optPipeD(1) = pipeD;
                                            optPipeF(1) = pipeF;
                                            optTurbN(1) = turbN;
                                            optTurbQ(1) = turbQ;
                                            optPumpN(1) = pumpN;
                                            optPumpQ(1) = pumpQ;
                                            optSite(1) = iSite;
                                            optBendKs(1) = bendKs;
                                            optHWall(1) = hm(1,iHM);
                                            optM(1) = hm(2,iHM);
                                            optEff(1) = eff;
                                            optCost(1) = totalCost;
                                            optArea(1) = area;
                                            optTimeFill(1) = timeFill;
                                            optTimeEmpty(1) = timeEmpty;
                                            optEin(1) = eIn;
                                        end
                                        
                                        if(TDR > maxTDR) %BEST (TDR)
                                            maxTDR = TDR;
                                            optPipeD(2) = pipeD;
                                            optPipeF(2) = pipeF;
                                            optTurbN(2) = turbN;
                                            optTurbQ(2) = turbQ;
                                            optPumpN(2) = pumpN;
                                            optPumpQ(2) = pumpQ;
                                            optSite(2) = iSite;
                                            optBendKs(2) = bendKs;
                                            optHWall(2) = hm(1,iHM);
                                            optM(2) = hm(2,iHM);
                                            optEff(2) = eff;
                                            optCost(2) = totalCost;
                                            optArea(2) = area;
                                            optTimeFill(2) = timeFill;
                                            optTimeEmpty(2) = timeEmpty;
                                            optEin(2) = eIn;
                                        end
                                        
                                        if(eff > maxEff)
                                            maxEff = eff;
                                            optPipeD(3) = pipeD;
                                            optPipeF(3) = pipeF;
                                            optTurbN(3) = turbN;
                                            optTurbQ(3) = turbQ;
                                            optPumpN(3) = pumpN;
                                            optPumpQ(3) = pumpQ;
                                            optSite(3) = iSite;
                                            optBendKs(3) = bendKs;
                                            optHWall(3) = hm(1,iHM);
                                            optM(3) = hm(2,iHM);
                                            optEff(3) = eff;
                                            optCost(3) = totalCost;
                                            optArea(3) = area;
                                            optTimeFill(3) = timeFill;
                                            optTimeEmpty(3) = timeEmpty;
                                            optEin(3) = eIn;
                                        end
                                        
                                        
                                        %allCosts = [allCosts, totalCost];
                                        %allEfficiencies = [allEfficiencies, efficiency];
                                        numValid = numValid + 1;
                                    end
                                end
                                numCombos = numCombos + 1;
                            end
                        end
                    end
                end
            end
        end
        fprintf('.');
    end
end
fprintf('DONE\n\n');

%% OUTPUTS

% Calculation Stats
fprintf('Total design combinations tried: %d\n', numCombos);
fprintf('Total valid designs tried: %d\n', numValid);
fprintf('Percent valid: %f%%\n', ((numValid/numCombos)*100) );
printLine();
fprintf('                    OPTIMUM  SOLUTION                   \n');
fprintf('System efficiency: %.2f\n', optEff(2));
fprintf('Total cost: $ %.2f\n\n', optCost(2));
fprintf('Energy input required: %.2f MWh\n', optEin(2));
fprintf('Area of resevoir: %.2f m^2\n', optArea(2));
fprintf('Time to fill: %.2f hr\n', optTimeFill(2));
fprintf('Time to empty: %.2f hr\n', optTimeEmpty(2));
printLine();
fprintf('                LEAST EXPENSIVE SOLUTION                 \n');
fprintf('System efficiency: %.2f\n', optEff(1));
fprintf('Total cost: $ %.2f\n\n', optCost(1));
fprintf('Energy input required: %.2f MWh\n', optEin(1));
fprintf('Area of resevoir: %.2f m^2\n', optArea(1));
fprintf('Time to fill: %.2f hr\n', optTimeFill(1));
fprintf('Time to empty: %.2f hr\n', optTimeEmpty(1));
printLine();
fprintf('                HIGHEST EFFICIENCY SOLUTION                \n');
fprintf('System efficiency: %.2f\n', optEff(3));
fprintf('Total cost: $ %.2f\n\n', optCost(3));
fprintf('Energy input required: %.2f MWh\n', optEin(3));
fprintf('Area of resevoir: %.2f m^2\n', optArea(3));
fprintf('Time to fill: %.2f hr\n', optTimeFill(3));
fprintf('Time to empty: %.2f hr\n', optTimeEmpty(3));
printLine();
%plot(allCosts, allEfficiencies, 'o');

% answer = input('Would you like to know more? ', 's');
% 
% if (strcmp('Y', answer) == 1)
%     
%     fprintf('Max Total Design Rating: %f\n', maxTDR);
%     fprintf('Corresponding efficiency: %f\n', optEff);
%     fprintf('Corresponding site number: %d\n', optSite);
%     %fprintf('Minimum Energy-In found: %f\n', leastEIn);
%     fprintf('Maximum efficiency: %f\n', maxEff);
% end


