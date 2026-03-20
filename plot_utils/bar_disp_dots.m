function bar_disp_dots(data,cfg)

% bar_disp_dots(data,cfg)
%
% plots bars, despersion and individual data points
% 
% Inputs
%   data: vector with points
%   cfg: configuration struct containing the following fields
%       position: position of each bar (columns in data)
%       bar_color
%       max_jitter: maximum jitter of the individual data points around the
%                   bar's position
%       dot_color
%       paired: true if data is paired and lines bwtween data points should be ploted
%       transparency: of the bars
%
%   Sergio Conde, 2023. NIN. Willuhn's Lab. 

hold on
if isfield(cfg,'transparency')
    plot_dots(cfg,data)
    hbar = plot_bars(cfg,data);
    hbar.FaceAlpha = cfg.transparency;
else
    plot_bars(cfg,data);
    plot_dots(cfg,data);
end
box off
end

function hbar = plot_bars(cfg,data)
hbar = bar(cfg.position,mean(data,'omitnan'),'facecolor',cfg.bar_color);
disp_bars = std(data,[],'omitnan');
if isfield(cfg,'error')   
    if cfg.error
        disp_bars = disp_bars/sqrt(size(data,1));
    end
end
errorbar(cfg.position,mean(data,'omitnan'),disp_bars,'.k');
end


function plot_dots(cfg,data)
% define the x coordinate of each data point %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x_dots = [];
for ibar = cfg.position
    dot_jitter = ibar - cfg.max_jitter + 2*cfg.max_jitter*rand(size(data,1),1);
    x_dots = cat(1,x_dots,dot_jitter);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if cfg.paired
    x_dots = reshape(x_dots,size(data));
    for ipoint = 1:size(data,1)
        plot(x_dots(ipoint,:),data(ipoint,:),'o-',...
            'markersize',4, ...
            'Color', 0.75 * ones(1,3),...
            'MarkerFaceColor',cfg.dot_color)
    end
else
    plot(x_dots,data(:),'o',...
        'markersize',4, ...
        'Color', 0.75 * ones(1,3),...
        'MarkerFaceColor',cfg.dot_color)
end

end


