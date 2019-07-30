function Model = dissEnergyCM(Model, roundArch, netArch)
% Calculation of Energy dissipated for CHs
%   Input:
%       Model            architecture of nodes
%       roundArch        round Architecture
%       netArch          network Architecture
    
    nodeArch = Model.nodeArch;
    cluster  = Model.clusterNode;
%     if cluster.countCHs == 0
%         return
%     end
    d0 = sqrt(netArch.Energy.freeSpace / ...
              netArch.Energy.multiPath);
    ETX = netArch.Energy.transfer;
%     ERX = netArch.Energy.receive;
%     EDA = netArch.Energy.aggr;
    Emp = netArch.Energy.multiPath;
    Efs = netArch.Energy.freeSpace;
    packetLength = roundArch.packetLength;
    ctrPacketLength = roundArch.ctrPacketLength;
    
    locAlive = find(~Model.nodeArch.dead); % find the nodes that are alive
    for i = locAlive % search in alive nodes
        if (strcmp(Model.nodeArch.node(i).type, 'N') &&  Model.nodeArch.node(i).energy > 0)
%             energy = Model.nodeArch.node(i).energy;
%             countCHs = Model.numCluster; % Number of CHs
%             Dist = calDistance(Model.nodeArch.node(i).x, Model.nodeArch.node(i).y, Model.nodeArch.node(i).parent.x, Model.nodeArch.node(i).parent.y);   
%             Dist
%             if (Dist >= d0)
%                     Model.nodeArch.node(i).energy = energy - (packetLength * ETX + Emp * packetLength * (Dist ^ 4));
%             else
%                     Model.nodeArch.node(i).energy = energy - (packetLength * ETX + Efs * packetLength * (Dist ^ 2));
%             end    
            
            energy = Model.nodeArch.node(i).energy;
            countCHs = Model.numCluster; % Number of CHs
            if countCHs == 0
                Model.nodeArch.node(i).parent = netArch.Sink;
                Dist = calDistance(Model.nodeArch.node(i).x, Model.nodeArch.node(i).y,...
                        netArch.Sink.x, netArch.Sink.y);
                
                if (Dist >= d0)
                    Model.nodeArch.node(i).energy = energy - ...
                        (packetLength * ETX + Emp * packetLength * (Dist ^ 4));
                else
                    Model.nodeArch.node(i).energy = energy - ...
                        (packetLength * ETX + Efs * packetLength * (Dist ^ 2));
                end
            else
                Dist = calDistance(Model.nodeArch.node(i).x, Model.nodeArch.node(i).y,...
                        Model.nodeArch.node(i).parent.x, Model.nodeArch.node(i).parent.y);
                
                if (Dist >= d0)
                    Model.nodeArch.node(i).energy = energy - ...
                        (packetLength * ETX + Emp * packetLength * (Dist ^ 4));
                else
                    Model.nodeArch.node(i).energy = energy - ...
                        (packetLength * ETX + Efs * packetLength * (Dist ^ 2));
                end
            end
        end % if
    end % for
    Model.nodeArch = Model.nodeArch;
end