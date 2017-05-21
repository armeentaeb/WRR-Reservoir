%% This function averages responses monthly data to obtain monthly measurements
%% Input: DataResponse with size being monthly observations by number of variables
%% Input: endMonth: total number of months that the daily measurements would get averaged to
%% We note that this analysis assumes that the reservoir data starts from January
function [AvgMonthData] = AverageMonthly(DataResponses,endMonth)

% number of years this data covers
years = floor(size(DataResponses,1)/365);

% index to a new month starting from January
newMonthInd = [1,32,60,91,121,152,182,213,244,274,305,335];

numDays = 365; % total number of days in a year

k = 1;
for i = 0:years
    for j = 1:length(newMonthInd)
        if k == endMonth+1
            return;
        end
        
        % Everything but month of December
        if j ~= 12
            for index = 1:size(DataResponses,2)
                TempD = DataResponses(i*numDays+newMonthInd(j):i*numDays+newMonthInd(j+1)-1,index); % get daily data from the month
                ind = find(isnan(TempD) == 0); % consider only data that is available   
                AvgMonthData(k,index) = mean(TempD(ind),1); % average daily observations to get monthly output
            end
        
        % Month of December case
        else
            for index = 1:size(DataResponses,2)
                TempD = DataResponses(i*numDays+newMonthInd(j):i*numDays+numDays,index); % get daily data from the monthly data
                ind = find(isnan(TempD) == 0); % consider only data that is available
                AvgMonthData(k,index) = mean(TempD(ind),1); % average daily observations to get monthly output
            end                
        end
         k = k + 1;
    end
end