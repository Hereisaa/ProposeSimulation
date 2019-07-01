function Model = dissEnergyRN(Model, roundArch, netArch)
% Calculation of Energy dissipated for CHs
%   Input:
%       Model            architecture of nodes
%       roundArch        round Architecture
%       netArch          network Architecture

    nodeArch = Model.nodeArch;
    cluster  = Model.relayNode;
    
    d0 = sqrt(netArch.Energy.freeSpace / ...
              netArch.Energy.multiPath);

    if Model.clusterNode.countRNs == 0
        return
    end

    n = Model.clusterNode.countRNs; % Number of RNs
    ETX = netArch.Energy.transfer;
    ERX = netArch.Energy.receive;
    EDA = netArch.Energy.aggr;
    Emp = netArch.Energy.multiPath;
    Efs = netArch.Energy.freeSpace;
    packetLength = roundArch.packetLength;
    ctrPacketLength = roundArch.ctrPacketLength;

    for i = 1:n
        rnNo = Model.relayNode.no(i);
%         Dist = Model.clusterNode.distance(i); % to BS
        Dist = calDistance(Model.nodeArch.node(rnNo).x, Model.nodeArch.node(rnNo).y,...
                        Model.nodeArch.node(rnNo).parent.x, Model.nodeArch.node(rnNo).parent.y);
        energy = Model.nodeArch.node(rnNo).energy;

        % energy for aggregation & Rx 
        energy = energy - (packetLength * ERX * Model.nodeArch.node(rnNo).child + ...
                 packetLength * EDA * (Model.nodeArch.node(rnNo).child + 1));

        % energy for transferring
        if(Dist >= d0)
             Model.nodeArch.node(rnNo).energy = energy - ...
                 (ETX * packetLength + Emp * packetLength * (Dist ^ 4));
        else
             Model.nodeArch.node(rnNo).energy = energy - ...
                 (ETX * packetLength + Efs * packetLength * (Dist ^ 2));
        end
        
    end
    
    Model.nodeArch = Model.nodeArch;
end