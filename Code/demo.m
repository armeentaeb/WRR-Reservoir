%% This is a demo for the paper "A Statistical Graphical Model of the California Reservoir Network
%% Written by Armeen Taeb, California Institute of Technology, December 2016
close all
clear all
clc

%%  Define globa variables for solvers
global GM; % Graphical modeling 
global LVGM; % Latent variable graphical modeling
global Conditional_LVGM; % Conditional latent variable graphical modeling
GM = 1;
LVGM = 2;
Conditional_LVGM = 3;
global covariatesName; % cell containing name of the covariates
global resInfo
global TrainTest
global root

% get appropriate directory
temp = pwd;
root = temp(1:end-4);

% addpath to reservoir data and info
addpath(strcat(root,'/Data/Reservoirs'))
addpath(strcat(root,'/Data/Covariates'))

% addpath to solvers
addpath(strcat(root,'/Solvers'))
addpath(strcat(root,'/Solvers/logdetppa-0'))
addpath(strcat(root,'/Solvers/logdetppa-0/solver'))
addpath(strcat(root,'/Solvers/logdetppa-0/util'))
addpath(strcat(root,'/Solvers/logdetppa-0/solver/mexfun'))

% read reservoir data
[DataY] = xlsread('ReservoirsData');
DataY = DataY(:,2:end);
selRes = [1:9,11:13,15:16,18:29,31:49,51:60]; % These are reservoirs without huge chunk of missing information
DataY = DataY(:,selRes);

[resInfoM,resInfoT] = xlsread('reservoir_summary');

% numeric fields
resInfo.lat = resInfoM(selRes,1);
resInfo.lon = resInfoM(selRes,2);
resInfo.elev = resInfoM(selRes,3);
resInfo.cap = resInfoM(selRes,4);
resInfo.drain = resInfoM(selRes,5);
resInfo.zoneind = resInfoM(selRes,7);
resInfo.basinind = resInfoM(selRes,9);
resInfo.streamind = resInfoM(selRes,11);


% text fields
resInfo.name = resInfoT(selRes+1,1);
resInfo.dam = resInfoT(selRes+1,2);
resInfo.lake = resInfoT(selRes+1,3);
resInfo.hydro = resInfoT(selRes+1,4);
resInfo.basinname = resInfoT(selRes+1,5);
resInfo.zonename = resInfoT(selRes+1,6);
resInfo.basinname = resInfoT(selRes+1,7);
resInfo.streamname = resInfoT(selRes+1,8);



numYears = floor(size(DataY,1)/365);
numMonths = numYears*12 + floor((size(DataY,1)/365-numYears)*12);

% Obtain monthly average reservoir volumes
DataYM = AverageMonthly(DataY,numMonths);
timePeriod = 1:size(DataYM,1); % start in January 2004 since snowpack data starts 

%% Loading Covariates 
[DataXM, covariatesName] = loadCovariatesData(size(DataYM,1),strcat(root,'/Data/Covariates'));



