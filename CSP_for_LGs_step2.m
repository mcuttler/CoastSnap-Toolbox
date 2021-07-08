%% CSP_for_LGs - step 2

% This script collects user information required for running CSP workflows as an executable. 

% Step 2 is for running raw2processed

%M Cuttler - July 2021clear; clc; 
%%
clear; clc; 
prompt = {'Enter full path for location of CoastSnapWA repository'}; 
dlgtitle = 'Input';
dims = [1 100];
definput = {'F:\Active_Projects\CUTTLER_CoastSnapWA\CoastSnapWA\Data\CoastSnapWA_LGs'};
answer = inputdlg(prompt,dlgtitle,dims,definput);


base_path = answer{1,:}; 
github_path = [base_path '\Code\GitHub']; 

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

disp('Finished processing RAW CoastSnapWA imagery'); 
f = msgbox('CSP STEP 2 COMPLETE - All CoastSnapWA images renamed and moved to processed');

