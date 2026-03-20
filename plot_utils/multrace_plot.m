
function multrace_plot(loc_data,ifig,srate)

% multrace_plot function plots multiple traces
%
% loc_data: data organized as each line containing a single trace
% ifig: figure id
% srate: data's sample rate. Used to compute the time axis.
%
% Sergio Conde, 2023. NIN. Willuhn's Lab.

% initializing plotting data %%%%%%
plot_data = zeros(size(loc_data));
plot_data(1,:) = loc_data(1,:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% adding offsets to visualize each line separately %%%%%%%%%%%%%%%%%%%%
max_vals = max(loc_data,[],2); % offsets of each line
for iline = 2:size(loc_data,1)
    plot_data(iline,:) = loc_data(iline,:) + 1.1*sum(max_vals(1:iline-1)); 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% plotting and formating the figure %%%%%%%%%
wfig(ifig)
plot((1:size(plot_data,2))/srate,plot_data','color',0.4 * ones(1,3)); 
axis tight
set(gca,'TickDir','out','YColor','w');
box off; xlabel 'Time [s]'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%