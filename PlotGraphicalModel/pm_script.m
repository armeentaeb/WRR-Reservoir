%
% plots of hydro results
% turmon mar/apr 2016
%function [] = plotGraphicalModel(S1,S2)

pm_load;

assert(sum(z_blocks) == size(pm_gm, 1));

cb_props = {'Location', 'SouthOutside', 'FontSize', 12};

% sparse GM vs. full model
% (re: threshold: inspection shows there are really 3 standouts)
if false,
  figure(1)
  [h1a,h1b]=pm_image_plot(pm_gm, [0.81 0.95], names, z_blocks, z_lbls);
  colorbar;
end

% latent GM vs. sparse GM
% (re: threshold: inspection shows there are really 3, or 6, standouts)
%figure(2)
[h2a,h2b]=pm_image_plot(pm_lm, pm_gm,[0.775 0.81], names, z_blocks, z_lbls);
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
