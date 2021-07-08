%% CSP_for_LGs

% This script collects user information required for running CSP workflows as an executable. 

%M Cuttler - July 2021

%% Get user data on where GitHub paths (needed for CSPsetPaths.m) and base path for CoastSnap directory (images, shorelines, etc.)
clear; clc; 
prompt = {'Enter full path for location of CoastSnap toolboxes'; 'Enter full path for location of CoastSnap image database'};
dlgtitle = 'Input';
dims = [1 100];
definput = {'G:\CUTTLER_GitHub','C:\Users\00084142\Dropbox\Research\Active_Projects\CUTTLER_CoastSnapWA\CoastSnap'};
answer = inputdlg(prompt,dlgtitle,dims,definput);

github_path = answer{1,:};
base_path = answer{2,:}; 

% h = waitbar(0, 'Settings paths for CoastSnap workflow'); 
CSPsetPaths; 
% waitbar(5/10,h); 
CSPloadPaths; 
% waitbar(10/10, h); 
% close(h); 

clear prompt dlgtitle dims definput answer

%% run CSP download
%get site names
sites = dir([base_path '\Images']);
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
for i = 1:size(sites,1)    
    CSPdownload(site{i}, siteDB{i}, base_path, image_path);
end

f = msgbox('All CoastSnap images downloaded');




    
