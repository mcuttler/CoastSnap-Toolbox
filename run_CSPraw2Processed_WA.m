%% Convert raw imagery for CoastSnapWA to processed
sites = {'binningup','bussojetty','dalyellup','eaton','koombanabay','shoalwater','prestonbeach','silversands'};

CSPsetPaths;
CSPloadPaths;

disp('paths set, processing raw images'); 
for i = 1:length(sites)
    CSPraw2Processed(sites{i});
end


