function Model = dissEnergyCH(Model, roundArch, netArch)
% Calculation of Energy dissipated for CHs
%   Input:
%       Model            architecture of nodes
%       roundArch        round Architecture
%       netArch          network Architecture


    nodeArch = Model.nodeArch;
    cluster  = Model.clusterNode;
    
    d0 = sqrt(netArch.Energy.freeSpace / ...
              netArch.Energy.multiPath);

    if Model.clusterNode.countCHs == 0
        return
    end

    n = Model.clusterNode.countCHs; % Number of CHs
    ETX = netArch.Energy.transfer;
    ERX = netArch.Energy.receive;
    EDA = netArch.Energy.aggr;
    Emp = netArch.Energy.multiPath;
    Efs = netArch.Energy.freeSpace;
    packetLength = roundArch.packetLength;
    ctrPacketLength = roundArch.ctrPacketLength;

    for i = 1:n
        chNo = Model.clusterNode.no(i);

%         Dist = Model.clusterNode.distance(i); % to BS
        Dist = calDistance(Model.nodeArch.node(chNo).x, Model.nodeArch.node(chNo).y,...
                        Model.nodeArch.node(chNo).parent.x, Model.nodeArch.node(chNo).parent.y);

        energy = Model.nodeArch.node(chNo).energy;

        % energy for aggregation & Rx 
        energy = energy - (packetLength * ERX * Model.nodeArch.node(chNo).child + ...
                 packetLength * EDA * (Model.nodeArch.node(chNo).child + 1));

        % energy for transferring
        if(Dist >= d0)
             Model.nodeArch.node(chNo).energy = energy - ...
                 (ETX * packetLength + Emp * packetLength * (Dist ^ 4));
        else
             Model.nodeArch.node(chNo).energy = energy - ...
                 (ETX * packetLength + Efs * packetLength * (Dist ^ 2));
        end
    end
    Model.nodeArch = Model.nodeArch;
end