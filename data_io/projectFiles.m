function fileList = projectFiles(cfg)

% fileList = projectFiles(cfg)
%
% projectFiles function lists all the files matching the configuration
% contained in cfg (folder structure and file naming)
%
%   Inputs:
%     cfg: structure containing the following fields
%       mainPath: main project folder path                                            [string]
%       levelName: name associated with each level of the organigram.                 [cell array of strings]
%       folderCode: string codification of the folders associated to each level.    [cell array of strings]
%       fileCode: string codification of the required files. If empty, all files on    [string]
%                 each folder will be listed.                                          
%   Outputs:
%     out_files: Output struct containing the following fields
%       name: file name
%       folder: file folder
%       file_path: full file path
%       + one field per level following the name con cfg.levelName input
%
% v1.0: April 2023
% v2.0: August 2026
%
% Sergio Conde-Ocazionez, August 2024. 
% Neuromodulation & Behavior Laboratory
% Netherlands Institute for Neuroscience.


% defining the search path %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
catPath = cfg.mainPath;                                       % main project folder 
for ilevel = 1:length(cfg.levelName)
    catPath = cat(2,catPath,['\' cfg.folderCode{ilevel}]); % concatenate all levels 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% if there is a string code for the file names %%%%%%%%%%%%%%%%%%%%%%%%%
if ~isempty(cfg.fileCode)
    catPath = cat(2,catPath,['\' cfg.fileCode]); % add to search path
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
allFiles = dir(catPath); % all files matching the configuration 

mainLength = length(cfg.mainPath);                                    % main project folder str length 
fileList = struct([]);                                                 % output structure initialization

for ifile = 1:length(allFiles)
    
    % create string references to extract level names %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    bslash = strfind(allFiles(ifile).folder,'\');                                  % backslash positions 
    refPos = [bslash(bslash >= mainLength) length(allFiles(ifile).folder) + 1];  % add final reference
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % fill output structure %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for ilevel = 1:length(cfg.folderCode)
        fileList(ifile).name = allFiles(ifile).name;                                      % file name
        fileList(ifile).folder = allFiles(ifile).folder;                                  % file folder
        fileList(ifile).file_path = [allFiles(ifile).folder '\' fileList(ifile).name];   % full file path
        fileList(ifile).(cfg.levelName{ilevel}) = ...
            allFiles(ifile).folder(refPos(ilevel) + 1 : refPos(ilevel + 1) - 1);         % level name
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end