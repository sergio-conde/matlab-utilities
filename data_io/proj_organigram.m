function out_files = proj_organigram(cfg)

% out_files = proj_organigram(cfg)
%
% proj_organigram function lists all the files matching the configuration
% contained in cfg (project organigram)
%
%   Inputs:
%     cfg: structure containing the following fields
%       main_path: main project folder path                                            [string]
%       level_name: name associated with each level of the organigram.                 [cell array of strings]
%       folder_coding: string codification of the folders associated to each level.    [cell array of strings]
%       file_str: string codification of the required files. If empty, all files on    [string]
%                 each folder will be listed.                                          
%   Outputs:
%     out_files: Output struct containing the following fields
%       name: file name
%       folder: file folder
%       file_path: full file path
%       + one field per level following the name con cfg.level_name input
%
% Sergio Conde, Apr 2023. NIN. Willuhn's Lab.

% defining the search path %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cat_path = cfg.main_path;                                       % main project folder 
for ilevel = 1:length(cfg.level_name)
    cat_path = cat(2,cat_path,['\' cfg.folder_coding{ilevel}]); % concatenate all levels 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% if there is a string code for the file names %%%%%%%%%%%%%%%%%%%%%%%%%
if ~isempty(cfg.file_str)
    cat_path = cat(2,cat_path,['\' cfg.file_str]); % add to search path
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
all_files = dir(cat_path); % all files matching the configuration 

main_length = length(cfg.main_path);                                    % main project folder str length 
out_files = struct([]);                                                 % output structure initialization

for ifile = 1:length(all_files)
    
    % create string references to extract level names %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    bslash = strfind(all_files(ifile).folder,'\');                                  % backslash positions 
    ref_pos = [bslash(bslash >= main_length) length(all_files(ifile).folder) + 1];  % add final reference
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % fill output structure %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for ilevel = 1:length(cfg.folder_coding)
        out_files(ifile).name = all_files(ifile).name;                                      % file name
        out_files(ifile).folder = all_files(ifile).folder;                                  % file folder
        out_files(ifile).file_path = [all_files(ifile).folder '\' out_files(ifile).name];   % full file path
        out_files(ifile).(cfg.level_name{ilevel}) = ...
            all_files(ifile).folder(ref_pos(ilevel) + 1 : ref_pos(ilevel + 1) - 1);         % level name
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end