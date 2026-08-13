function fileList = projectFiles(cfg)

% fileList = projectFiles(cfg)
%
% projectFiles function lists all the files matching the configuration
% contained in cfg (folder structure and file naming)
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
% v1.0: April 2023
% v2.0: August 2026
%
% Sergio Conde-Ocazionez, August 2024. 
% Neuromodulation & Behavior Laboratory
% Netherlands Institute for Neuroscience.


% defining the search path %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
catPath = cfg.main_path;                                       % main project folder 
for ilevel = 1:length(cfg.level_name)
    catPath = cat(2,catPath,['\' cfg.folder_coding{ilevel}]); % concatenate all levels 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% if there is a string code for the file names %%%%%%%%%%%%%%%%%%%%%%%%%
if ~isempty(cfg.file_str)
    catPath = cat(2,catPath,['\' cfg.file_str]); % add to search path
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
all_files = dir(catPath); % all files matching the configuration 

main_length = length(cfg.main_path);                                    % main project folder str length 
fileList = struct([]);                                                 % output structure initialization

for ifile = 1:length(all_files)
    
    % create string references to extract level names %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    bslash = strfind(all_files(ifile).folder,'\');                                  % backslash positions 
    ref_pos = [bslash(bslash >= main_length) length(all_files(ifile).folder) + 1];  % add final reference
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % fill output structure %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for ilevel = 1:length(cfg.folder_coding)
        fileList(ifile).name = all_files(ifile).name;                                      % file name
        fileList(ifile).folder = all_files(ifile).folder;                                  % file folder
        fileList(ifile).file_path = [all_files(ifile).folder '\' fileList(ifile).name];   % full file path
        fileList(ifile).(cfg.level_name{ilevel}) = ...
            all_files(ifile).folder(ref_pos(ilevel) + 1 : ref_pos(ilevel + 1) - 1);         % level name
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end