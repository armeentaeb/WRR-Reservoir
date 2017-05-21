function gisinfo = hydro_load_gisinfo(d)
%hydro_load_gisinfo	load GIS metadata from fixed files
% 
% gisinfo = hydro_load_gisinfo(d)
% * Ad hoc function to load GIS shape information from fixed files
% in a given directory.  If not supplied, uses a certain fixed dir.
% * We return fields:
%   -- gisinfo.cali: state outline
%   -- gisinfo.zone: hydrological zones
%   -- gisinfo.stream_all: streams (all)
%   -- gisinfo.stream:     streams (just large ones)
%
% Inputs:
%   opt string d = $HOME/matlab/mfile/hydro/Data-GIS
% 
% Outputs:
%   struct gisinfo
% 
% See Also:

% 
% Error checking
% 
if all(nargin  ~= [0 1]), error ('Bad input arg number'); end
% if all(nargout ~= [0 1]), error ('Bad output arg number'); end  

% default d if not given
if nargin < 1,
  d = fullfile(getenv('HOME'), 'matlab/mfile/hydro/Data-GIS');
end

if ~exist(d, 'dir'), error('Need <%s> to be a directory', d); end;

%% Load data

% state outline
cali_all = shaperead('usastatehi', 'UseGeoCoords', true,'Selector',{@(name) strcmpi(name,'California'), 'Name'});

% hydrological zones
FN_zone = fullfile(d, 'hydro-zones', 'ca_hydro_zones.shp');
cali_zone = shaperead(FN_zone, 'UseGeoCoords', true);

% streams
FN_str = fullfile(d, 'river', 'rivs_cnrfc.shp');
cali_str_all = shaperead(FN_str, 'UseGeoCoords', true);

% filter streams
% 1: in the state
in_ca =  ([cali_str_all.MAX_X_AXIS] < -118) & ...
         ([cali_str_all.MAX_Y_AXIS] <  42.0 ) & ...
        (([cali_str_all.MAX_X_AXIS] < -120.0) | ([cali_str_all.MAX_Y_AXIS] < 38.5));
% 2: big, by some measure (room for improvement here)
big = ([cali_str_all.SUM_DRAIN_] > 250);

cali_str = cali_str_all(big & in_ca);


%% Insert fields

% whole state
gisinfo.cali = cali_all;

% hydrological zones
gisinfo.zone = cali_zone;

% streams
gisinfo.stream_all = cali_str_all;

% just the large ones
gisinfo.stream = cali_str;

end