%% Create training and validation data
    %validation observations from January 2003 - December 2003, January
    %2013 - November 2015
    TestInd = [1:12, size(DataYM,1)-34:size(DataYM,1)]; 
    
    % Training observations, January 2003 - December 2012
    TrainInd = setdiff(1:size(DataYM,1),TestInd);
  
    
    % Training and Validation Data
    TestY = DataYM(TestInd,:); % reservoirs validation data
    TrainY =  DataYM(TrainInd,:); % reservoirs training data
    TrainX = DataXM(TrainInd,:); % covariates training data
    TestX = DataXM(TestInd,:); % covariates validation data
    
   PlotFigure2 = 1;
   PlotFigure3 = 1;
   PlotFigure4 = 0;
   PlotFigure5 = 0;
   PlotFigure6 = 0;
   PlotFigure1Sup = 0;
   PlotFigure2Sup = 0;
   PlotFigure3Sup = 0;
   PlotFigure2Response = 0;
   PlotFigure4Response = 1;
   
   
    
   TrainTest = cell(4,1);
   TrainTest{1} = TrainY;
   TrainTest{2} = TestY;
   TrainTest{3} = TrainX;
   TrainTest{4} = TestX; 
    
   
   [TrainYa, TestYa, avgMonthY,varY] = preprocessingData(TrainY,TestY,TrainInd,TestInd);
   [TrainXa, TestXa, avgMonthX,varX] = preprocessingData(TrainX,TestX,TrainInd,TestInd);
    
    
    
    TrainTest = cell(4);
    TrainTest{1} = TrainYa;
    TrainTest{2} = TestYa;
    TrainTest{3} = TrainXa;
    TrainTest{4} = TestXa;
    p = size(TrainYa,2); 

   
   
   % Peformances of Unregularized ML, Independent Reservoir Model and
   % Graphical model
   [precisionGM, ~, ~] = ObtainEstimate(TrainTest,GM,[0.2350]);
   [trainGM, testGM] = computeTrainValidationPerformance(precisionGM,GM);
   [precisionGMUn, ~, ~] = ObtainEstimate(TrainTest,GM,[0]);
   [trainUn, testUn] = computeTrainValidationPerformance(precisionGMUn,GM);
   [precisionGMInd, ~, ~] = ObtainEstimate(TrainTest,GM,[1]);
   [trainInd, testInd] = computeTrainValidationPerformance(precisionGMInd,GM);
   
   
   % Computing kappa quantity for graphical model
   graphStrength1 = computeEdgeStrength(precisionGM);
    kappa_GM = computeKappa(graphStrength1);
    graphStrengthUn = computeEdgeStrength(precisionGMUn);
    kappa_Un = computeKappa(graphStrengthUn);

   
   
  
   % one latent variables
   [precisionLVGM1, lowRankLVGM1, graphModelLVGM1] = ObtainEstimate(TrainTest,LVGM,[0.2,3]);
   graphStrengthLV1 = computeEdgeStrength(graphModelLVGM1);
   kappa_LVGM1 = computeKappa(graphStrengthLV1);
   delta1 = computeDelta(precisionLVGM1,graphModelLVGM1);

   % two latent variables
   [precisionLVGM2, lowRankLVGM2, graphModelLVGM2] = ObtainEstimate(TrainTest,LVGM,[0.21,2.80]);
   graphStrengthLV2 = computeEdgeStrength(graphModelLVGM2);
   kappa_LVGM2 = computeKappa(graphStrengthLV2);
   delta2 = computeDelta(precisionLVGM2,graphModelLVGM2);

   % three latent variables
   [precisionLVGM3, lowRankLVGM3, graphModelLVGM3] = ObtainEstimate(TrainTest,LVGM,[0.2050,2.23]);
   graphStrengthLV3 = computeEdgeStrength(graphModelLVGM3);
   kappa_LVGM3 = computeKappa(graphStrengthLV3);
   delta3 = computeDelta(precisionLVGM3,graphModelLVGM3);


   % four latent variables
    [precisionLVGM4, lowRankLVGM4, graphModelLVGM4] = ObtainEstimate(TrainTest,LVGM,[0.1950,1.91]);
   graphStrengthLV4 = computeEdgeStrength(graphModelLVGM4);
    kappa_LVGM4 = computeKappa(graphStrengthLV4);
   delta4 = computeDelta(precisionLVGM4,graphModelLVGM4);


   % five latent variables
    [precisionLVGM5, lowRankLVGM5, graphModelLVGM5] = ObtainEstimate(TrainTest,LVGM,[0.22,1.69]);
   graphStrengthLV5 = computeEdgeStrength(graphModelLVGM5);
    kappa_LVGM5 = computeKappa(graphStrengthLV5);
   delta5 = computeDelta(precisionLVGM5,graphModelLVGM5);


  % siz latent variables
    [precisionLVGM6, lowRankLVGM6, graphModelLVGM6] = ObtainEstimate(TrainTest,LVGM,[0.235,1.02]);
   graphStrengthLV6 = computeEdgeStrength(graphModelLVGM6);
    kappa_LVGM6 = computeKappa(graphStrengthLV6);
   delta6 = computeDelta(precisionLVGM6,graphModelLVGM6);


   % train and validation performance
   [trainLVGM, testLVGM] = computeTrainValidationPerformance(precisionLVGM2,LVGM);
   correlation = latentVariableSemantics(lowRankLVGM2,TrainTest);
   correlationModified = latentVariableSemantics(lowRankLVGM2,TrainTest,6);
   
   % Conditional latent variable graphical modeling
   TrainTest{3} = TrainX(:,6);
   TrainTest{4} = TestX(:,6);
   [precisionCond, lowRank, graphModel] = ObtainEstimate(TrainTest,Conditional_LVGM,[0.18,2.72]);
   [trainCondLVGM, testCondLVGM] = computeTrainValidationPerformance(precisionCond,Conditional_LVGM);

    
    
    
    if PlotFigure2 == 1
        plotGraphicalModel(precisionGM,precisionGMUn)   
    end  
   
    if PlotFigure5 == 1
         figure;plotGraphicalModel(graphModelLVGM1,precisionGM)  
        figure;plotGraphicalModel(graphModelLVGM2,precisionGM)
        figure;plotGraphicalModel(graphModelLVGM3,precisionGM)
        figure;plotGraphicalModel(graphModelLVGM4,precisionGM)
        figure;plotGraphicalModel(graphModelLVGM5,precisionGM)
        figure;plotGraphicalModel(graphModelLVGM6,precisionGM)
    end

    
   if PlotFigure1Sup == 1
        generateQQPlot(TrainYa);
   end  
   
   
   
   
   if PlotFigure3Sup == 1
       [precisionGM, ~, ~] = ObtainEstimate(TrainTest,GM,[0.2350]);
        graphStrength1 = computeEdgeStrength(precisionGM);
        [precisionGM2, ~, ~] = ObtainEstimate(TrainTest,GM,[0.200]);
        graphStrength2 = computeEdgeStrength(precisionGM2);
         [precisionGM3, ~, ~] = ObtainEstimate(TrainTest,GM,[0.260]);
        graphStrength3 = computeEdgeStrength(precisionGM3); 
        plot(reshape(graphStrength1,p^2,1),reshape(graphStrength2,p^2,1),'x')
         xlabel('Edge Strength (\lambda = 0.230)','FontSize',16,'FontWeight','Bold')
        ylabel('Edge Strength (\lambda = 0.20)','FontSize',16,'FontWeight','Bold')
        grid on;
        figure;
        plot(reshape(graphStrength1,p^2,1),reshape(graphStrength3,p^2,1),'x')
        xlabel('Edge Strength (\lambda = 0.23)','FontSize',16,'FontWeight','Bold')
         ylabel('Edge Strength (\lambda = 0.26)','FontSize',16,'FontWeight','Bold')
        set(gca,'FontSize',16,'FontWeight','Bold')
        grid on
   end
   
   if PlotFigure3 == 1
    showReservoirSchematic()
   end
   
   
   
   if PlotFigure2Sup == 1
    regularizer = holdout(TrainTest,GM); 
   end
   
   
  
   if PlotFigure4 == 1
       elevDrainageRatio(graphStrength1);
       elevDrainageRatio(graphStrengthUn);
   end
       
   
    if PlotFigure6 == 1
    [val,ind] = sort(resInfo.cap,'descend');
    s = length(find(val>1*10^8));
    resInd = ind(setdiff((1:s),[22,33])); 
    networkSensitivity(precisionCond,avgMonthY,avgMonthX,varY,varX,resInd)
    end
    
    
    if PlotFigure2Response == 1
       
        TrainY2 = TrainY(13:end,:);
        TestY2 = TestY(13:end,:);
       TrainX2 = TrainX(13:end,:);
       TestX2 = TestX(13:end,:);
       [TrainYmod, TestYmod, ~,~] = preprocessingData(TrainY2,TestY2,1:108,1:35);
 

        TrainTest1{1} = TrainYmod;
        TrainTest1{2} = TestYmod;
        TrainTest1{3} = TrainYmod;
        TrainTest1{4} = TestYmod;
        cGMNew = linspace(0.01,0.5,100);
       for i = 1:length(cGMNew)
           [precisionGMMod, ~, ~] = ObtainEstimate(TrainTest1,GM,cGMNew(i));
           [trainGMMod(i), validGMMod(i)] = computeTrainValidationPerformance(precisionGMMod,GM);
       end
       [~,ind] = max(validGMMod);
       [precisionGMMod,~,~] = ObtainEstimate(TrainTest1,GM,cGMNew(ind));
       graphStrengthMod = computeEdgeStrength(precisionGMMod);
       kappaGMMod = computeKappa(edgeStrengthMod);
       plot(reshape(graphStrength1,p^2,1),reshape(graphStrengthMod,p^2,1),'x')
       xlabel('Original','FontSize',16,'FontWeight','Bold')
       ylabel('Modified','FontSize',16,'FontWeight','Bold')
        set(gca,'FontSize',16,'FontWeight','Bold') 
        grid on;
    end
    
    
    if PlotFigure4Response == 1
       TrainY2 = [TrainY(1:84,:); TrainY(97:120,:); TestY(1:12,:)];
       TestY2 = [TestY(12+1:end,:);TrainY(85:96,:)];
       [TrainYmod, TestYmod, ~,~] = preprocessingData(TrainY2,TestY2,TrainInd,TestInd);
 

        TrainTest1{1} = TrainYmod;
        TrainTest1{2} = TestYmod;
        TrainTest1{3} = TrainYmod;
        TrainTest1{4} = TestYmod;
        cGMNew = linspace(0.01,0.5,100);
       for i = 1:length(cGMNew)
           [precisionGMMod, ~, ~] = ObtainEstimate(TrainTest1,GM,cGMNew(i));
           [trainGMMod(i), validGMMod(i)] = computeTrainValidationPerformance(precisionGMMod,GM);
       end
       [~,ind] = max(validGMMod);
       [precisionGMMod,~,~] = ObtainEstimate(TrainTest1,GM,cGMNew(ind));
       graphStrengthMod = computeEdgeStrength(precisionGMMod);
       kappaGMMod = computeKappa(graphStrengthMod);
       plot(reshape(graphStrength1,p^2,1),reshape(graphStrengthMod,p^2,1),'x')
       xlabel('Original','FontSize',16,'FontWeight','Bold')
       ylabel('Modified','FontSize',16,'FontWeight','Bold')
        set(gca,'FontSize',16,'FontWeight','Bold') 
        grid on;
    end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    