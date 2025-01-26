dpath = 'P:\CUTTLER_CoastSnapWA\CoastSnap\Database'; 

files = dir(fullfile(dpath, '*.csv')); 

for i = 1:size(files,1)
    if contains(files(i).name,'users.csv'); 
        try

        data = readtable(fullfile(files(i).folder, files(i).name),'VariableNamingRule','preserve'); 

        for j = 1:size(data,1)
            imname = data.im_filename(j); 
            imname = strsplit(imname{1},'_');

            if length(imname)>1
                imtime = datetime(str2num(imname{2}(1:4)), str2num(imname{2}(5:6)), str2num(imname{2}(7:8)), str2num(imname{3}(1:2)), str2num(imname{3}(3:4)), str2num(imname{3}(5:6))) + hours(8); 
                imtime_out{j,1} = datestr(imtime,'dd/mm/yyyy HH:MM:SS'); 
            else
                imtime_out{j,1} = 'nan'; 
            end
        end

        data.imtime_out = imtime_out; 

        dnameout = strrep(files(i).name, '.csv','_v2.csv'); 

        writetable(data,fullfile(files(i).folder, dnameout)); 

        clear data imname imtime imtime_out
        catch
            disp(['could not process ' files(i).name])
        end
    end
end

    

  


