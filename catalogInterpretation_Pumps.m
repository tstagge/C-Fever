% Interpretting Catalog Data: PUMPS

pumpsRaw = load('catalog_pumps.txt');
pumpsRawDim = size(pumpsRaw);
pumpsNumQual = pumpsRawDim(2)-1; %Number of qualities of pipes in catalog

pumpsEfficiency = pumpsRaw(1,1:pumpsNumQual); %Row array of efficiencies corresponding to quality
pumpsEPR = pumpsRaw(2:end,1); %Column array of EPRs
pumpsCostPerQ = pumpsRaw(2:end, 2:end); %Rows vary EPR; Columns vary quality