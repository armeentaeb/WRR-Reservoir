% hydro_demo_shapefiles -- demo hydrological shapefiles
%
% turmon aug 2015
%
global root

 gisInfo = hydro_load_gisinfo(strcat(root,'/Code/'));


%% make a figure

clf
% axesm mercator

% hydro zone overlay
gh_zone = geoshow(gisInfo.zone, 'FaceColor', [0.9 1 0.9], 'EdgeColor', [1 0.2 0.2]);

% streams/rivers overlay
gh_str = geoshow(gisInfo.stream, 'Color', [0.4 0.4 1], 'LineWidth', 2);

hold on

% reservoir markers
%h_res_mark = plot(resInfo.lon(), resInfo.lat(), 'o', 'MarkerSize', 10);
% can change attributes with, e.g., 
% set(h_res_mark,'Marker', 'o');

% text labels -- offset slightly
for i = 1:55
    if strcmp(resInfo.name((i)),'WRS')
        h_res_mark = plot(resInfo.lon((i)), resInfo.lat((i)), 'o', 'MarkerSize', 10,'MarkerFaceColor', 'g','MarkerEdgeColor', 'g');
        h_res_text = text(resInfo.lon((i))-0.4, resInfo.lat((i))+0.05, resInfo.name((i)),'FontSize',12,'FontWeight','Bold');
    elseif strcmp(resInfo.name((i)),'INV')
        h_res_mark = plot(resInfo.lon((i)), resInfo.lat((i)), 'o', 'MarkerSize', 10,'MarkerFaceColor', 'g','MarkerEdgeColor', 'g');
       h_res_text = text(resInfo.lon((i))+0.05, resInfo.lat((i))+0.05, resInfo.name((i)),'FontSize',12,'FontWeight','Bold');
    elseif strcmp(resInfo.name((i)),'DAV')
        h_res_mark = plot(resInfo.lon((i)), resInfo.lat((i)), 'o', 'MarkerSize', 10,'MarkerFaceColor', 'g','MarkerEdgeColor', 'g');
       h_res_text = text(resInfo.lon((i))+0.05, resInfo.lat((i))+0.05, resInfo.name((i)),'FontSize',12,'FontWeight','Bold');
    elseif strcmp(resInfo.name((i)),'SWB')
        h_res_mark = plot(resInfo.lon((i)), resInfo.lat((i)), 'o', 'MarkerSize', 10,'MarkerFaceColor', 'g','MarkerEdgeColor', 'g');
       h_res_text = text(resInfo.lon((i))-0.4, resInfo.lat((i))+0.05, resInfo.name((i)),'FontSize',12,'FontWeight','Bold');
 elseif strcmp(resInfo.name((i)),'HTH')
     h_res_mark = plot(resInfo.lon((i)), resInfo.lat((i)), 'o', 'MarkerSize', 10,'MarkerFaceColor', 'g','MarkerEdgeColor', 'g');
       h_res_text = text(resInfo.lon((i))+0.05, resInfo.lat((i))+0.05, resInfo.name((i)),'FontSize',12,'FontWeight','Bold');
 elseif strcmp(resInfo.name((i)),'CHV')
     h_res_mark = plot(resInfo.lon((i)), resInfo.lat((i)), 'o', 'MarkerSize', 10,'MarkerFaceColor', 'g','MarkerEdgeColor', 'g');
       h_res_text = text(resInfo.lon((i))-0.4, resInfo.lat((i))+0.05, resInfo.name((i)),'FontSize',12,'FontWeight','Bold');
 elseif strcmp(resInfo.name((i)),'RLF')
     h_res_mark = plot(resInfo.lon((i)), resInfo.lat((i)), 'o', 'MarkerSize', 10,'MarkerFaceColor', 'g','MarkerEdgeColor', 'g');
       h_res_text = text(resInfo.lon((i))+0.05, resInfo.lat((i))+0.05, resInfo.name((i)),'FontSize',12,'FontWeight','Bold')
elseif strcmp(resInfo.name((i)),'BER')
    h_res_mark = plot(resInfo.lon((i)), resInfo.lat((i)), 'o', 'MarkerSize', 10,'MarkerFaceColor', 'g','MarkerEdgeColor', 'g');
       h_res_text = text(resInfo.lon((i))+0.05, resInfo.lat((i))+0.05, resInfo.name((i)),'FontSize',12,'FontWeight','Bold');
elseif strcmp(resInfo.name((i)),'ALM')
    h_res_mark = plot(resInfo.lon((i)), resInfo.lat((i)), 'o', 'MarkerSize', 10,'MarkerFaceColor', 'g','MarkerEdgeColor', 'g');
       h_res_text = text(resInfo.lon((i))+0.05, resInfo.lat((i))+0.05, resInfo.name((i)),'FontSize',12,'FontWeight','Bold');
elseif strcmp(resInfo.name((i)),'COY')
    h_res_mark = plot(resInfo.lon((i)), resInfo.lat((i)), 'o', 'MarkerSize', 10,'MarkerFaceColor', 'g','MarkerEdgeColor', 'g');
       h_res_text = text(resInfo.lon((i))+0.05, resInfo.lat((i))+0.05, resInfo.name((i)),'FontSize',12,'FontWeight','Bold');
    
