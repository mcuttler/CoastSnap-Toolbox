%% Rename registered images
%When exported from Adobe Photoshop, registered images have a leading
%prefix and addition '.jpg' appended --- this removes, and renames

%MCuttler - November 2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = CSP_rename_registered_images(sites_db, base_path, time_start, time_end)

%convert time_start from string to date
tstart = datenum(time_start,'yyyy-mm-dd'); 
tstart_vec= datevec(tstart); 

tend = datenum(time_end,'yyyy-mm-dd'); 
tend_vec = datevec(tend); 
%check if same years 
if tend_vec(1)==tstart_vec(1)
    impath = [base_path '\Images\' sites_db{j} '\Registered\' num2str(tstart_vec(1))]; 
    dum = dir(impath);
    dum = dum(3:end); 
else
    impath = [base_path '\Images\' sites_db{j} '\Registered\' num2str(tstart_vec(1))];
    impath2 = [base_path '\Images\' sites_db{j} '\Registered\' num2str(tend_vec(1))]; 
    dum = dir(impath);        
    dum = dum(3:end); 
    dum2 = dir(impath2); 
    dum2 = dum2(3:end); 
    
    dum = [dum; dum2]; 
end

%now rename 
for i = 1:size(dum,1)
    if dum(i).name(1) == '_'
        name_out = dum(i).name(7:end-4); 
        filein = [dum(i).folder '\' dum(i).name];
        fileout = [dum(i).folder '\' name_out];
        %make new file
        copyfile(filein, fileout); 
        %delete file
        delete(filein)
    end
end

end
