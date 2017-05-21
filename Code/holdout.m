function [] = holdout(TrainTest,method)

global GM
global LVGM
global Conditional_LVGM

if method == GM
    lambda = linspace(0.01,1,200);
    train = zeros(length(lambda),1);
    validation = zeros(length(lambda),1);
    
    for i = 1:length(lambda)
       [precision, ~, ~] = ObtainEstimate(TrainTest,GM,lambda(i));
       [train(i), validation(i)] = computeTrainValidationPerformance(precision,GM);
    end
    
    plot(lambda,train,'x');
    figure;
    plot(lambda,validation,'x')
    
elseif method == LVGM
    
    
elseif method == Conditional_LVGM
    
    
end    