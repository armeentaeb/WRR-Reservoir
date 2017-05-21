%% Written by Armeen Taeb, December 2016
%% Goal: compute validation and training performance of a model
%% Input: Precision: joint precision matrix (with the size equal to ...
%% the number of variables.
%% Input: TrainTest: containing training and testing observations of the responses
%% and covariates

function [train, validation] = computeTrainValidationPerformance(Precision, method)

global TrainTest
global Conditional_LVGM

% Extract training and validation performance
trainY = TrainTest{1};
testY = TrainTest{2};
trainX = TrainTest{3};
testX = TrainTest{4};

p = size(trainY,2);
q = size(trainX,2);


% Extract validation data that is not missing
sizeNonan = 1;
testYnonan = zeros(size(testY));
testXnonan = zeros(size(testX));
for j = 1:size(testY,1)
    if sum(isnan(testY(j,:))) == 0 && sum(isnan(testX(j,:))) == 0
        testYnonan(sizeNonan,1:size(testY,2)) = testY(j,:);
        testXnonan(sizeNonan,1:size(testX,2)) = testX(j,:);
        sizeNonan = sizeNonan + 1;
    end
end
testYnonan = testYnonan(1:sizeNonan-1,:);
testXnonan = testXnonan(1:sizeNonan-1,:);

 sizeNonan = 1;
    trainYnonan = zeros(size(testY));
    trainXnonan = zeros(size(testX));
    for j = 1:size(trainY,1)
        if sum(isnan(trainY(j,:))) == 0 && sum(isnan(trainX(j,:))) == 0
            trainYnonan(sizeNonan,1:size(trainY,2)) = trainY(j,:);
            trainXnonan(sizeNonan,1:size(trainX,2)) = trainX(j,:);
            sizeNonan = sizeNonan + 1;
        end
    end
trainYnonan = trainYnonan(1:sizeNonan-1,:);
trainXnonan = trainXnonan(1:sizeNonan-1,:);
    
numTrain = size(trainYnonan,1);
numTest = size(testYnonan,1); 

if method == Conditional_LVGM
    totalTest = ([testYnonan';testXnonan']);%-BestLinearEstimator*DtransX*(TestXnonan' - repmat(avgX',1, NumTest));
    
    % compute average validation performance
    LogLikelihood = 0;
    for i = 1:numTest
        l = totalTest(:,i);
        temp = -(p+q)/2*log(2*pi)+1/2*sum(log(eig(Precision)))-1/2*l'*Precision*l;
        LogLikelihood = LogLikelihood + temp;
    end
     validation = LogLikelihood/numTest;
    
  
    
    % compute training performance
    
    totalTrain = ([trainYnonan';trainXnonan']);%;- BestLinearEstimator*DtransX*(TrainXnonan' - repmat(avgX',1, NumTrain));
    
    LogLikelihoodtrain = 0;
    for i = 1:numTrain
        l = totalTrain(:,i);
        temp = -(p+q)/2*log(2*pi)+1/2*sum(log(eig(Precision)))-1/2*l'*Precision*l;
        LogLikelihoodtrain = LogLikelihoodtrain + temp;
    end
    
    train =   LogLikelihoodtrain/numTrain;
    
    
    
else
    
    % compute testing performance
    totalTest = testYnonan';
    LogLikelihood = 0;
    for i = 1:numTest
        l = totalTest(:,i);
        temp = -p/2*log(2*pi)+1/2*sum(log(eig(Precision)))-1/2*l'*Precision*l;
        LogLikelihood = LogLikelihood + temp;
    end
    
    validation = LogLikelihood/numTest;
    totalTrain = (trainYnonan');
    LogLikelihoodtrain = 0;
    for i = 1:numTrain
        l = totalTrain(:,i);
        temp = -p/2*log(2*pi)+1/2*sum(log(eig(Precision)))-1/2*l'*Precision*l;
        LogLikelihoodtrain = LogLikelihoodtrain + temp;
    end
    
    train =   LogLikelihoodtrain/numTrain;
   
end

