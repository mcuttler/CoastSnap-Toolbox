%% CSP_for_LGs

% This script collects user information required for running CSP workflows as an executable. 

%M Cuttler - July 2021

%% Get user data on where GitHub paths (needed for CSPsetPaths.m) and base path for CoastSnap directory (images, shorelines, etc.)
clear; clc; 
prompt = {'Enter full path for location of CoastSnapWA repository'}; 
dlgtitle = 'Input';
dims = [1 100];
definput = {'F:\Active_Projects\CUTTLER_CoastSnapWA\CoastSnapWA\Data\CoastSnapWA_LGs'};
answer = inputdlg(prompt,dlgtitle,dims,definput);


base_path = answer{1,:}; 
github_path = [base_path '\Code\GitHub']; 

clear prompt dlgtitle dims definput answer

%% run CSP download
%get site names
image_path = [base_path '\Images']; 
sites = dir(image_path); 
sites = sites(3:end); 
%clean up
idx = []; 
for i = 1:size(sites,1)
    if  ~strcmp(sites(i).name,'insert_newsitename_here')
        idx = [idx; i]; 
    end
end

%archive must now have aws_name.txt in the archive 
for i = 1:size(idx,1)
    siteDB{i,1} = sites(idx(i)).name; 
    dname = importdata([base_path '\Images\' sites(idx(i)).name '\aws_name.txt']); 
    site{i,1} = dname{:}; 
end

clear sites idx dname

%now download images

for i = 1:size(siteDB,1)
    disp(['Downloading images for ' siteDB{i} '...']); 
    CSPdownload(site{i}, siteDB{i}, base_path, image_path);
end
disp('Finished downloading'); 
f = msgbox('CSP STEP 1 COMPLETE - All CoastSnap images downloaded');





    
