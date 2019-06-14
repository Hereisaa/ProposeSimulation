% PLOT THE LEACH DEPLOYMENT
%%
figure(1), hold on
grid on

%% Color para
% Convert color code to 1-by-3 RGB array (0~1 each) [must do this way, if MATLAB version is R2018b or older]
color1 = '#00FFFF'; color1 = sscanf(color1(2:end),'%2x%2x%2x',[1 3])/255;

%% Circle para
% angle of each line sector 
t = 0:pi/30:2*pi; 
% radius
R = sqrt(netArch.Yard.Width * netArch.Yard.Length / clusterModel.numCluster);
R
x = R*cos(t); 
y = R*sin(t); 

%% Line
for i = 1:nodeArch.numNode
    if(nodeArch.node(i).parent)
       j = nodeArch.node(i).parent;
       plot([nodeArch.node(i).x nodeArch.node(j).x],[nodeArch.node(i).y nodeArch.node(j).y],...
           	'Color', color1);
    end
end

%% Sensors
for i = 1:nodeArch.numNode
    if(strcmp(nodeArch.node(i).type, 'C'))
       % circle
       % plot(x+nodeArch.nodesLoc(i, 1),y+nodeArch.nodesLoc(i, 2),'k:') 
       plot(nodeArch.nodesLoc(i, 1), nodeArch.nodesLoc(i, 2),...
           'r.', 'MarkerSize',15);
    else
       plot(nodeArch.nodesLoc(i, 1), nodeArch.nodesLoc(i, 2),...
           'b.', 'MarkerSize',15);
    end
end

%% BS
plot(netArch.Sink.x, netArch.Sink.y,'o', ...
    'MarkerSize',8, 'MarkerFaceColor', 'g');

hold off