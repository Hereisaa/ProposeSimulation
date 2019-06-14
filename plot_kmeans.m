% PLOT THE LEACH DEPLOYMENT
%%
figure(3), hold on
grid on

for i = 1:nodeArch.numNode
    
    switch num2str(nodeArch.node(i).km)
        case {'1'}
            plot(nodeArch.nodesLoc(i, 1), nodeArch.nodesLoc(i, 2),'r.', 'MarkerSize',8);
        case {'2'}
            plot(nodeArch.nodesLoc(i, 1), nodeArch.nodesLoc(i, 2),'g.', 'MarkerSize',8);
        case {'3'}
            plot(nodeArch.nodesLoc(i, 1), nodeArch.nodesLoc(i, 2),'b.', 'MarkerSize',8);    
        case {'4'}
            plot(nodeArch.nodesLoc(i, 1), nodeArch.nodesLoc(i, 2),'c.', 'MarkerSize',8);
        case {'5'}
            plot(nodeArch.nodesLoc(i, 1), nodeArch.nodesLoc(i, 2),'m.', 'MarkerSize',8);
        case {'6'}
            plot(nodeArch.nodesLoc(i, 1), nodeArch.nodesLoc(i, 2),'mo', 'MarkerSize',8);
        case {'7'}
            plot(nodeArch.nodesLoc(i, 1), nodeArch.nodesLoc(i, 2),'ko', 'MarkerSize',8);
        case {'8'}
            plot(nodeArch.nodesLoc(i, 1), nodeArch.nodesLoc(i, 2),'ro', 'MarkerSize',8);
        case {'9'}
            plot(nodeArch.nodesLoc(i, 1), nodeArch.nodesLoc(i, 2),'go', 'MarkerSize',8);
        case {'10'}
            plot(nodeArch.nodesLoc(i, 1), nodeArch.nodesLoc(i, 2),'bo', 'MarkerSize',8);
        case {'11'}
            plot(nodeArch.nodesLoc(i, 1), nodeArch.nodesLoc(i, 2),'co', 'MarkerSize',8);    
        otherwise
            plot(nodeArch.nodesLoc(i, 1), nodeArch.nodesLoc(i, 2),'k.', 'MarkerSize',8);  
    end
    
end

%% range (d0)
theta = 0:pi/30:2*pi; 
R = 87;
x = R*cos(theta); 
y = R*sin(theta); 
for i = 1:length(centr)
    plot(centr(1, i), centr(2, i),'k*', 'MarkerSize',8); 
    plot(x + centr(1, i), y + centr(2, i),'k:');
end

%% BS and Layer
plot(netArch.Sink.x, netArch.Sink.y,'o', ...
    'MarkerSize',8, 'MarkerFaceColor', 'g');
% Layer 1 near BS 
plot(x + netArch.Sink.x, y + netArch.Sink.y,'k:');
% Layer 2 
plot(x*2 + netArch.Sink.x, y*2 + netArch.Sink.y,'k:');
% Layer 3 
plot(x*3 + netArch.Sink.x, y*3 + netArch.Sink.y,'k:');

hold off