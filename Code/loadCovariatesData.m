%% Thus function loads covariates data
%% Input -  timePeriod: index to the months to download the covariates
%% Output - DataXM: the covariates data

function [DataXM, covariatesName] = loadCovariatesData(timePeriod,dirCovariates)


files = dir(dirCovariates);
fileIndex = find(~[files.isdir]);
q = length(fileIndex)-1;

% Define time series of the covariates
DataXM = zeros(timePeriod,q);

covariatesName = cell(length(fileIndex)-1,1);

% read covariate information
for i = 2:length(fileIndex)
       covariatesName{i-1} = files(fileIndex(i)).name;
      	A = xlsread(strcat(dirCovariates,'/',covariatesName{i-1}));
      if i ~= 7 & i ~= 2
        DataXM(:,i-1) = [zeros(12,1);A(:,2);zeros(35,1)]; % these numbers are for missing data
      else
        DataXM(:,i-1) = A(:,2);  
      end
end

end