function [h_diag,h_large]=pm_image_plot(pm, pm2, tau, names, blocks, lbls)
%pm_image_plot	plot precision matrix
% 
% [h_diag,h_large]=pm_image_plot(pm, pm2, tau)
% * Plot precision matrix pm
% * Returns handles to the patch objects.
% 
% Inputs:
%   real pm(n,n)
%   opt real pm2(n,n) = pm
%   opt real tau = 0.8  (in 0..1)
%
% Outputs:
%   handle h_diag -- diagonal patches
%   handle h_large -- large-value patches
% 
% See Also:  

% 
% Error checking
% 
% if all(nargin  ~= [1 2 3]), error ('Bad input arg number'); end
% if all(nargout ~= [0 1]), error ('Bad output arg number'); end  
if nargin < 2,
  pm2 = pm;
end
if nargin < 3, tau = 0.8; end;
if nargin < 4, names = {}; end;
if nargin < 5, blocks = []; end;
if nargin < 6, lbls = {}; end;

assert(length(blocks) == length(lbls));

%
% Computation
% 
N_res = max(size(pm));
pm_diag = (eye(N_res) > 0);

% precision matrix diagonals
pm_d = diag(pm);
pm2_d = diag(pm2);

% make normalized precision matrix
%   PM_ij / sqrt(PM_ii * PM_jj)
junk = sqrt(pm_d * pm_d');
pm_norm = pm ./ junk;
pm_norm(pm_diag) = 0;

% same for pm2
junk = sqrt(pm2_d * pm2_d');
pm2_norm = pm2 ./ junk;
pm2_norm(pm_diag) = 0;

% make non-negative
pm_norm = abs(pm_norm);
pm2_norm = abs(pm2_norm);

% also, make rescaled version of pm2 so that it will
%   be on same scale as pm1
%   (both are >= 0)
pm2_scale = pm2_norm; %* (max(pm_norm(:)) / max(pm2_norm(:)));

% compose pm + pm2 into one matrix
pmAll = zeros(size(pm));
pmAll(cumsum(pm_diag) == 0) = pm2_scale(cumsum(pm_diag) == 0);
pmAll(cumsum(pm_diag) == 1) = pm_norm(cumsum(pm_diag) == 1);

% arrange pmAll so 0-values will go to a special color
%   (NaN is at the bottom of the colormap)
pmAll(pmAll == 0) = NaN; % 0 values to a sentinel
pmAll_max = max(pmAll(:));

% main image colormap
N_cmap = 256;
if false,
  % old
  cmap = flipud(bone(N_cmap));
  cmap(1,:) = [1 0.92 1];
else,
  cmap = parula(N_cmap);
  cmap(1,:) = [1 1 1] * 0.85;
end;

% there will be N_cmap-2 gaps between 0 and pmAll_max,
% and one final gap below zero.
cmap_delta = pmAll_max/(N_cmap + 2);

% make basic image plot
imagesc(pmAll);
colormap(cmap);
caxis([-cmap_delta pmAll_max]);
axis image
axis xy

set(gca, 'FontSize', 14);

% make overlay along the diagonal
% Old colormap:
%   cmap_diag = flipud(hot(256));
%   cmap_diag = cmap_diag(64:end,:); % chop off whitish colors
% New colormap, that is all-red, effectively suppressing diagonal
cmap_diag = ones(64,1) * [0.8 0 0];
cmap_diag = ones(64,1) * [1 1 1];
% h_diag = pm_diag_plot(pm_d, cmap_diag);
h_diag = pm_diag_plot(sum(pm_norm), cmap_diag);

% the above command resets the caxis
caxis([-cmap_delta pmAll_max]);
[val ind] = sort(vec(triu(abs(pm_norm))),'descend');
for i = 1:5
    [inx_I1(i,1) inx_J1(i,1)] = find(triu(abs(pm_norm)) == val(i)); 
end
% identify the largest off-diagonals in pm (above the diagonal)
%[inx_I1, inx_J1] = find((triu(pm_norm)  > (tau(1) * max(pm_norm(:)))));
% identify the largest off-diagonals in pm2 (below the diagonal)
[val ind] = sort(vec(tril(abs(pm2_norm))),'descend');
for i = 1:5
    [inx_I2(i,1) inx_J2(i,1)] = find(tril(abs(pm2_norm)) == val(i)); 
end

%[inx_I2, inx_J2] = find((tril(pm2_norm) > (tau(2) * max(pm2_norm(:)))));


%inx_I1 = inx_I1([1:5]);
%inx_J1 = inx_J1([1:5]);

%inx_I2 = inx_I2([1:5]);
%inx_J2 = inx_J2([1:5]);
% combine or not combine lists
if false,
  inx_I = [inx_I1(:)];
  inx_J = [inx_J1(:)];
else,
  inx_I = [inx_I1(:); inx_I2(:)];
  inx_J = [inx_J1(:); inx_J2(:)];
  %inx_I = unique([inx_I1(:); inx_I2(:)]);
  %inx_J = unique([inx_J1(:); inx_J2(:)]);
end;
inx_I_u = unique(inx_I);
inx_J_u = unique(inx_J);

% X and Y list their corners
X = [inx_I-0.5; inx_I-0.5; inx_I+0.5; inx_I+0.5];
Y = [inx_J-0.5; inx_J+0.5; inx_J+0.5; inx_J-0.5];

% a row in "vert" is a single corner, (x,y)
vert = [X Y];

% fac = stack of all faces -- each row is one face, which is
% a list of the 4 corners (vertices) of the patch
n = length(inx_I);
N = [1:n]';
fac = [N n+N 2*n+N 3*n+N];

% create a patch object for the largest values
%   they are indicated mostly with edges
h_large = patch(...
    'Vertices',vert, ...
    'Faces',fac, ...
    'FaceVertexCData', [1 0 0], ...
    'FaceAlpha', 0, ...
    'EdgeColor', [1 0 0]*0.9, ...
    'LineWidth', 3);

% make a grid to separate hydro zones
if ~isempty(blocks),
  % find fencepost locations
  b_pos = cumsum(blocks(1:end-1)) + 0.5;
  set(gca, 'XTick', b_pos, 'YTick', b_pos);
  set(gca, 'XTickLabel', [], 'YTickLabel', []);
  set(gca, 'XGrid', 'on', 'YGrid', 'on');
  set(gca, 'XMinorGrid', 'on', 'YMinorGrid', 'on');
  drawnow; pause(0.1); % (let handle graphics catch up)
  xgrid = get(gca, 'XGridHandle');
  ygrid = get(gca, 'YGridHandle');
  % grid is thick + reddish
  grid_color = [0.8 0.2 0.2]; 
  grid_style = {'LineWidth', 3, 'Color', grid_color};
  set(xgrid, grid_style{:})
  set(ygrid, grid_style{:})
  % use minor-ticks to hilight certain reservoirs (ticks must be sorted)
  minor_tick_style = {'MinorLineWidth', 1.2};
  set(xgrid, 'MinorTick', inx_I_u, minor_tick_style{:});
  set(ygrid, 'MinorTick', inx_J_u, minor_tick_style{:});
end

% text labels for hydro zones
if ~isempty(lbls),
  % t_pos is halfway between the b_pos fenceposts
  t_pos = ([-0.5;b_pos(:)] + [b_pos(:);N_res+0.5]) * 0.5;
  t_style = {'HorizontalAlignment','center','EdgeColor', [0 0 0]+0.3};
  % along x-axis
  text(t_pos+0.5, zeros(size(t_pos))-0.1, lbls, t_style{:}, ...
       'VerticalAlignment', 'top');
  % along y-axis
  text(zeros(size(t_pos))-0.1, t_pos+0.5, lbls, t_style{:}, ...
       'Rotation', 90, 'VerticalAlignment', 'bottom');
end

% labels for selected reservoirs
if ~isempty(names),
  t_style = {'HorizontalAlignment', 'left', 'FontSize', 12};
  text(inx_I_u, zeros(size(inx_I_u))+N_res+1, names(inx_I_u), t_style{:}, ...
       'Rotation', 90);
  text(zeros(size(inx_J_u))+N_res+1, inx_J_u, names(inx_J_u), t_style{:});
end;

% title, raised a bit
%h_title = title('Reservoir Connectivity', 'FontSize', 16);
%h_title.Position = h_title.Position + [0 3 0];

ax_lbl_style = {'FontWeight', 'bold', 'FontSize', 14};
xlabel('Reservoir', ax_lbl_style{:})
ylabel('Reservoir', ax_lbl_style{:})

% move the axis labels away from axes
ax = gca;
ax.XLabel.Position = ax.XLabel.Position + [0 -2 0];
ax.YLabel.Position = ax.YLabel.Position + [-2 0 0];

% make minor grid more visible
ax.MinorGridAlpha = 1;

if nargout == 0,
  clear h_diag
end;

return
