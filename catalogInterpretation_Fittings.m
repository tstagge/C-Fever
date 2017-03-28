% Interpretting Catalog Data: FITTINGS

fittingsRaw = load('catalog_fittings.txt');
fittingsRawDim = size(fittingsRaw);
fittingsNumAngles = fittingsRawDim(2)-1; %Number of angles of fittings in catalog

fittingsAngles = fittingsRaw(1,1:fittingsNumAngles); %Row array of angles
fittingsLossCoeffs = fittingsRaw(2,1:fittingsNumAngles); %Row array of pipe loss ceofficients
fittingsIDs = fittingsRaw(3:end,1); %Column array of fitting internal diameters
fittingsCost = fittingsRaw(3:end, 2:end); %Rows vary ID; Columns vary angle (and thus efficiency)