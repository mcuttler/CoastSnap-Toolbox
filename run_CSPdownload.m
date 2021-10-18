%% run CSP download for WA data

%read the aws_name in each folder, then download new data
CSPsetPaths;
CSPloadPaths;

%databse names
sitesDB = {'binningup';'bussojetty';'dalyellup';'eaton';'koombanabay';'prestonbeach';'shoalwater';'silversands'};

for s = 1:length(sitesDB)
    dd = importdata(fullfile(image_path,sitesDB{s},'aws_name.txt')); 
    site{s,1} = dd{:};
end

    
%% download imagery


for s = 1:length(sitesDB)
    disp(si
    CSPdownload(site{s},sitesDB{s},base_path, image_path); 
end
