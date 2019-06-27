function Model = dissEnergyNonCH(Model, roundArch, netArch)
% Calculation of Energy dissipated for CHs
%   Input:
%       clusterModel     architecture of nodes, network
%       roundArch        round Architecture
%   Example:
%       r = 10; % round no = 10
%       clusterModel = newCluster(netArch, nodeArch, 'def', r);
%       clusterModel = dissEnergyCH(clusterModel);
%
% Mohammad Hossein Homaei, Homaei@wsnlab.org & Homaei@wsnlab.ir
% Ver 1. 10/2014
    
    nodeArch = Model.nodeArch;
    cluster  = Model.clusterNode;
%     if cluster.countCHs == 0
%         return
%     end
    d0 = sqrt(netArch.Energy.freeSpace / ...
              netArch.Energy.multiPath);
    ETX = netArch.Energy.transfer;
    ERX = netArch.Energy.receive;
    EDA = netArch.Energy.aggr;
    Emp = netArch.Energy.multiPath;
    Efs = netArch.Energy.freeSpace;
    packetLength = roundArch.packetLength;
    ctrPacketLength = roundArch.ctrPacketLength;
    
    locAlive = find(~Model.nodeArch.dead); % find the nodes that are alive
    for i = locAlive % search in alive nodes
        %find Associated CH for each normal node
        if (strcmp(Model.nodeArch.node(i).type, 'N') &&  Model.nodeArch.node(i).energy > 0)

            countCHs = Model.clusterNode.countCHs; % Number of CHs
            
            % calculate distance to each CH and find smallest distance
            if countCHs == 0
                Model.nodeArch.node(i).parent = netArch.Sink;
                Dist = calDistance(Model.nodeArch.node(i).x, Model.nodeArch.node(i).y, netArch.Sink.x, netArch.Sink.y);
                
                if (Dist >= d0)
                    Model.nodeArch.node(i).energy = Model.nodeArch.node(i).energy - ...
                        (packetLength * ETX + Emp * packetLength * (Dist ^ 4));
                else
                    Model.nodeArch.node(i).energy = Model.nodeArch.node(i).energy - ...
                        (packetLength * ETX + Efs * packetLength * (Dist ^ 2));
                end
            else
                Dist = calDistance(Model.nodeArch.node(i).x, Model.nodeArch.node(i).y, Model.nodeArch.node(i).parent.x, Model.nodeArch.node(i).parent.y);
                
                if (Dist >= d0)
                    Model.nodeArch.node(i).energy = Model.nodeArch.node(i).energy - ...
                        (packetLength * ETX + Emp * packetLength * (Dist ^ 4));
                else
                    Model.nodeArch.node(i).energy = Model.nodeArch.node(i).energy - ...
                        (packetLength * ETX + Efs * packetLength * (Dist ^ 2));
                end
%                 if (strcmp(Model.clusterFun,'leach')) % leach
%                     % [min , index]
%                     [minDis, loc] = min(sqrt(sum((repmat(locNode, countCHs, 1) - cluster.loc)' .^ 2)));
%                     minDisCH =  cluster.no(loc);
% 
%                     % assign to nearest CH
%                     nodeArch.node(i).parent = nodeArch.node(minDisCH);
%                     nodeArch.node(minDisCH).child = nodeArch.node(minDisCH).child + 1;
% 
%                     if (minDis >= d0)
%                         nodeArch.node(i).energy = nodeArch.node(i).energy - ...
%                             (packetLength * ETX + Emp * packetLength * (minDis ^ 4));
%                     else
%                         nodeArch.node(i).energy = nodeArch.node(i).energy - ...
%                             (packetLength * ETX + Efs * packetLength * (minDis ^ 2));
%                     end
%                 else % proposed
%                     Dist = calDistance(nodeArch.node(i).x, nodeArch.node(i).y, nodeArch.node(i).parent.x, nodeArch.node(i).parent.y);
%                 
%                     if (Dist >= d0)
%                         nodeArch.node(i).energy = nodeArch.node(i).energy - ...
%                             (packetLength * ETX + Emp * packetLength * (Dist ^ 4));
%                     else
%                         nodeArch.node(i).energy = nodeArch.node(i).energy - ...
%                             (packetLength * ETX + Efs * packetLength * (Dist ^ 2));
%                     end
%                 end

            end
        end % if
    end % for
    Model.nodeArch = Model.nodeArch;
end