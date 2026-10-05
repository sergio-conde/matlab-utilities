function [hBar,hDots] = barDots(data,cfg)

% barDots(data,cfg)
%
% plots bars, despersion and individual data points
% 
% Inputs
%   data: vector with points
%   cfg: configuration struct containing the following fields
%       position: position of each bar (columns in data)
%       barColor
%       maxJitter: maximum jitter of the individual data points around the
%                   bar's position
%       dotColor
%       paired: true if data is paired and lines bwtween data points should be ploted
%       transparency: of the bars
%
%   Sergio Conde, 2023. NIN. Willuhn's Lab. 


cfg = checkCfg(data,cfg);

localBar = plotBars(cfg,data);
localBar.FaceAlpha = cfg.transparency;
localBar.BarWidth = cfg.BarWidth;

if strcmp(cfg.dots,'on')
    localDots = plotDots(cfg,data);
end
hold off; box off

if nargout == 1
    hBar = localBar;
elseif nargout == 2
    hBar = localBar;
    hDots = localDots;
end

end

function hbar = plotBars(cfg,data)
hbar = bar(cfg.position,mean(data,'omitnan'),'facecolor',cfg.barColor);
errorBars = std(data,[],'omitnan');
if isfield(cfg,'error')   
    if cfg.error
        errorBars = errorBars/sqrt(size(data,1));
    end
end
hold on
errorbar(cfg.position,mean(data,'omitnan'),errorBars,'.k');
end


function hdots = plotDots(cfg,data)
% define the x coordinate of each data point %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xDots = [];
for ibar = cfg.position
    dotJitter = ibar - cfg.maxJitter + 2*cfg.maxJitter*rand(size(data,1),1);
    xDots = cat(1,xDots,dotJitter);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if cfg.paired
    xDots = reshape(xDots,size(data));
    nDots = size(data,1);
    hdots = nan(1,nDots);
    for iDot = 1:nDots
        hdots(iDot) = plot(xDots(iDot,:),data(iDot,:),'o-',...
            'markersize',cfg.dotSize, ...
            'Color', 0.75 * ones(1,3),...
            'MarkerFaceColor',cfg.dotColor,...
            'MarkerEdgeColor',cfg.dotColor);
    end
else
    hdots = plot(xDots,data(:),'o',...
        'markersize',cfg.dotSize, ...
        'Color', 0.75 * ones(1,3),...
        'MarkerFaceColor',cfg.dotColor, ...
        'MarkerEdgeColor',cfg.dotColor);
end

end

function cfg = checkCfg(data,cfg)

if ~isfield(cfg,'error')
    cfg.error = true;
end

if ~isfield(cfg,'dots')
    cfg.dots = 'on';
end

if ~isfield(cfg,'dotSize')
    cfg.dotSize = 3;
end

if ~isfield(cfg,'position')
    cfg.position = 1:size(data,2);
end

if ~isfield(cfg,'BarWidth')
    cfg.BarWidth = 0.8;
end

if ~isfield(cfg,'paired')
    cfg.paired = false;
end

if ~isfield(cfg,'maxJitter')
    cfg.maxJitter = 0.5;
end

if ~isfield(cfg,'transparency')
    cfg.transparency = 0.5;
end

if ~isfield(cfg,'dotColor')
    cfg.dotColor = 'k';
end

if ~isfield(cfg,'barColor')
    cfg.barColor = 'k';
end

end