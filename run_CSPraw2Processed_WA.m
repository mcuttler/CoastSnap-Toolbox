%% Convert raw imagery for CoastSnapWA to processed
clear; clc; 
sites = {'binningup','bussojetty','dalyellup','eaton','koombanabay','shoalwater','prestonbeach','silversands'};

CSPsetPaths; 

for i = 1:length(sites)
    CSPraw2Processed(sites{i});
end


