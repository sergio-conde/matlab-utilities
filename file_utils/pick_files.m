function out_files = pick_files(ref_files,varargin)

% out_files = pick_files(ref_files,'field1_name','field1_value', ... 'field_n_name','field_n_value')
%
% pick_files function lists files from the ref_files (output of the proj_organigram function)
%
%   Inputs:
%     ref_files: output of the proj_organigram function                     [struct]
%                Note: However, this function shuould work to select
%                specific lines of any structure.
%     field_name
%     field_value: selecting criteria for field_name. 
%          
%   Outputs:
%     out_files: Output struct containing the same fiels as ref_files
%       name: file name
%       folder: file folder
%       file_path: full file path
%       + one field per level following the name con cfg.level_name input
%
% Sergio Conde, Apr 2023. NIN. Willuhn's Lab.

% check if requested fields are paired to their values %%%%%%%%%%%%%%%%%%%%%%%%
if mod(length(varargin),2) == 1
    error('unpaired input arguments') % display en error in the command window
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% select requested files %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
field_names = check_fields(ref_files,varargin);                                                 % check requested fields
field_vals = varargin(2:2:end);                                                                 % pick requested values
check_flags = false(length(ref_files),length(field_names));                                     % initialization
for ifield = 1:length(field_names)
    if all(cellfun(@ischar,{ref_files.(field_names{ifield})}))
        check_flags(:,ifield) = strcmp(field_vals{ifield},{ref_files(:).(field_names{ifield})});    % selecting match elements
    elseif all(cellfun(@isnumeric,{ref_files.(field_names{ifield})})) 
        check_flags(:,ifield) = [ref_files(:).(field_names{ifield})] == field_vals{ifield};         % selecting match elements
    end
end
if any(check_flags)
    out_files = ref_files(all(check_flags,2));                                                  % output struct
else
    out_files = [];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

% Check that all requested fields exist %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function field_names = check_fields(in_struct,in_args)

field_names = in_args(1:2:end);                                         % pick odd positions from the input arguments

for ifname = 1:length(field_names)
    if ~isfield(in_struct,field_names{ifname})                          % check each requested field
        error(['''' field_names{ifname} ''' is not a valid field'])     % display en error in the command window
    end
end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
