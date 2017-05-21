% Written by Armeen Taeb, December 2016
% Input: graphModel - graphical model (matrix of p x p)
% Outout: edgeStrength - edge strenghts (matrix of p x p)
function [edgeStrength] = computeEdgeStrength(graphModel)

edgeStrength = zeros(size(graphModel));
for i = 1:size(graphModel,2)
    for j = i : size(graphModel,2)
        if i ~= j
            edgeStrength(i,j) = abs(graphModel(i,j))/(graphModel(i,i)^(1/2)*graphModel(j,j)^(1/2));
        else
             edgeStrength(i,j) = 1;
        end
    end
end




