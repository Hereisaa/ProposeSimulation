function Model = dissEnergyCv2(Model, roundArch, netArch, clusterFun)
% Calculation of Energy dissipated for CHs
%   Input:
%       Model            architecture of nodes
%       roundArch        round Architecture
%       netArch          network Architecture


    nodeArch = Model.nodeArch;
    cluster  = Model.clusterNode;
    
    d0 = sqrt(netArch.Energy.freeSpace / ...
              netArch.Energy.multiPath);

    if Model.clusterNode.countCHv2 == 0
        return
    end

    n = Model.clusterNode.countCHs; % Number of CHs
    xm = netArch.Yard.Length;
    ym = netArch.Yard.Width;
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
        if (strcmp(Model.nodeArch.node(i).type, 'Cv2')  &&  Model.nodeArch.node(i).energy > 0)
            
            Dist = calDistance(Model.nodeArch.node(i).x, Model.nodeArch.node(i).y,...
                        Model.nodeArch.node(i).parent.x, Model.nodeArch.node(i).parent.y);
                    
            energy = Model.nodeArch.node(i).energy;
            
            BroadcastDist = sqrt(xm*xm+ym*ym);
            % Broadcast
            energy = energy -  (ETX * ctrPacketLength + Emp * ctrPacketLength * (BroadcastDist ^ 4));
            
            % Rx CH join msg
            energy = energy -  (ERX * ctrPacketLength) * Model.nodeArch.node(i).child;

            % energy for aggregation & Rx 
            energy = energy - (packetLength * ERX * Model.nodeArch.node(i).child + ...
                     packetLength * EDA * (Model.nodeArch.node(i).child + 1));

            % energy for transferring
            if(Dist >= d0)
                 Model.nodeArch.node(i).energy = energy - ...
                     (ETX * packetLength + Emp * packetLength * (Dist ^ 4));
            else
                 Model.nodeArch.node(i).energy = energy - ...
                     (ETX * packetLength + Efs * packetLength * (Dist ^ 2));
            end
        end
    end
    
    
    Model.nodeArch = Model.nodeArch;
end