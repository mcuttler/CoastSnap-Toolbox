function out = CSPGloadExistingGeometry(handles)

data = get(handles.oblq_image,'UserData'); %Get data stored in the userdata in the oblq_image handles
siteDB = data.siteDB;
I = data.I;
axes(handles.oblq_image) %Plot gpcs on GUI axis

%First, check if image has already been rectified
fileparts = CSPparseFilename(data.fname);
rect_path = strrep(data.pname,'Processed','Rectified');
rect_path = strrep(rect_path,'Registered','Rectified');
rect_name = strrep(data.fname,'snap','plan'); %Rectified is called plan to keep with Argus conventions
rect_name = strrep(rect_name,'timex','plan'); %For timex images
go = 1;
if exist(fullfile(rect_path,rect_name),'file')
    ButtonName = questdlg('Image has already been rectified. Do you want to continue?','Continue?','Yes','No','No');
    switch ButtonName
        case 'No'
            go = 0;
        case 'Yes'
            go = 1;
    end
end

if go==1 %If hasn't been previously rectified
    tide_level = CSPgetTideLevel(str2num(fileparts.epochtime),data.site);

    %%Load existing geometry
    [fname,pname]=uigetfile([rect_path filesep '*.mat'],'Select Previous Rectified Image.mat file to use for geometry');
    load(fullfile(pname,fname)); %Load geomtry from this file
       
   
    %% Rectification limits
    inputs.rectxy = [siteDB.rect.xlim(1) siteDB.rect.res siteDB.rect.xlim(2) siteDB.rect.ylim(1) siteDB.rect.res siteDB.rect.ylim(2)]; % rectification specs
    inputs.tide_offset = siteDB.rect.tidal_offset;
    inputs.rectz = tide_level+inputs.tide_offset; % rectification z-level

 
    % Plot GCPs transformed in image coordinates by the fitted geometry
    UV_computed = findUVnDOF(metadata.geom.betas, metadata.gcps.xyzMeas, metadata.geom);
    UV_computed = reshape(UV_computed,[],2);
    plot(UV_computed(:,1),UV_computed(:,2),'ro');
    
    %% Rectify image
    images.xy = inputs.rectxy;
    images.z = inputs.rectz;
    images = buildRectProducts(1, images, I, metadata.geom.betas, metadata.geom);
    
    % Plot image
    finalImages = makeFinalImages(images);
    axes(handles.plan_image) %Plot gpcs on GUI axis
    %figure('Name', 'Plan', 'Tag', 'Timex', 'Units', 'normalized','Position', [0 0 1 1]);
    imagesc(finalImages.x,finalImages.y,finalImages.timex);
    xlabel('Eastings [m]'); ylabel('Northings [m]'); title('Rectified Image');
    axis xy;axis image; grid on
    
    %Create output matrix
    xgrid = finalImages.x;
    ygrid = finalImages.y;
    Iplan = finalImages.timex;
    metadata.whenDone = matlab2Epoch(now-siteDB.timezone.gmt_offset/24);
    metadata.rectz = inputs.rectz;
    %metadata.gcps.xyzMeas = xyz;
    metadata.gcps.UVpicked = NaN;
    %metadata.geom.betas = betas;
    %metadata.geom.CI = meta.CI;
    %metadata.geom.MSE = meta.MSE;
    %metadata.geom.lcp = globs.lcp;
    %metadata.geom.knownFlags = globs.knownFlags;
    %metadata.geom.knowns = globs.knowns;
    
    %Save data to file
    imwrite(flipud(Iplan),fullfile(rect_path,rect_name))
    fname_rectified_mat = strrep(rect_name,'.jpg','.mat');
    save(fullfile(rect_path,fname_rectified_mat),'xgrid', 'ygrid', 'Iplan', 'metadata')
    end
        
    data.tide_level = tide_level;
    set(handles.oblq_image,'UserData',data) %Add tide level to UserData
    
    data2.xgrid = xgrid;
    data2.ygrid = ygrid;
    data2.Iplan = Iplan;
    data2.metadata = metadata;
    set(handles.plan_image,'UserData',data2) %Store rectified info in userdata of plan_image
    
    %Save rectified image to file
end