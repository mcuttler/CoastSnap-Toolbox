%% Rename registered images
%When exported from Adobe Photoshop, registered images have a leading
%prefix and addition '.jpg' appended --- this removes, and renames

%MCuttler - November 2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = rename_registered_images(reg_path)

dum = dir(reg_path); 
dum = dum(3:end); 

for i = 1:size(dum,1); 
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