elseif strcmp(resInfo.name((i)),'FOL')
    h_res_mark = plot(resInfo.lon((i)), resInfo.lat((i)), 'o', 'MarkerSize', 10,'MarkerEdgeColor', 'k');
       h_res_text = text(resInfo.lon((i))+0.05, resInfo.lat((i))+0.05, resInfo.name((i)),'FontSize',12,'FontWeight','Bold');
    
  elseif strcmp(resInfo.name((i)),'BUL')
    h_res_mark = plot(resInfo.lon((i)), resInfo.lat((i)), 'o', 'MarkerSize', 10,'MarkerFaceColor', 'r','MarkerEdgeColor', 'r');
       h_res_text = text(resInfo.lon((i))+0.05, resInfo.lat((i))+0.05, resInfo.name((i)),'FontSize',12,'FontWeight','Bold');
    
    elseif strcmp(resInfo.name((i)),'SHA')
    h_res_mark = plot(resInfo.lon((i)), resInfo.lat((i)), 'o', 'MarkerSize', 10,'MarkerFaceColor', 'r','MarkerEdgeColor', 'r');
       h_res_text = text(resInfo.lon((i))+0.05, resInfo.lat((i))+0.05, resInfo.name((i)),'FontSize',12,'FontWeight','Bold');

     elseif strcmp(resInfo.name((i)),'CMN')
    h_res_mark = plot(resInfo.lon((i)), resInfo.lat((i)), 'o', 'MarkerSize', 10,'MarkerFaceColor', 'r','MarkerEdgeColor', 'r');
       h_res_text = text(resInfo.lon((i))+0.05, resInfo.lat((i))+0.05, resInfo.name((i)),'FontSize',12,'FontWeight','Bold');
 
    elseif strcmp(resInfo.name((i)),'EXC')
    h_res_mark = plot(resInfo.lon((i)), resInfo.lat((i)), 'o', 'MarkerSize', 10,'MarkerFaceColor', 'r','MarkerEdgeColor', 'r');
       h_res_text = text(resInfo.lon((i))+0.05, resInfo.lat((i))+0.05, resInfo.name((i)),'FontSize',12,'FontWeight','Bold');

         elseif strcmp(resInfo.name((i)),'DNP')
    h_res_mark = plot(resInfo.lon((i)), resInfo.lat((i)), 'o', 'MarkerSize', 10,'MarkerFaceColor', 'r','MarkerEdgeColor', 'r');
       h_res_text = text(resInfo.lon((i))+0.05, resInfo.lat((i))+0.05, resInfo.name((i)),'FontSize',12,'FontWeight','Bold');

    end    
    
    
    
end

resInfo.lon = resInfo.lon();
resInfo.lat = resInfo.lat();
resInfo.name = resInfo.name();
plot(resInfo.lon([9 25]), resInfo.lat([9 25]), '-', 'LineWidth', 2, 'Color', [0.5 0.5 0.5]);
plot(resInfo.lon([50 43]), resInfo.lat([50 43]), '-', 'LineWidth', 2, 'Color', [0.5 0.5 0.5]);
plot(resInfo.lon([3 27]), resInfo.lat([3 27]), '-', 'LineWidth', 2, 'Color', [0.5 0.5 0.5]);
plot(resInfo.lon([1 14]), resInfo.lat([1 14]), '-', 'LineWidth', 2, 'Color', [0.5 0.5 0.5]);
plot(resInfo.lon([12 54]), resInfo.lat([12 54]), '-', 'LineWidth', 2, 'Color', [0.5 0.5 0.5]);

plot(resInfo.lon([20 45]), resInfo.lat([20 45]), '-', 'LineWidth', 2, 'Color', [0.5 0.5 0.5]);
plot(resInfo.lon([20 8]), resInfo.lat([20 8]), '-', 'LineWidth', 2, 'Color', [0.5 0.5 0.5]);
plot(resInfo.lon([20 11]), resInfo.lat([20 11]), '-', 'LineWidth', 2, 'Color', [0.5 0.5 0.5]);
plot(resInfo.lon([20 15]), resInfo.lat([20 15]), '-', 'LineWidth', 2, 'Color', [0.5 0.5 0.5]);
plot(resInfo.lon([20 18]), resInfo.lat([20 18]), '-', 'LineWidth', 2, 'Color', [0.5 0.5 0.5]);


% reservoir edges
%[i,j] = find(resInfo.adjacency);
%for inx = 1:length(i),
 % plot(resInfo.lon([i(inx) j(inx)]), resInfo.lat([i(inx) j(inx)]), '-', 'LineWidth', 2, 'Color', [0.5 0.5 0.5]);
%end

% constrain viewport
axis([-124 -118 34.5 42]);

grid on
h = zeros(2, 1);
h(1) = plot(NaN,NaN,'o','MarkerFaceColor', 'g','MarkerEdgeColor', 'g');
h(2) = plot(NaN,NaN,'o','MarkerFaceColor', 'r','MarkerEdgeColor', 'r');
legend(h,'Strongest edges', 'Strongest edges to Folsom Lake')
set(gca,'FontSize',16,'FontWeight','Bold')
