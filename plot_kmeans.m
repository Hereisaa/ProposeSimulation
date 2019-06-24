% PLOT THE LEACH DEPLOYMENT
%%
figure(3), 
grid on

for i = 1:proposed_nodeArch.numNode
    
    switch num2str(proposed_nodeArch.node(i).CID)
        case {'1'}
            plot(nodeArch.nodesLoc(i, 1), nodeArch.nodesLoc(i, 2),'r.', 'MarkerSize',12);
        case {'2'}
            plot(nodeArch.nodesLoc(i, 1), nodeArch.nodesLoc(i, 2),'g.', 'MarkerSize',12);
        case {'3'}
            plot(nodeArch.nodesLoc(i, 1), nodeArch.nodesLoc(i, 2),'b.', 'MarkerSize',12);    
        case {'4'}
            plot(nodeArch.nodesLoc(i, 1), nodeArch.nodesLoc(i, 2),'c.', 'MarkerSize',12);
        case {'5'}
            plot(nodeArch.nodesLoc(i, 1), nodeArch.nodesLoc(i, 2),'m.', 'MarkerSize',12);
        case {'6'}
            plot(nodeArch.nodesLoc(i, 1), nodeArch.nodesLoc(i, 2),'mo', 'MarkerSize',4);
        case {'7'}
            plot(nodeArch.nodesLoc(i, 1), nodeArch.nodesLoc(i, 2),'ko', 'MarkerSize',4);
        case {'8'}
            plot(nodeArch.nodesLoc(i, 1), nodeArch.nodesLoc(i, 2),'ro', 'MarkerSize',4);
        case {'9'}
            plot(nodeArch.nodesLoc(i, 1), nodeArch.nodesLoc(i, 2),'go', 'MarkerSize',4);
        case {'10'}
            plot(nodeArch.nodesLoc(i, 1), nodeArch.nodesLoc(i, 2),'bo', 'MarkerSize',4);
        case {'11'}
            plot(nodeArch.nodesLoc(i, 1), nodeArch.nodesLoc(i, 2),'co', 'MarkerSize',4);    
        otherwise
            plot(nodeArch.nodesLoc(i, 1), nodeArch.nodesLoc(i, 2),'k.', 'MarkerSize',12);  
    end
    
    hold on
    
end

%% range (d0)
theta = 0:pi/30:2*pi; 
R = 87;
x = R*cos(theta); 
y = R*sin(theta); 
for i = 1:length(centr)
    plot(centr(1, i), centr(2, i),'r*', 'MarkerSize',8); 
    plot(x + centr(1, i), y + centr(2, i),'k:');
end

%% BS and Layer
plot(netArch.Sink.x, netArch.Sink.y,'o', ...
    'MarkerSize',8, 'MarkerFaceColor', 'g');
% Layer 1 near BS 
plot(x + netArch.Sink.x, y + netArch.Sink.y,'k:');
% % Layer 2 
plot(x*2 + netArch.Sink.x, y*2 + netArch.Sink.y,'k:');
% % Layer 3 
plot(x*3 + netArch.Sink.x, y*3 + netArch.Sink.y,'k:');

hold off