function hf = wfig(varargin)

% wfig(nfig)
%
% Inputs
%   nfig [numeric]: number of the figure to be either opened or created
%
% Outputs
%   hf: figure handle
%
% This function opens the nfig figure and set white. If no nfig input is
% provided, the function will open the next available figure.
%
% Sergio Conde-Ocazionez, 2022.

if nargin == 1
    h = figure(varargin{1});
else
    h = figure;
end
set(h,'color','w')

if nargout > 0
    hf = h;
end