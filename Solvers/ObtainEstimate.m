
function [precision,lowRank,graphModel] = ObtainEstimate(TrainTestData,method,regularizer)

% load Training and testing data
TrainY = TrainTestData{1};
TrainX = TrainTestData{3}(:,:);



% Compute scaled smaple covariance
SigmaTrain = cov([TrainY TrainX]);


global GM;
global LVGM;
global Conditional_LVGM;

p = size(TrainY,2);
q = size(TrainX,2);


switch method
    
    % Graphical Model Estimate
    case GM
        [F] = LogDetPPAParser(SigmaTrain(1:p,1:p),p,0,regularizer(1),100,0);
        
        % This is the graphical model estimate
        graphModel = F{1}(1:p,1:p);
        graphModel(abs(graphModel)<10^(-2)) = 0;
        
        precision = graphModel; %computes Precision matrix
        lowRank = zeros(p);
        graphModel = precision;
        graphSparsity = length(find(abs(graphModel) < 10^(-2)))/p^2;
        fprintf('total number of edges is %d\n', (1-graphSparsity)*p^2/2 - p/2)
        
        
    % Latent Variable Graphical Model Estimate
    case LVGM
        [F] = LogDetPPAParser(SigmaTrain(1:p,1:p),p,0,regularizer(1),regularizer(2),0);
        hatL = F{2};
        hatS = F{1}(1:p,1:p) + hatL;
        hatS(abs(hatS)<10^(-2)) = 0; 
        graphSparsity = length(find(abs(hatS) < 10^(-2)))/p^2; %number of edges
        numLatent = length(find(svd(hatL)>10^(-2))); %number of latent variables
        [U, D, V] = svd(hatL);
        hatL = U(:,1:numLatent)*D(1:numLatent,1:numLatent)*V(:,1:numLatent)';
        graphModel = hatS;
        lowRank = hatL;
        precision = hatS-hatL;
        fprintf('total number of edges is %d\n', (1- graphSparsity)*p^2/2 - p/2)
        fprintf('Number of hidden variables is %d\n', numLatent)
        
        
        
        
     % Conditional graphical model estimate
    case Conditional_LVGM
        
        [F] = LogDetPPAParser(SigmaTrain,p,q,regularizer(1),regularizer(2),0);
        precision = F{1};
        hatSY = F{1}(1:p,1:p) + F{2};
        hatSY(abs(hatSY)<10^(-2)) = 0; 
        graphSparsity = length(find(abs(hatSY) < 10^(-2)))/p^2; %number of edges
        hatLY = F{2};
        numLatent = length(find(svd(hatLY)>10^(-2))); %number of latent variables
        [U, D, V] = svd(hatLY);
        hatLY = U(:,1:numLatent)*D(1:numLatent,1:numLatent)*V(:,1:numLatent)';
        lowRank = hatLY;
        graphModel = hatSY;
        %disp(sprintf('Total number of parameters is %d', ModelComplex))
        fprintf('total number of edges is %d\n', (1-graphSparsity)*p^2/2 - p/2)
        fprintf('Number of hidden variables is %d\n', numLatent)
   
end
