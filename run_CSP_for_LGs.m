%% CSP_for_LGs

This script collects user information required for running CSP workflows as an executable. 

%M Cuttler - May 2020

%% Get user data on where GitHub paths (needed for CSPsetPaths.m) and base path for CoastSnap directory (images, shorelines, etc.)
prompt = {'Enter full path for location of CoastSnap toolboxes'; 'Enter full path for location of CoastSnap image database'};
dlgtitle = 'Input';
dims = [1 100];
definput = {'G:\CUTTLER_GitHub','C:\Users\00084142\Dropbox\Research\Active_Projects\CUTTLER_CoastSnapWA\CoastSnap'};
answer = inputdlg(prompt,dlgtitle,dims,definput);

github_path = answer{1,:};
base_path = answer{2,:}; 

CSP_setPaths; 
CSP_loadPaths; 

clear prompt dlgtitle dims definput answer
%% run CSPraw2Processed for all sites

sites = dir([base_path '\Images']); sites = sites(3:end); 
for i = 1:size(sites,1); 
    
    
