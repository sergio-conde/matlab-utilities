function [out_files,file_line] = get_entry(ref_files,fcn_cfg)

% out_files = get_entry(ref_files,'field1_name','field1_value', ... 'field_n_name','field_n_value')
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
% Sergio Conde, Aug 2024. NIN. Willuhn's Lab.


req_fields = fieldnames(fcn_cfg);
ref_fields = fieldnames(ref_files);

% ref default %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~isfield(fcn_cfg,'ref')
    for ivar = 1:length(req_fields)
        fcn_cfg.ref.(req_fields{ivar}) = 'equal';
    end
else
    req_fields = setdiff(req_fields,'ref');
    for ivar = 1:length(req_fields)
        if ~isfield(fcn_cfg.ref,req_fields{ivar})
            fcn_cfg.ref.(req_fields{ivar}) = 'equal';
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

no_ref = setdiff(req_fields,[ref_fields; 'ref']);
if ~isempty(no_ref)
    for inot = 1:length(no_ref)
%         fprintf('\n-> field %s not found\n',no_ref{inot})
    end
    req_fields = setdiff(req_fields,no_ref);
end


var_id = [];
nvars  = length(req_fields);
nvals  = zeros(length(req_fields),1);

for ivar = 1:length(req_fields)

    if ~iscell(fcn_cfg.(req_fields{ivar}))
        fcn_cfg.(req_fields{ivar}) = {fcn_cfg.(req_fields{ivar})};
    end
    nvals(ivar) = length(fcn_cfg.(req_fields{ivar}));
    var_id = cat(2,var_id,ivar * ones(1,nvals(ivar)));
end
check_flags = false(length(ref_files),sum(nvals));

nval = 1;
for ivar = 1:length(req_fields)
    var_vals  = fcn_cfg.(req_fields{ivar});

    for ivals = 1:length(var_vals)
        loc_val = fcn_cfg.(req_fields{ivar}){ivals};
        if all(cellfun(@ischar,{ref_files.(req_fields{ivar})}))
            check_flags(:,nval) = strcmp(fcn_cfg.(req_fields{ivar}),{ref_files(:).(req_fields{ivar})});  % selecting match elements
        elseif all(cellfun(@isnumeric,{ref_files.(req_fields{ivar})}))
            if isfield(fcn_cfg.ref,req_fields{ivar})
                if strcmp(fcn_cfg.ref.(req_fields{ivar}),'lower')
                    check_flags(:,nval) = [ref_files(:).(req_fields{ivar})] < loc_val;
                elseif strcmp(fcn_cfg.ref.(req_fields{ivar}),'higher')
                    check_flags(:,nval) = [ref_files(:).(req_fields{ivar})] > loc_val;
                elseif strcmp(fcn_cfg.ref.(req_fields{ivar}),'equal')
                    % check_flags(:,nval) = [ref_files(:).(req_fields{ivar})] == loc_val;
                    check_flags(:,nval) = ismember([ref_files(:).(req_fields{ivar})],loc_val);
                end
            else
                % check_flags(:,nval) = [ref_files(:).(req_fields{ivar})] == loc_val;
                check_flags(:,nval) = ismember([ref_files(:).(req_fields{ivar})],loc_val);
            end
        end
        nval = nval + 1;
    end
end

if any(check_flags)
    compile_vars = false(length(ref_files),nvars);
    for ivar = 1:nvars
        compile_vars(:,ivar) = any(check_flags(:,var_id == ivar),2);
    end
    out_files = ref_files(all(compile_vars,2));                                        % output struct
    file_line = find(all(check_flags,2));
else
    out_files = [];
    file_line = [];
end
