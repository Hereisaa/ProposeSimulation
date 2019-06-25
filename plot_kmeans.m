% PLOT THE LEACH DEPLOYMENT
%%
figure(3), 
grid on

%% Color para
% Convert color code to 1-by-3 RGB array (0~1 each) [must do this way, if MATLAB version is R2018b or older]
color1 = '#00FFFF'; color1 = sscanf(color1(2:end),'%2x%2x%2x',[1 3])/255; %light blue
color2 = '#6E6E6E'; color2 = sscanf(color2(2:end),'%2x%2x%2x',[1 3])/255; %light gray 
color3 = '#BABABA'; color3 = sscanf(color3(2:end),'%2x%2x%2x',[1 3])/255; %light gray 

%%
for i = 1:proposed_nodeArch.numNode
    
    switch num2str(proposed_nodeArch.node(i).CID)
        case {'1'}
            plot(proposed_nodeArch.nodesLoc(i, 1), proposed_nodeArch.nodesLoc(i, 2),'r.', 'MarkerSize',12);
        case {'2'}
            plot(proposed_nodeArch.nodesLoc(i, 1), proposed_nodeArch.nodesLoc(i, 2),'g.', 'MarkerSize',12);
        case {'3'}
            plot(proposed_nodeArch.nodesLoc(i, 1), proposed_nodeArch.nodesLoc(i, 2),'b.', 'MarkerSize',12);    
        case {'4'}
            plot(proposed_nodeArch.nodesLoc(i, 1), proposed_nodeArch.nodesLoc(i, 2),'c.', 'MarkerSize',12);
        case {'5'}
            plot(proposed_nodeArch.nodesLoc(i, 1), proposed_nodeArch.nodesLoc(i, 2),'m.', 'MarkerSize',12);
        case {'6'}
            plot(proposed_nodeArch.nodesLoc(i, 1), proposed_nodeArch.nodesLoc(i, 2),'mo', 'MarkerSize',4);
        case {'7'}
            plot(proposed_nodeArch.nodesLoc(i, 1), proposed_nodeArch.nodesLoc(i, 2),'ko', 'MarkerSize',4);
        case {'8'}
            plot(proposed_nodeArch.nodesLoc(i, 1), proposed_nodeArch.nodesLoc(i, 2),'ro', 'MarkerSize',4);
        case {'9'}
            plot(proposed_nodeArch.nodesLoc(i, 1), proposed_nodeArch.nodesLoc(i, 2),'go', 'MarkerSize',4);
        case {'10'}
            plot(proposed_nodeArch.nodesLoc(i, 1), proposed_nodeArch.nodesLoc(i, 2),'bo', 'MarkerSize',4);
        case {'11'}
            plot(proposed_nodeArch.nodesLoc(i, 1), proposed_nodeArch.nodesLoc(i, 2),'co', 'MarkerSize',4);    
        otherwise
            plot(proposed_nodeArch.nodesLoc(i, 1), proposed_nodeArch.nodesLoc(i, 2),'k.', 'MarkerSize',12);  
    end
    
    % Line
    
    j = proposed_nodeArch.node(i).parent;
    plot([proposed_nodeArch.node(i).x j.x],[proposed_nodeArch.node(i).y j.y],...
          'Color', color1);
%     plot([proposed_nodeArch.node(i).x proposed_nodeArch.node(j).x],[proposed_nodeArch.node(i).y proposed_nodeArch.node(j).y],...
%           'Color', color1);
    
    hold on
    
end

%% range (d0)
theta = 0:pi/30:2*pi; 
R = 87;
x = R*cos(theta); 
y = R*sin(theta); 
for i = 1:length(centr)
    plot(centr(1, i), centr(2, i),'k*', 'MarkerSize',8); 
    plot(x + centr(1, i), y + centr(2, i),'Color', color2,'LineStyle',':');
end

%% BS and Layer
plot(netArch.Sink.x, netArch.Sink.y,'o', ...
    'MarkerSize',8, 'MarkerFaceColor', 'g');
% Layer 1 near BS 
plot(x + netArch.Sink.x, y + netArch.Sink.y,'Color', color3,'LineStyle',':');
% % Layer 2 
plot(x*2 + netArch.Sink.x, y*2 + netArch.Sink.y,'Color', color3,'LineStyle',':');
% % Layer 3 
plot(x*3 + netArch.Sink.x, y*3 + netArch.Sink.y,'Color', color3,'LineStyle',':');

hold off