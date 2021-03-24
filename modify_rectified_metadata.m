%% modify metadata for registered mapping

function [] = modify_rectified_metadata(site); 

for i = 1:length(site)
    rect_path = ['C:\Users\00084142\Dropbox\Research\Active_Projects\CUTTLER_CoastSnapWA\CoastSnap\Images\' site{i} '\Rectified\2020']; 
    dum = dir(rect_path); dum = dum(3:end); 
    
    for j =1 :length(dum); 
        if strcmp(dum(j).name(end-2:end),'mat')
            load([dum(j).folder '\' dum(j).name]); 
            
            if isnan(metadata.gcps.UVpicked)
                %fill with zeros
                [m,~] = size(metadata.gcps.xyzMeas); 
                metadata.gcps.UVpicked = zeros(m,2); 
            end
            save([dum(j).folder '\' dum(j).name], 'metadata','Iplan','xgrid','ygrid'); 
            clear metadata Iplan xgrid ygrid
        end
      
        
    end
end
end

            