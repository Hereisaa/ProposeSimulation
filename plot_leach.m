% PLOT THE LEACH DEPLOYMENT
%%
figure, hold on
grid on

%% Color para
% Convert color code to 1-by-3 RGB array (0~1 each) [must do this way, if MATLAB version is R2018b or older]
color1 = '#00FFFF'; color1 = sscanf(color1(2:end),'%2x%2x%2x',[1 3])/255;

%% Circle para
% angle of each line sector 
t = 0:pi/30:2*pi; 
% radius
R = sqrt(netArch.Yard.Width * netArch.Yard.Length / clusterModel.numCluster);
% R
x = R*cos(t); 
y = R*sin(t); 

%% Line
locAlive = find(~clusterModel.nodeArch.dead);
for i = locAlive
%     if(nodeArch.node(i).parent)
       j = clusterModel.nodeArch.node(i).parent;
       plot([clusterModel.nodeArch.node(i).x j.x],[clusterModel.nodeArch.node(i).y j.y],...
           	'k');
%     end
end

%% Sensors
for i = 1:init_nodeArch.numNode
    if(strcmp(clusterModel.nodeArch.node(i).type, 'C'))
       % circle
       % plot(x+nodeArch.nodesLoc(i, 1),y+nodeArch.nodesLoc(i, 2),'k:') 
       plot(clusterModel.nodeArch.nodesLoc(i, 1), clusterModel.nodeArch.nodesLoc(i, 2),...
           'r.', 'MarkerSize',15);
    elseif(strcmp(clusterModel.nodeArch.node(i).type, 'N'))
       plot(clusterModel.nodeArch.nodesLoc(i, 1), clusterModel.nodeArch.nodesLoc(i, 2),...
           'k.', 'MarkerSize',15);
    else
        plot(clusterModel.nodeArch.nodesLoc(i, 1), clusterModel.nodeArch.nodesLoc(i, 2),...
           'Color', color1,'Marker','.', 'MarkerSize',15);
    end
end

%% BS
plot(netArch.Sink.x, netArch.Sink.y,'ko','MarkerSize',8, 'MarkerFaceColor', 'k');
title('LEACH','FontWeight','bold',...
        'FontSize',12,...
        'FontName','Cambria');
hold off