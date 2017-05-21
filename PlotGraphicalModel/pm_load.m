%
% load processed data of hydro results -- for plots
% turmon mar 2016
clear all
close all
clc

root = '/Users/armeentaeb/Desktop/ReservoirModeling/PlotGraphicalModel/';

%% precision matrices
%if ~exist('names', 'var'),
  junk = load([root 'SRN']);
  names_orig = junk.SRN;
  junk = load([root 'S_Full']);
  pm_gm_orig = junk.S_Full;
  pm_gm_orig = pm_gm_orig;%([1:21,23:55],[1:21,23:55]);
  junk = load([root 'S_GM2']);
  pm_lm_orig = junk.S_GM2;
%end

%% zone info - unused
%   could not see how these helped
if false,
  junk = load([root 'Z1']);
  z1 = junk.Z1;
  junk = load([root 'Z3']);
  z3 = junk.Z3;
  junk = load([root 'Z4']);
  z4 = junk.Z4;
  junk = load([root 'Z5']);
  z5 = junk.Z5;
  clear junk
end;

%% metadata
if ~exist('resv', 'var'),
  fn = '/Users/armeentaeb/Dropbox/JPL Work/Data/reservoir-summary.csv';
  % slick!
  
  resv_all = readtable(fn, 'ReadRowNames', true);

  % take only the rows we need, in "names_orig" order
  resv_orig = resv_all(names_orig,:);
end

% add an index, which is the row/col in the precision matrices,
% as a convenience
NRes = 55;
resv_orig.index = [1:NRes]';

% get the index set
% sorting is primary by hydro-zone (1, 3, 4, 5), then by basin index,
% which is essentially major river ID, then by latitude
resv = sortrows(resv_orig, ...
                {'ZoneIndex', 'BasinIndex','Latitude'},...
                {'ascend', 'ascend', 'ascend'});
resv_index = resv.index;
%ind = find(resv_index == 22);
%resv_index(ind) = [];
%resv.ZoneIndex(ind) = [];

% re-order precision matrices
%pm_fm = pm_fm_orig(resv_index, resv_index);
pm_gm = pm_gm_orig(resv_index, resv_index);
pm_lm = pm_lm_orig(resv_index, resv_index);
% re-order names
names = names_orig(resv_index);

% for convenience, find re-scaled precision matrices
%pm_rescaler = @(pm)(pm ./ sqrt(diag(pm) * diag(pm)'));
%pm_fm_rescale = pm_rescaler(pm_fm);
%pm_gm_rescale = pm_rescaler(pm_gm);
%pm_lm_rescale = pm_rescaler(pm_lm);

% find zone counts
z_blocks = diff([0;find(diff(resv.ZoneIndex));NRes]);
z_lbls = {{'N.', 'Coast'}, 'Sacramento', 'S.Joaquin', 'Tulare'};

