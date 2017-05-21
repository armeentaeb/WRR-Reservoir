%% Written by Armeen Taeb, December 2016
%% Objective: plots figure XX of paper 
%% Input: edge strength matrix

function [] = elevDrainageRatio(edgeStrength)

global resInfo

p = size(edgeStrength,1);
capRatio = length(find(edgeStrength > 0)) - length(edgeStrength);
elevRatio = length(find(edgeStrength > 0)) - length(edgeStrength);
strength = length(find(edgeStrength > 0)) - length(edgeStrength);

l = 1;
for i = 1:p
    for j = i+1:p
        if edgeStrength (i,j) > 0
           
           strength(l) = abs(edgeStrength(i,j));
           capRatio(l) = abs(max(resInfo.drain(i)/resInfo.drain(j),...
               resInfo.drain(j)/resInfo.drain(i)));
           elevRatio(l) = abs(max(resInfo.elev(i)/resInfo.elev(j),...
               resInfo.elev(j)/resInfo.elev(i)));
           l = l + 1;
        end
    end
end

figure
plot(elevRatio,strength,'x')
grid on;
set(gca,'FontSize',16,'FontWeight','Bold')
xlabel('Elevation Ratio','FontSize',16,'FontWeight','Bold')
ylabel('Edge Strength','FontSize',16,'FontWeight','Bold')


figure
plot(capRatio,strength,'x')
grid on;
set(gca,'FontSize',16,'FontWeight','Bold')
xlabel('Drainage Area Ratio','FontSize',16,'FontWeight','Bold')
ylabel('Edge Strength','FontSize',16,'FontWeight','Bold')
