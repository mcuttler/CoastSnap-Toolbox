%% Convert raw imagery for CoastSnapWA to processed

sites = {'binningup','bussojetty','dalyellup','eaton','koombanabay','shoalwater','prestonbeach','silversands'};

% CSPsetPaths; 
CSPloadPaths;

for i = 1:length(sites)
    t = datevec(now); 
    reg_path = [image_path '\' sites{i} '\Registered\' num2str(t(1))]; 
    CSPrename_registered_images(reg_path); 
end


%% now build GIF
clear; clc; 

sites_db = {'binningup','bussojetty','dalyellup','eaton','koombanabay','shoalwater','silversands'};
sites_nm = {'Binningup','Busselton Jetty','Dalyellup','Eaton Foreshore','Koombana Bay','Shoalwater','Silver Sands'}; 

% CSPsetPaths; 
CSPloadPaths;
tstart = datenum(2021,01,01); 
tend = datenum(2021,08,01); 

for j = 1:length(sites_db)
    CSPplot_registered_gif(image_path, sites_nm{j}, sites_db{j},tstart, tend); 
end

