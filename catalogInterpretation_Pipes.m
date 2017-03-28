% Interpretting Catalog Data: PIPES

pipesRaw = load('catalog_pipes.txt');
pipesRawDim = size(pipesRaw);
pipesNumQual = pipesRawDim(2)-1; %Number of qualities of pipes in catalog

pipesDarcyFric = pipesRaw(1,1:pipesNumQual); %Row array of friction factors corresponding to quality
pipesDiameters = pipesRaw(2:end,1); %Column array of diameters
pipesCosts = pipesRaw(2:end, 2:end); %Rows vary diameter; Columns vary quality