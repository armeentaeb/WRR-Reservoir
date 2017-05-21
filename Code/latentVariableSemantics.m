% This function conmputes the correlation of each covariate with the latent space
% Written by Armeen Taeb, December 2016
% Input: Low rank matrix summarizing the effect of latent variables
%

function [correlation] = latentVariableSemantics(L,TrainTest,condOnCovariate)

Y = TrainTest{1};
X = TrainTest{3};
numCovariates = size(X,2);
numHidden = length(find(svd(L)>10^(-2)));

[Ub, ~, ~] = svd(Y*L);

correlation = zeros(numCovariates,1);

if nargin < 3
for i = 1:size(X,2)
    correlation(i) = norm(Ub(:,1:numHidden)*Ub(:,1:numHidden)'*X(:,i)/norm(X(:,i)));
end
else
    totalRemoveProj = zeros(size(Y,1));
    for j = 1:length(condOnCovariate)
        temp = X(:,condOnCovariate(j))/norm(X(:,condOnCovariate(j)));
        totalRemoveProj = totalRemoveProj + temp*temp';
    end
    for i = 1:size(X,2)
        correlation(i) = norm((eye(size(X,1))-totalRemoveProj)*Ub(:,1:2)*Ub(:,1:2)'*(eye(size(X,1))-totalRemoveProj)*...
            X(:,i)/norm(X(:,i)));
    end
end


end