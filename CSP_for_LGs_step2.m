%% CSP_for_LGs - step 2

% This script collects user information required for running CSP workflows as an executable. 

Step 2 is for running raw2processed

%M Cuttler - July 2021clear; clc; 
%%
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

%% run raw2processed

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

sites = sites(idx); 

for i = 1:size(sites,1)
    
    try
        CSPraw2Processed(sites(i).name)
    catch ME
         f = msgbox(ME.message);        
    end       
    
end


