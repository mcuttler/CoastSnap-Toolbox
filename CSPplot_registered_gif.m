%% general application

% sites = {'Koombana Bay'}; 
% sites_db = {'koombanabay'};
%%
function [] = CSPplot_registered_gif(image_path, site, site_db,tstart, tend)

addpath('C:\Users\00084142\Dropbox\matlab\MCuttler\File_exchange')
t1 = datevec(tstart); 
t2 = datevec(tend); 
if t1(1)==t2(1)
    impath = [image_path '\' site_db '\Registered\' num2str(t1(1))]; 
    dum = dir(impath);  dum = dum(3:end); 
else
    impath1 = [image_path '\' site_db '\Registered\' num2str(t1(1))];
    impath2 = [image_path '\' site_db '\Registered\' num2str(t2(1))]; 
    dum1 = dir(impath1); dum1 = dum1(3:end); 
    dum2 = dir(impath2); dum2 = dum2(3:end); 
    dum = [dum1;dum2]; 
end

%find images within time rage
for i =1:size(dum,1)
    t(i,1) = datenum(datetime(str2num(dum(i).name(1:10)), 'convertfrom','posixtime'))+datenum(0,0,0,8,0,0);
end

idx = find(t>=tstart & t<=tend); 
dum = dum(idx); 

for i = 1:size(dum,1); 
    im_time = datetime(str2num(dum(i).name(1:10)), 'convertfrom','posixtime')+datenum(0,0,0,8,0,0);
    if i == 1                  
        imshow([dum(i).folder '\' dum(i).name])
        set(gcf, 'PaperPositionMode', 'manual','PaperUnits','centimeters','units','centimeters',...
            'position',[4 2 19 16], 'PaperPosition', [0 0 19 16],'color','w')
        set(gca,'units','centimeters'); 
        set(gca,'Position',[0, -0.75, 19 16],'units','centimeters');             
        text(0.05, 1.05,[site ' - ' datestr(im_time,'dd-mmm-yyyy')],'fontweight','bold','units','normalized','fontsize',14); 
        % Create a new gif file and write the first frame: 
        gif_path = [image_path '\' site_db '\Timelapse']; 
        if ~exist(gif_path)
            mkdir(gif_path); 
        end
        gifname = [site '_' datestr(tstart,'yyyymmdd') '_' datestr(tend,'yyyymmdd'),'.gif']; 
        gif(fullfile(gif_path,gifname),'DelayTime',0.2,'LoopCount',3,'frame',gcf)
    else
        % Loop through every other frame.
        imshow([dum(i).folder '\' dum(i).name])
        set(gcf, 'PaperPositionMode', 'manual','PaperUnits','centimeters','units','centimeters',...
            'position',[4 2 19 16], 'PaperPosition', [0 0 19 16],'color','w')
        
        set(gca,'units','centimeters'); 
        set(gca,'Position',[0, -0.75, 19 16],'units','centimeters');            
        text(0.05, 1.05,[site ' - ' datestr(im_time,'dd-mmm-yyyy')],'fontweight','bold','units','normalized','fontsize',14); 
        gif
    end
end
close(gcf)
end


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
