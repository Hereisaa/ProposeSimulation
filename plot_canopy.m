% PLOT THE CANOPY CLUSTER
%%
figure(4), 
grid on

for i = 1:proposed_nodeArch.numNode
    nodeArch = proposed_nodeArch;
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
T1 = 87;
T2 = 60;
xT1 = T1*cos(theta); yT1 = T1*sin(theta);
xT2 = T2*cos(theta); yT2 = T2*sin(theta);
for i = 1:length(canopy_centr)
    plot(canopy_centr(1, i), canopy_centr(2, i),'k*', 'MarkerSize',8); 
    plot(xT1 + canopy_centr(1, i), yT1 + canopy_centr(2, i),'k:');
    plot(xT2 + canopy_centr(1, i), yT2 + canopy_centr(2, i),'k:');
end

%% BS and Layer
R = 87;
x = R*cos(theta); 
y = R*sin(theta);
plot(netArch.Sink.x, netArch.Sink.y,'o', ...
    'MarkerSize',8, 'MarkerFaceColor', 'g');
% Layer 1 near BS 
plot(x + netArch.Sink.x, y + netArch.Sink.y,'k:');
% % Layer 2 
plot(x*2 + netArch.Sink.x, y*2 + netArch.Sink.y,'k:');
% % Layer 3 
plot(x*3 + netArch.Sink.x, y*3 + netArch.Sink.y,'k:');

hold off