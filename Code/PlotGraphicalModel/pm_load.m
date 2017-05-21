%
% load processed data of hydro results -- for plots
% turmon mar 2016

root = '/Users/armeentaeb/Desktop/ReservoirModeling/Code/PlotGraphicalModel/';

%% precision matrices
  junk = load([root 'SRN']);
  names_orig = junk.SRN;
  junk = load([root 'WeightsFull']); % already is normalized
  pm_fm_orig = junk.EdgeStrengthFull;
  junk = load([root 'S_LVGM2']);
  pm_gm_orig = junk.S_LVGM;
  junk = load([root 'S_Full']);
  pm_lm_orig = junk.S_Full;


%% metadata
if ~exist('resv', 'var'),
  fn = fullfile(getenv('HOME'), ...
                '/Desktop/ReservoirModeling/Code/PlotGraphicalModel',...
                'reservoir-summary.csv');
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

% re-order precision matrices
pm_fm = pm_fm_orig(resv_index, resv_index);
pm_gm = pm_gm_orig(resv_index, resv_index);
pm_lm = pm_lm_orig(resv_index, resv_index);
% re-order names
names = names_orig(resv_index);

% for convenience, find re-scaled precision matrices
pm_rescaler = @(pm)(pm ./ sqrt(diag(pm) * diag(pm)'));
pm_fm_rescale = pm_rescaler(pm_fm);
pm_gm_rescale = pm_rescaler(pm_gm);
pm_lm_rescale = pm_rescaler(pm_lm);

% find zone counts
z_blocks = diff([0;find(diff(resv.ZoneIndex));NRes]);
z_lbls = {{'N.', 'Coast'}, 'Sacramento', 'S.Joaquin', 'Tulare'};

