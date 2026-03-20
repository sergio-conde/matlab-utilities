function h_shadow = shadow_plot(xdata,ydata,err_flag,color_val,alpha)

% shadow_plot function plots the mean trace and shadow dispersion 
% 
% Inputs
%   xdata:  x axis data values. If empty xdata = sample number of ydata.
%   ydata:  y axis data values. Can be either a 2D matrix [nobservations x  nsamples] 
%           or a struct containing mean_data and std_vectors.
%   err_flag:  true to plot standard error; false to plot standard
%              deviation.
%   color_val: color definition same as Matlab's
%   alpha:  transparency level
%
% Outputs
%
%   h_shadow: plot handle
%
%   Sergio Conde, 2023. NIN. Willuhn's Lab. 

if isstruct(ydata)
    mean_data = ydata.mean_data;
    std_data  = ydata.std_data;
else
    mean_data = mean(ydata,1,'omitnan');
    std_data  = std(ydata,[],1,"omitnan");

    % mean_data = median(ydata,1,'omitnan');
    % std_data  = iqr(ydata,1);
    if err_flag
        std_data = std_data./sqrt(size(ydata,1));
    end
end

% mean_data = smoothdata(mean_data,2,"gaussian",8);
% std_data = smoothdata(std_data,2,"gaussian",8);

if size(mean_data,1) > 1
    mean_data = mean_data';
    std_data  = std_data';
end

if ~isempty(xdata)
    x_vector = [xdata fliplr(xdata)];
else
    x_vector = [1:length(mean_data) length(mean_data):-1:1];
end

h_shadow = fill(x_vector,[mean_data - std_data fliplr(mean_data + std_data)],...
    color_val,'FaceAlpha',alpha,'EdgeAlpha',alpha);
hold on
plot(x_vector(1:length(mean_data)),mean_data,'color',color_val,'LineWidth',1);




