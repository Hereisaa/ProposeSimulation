% PLOT THE LEACH DEPLOYMENT
%%
figure
grid on
hold on

p_nodeArch = p_clusterModel.nodeArch;

%% Color para
% Convert color code to 1-by-3 RGB array (0~1 each) [must do this way, if MATLAB version is R2018b or older]
color1 = '#00FFFF'; color1 = sscanf(color1(2:end),'%2x%2x%2x',[1 3])/255; %light blue
color2 = '#8E8E8E'; color2 = sscanf(color2(2:end),'%2x%2x%2x',[1 3])/255; %light gray 
color3 = '#BABABA'; color3 = sscanf(color3(2:end),'%2x%2x%2x',[1 3])/255; %light gray 

%% FOR DEBUG
% plot(p_clusterModel.nodeArch.nodesLoc(222, 1), p_clusterModel.nodeArch.nodesLoc(222, 2),'k*', 'MarkerSize',12); 

%% Association Line
for i = 1:p_nodeArch.init_numNodes
    if(~isempty(p_nodeArch.node(i).parent))
        j = p_nodeArch.node(i).parent;
        plot([p_nodeArch.node(i).x j.x],[p_nodeArch.node(i).y j.y],'Color', color2);
    end
end

%% Nodes
for i = 1:p_nodeArch.init_numNodes
%     if p_nodeArch.node(i).type == 'C'
%         plot(p_nodeArch.nodesLoc(i, 1), p_nodeArch.nodesLoc(i, 2),'r.', 'MarkerSize',18); 
%     elseif p_nodeArch.node(i).type == 'R'
%         plot(p_nodeArch.nodesLoc(i, 1), p_nodeArch.nodesLoc(i, 2),'b.', 'MarkerSize',18); 
%     elseif p_nodeArch.node(i).type == 'N'
%         plot(p_nodeArch.nodesLoc(i, 1), p_nodeArch.nodesLoc(i, 2),'k.', 'MarkerSize',18); 
%     else
%         plot(p_nodeArch.nodesLoc(i, 1), p_nodeArch.nodesLoc(i, 2),'Color', color2,'Marker','.', 'MarkerSize',18); 
%     end
    
    % cluster
    switch num2str(p_nodeArch.node(i).CID)
        case {'1'}
            plot(p_nodeArch.nodesLoc(i, 1), p_nodeArch.nodesLoc(i, 2),'r.', 'MarkerSize',12);
        case {'2'}
            plot(p_nodeArch.nodesLoc(i, 1), p_nodeArch.nodesLoc(i, 2),'g.', 'MarkerSize',12);
        case {'3'}
            plot(p_nodeArch.nodesLoc(i, 1), p_nodeArch.nodesLoc(i, 2),'b.', 'MarkerSize',12);    
        case {'4'}
            plot(p_nodeArch.nodesLoc(i, 1), p_nodeArch.nodesLoc(i, 2),'c.', 'MarkerSize',12);
        case {'5'}
            plot(p_nodeArch.nodesLoc(i, 1), p_nodeArch.nodesLoc(i, 2),'m.', 'MarkerSize',12);
        case {'6'}
            plot(p_nodeArch.nodesLoc(i, 1), p_nodeArch.nodesLoc(i, 2),'mo', 'MarkerSize',4);
        case {'7'}
            plot(p_nodeArch.nodesLoc(i, 1), p_nodeArch.nodesLoc(i, 2),'ko', 'MarkerSize',4);
        case {'8'}
            plot(p_nodeArch.nodesLoc(i, 1), p_nodeArch.nodesLoc(i, 2),'ro', 'MarkerSize',4);
        case {'9'}
            plot(p_nodeArch.nodesLoc(i, 1), p_nodeArch.nodesLoc(i, 2),'go', 'MarkerSize',4);
        case {'10'}
            plot(p_nodeArch.nodesLoc(i, 1), p_nodeArch.nodesLoc(i, 2),'bo', 'MarkerSize',4);
        case {'11'}
            plot(p_nodeArch.nodesLoc(i, 1), p_nodeArch.nodesLoc(i, 2),'co', 'MarkerSize',4);    
        otherwise
            plot(p_nodeArch.nodesLoc(i, 1), p_nodeArch.nodesLoc(i, 2),'k.', 'MarkerSize',12);  
    end
    
    if p_nodeArch.node(i).type == 'C'
        plot(p_nodeArch.nodesLoc(i, 1), p_nodeArch.nodesLoc(i, 2),'r*', 'MarkerSize',18); 
    elseif p_nodeArch.node(i).type == 'R'
        plot(p_nodeArch.nodesLoc(i, 1), p_nodeArch.nodesLoc(i, 2),'b*', 'MarkerSize',18); 
    elseif p_nodeArch.node(i).type == 'D'
        plot(p_nodeArch.nodesLoc(i, 1), p_nodeArch.nodesLoc(i, 2),'Color', color2,'Marker','.', 'MarkerSize',18); 
    end
    
    
end


%% Node's range (d0)
% theta = 0:pi/30:2*pi; 
% R = 87;
% x = R*cos(theta); 
% y = R*sin(theta); 
% for i=1:p_nodeArch.init_numNodes
%     if p_nodeArch.node(i).type == 'C'
%          plot(x +p_nodeArch.node(i).x, y + p_nodeArch.node(i).y,'Color', color2,'LineStyle',':'); % nearest centr node range i.e.clusterNode
%     end
% end

%% BS and Layer
plot(netArch.Sink.x, netArch.Sink.y,'o','MarkerSize',8, 'MarkerFaceColor', 'g');
% % Layer 1 near BS 
% plot(x + netArch.Sink.x, y + netArch.Sink.y,'Color', color3,'LineStyle',':');
% % Layer 2 
% plot(x*2 + netArch.Sink.x, y*2 + netArch.Sink.y,'Color', color3,'LineStyle',':');
% % Layer 3 
% plot(x*3 + netArch.Sink.x, y*3 + netArch.Sink.y,'Color', color3,'LineStyle',':');

hold off