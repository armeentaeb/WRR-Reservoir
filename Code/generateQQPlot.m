function [] = generateQQPlot(TrainY)
TrainY = TrainY(:,setdiff([1:55],22));
difT = [];
for	j = 1:size(TrainY,2)
   eval(['difT=[difT,(TrainY(:,j)-mean(TrainY(:,j)))];']);
end
S = cov(TrainY,1);
D = difT*inv(S)*difT';
[d,t] = sort(diag(D));   %squared Mahalanobis distances
r = tiedrank(d);  %ranks of the squared Mahalanobis distances
chi2q=chi2inv((r-0.5)./size(TrainY,1),size(TrainY,2));  %chi-square quantiles  
plot(chi2q,d,'*b')
axis([0 max(chi2q)+1 0 max(d)+1])
hold on;
plot(linspace(0,max(chi2q)+1,100),linspace(0,max(chi2q)+1,100),'r--')
end