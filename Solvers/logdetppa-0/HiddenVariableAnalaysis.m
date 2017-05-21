function [correlation] = HiddenVariableAnalaysis(F,TrainTest,method)
Y = TrainTest{1};
X = TrainTest{3};
Y = Y;
X = X;
L = F{2};

[Ub Db Vb] = svd(Y*L);

z = zeros(size(X,1),1);
for i = 1:size(X,2)
    t = zeros(size(X,1),1);
    for j = 1:rank(L)
        t =  t + X(:,i)'*Ub(:,j)/norm(X(:,i))*Ub(:,j);
    end
    correlation(i) = abs(t'*X(:,i)/(norm(X(:,i))*norm(t)));
end



%%
plot(t/norm(t),'r-')
hold on;
plot(X(:,7)/norm(X(:,7)),'b-')
set(gca,'ytick',[])
set(gca,'XTickLabel',['2006';'2007';'2008';'2009';'2010';'2011';'2012';'2013';'2014';'2015'; '2016']);
grid on;
xlabel('year','FontSize',14,'FontWeight','Bold')
set(gca,'FontSize',16,'FontWeight','Bold')
set(gca,'FontSize',14,'FontWeight','Bold')
xlabel('year','FontSize',12,'FontWeight','Bold')
set(gca,'FontSize',12,'FontWeight','Bold')
set(gca,'XTick',[5:12:size(t,2)])
set(gca,'XTick',[5:12:size(t,1)])
title('Palmer Drought Index Comparison')
title('Palmer Drought Index Comparison','FontSize',14)

end