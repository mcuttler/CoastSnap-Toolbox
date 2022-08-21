%% CSP_for_LGs - step 3

% This script collects user information required for running CSP workflows as an executable. 

% Step 3 is for making timelapse GIF 

%M Cuttler - July 2021clear; clc; 
%%
prompt = {'Enter full path for location of CoastSnapWA repository';
    'Enter timelapse start date (YYYY-MM-DD)'; 'Enter timelapse end date (YYYY-MM-DD)'; 
    'Enter site name as appears in CoastSnapWA database'; 'Enter normal site name'};
dlgtitle = 'Input';
dims = [1 100];
definput = {'F:\Active_Projects\CUTTLER_CoastSnapWA\CoastSnapWA\Data\CoastSnapWA_LGs';
    datestr(now,'yyyy-mm-dd');
    datestr(now,'yyyy-mm-dd');
    'bussojetty';'Busselton Jetty'};
answer = inputdlg(prompt,dlgtitle,dims,definput);

base_path = answer{1,:}; 
time_start = answer{2,:};
time_end = answer{3,:}; 
sites_db = answer{4,:}; 
sites = answer{5,:}; 

github_path = [base_path '\Code\GitHub']; 
image_path =  [base_path '\Images' ]; 
clear prompt dlgtitle dims definput answer

%% create pop up dialogue window to make sure user has created registered images
quest = ['You are about to create a timelapse video for ' sites ' ' 10 '- do you have Registered images for this site?'];     
qmenu = 'Timelapse video creation'; 
answer = questdlg(quest, qmenu, 'Yes','No','Yes'); 
	
if strcmp(answer,'Yes')
    %first rename the images to remove extra text from Photoshop
    for i = 1:size(sites_db,1) 
        if size(sites_db,1)==1
            dyrs = dir( [image_path '\' sites_db '\Registered']); 
        else
            dyrs = dir( [image_path '\' sites_db{i} '\Registered']); 
        end
        dyrs = dyrs(3:end); 

        for j = 1:size(dyrs,1)        
            if size(sites_db,1)==1
                reg_path = [image_path '\' sites_db '\Registered\' dyrs(j).name];                 
            else
                reg_path = [image_path '\' sites_db{i} '\Registered\' dyrs(j).name];          
            end
            CSPrename_registered_images(reg_path); 
        end
    end    

    %now create GIF    
    for i = 1:size(sites_db,1)    
        CSPplot_registered_gif(image_path, sites, sites_db, datenum(time_start), datenum(time_end))
    end    
    disp('Finished making timelapse!');
    f = msgbox('CSP STEP 3 COMPLETE - All CoastSnap timelapse created!');    
else
    disp(['Please add reigstered images to ' sites_db ' registered folder']); 
    f = msgbox(['CSP STEP 3 ERROR : Please add reigstered images to ' sites_db ' registered folder']);     
end






