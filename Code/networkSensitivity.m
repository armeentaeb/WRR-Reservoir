%%% Written by Armeen Taeb, California Institute of Technology, December 2016



function [] = networkSensitivity(precision,avgMonthY, avgMonthX,varY,varX,resInd)


% Find scaling to make all time series have unit variance
Sigma = precision^(-1);
p = size(avgMonthY,2);




%% this is a montecarlo approach to compute probability

kf = 6; % parameter k in the paper
numIter = 50000;

% PDSI values
PDSIv = 2:-0.1:-7;

% November reservoir averages
reservoirAvergeNovember = avgMonthY(12,resInd);
 ProbEmptyPrp = zeros(length(PDSIv),kf);
 
for i = 1:length(PDSIv)
    i
    PDSIAdjusted = (avgMonthX(12,6)-PDSIv(i)); 
  for k = 1:kf 
      count = 0;
    for iter = 1:numIter
 
        
        
        % what does 0 translate to after scaling
        exhaustionThresholds = -varY(resInd,resInd)*reservoirAvergeNovember';
        
        
        % conditional distribution of reservoir volume conditioned on PDSI
        SigmaCond = Sigma(resInd,resInd)-Sigma(resInd,p+1)*Sigma(p+1,p+1)^(-1)*Sigma(resInd,p+1)';
       
    
        % PDSI values standard deviations away from the mean:         
        mu_resi =  Sigma(resInd,p+1)*Sigma(p+1,p+1)^(-1)*varX(6,6)*(-PDSIAdjusted);
       
        y = mvnrnd(mu_resi,SigmaCond);
      
        % find if at least k of the reservoirs will run dry
        val= length(find(y' < exhaustionThresholds));
        if val >= k
          count = count +1;
        end
      
    end
    
    ProbEmptyPrp(i,k) = count/iter;
         
  end

end



close all
plot(PDSIv,ProbEmptyPrp(:,1),'LineWidth',2)
hold on; plot(PDSIv,ProbEmptyPrp(:,2),'LineWidth',2)
hold on; plot(PDSIv,ProbEmptyPrp(:,3),'LineWidth',2)
hold on; plot(PDSIv,ProbEmptyPrp(:,4),'LineWidth',2)
hold on; plot(PDSIv,ProbEmptyPrp(:,5),'LineWidth',2)
hold on; plot(PDSIv,ProbEmptyPrp(:,6),'LineWidth',2)
grid on;
set(gca,'FontSize',16,'FontWeight','Bold')
xlabel('PDSI','FontSize',16,'FontWeight','Bold')
ylabel('Probability of Exhaustion','FontSize',16,'FontWeight','Bold')
xlim([-7,2])
plot(avgMonthX(12,6)*ones(100,1),linspace(0,1,100),'k--','LineWidth',2)
plot(DataXM(12*11+11,6)*ones(100,1),linspace(0,1,100),'b-.','LineWidth',2)
plot(DataXM(12*12+11,6)*ones(100,1),linspace(0,1,100),'r-.','LineWidth',2)
plot(DataXM(12*13+11,6)*ones(100,1),linspace(0,1,100),'g-.','LineWidth',2)
legend('k = 1','k = 2','k = 3','k = 4', 'k = 5', 'k = 6','mean', 'Sept. 2014','Sept. 2015','Sept. 2016')

