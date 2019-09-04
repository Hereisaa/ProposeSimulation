%%
figure
grid on
hold on
box on

p_nodeArch = p_clusterModel.nodeArch;

%% Color para
% Convert color code to 1-by-3 RGB array (0~1 each) [must do this way, if MATLAB version is R2018b or older]
color1 = '#00FFFF'; color1 = sscanf(color1(2:end),'%2x%2x%2x',[1 3])/255; %light blue
color2 = '#8E8E8E'; color2 = sscanf(color2(2:end),'%2x%2x%2x',[1 3])/255; %light gray 
color3 = '#BABABA'; color3 = sscanf(color3(2:end),'%2x%2x%2x',[1 3])/255; %light gray 


%% Nodes
for i = 1:p_nodeArch.init_numNodes
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
                   case {'12'}
            plot(p_nodeArch.nodesLoc(i, 1), p_nodeArch.nodesLoc(i, 2),'r*', 'MarkerSize',4); 
                    case {'13'}
            plot(p_nodeArch.nodesLoc(i, 1), p_nodeArch.nodesLoc(i, 2),'g*', 'MarkerSize',4); 
                    case {'14'}
            plot(p_nodeArch.nodesLoc(i, 1), p_nodeArch.nodesLoc(i, 2),'b*', 'MarkerSize',4); 
                    case {'15'}
            plot(p_nodeArch.nodesLoc(i, 1), p_nodeArch.nodesLoc(i, 2),'c*', 'MarkerSize',4); 
        otherwise
            plot(p_nodeArch.nodesLoc(i, 1), p_nodeArch.nodesLoc(i, 2),'k.', 'MarkerSize',12);  
    end
       
    
end


hold off