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
    hf = figure(varargin{1});
else
    hf = figure;
end
set(hf,'color','w')