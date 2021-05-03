%This file contains all the necessary path information for your local
%CoastSnap database. It is called in almost all files in the CoastSnap
%Toolbox
%
%Mitch Harley, June 2018

%converted to function for executable developmoent - MCuttler May 2020

%%

% function [] = CSPloadPaths(vars)  
% 
% for i = 1:size(vars,1)
%     if strcmp(vars(i).name, 'base_path')
%         base_path = vars(i).name;
%     end
% end

base_path = evalin('base','base_path'); 

DB_path = fullfile(base_path,'Database'); %Path where database is located
image_path = fullfile(base_path,'Images'); %Path where all images are stored
shoreline_path = fullfile(base_path,'Shorelines'); %Path where shorelines are stored
tide_path = fullfile(base_path,'Tide Data'); %Path where tide data are stored
transect_dir = fullfile(base_path,'Shorelines','Transect Files'); %Path where transects are stored for shoreline mapping

% end
