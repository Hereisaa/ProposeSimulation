% PLOT THE LEACH DEPLOYMENT
%%
figure
grid on
hold on

p2_nodeArch = p2_clusterModel.nodeArch;


%% Color para
% Convert color code to 1-by-3 RGB array (0~1 each) [must do this way, if MATLAB version is R2018b or older]
color1 = '#00FFFF'; color1 = sscanf(color1(2:end),'%2x%2x%2x',[1 3])/255; %light blue
color2 = '#8E8E8E'; color2 = sscanf(color2(2:end),'%2x%2x%2x',[1 3])/255; %light gray 
color3 = '#BABABA'; color3 = sscanf(color3(2:end),'%2x%2x%2x',[1 3])/255; %light gray 

%% FOR DEBUG
% plot(p_clusterModel.nodeArch.nodesLoc(222, 1), p_clusterModel.nodeArch.nodesLoc(222, 2),'k*', 'MarkerSize',12); 

%% Association Line
for i = 1:p2_nodeArch.init_numNodes
    if(~isempty(p2_nodeArch.node(i).parent))
        j = p2_nodeArch.node(i).parent;
        plot([p2_nodeArch.node(i).x j.x],[p2_nodeArch.node(i).y j.y],'Color', color2);
    end
end

%% Nodes
for i = 1:p2_nodeArch.init_numNodes
    if p2_nodeArch.node(i).type == 'C'
        plot(p2_nodeArch.nodesLoc(i, 1), p2_nodeArch.nodesLoc(i, 2),'r.', 'MarkerSize',18); 
    elseif p2_nodeArch.node(i).type == 'R'
        plot(p2_nodeArch.nodesLoc(i, 1), p2_nodeArch.nodesLoc(i, 2),'b.', 'MarkerSize',18); 
    elseif p2_nodeArch.node(i).type == 'N'
        plot(p2_nodeArch.nodesLoc(i, 1), p2_nodeArch.nodesLoc(i, 2),'k.', 'MarkerSize',18); 
    else
        plot(p2_nodeArch.nodesLoc(i, 1), p2_nodeArch.nodesLoc(i, 2),'Color', color2,'Marker','.', 'MarkerSize',18); 
    end
end


%% Node's range (d0)
theta = 0:pi/30:2*pi; 
R = 87;
x = R*cos(theta); 
y = R*sin(theta); 

%% BS and Layer
plot(netArch.Sink.x, netArch.Sink.y,'ko','MarkerSize',8, 'MarkerFaceColor', 'k');
% Layer 1 near BS 
plot(x + netArch.Sink.x, y + netArch.Sink.y,'Color', color3,'LineStyle',':');
% Layer 2 
plot(x*2 + netArch.Sink.x, y*2 + netArch.Sink.y,'Color', color3,'LineStyle',':');
% Layer 3 
plot(x*3 + netArch.Sink.x, y*3 + netArch.Sink.y,'Color', color3,'LineStyle',':');
% Layer 4 
plot(x*4 + netArch.Sink.x, y*4 + netArch.Sink.y,'Color', color3,'LineStyle',':');

axis([0,netArch.Yard.Length,0,netArch.Sink.y]);
set(gca,'XTick',[0:50:netArch.Yard.Length]);
set(gca,'YTick',[0:50:netArch.Sink.y]);
title('Proposed2','FontWeight','bold',...
        'FontSize',12,...
        'FontName','Cambria');

hold off