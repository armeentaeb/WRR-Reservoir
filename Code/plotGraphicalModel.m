
function [] = plotGraphicalModel(graphModel1,graphModel2)

global resInfo
global root

%fn = fullfile(root, ...
 %               '/Desktop/ReservoirModeling/Code/PlotGraphicalModel',...
  %              'reservoir-summary.csv');
fn = strcat(root,'Data/Reservoirs/reservoir-summary.csv');
  
resv_all = readtable(fn, 'ReadRowNames', true);

  % take only the rows we need, in "names_orig" order
resv_orig = resv_all(resInfo.name,:);

resv_orig.index = [1:55]';

% get the index set
% sorting is primary by hydro-zone (1, 3, 4, 5), then by basin index,
% which is essentially major river ID, then by latitude
resv = sortrows(resv_orig, ...
                {'ZoneIndex', 'BasinIndex','Latitude'},...
                {'ascend', 'ascend', 'ascend'});
resv_index = resv.index;

% re-order precision matrices
graphModel1 = graphModel1(resv_index, resv_index);
graphModel2 = graphModel2(resv_index, resv_index);
% re-order names
names = resInfo.name(resv_index);

% for convenience, find re-scaled precision matrices
pm_rescaler = @(pm)(pm ./ sqrt(diag(pm) * diag(pm)'));
edgeStrength1 = pm_rescaler(graphModel1);
edgeStrength2 = pm_rescaler(graphModel2);

% find zone counts
z_blocks = diff([0;find(diff(resv.ZoneIndex));size(graphModel1,1)]);
z_lbls = {{'N.', 'Coast'}, 'Sacramento', 'S.Joaquin', 'Tulare'};


assert(sum(z_blocks) == size(edgeStrength1, 1));

cb_props = {'Location', 'SouthOutside', 'FontSize', 12};

% sparse GM vs. full model
% (re: threshold: inspection shows there are really 3 standouts)
if false,
  figure(1)
  [h1a,h1b]=pm_image_plot(edgeStrength1, [0.81 0.95], names, z_blocks, z_lbls);
  colorbar;
end

% latent GM vs. sparse GM
% (re: threshold: inspection shows there are really 3, or 6, standouts)
%figure(2)
[h2a,h2b]=pm_image_plot(edgeStrength1, edgeStrength2,[0.775 0.81], names, z_blocks, z_lbls);
h = colorbar(cb_props{:});
h.Position = h.Position + [0 -0.109 0 0];

% may want to fiddle with figs...c

if false,
  figure(1)
  export_fig -transparent /tmp/connect-gm-fm.png
  figure(2)
  export_fig -transparent /tmp/connect-lm-gm.png
  figure(1)
  export_fig -transparent /tmp/connect-gm-fm.pdf
  figure(2)
  export_fig -transparent /tmp/connect-lm-gm.pdf
end
