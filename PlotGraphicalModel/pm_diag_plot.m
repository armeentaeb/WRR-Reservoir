function h=pm_diag_plot(d, cm, cax)
%pm_diag_plot	plot diagonals of precision matrix
% 
% h=pm_diag_plot(d, cm, cax)
% * Plot vector d along the diagonals of a matrix
% * Map its values through a colormap cm and color axis
% range cax.
% * Returns handles to the patch objects.
% 
% Inputs:
%   real d(n)
%   opt real cm(ncolor, 3) = jet
%   opt real cax = [min(d) max(d)]
%
% Outputs:
%   handle h
% 
% See Also:  

% 
% Error checking
% 
if all(nargin  ~= [1 2 3]), error ('Bad input arg number'); end
% if all(nargout ~= [0 1]), error ('Bad output arg number'); end  
if nargin < 2, cm = jet(256); end;
if nargin < 3, cax = [min(d) max(d)]; end;

%
% Computation
% 
n = length(d);
N = [1:n]'; % column vector

% rescale d
val = (d - cax(1)) / (cax(2) - cax(1));
val(val < 0) = 0;
val(val > 1) = 1;
% map val through colormap
val_cmap = interp1(linspace(0, 1, size(cm,1)), cm, val);

% vert = stack of all (x,y) pairs that are vertices of
% any grid square
X = [N-0.5; N-0.5; N+0.5; N+0.5];
Y = [N-0.5; N+0.5; N+0.5; N-0.5];
vert = [X Y];

% fac = stack of all faces -- each row is one face, which is
% a list of the 4 corners (vertices) of the patch
fac = [N n+N 2*n+N 3*n+N];

% create a patch object
h = patch(...
    'Vertices',vert, ...
    'Faces',fac, ...
    'FaceVertexCData', val_cmap, ...
    'FaceColor', 'flat');

% kill black lines around these elements
set(h, 'LineStyle', 'none');

if nargout == 0,
  clear h
end;

return
