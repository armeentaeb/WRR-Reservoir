function [ProbEmptyPrp] = individualSensitivity(precision,avgMonthY, avgMonthX,varY,varX,DataXM,resInd)



% Find scaling to make all time series have unit variance
Sigma = precision^(-1);
p = size(avgMonthY,2);
global resInfo




%% this is a montecarlo approach to compute probability

kf = 6; % parameter k in the paper
numIter = 10000;

% PDSI values
PDSIv = 2:-0.1:-7;

% November reservoir averages
reservoirAvergeNovember = avgMonthY(12,resInd);
 ProbEmptyPrp = zeros(length(PDSIv),length(resInd));
CondVari = cell(length(PDSIv),1);
CondMean = cell(length(PDSIv),1);
for i = 1:length(PDSIv)
    PDSIAdjusted = (avgMonthX(12,6)-PDSIv(i)); 
  for l = 1:length(resInd)
 
 
        
        
        % what does 0 translate to after scaling
        exhaustionThresholds = -varY(resInd,resInd)*reservoirAvergeNovember';
        SigmaExtract = Sigma([resInd(l) p+1],[resInd(l) p+1]);
        sigmaCond = SigmaExtract(1,1)-SigmaExtract(1,2)*SigmaExtract(2,2)^(-1)*SigmaExtract(1,2)';
        muCond = SigmaExtract(1,2)*SigmaExtract(2,2)^(-1)*varX(6,6)*-PDSIAdjusted;
        
         ProbEmptyPrp(i,l)= normcdf(exhaustionThresholds(l),muCond,sigmaCond);
        
  end
  i
end

[val ind] = sort(ProbEmptyPrp(end,:),'descend');
resInfo.name(resInd(ind(1:6)))

close all
plot(PDSIv,ProbEmptyPrp(:,ind(1)),'LineWidth',2)
hold on; plot(PDSIv,ProbEmptyPrp(:,ind(2)),'LineWidth',2)
hold on; plot(PDSIv,ProbEmptyPrp(:,ind(3)),'LineWidth',2)
hold on; plot(PDSIv,ProbEmptyPrp(:,ind(4)),'LineWidth',2)
hold on; plot(PDSIv,ProbEmptyPrp(:,ind(5)),'LineWidth',2)
hold on; plot(PDSIv,ProbEmptyPrp(:,ind(6)),'LineWidth',2)
grid on;
set(gca,'FontSize',16,'FontWeight','Bold')
xlabel('PDSI','FontSize',16,'FontWeight','Bold')
ylabel('Probability of Exhaustion','FontSize',16,'FontWeight','Bold')
xlim([-7,2])
plot(avgMonthX(12,6)*ones(100,1),linspace(0,1,100),'k--','LineWidth',2)
plot(DataXM(12*11+11,6)*ones(100,1),linspace(0,1,100),'b-.','LineWidth',2)
plot(DataXM(12*12+11,6)*ones(100,1),linspace(0,1,100),'r-.','LineWidth',2)
plot(DataXM(12*13+11,6)*ones(100,1),linspace(0,1,100),'g-.','LineWidth',2)
legend('Buchanan','Hidden Dam','Pine Flat','Isabella','Indian Valley','Black Butte','mean','Sept. 2014', 'Sept. 2015', 'Sept. 2016')
%legend('','k = 2','k = 3','k = 4', 'k = 5', 'k = 6','mean', 'Sept. 2014','Sept. 2015','Sept. 2016')
 


