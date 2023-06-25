%% convert file name to date time for excel

function [] = convert_to_excel_string_time(filename,tzone)

dum = readtable(filename,'VariableNamingRule','preserve');

for i = 1:size(dum,1)
    fname = dum.im_filename{i};
    if ~strcmp(fname,'check AWS for this site')
        ff = strsplit(fname,'_');     
        site = ff{1}; 
        year_month_day = ff{2}; 
        hhmmss = ff{3}; 
        
        yr = str2num(year_month_day(1:4)); 
        mo = str2num(year_month_day(5:6)); 
        dd = str2num(year_month_day(7:8)); 
        hh = str2num(hhmmss(1:2)); 
        mm = str2num(hhmmss(3:4)); 
        ss = str2num(hhmmss(5:6)); 
        
        %build time
        if strcmp(tzone,'utc')
            tdum = datetime(yr,mo,dd,hh,mm,ss) +hours(8); 
        elseif strcmp(tzone,'awst')
            tdum = datetime(yr,mo,dd,hh,mm,ss); 
        end
        tout{i,1} = datestr(datenum(tdum),'yyyy/mm/dd HH:MM:SS'); 
    else
        tout{i,1} = nan;
    end
end

dum.('excel_time') = tout; 

fdum = strsplit(filename,'.');
fnameout = [fdum{1} '_MC.' fdum{2}]; 

writetable(dum,fnameout); 
end


