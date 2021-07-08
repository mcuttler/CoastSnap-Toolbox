%% general application

%%
function [] = CSP_plot_registered_gif(sites, sites_db, base_path, time_start, time_end)

addpath('C:\Users\00084142\Dropbox\matlab\MCuttler\File_exchange')


%convert time_start from string to date
tstart = datenum(time_start,'yyyy-mm-dd'); 
tstart_vec= datevec(tstart); 

tend = datenum(time_end,'yyyy-mm-dd'); 
tend_vec = datevec(tend); 

for j = 1:length(sites)
    %check if same year or not
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
    
    %site outpath for GIF
    outpath = [base_path '\Images\' sites_db{j} '\Timelapse']; 
    if ~exist(outpath)
        mkdir(outpath)
    end
    
    %loop over images to make GIF 
    [m,~] = size(dum);        
    for i = 1:m
        im_time = datetime(str2num(dum(i).name(1:10)), 'convertfrom','posixtime')+datenum(0,0,0,8,0,0);
        if i == 1           
            imshow([dum(i).folder '\' dum(i).name])
            set(gcf, 'PaperPositionMode', 'manual','PaperUnits','centimeters','units','centimeters',...
                'position',[4 2 19 16], 'PaperPosition', [0 0 19 16],'color','w')
            set(gca,'units','centimeters'); 
            set(gca,'Position',[0, -0.75, 19 16],'units','centimeters'); 
            
            text(0.05, 1.05,[sites{j} ' - ' datestr(im_time,'dd-mmm-yyyy')],'fontweight','bold','units','normalized','fontsize',14); 
            
            % Create a new gif file and write the first frame: 
            gifname = [outpath '\' sites_db{j} '_' time_start '_' time_end '.gif'];
            
            gif(gifname,'DelayTime',0.2,'LoopCount',3,'frame',gcf);
       
        else
            % Loop through every other frame.
            imshow([dum(i).folder '\' dum(i).name])
            set(gcf, 'PaperPositionMode', 'manual','PaperUnits','centimeters','units','centimeters',...
                'position',[4 2 19 16], 'PaperPosition', [0 0 19 16],'color','w')
            
            set(gca,'units','centimeters'); 
            set(gca,'Position',[0, -0.75, 19 16],'units','centimeters'); 
            
            text(0.05, 1.05,[sites{j} ' - ' datestr(im_time,'dd-mmm-yyyy')],'fontweight','bold','units','normalized','fontsize',14); 
            gif
            
        end
        
    end
    close(gcf)
end

end

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
