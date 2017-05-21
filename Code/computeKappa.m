%% Written by Armeen Taeb, December 2016
%% Objective: computes the quantity kappa in the paper
%% Input: graphStrength - strength of edges (matrix of p x p)
%% Output: kappa - quantity capturing inner zone connection over total edge strength

function [kappa] = computeKappa(graphStrength)

global resInfo

zone3 = find(resInfo.zoneind == 3); % reservoirs in time zone 3
zone4 = find(resInfo.zoneind == 4); % reservoirs in time zone 4
zone5 = find(resInfo.zoneind == 5); % reservoirs in time zone 5
zone1 = find(resInfo.zoneind == 1); % reservoirs in time zone 5

strengthInnerZone = sum(sum(abs(graphStrength(zone1',zone1')))) + ...
    sum(sum(abs(graphStrength(zone3',zone3'))))+ ...
    sum(sum(abs(graphStrength(zone4',zone4')))) + ...
    sum(sum(abs(graphStrength(zone5',zone5'))));

totalStrenth = sum(sum(abs(graphStrength)));
kappa = strengthInnerZone/totalStrenth;
end