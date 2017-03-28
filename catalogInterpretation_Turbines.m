% Interpretting Catalog Data: TURBINES

turbinesRaw = load('catalog_turbines.txt');
turbinesRawDim = size(turbinesRaw);
turbinesNumQual = turbinesRawDim(2)-1; %Number of qualities of turbines in catalog

turbinesEfficiency = turbinesRaw(1,1:turbinesNumQual); %Row array of efficiencies corresponding to quality
turbinesEPD = turbinesRaw(2:end,1); %Column array of EPDs
turbinesCostPerQ = turbinesRaw(2:end, 2:end); %Rows vary EPD; Columns vary quality