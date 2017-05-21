   
function [TrainData,TestData, avgMonth, varScaling] = preprocessingData(TrainData,TestData,TrainInd,TestInd)

Obser = 1:size(TrainData,1)+size(TestData,1);
temp = mod(Obser,12);


avgMonth = zeros(12,size(TrainData,2));
% remove climatalogy
 for i = 0:11
       [ind] = find(temp(TrainInd) == i); % data corresponding to ith month
        avgMonth(i+1,1:size(TrainData,2))  = mean(TrainData(ind,:),1); % average data from this month
        TrainData(ind,:) = TrainData(ind,:) - repmat(avgMonth(i+1,:),length(ind),1); % subtract climatalogy
 end

% scale to have unit variance 
SigmaTrain = cov(TrainData);
varScaling = diag(diag(SigmaTrain).^(-1/2));
TrainData = TrainData*varScaling;
 
 
% apply the same transformations to validation observations
for i = 0:11
    [ind] = find(temp(TestInd) == i);
     TestData(ind,:) = TestData(ind,:) - repmat(avgMonth(i+1,:),length(ind),1);
end

% scale to have unit variance 
TestData = TestData*varScaling;