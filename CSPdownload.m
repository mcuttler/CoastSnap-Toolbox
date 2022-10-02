%% CoastSnap image download from AWS
%This code finds all new images and downloads from AWS
%If there are no images in the CoastSnap 'Processed' folders, it uses
%current time as starting point for download. 

%site is name of site as in CoastSnap database
%M Cuttler, UWA, June 2021 
%%

function [] = CSPdownload(site, siteDB, base_path, image_path); 

raw_path = [image_path '\' siteDB '\Raw']; 
db_path = [base_path '\Database']; 
tfirst = datevec(datenum(2020,7,1)); 
tnow = datevec(now); 
processed_path = [image_path '\' siteDB '\Processed\' num2str(tnow(1))]; 

%check to see if files exist in processed path, if they do use last time
%stamp as starting point. otherwise, use first time point for any
%CoastSnapWA site (July 2020). 
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
options = weboptions('Timeout',120); 
data = webread(url,options); 

%now loop through and download to local 
aws_base = 'http://s3-ap-southeast-2.amazonaws.com/'; 
author_name = []; 
im_filename = []; 

for i = 1:size(data,1)
    %sometimes data structure is weird
    if any(strcmp(data.Properties.VariableNames,'Var1'))
        try
            cdum = split(data.Var1(i),','); 
            s3name = cdum{1}; 
            patt = '-scaled';
            if contains(s3name,patt)
                s3name = erase(s3name,patt); 
            end        
            aws_url = [aws_base s3name];
  
            %timestamp
            if length(cdum{4}(2:end))==13
                dt = [cdum{4}(2:end) ':' num2str(data.Var2(i)) ':' data.Var3{i}(1:2)];
                CoastSnaps_Post_Date = datenum(dt,'yyyy-mm-dd HH:MM:SS'); 
                if strcmp(s3name(end-4:end),'.jpeg')
                    outfile = [siteDB '_' datestr(CoastSnaps_Post_Date,'yyyymmdd_HHMMSS') s3name(end-4:end)]; 
                else
                    outfile = [siteDB '_' datestr(CoastSnaps_Post_Date,'yyyymmdd_HHMMSS') s3name(end-3:end)]; 
                end
            else
                if strcmp(s3name(end-4:end),'.jpeg')
                    outfile = [siteDB '__NoDateInfo' s3name(end-4:end)]; 
                else
                    outfile = [siteDB '__NoDateInfo' s3name(end-3:end)]; 
                end            
            end
            websave([raw_path '\' outfile],aws_url);
            
            %save filename and author for CoastSnapDB
            author_name = [author_name; cdum(3)]; 
            im_filename = [im_filename; {outfile}]; 
        catch
            author_name = [author_name; 'could not read file'];
            im_filename = [im_filename; 'check AWS for this site']; 
        end
    else
        try
            %remove '-scaled' from file name if it exists     
            s3name = data.AmazonS3{i}; 
            patt = '-scaled';
            if contains(s3name,patt)
                s3name = erase(s3name,patt); 
            end
            
            aws_url = [aws_base s3name];
            
            %determine timestamp of image
            if isdatetime(data.CoastSnaps_Post_Date(i))
                if strcmp(data.AmazonS3{i}(end-4:end),'.jpeg')
                    outfile = [siteDB '_' datestr(data.CoastSnaps_Post_Date(i),'yyyymmdd_HHMMSS') data.AmazonS3{i}(end-4:end)]; 
                else
                    outfile = [siteDB '_' datestr(data.CoastSnaps_Post_Date(i),'yyyymmdd_HHMMSS') data.AmazonS3{i}(end-3:end)]; 
                end
            else
                if strcmp(data.AmazonS3{i}(end-4:end),'.jpeg')
                    outfile = [siteDB '__NoDateInfo' data.AmazonS3{i}(end-4:end)]; 
                else
                    outfile = [siteDB '__NoDateInfo' data.AmazonS3{i}(end-3:end)]; 
                end            
            end
            
            websave([raw_path '\' outfile],aws_url);
            
            %save filename and author for CoastSnapDB
            author_name = [author_name; data.Author(i)]; 
            im_filename = [im_filename; {outfile}]; 
        catch
            author_name = [author_name; 'could not read file'];
            im_filename = [im_filename; 'check AWS for this site']; 
        end
    end
end

%write author names and filenames to csv
csvout = table(author_name, im_filename); 
tablename = [db_path '\' siteDB '_users.csv']; 
writetable(csvout, tablename); 

end
