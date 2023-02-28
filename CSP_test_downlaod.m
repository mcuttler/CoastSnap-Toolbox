for s = 1:length(sitesDB)
    disp(['Downloading images for ' sitesDB{s}]); 
    site = sites{s}; siteDB = sitesDB{s}; 
    dd = dir(processed_path); 
    if size(dd,1)==2 %empty
        %try using previous year as may be start of new year 
        processed_path2 = [image_path '\' siteDB '\Processed\' num2str(tnow(1)-1)]; 
        if exist(processed_path2) 
            dd2 = dir(processed_path2); 
            if size(dd2,1)==2
                tstart = posixtime(datetime(tfirst)); 
            else
                tstart = str2num(dd2(end).name(1:10)); 
            end
        else
            tstart = posixtime(datetime(tfirst));
        end
    else
        tstart = str2num(dd(end).name(1:10));
    end
    
    %read CSV from website with images after tstart
    url = ['http://wacoastline.org/wac-api/images/site/' site '_upload/from/' num2str(tstart) '/dum.csv']; 
    options = weboptions('Timeout',180); 
    websave(fullfile(DB_path,[site '_download.csv']),url,options); 

    data2.(site) = importdata(fullfile(DB_path,[site '_download.csv'])); 
end

%% 
%Use import data, then split by comma