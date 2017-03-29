siteNnumBends = [0,1,1];
siteNbendAngleIs = [[0]; [4]; [1]];
siteN = 3;

fittingsRaw = load('catalog_fittings.txt');
fittingsRawDim = size(fittingsRaw);
fittingsNumAngles = fittingsRawDim(2)-1; %Number of angles of fittings in catalog
fittingsNumLossK = fittingsNumAngles;

fittingsAngles = fittingsRaw(1,1:fittingsNumAngles); %Row array of angles
fittingsLossK = fittingsRaw(2,1:fittingsNumAngles); %Row array of pipe loss ceofficients
fittingsIDs = fittingsRaw(3:end,1); %Column array of fitting internal diameters
fittingsCost = fittingsRaw(3:end, 2:end); %Rows vary ID; Columns vary angle (and thus efficiency)



bendKs = [];
for(i = 1:siteN)
    if(~(siteNnumBends(i) == 0))
        %fprintf('Hello');
        for(j = 1:siteNnumBends(i))
            %fprintf('%d\n', fittingsLossK(siteNbendAngleIs(i,j)));
            bendKs = [bendKs, fittingsLossK(siteNbendAngleIs(i,j))];
        end
    else
        %fprintf('Goodbye');
        bendKs = [bendKs, 0];
    end
end