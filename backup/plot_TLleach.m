% PLOT THE LEACH DEPLOYMENT
%%
figure, hold on
grid on

%% Color para
% Convert color code to 1-by-3 RGB array (0~1 each) [must do this way, if MATLAB version is R2018b or older]
color1 = '#00FFFF'; color1 = sscanf(color1(2:end),'%2x%2x%2x',[1 3])/255; %light blue
color2 = '#8E8E8E'; color2 = sscanf(color2(2:end),'%2x%2x%2x',[1 3])/255; %light gray 
color3 = '#BABABA'; color3 = sscanf(color3(2:end),'%2x%2x%2x',[1 3])/255; %light gray 

%% Circle para
% angle of each line sector 
t = 0:pi/30:2*pi; 
% radius
R = sqrt(netArch.Yard.Width * netArch.Yard.Length / tl_clusterModel.numCluster);
% R
x = R*cos(t); 
y = R*sin(t); 

%% Line
locAlive = find(~tl_clusterModel.nodeArch.dead);
for i = locAlive
%     if(nodeArch.node(i).parent)
       j = tl_clusterModel.nodeArch.node(i).parent;
       plot([tl_clusterModel.nodeArch.node(i).x j.x],[tl_clusterModel.nodeArch.node(i).y j.y],'Color', color2);
%     end
end

%% Sensors
for i = 1:init_nodeArch.numNode
    if(strcmp(tl_clusterModel.nodeArch.node(i).type, 'C'))
       % circle
       % plot(x+nodeArch.nodesLoc(i, 1),y+nodeArch.nodesLoc(i, 2),'k:') 
       plot(tl_clusterModel.nodeArch.nodesLoc(i, 1), tl_clusterModel.nodeArch.nodesLoc(i, 2),...
           'r.', 'MarkerSize',12);
    elseif(strcmp(tl_clusterModel.nodeArch.node(i).type, 'Cv2'))
       plot(tl_clusterModel.nodeArch.nodesLoc(i, 1), tl_clusterModel.nodeArch.nodesLoc(i, 2),...
           'b.', 'MarkerSize',12);
    elseif(strcmp(tl_clusterModel.nodeArch.node(i).type, 'N'))
       plot(tl_clusterModel.nodeArch.nodesLoc(i, 1), tl_clusterModel.nodeArch.nodesLoc(i, 2),...
           'k.', 'MarkerSize',12);
    else
        plot(tl_clusterModel.nodeArch.nodesLoc(i, 1), tl_clusterModel.nodeArch.nodesLoc(i, 2),...
           'Color', color2,'Marker','.', 'MarkerSize',12);
    end
end

%% BS
plot(netArch.Sink.x, netArch.Sink.y,'o', ...
    'MarkerSize',8, 'MarkerFaceColor', 'g');

hold off