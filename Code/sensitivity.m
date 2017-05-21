function [] = sensitivity(TrainY,TestY,TrainX,TestX)


global TrainTest
global GM

TrainInd = 1:120;
TestInd = 1:47;

TrainY = TrainTest{1};
TestY = TrainTest{2};
TrainX = TrainTest{3};
TestX = TrainTest{4};


[TrainYa, TestYa, avgMonthY,varY] = preprocessingData(TrainY,TestY,TrainInd,TestInd);
[TrainXa, TestXa, avgMonthX,varX] = preprocessingData(TrainX,TestX,TrainInd,TestInd);

TrainTest1{1} = TrainYa;
TrainTest1{2} = TestYa;
TrainTest1{3} = TrainXa;
TrainTest1{4} = TestXa;


[precisionGM, ~, ~] = ObtainEstimate(TrainTest1,GM,[0.2350]);
graphStrength1 = computeEdgeStrength(precisionGM);


TrainTest1 = TrainTest;
TrainTest1{1} = [TrainY(1:96,:); TrainY(109:120,:); TestY(1:12,:)];
TrainTest1{2} = [TestY(12+1:end,:);TrainY(97:108,:)];
TrainTest1{3} = [TrainY(1:96,:); TrainY(109:120,:); TestY(1:12,:)];
TrainTest1{4} = [TestY(12+1:end,:);TrainY(97:108,:)];

[TrainYa, TestYa, avgMonthY,varY] = preprocessingData(TrainTest1{1},TrainTest1{2},TrainInd,TestInd);
[TrainXa, TestXa, avgMonthX,varX] = preprocessingData(TrainX,TestX,TrainInd,TestInd);
TrainTest1{1} = TrainYa;
TrainTest1{2} = TestYa;
TrainTest1{3} = TrainXa;
TrainTest1{4} = TestXa;

lambda = linspace(0.01,0.5,100);
   train = zeros(length(lambda),1);
   test = zeros(length(lambda),1);
   for i = 1:length(lambda)
       [precisionGM, ~, ~] = ObtainEstimate(TrainTest1,GM,[lambda(i)]);
       [train(i), test(i)] = computeTrainValidationPerformance(precisionGM,TrainTest1,GM);
   end
[~,ind] = max(test);
[precisionGM, ~, ~] = ObtainEstimate(TrainTest1,GM,lambda(ind));
 graphStrength4 = computeEdgeStrength(precisionGM);
figure;plot(reshape(graphStrength1,[p^2,1]),reshape(graphStrength4,[p^2,1]),'x')








global TrainTest
global GM
p = size(TrainTest{1},2);
[precisionGM, ~, ~] = ObtainEstimate(TrainTest,GM,[0.2350]);
  graphStrength1 = computeEdgeStrength(precisionGM);
[precisionGM, ~, ~] = ObtainEstimate(TrainTest,GM,[0.200]);
   graphStrength2 = computeEdgeStrength(precisionGM);
   [precisionGM, ~, ~] = ObtainEstimate(TrainTest,GM,[0.260]);
   graphStrength3 = computeEdgeStrength(precisionGM);
   figure;plot(reshape(graphStrength1,[p^2,1]),reshape(graphStrength2,[p^2,1]),'x')
   xlabel('Edge Strength (\lambda = 0.235)','FontSize',16,'FontWeight','Bold')
   ylabel('Edge Strength (\lambda = 0.200)','FontSize',16,'FontWeight','Bold')
   xlim([0,0.4]); ylim([0,0.4]);
   grid on;
   figure;plot(reshape(graphStrength1,[p^2,1]),reshape(graphStrength3,[p^2,1]),'x')
   xlabel('Edge Strength (\lambda = 0.235)','FontSize',16,'FontWeight','Bold')
   ylabel('Edge Strength (\lambda = 0.260)','FontSize',16,'FontWeight','Bold')
   grid on;
   xlim([0,0.4]);
   ylim([0,0.4]);

TrainTestTemp = TrainTest;
TrainY1 = [TestY(1:12,:);TrainY(setdiff(1:120,85:96),:)];
TestY1 = [TrainY(85:96,:);TestY(13:end,:)];
TrainX1 = [TestX(1:12,:);TrainX(setdiff(1:120,85:96),:)];
TestX1 = [TrainX(97:108,:);TestX(13:end,:)];
TrainInd = [1:120];
TestInd = [1:47];
[TrainY, TestY, avgMonthY,varY] = preprocessingData(TrainY1,TestY1,TrainInd,TestInd);
TrainTestTemp{1} = TrainY;
TrainTestTemp{2} = TestY;
TrainTestTemp{3} = TrainX;
TrainTestTemp{4} = TestX;


lambda = linspace(0.01,0.5,100);
   train = zeros(length(lambda),1);
   test = zeros(length(lambda),1);
   for i = 1:length(lambda)
       [precisionGM, ~, ~] = ObtainEstimate(TrainTestTemp,GM,[lambda(i)]);
       [train(i), test(i)] = computeTrainValidationPerformance(precisionGM,TrainTestTemp,GM);
   end
[~,ind] = max(test);
[precisionGM, ~, ~] = ObtainEstimate(TrainTestTemp,GM,lambda(ind));
 graphStrength4 = computeEdgeStrength(precisionGM);
figure;plot(reshape(graphStrength1,[p^2,1]),reshape(graphStrength4,[p^2,1]),'x')
   



   