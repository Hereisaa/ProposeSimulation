function Model = dissEnergyCH(Model, roundArch, netArch)
% Calculation of Energy dissipated for CHs
    nodeArch = Model.nodeArch;
    cluster  = Model.clusterNode;
    
    d0 = sqrt(netArch.Energy.freeSpace / netArch.Energy.multiPath);

    if Model.clusterNode.countCHs == 0
        return
    end

    n = Model.clusterNode.countCHs;
    ETX = netArch.Energy.transfer;
    ERX = netArch.Energy.receive;
    EDA = netArch.Energy.aggr;
    Emp = netArch.Energy.multiPath;
    Efs = netArch.Energy.freeSpace;
    packetLength = roundArch.packetLength;
    ctrPacketLength = roundArch.ctrPacketLength;

    locAlive = find(~Model.nodeArch.dead); % find the nodes that are alive
    for i = locAlive % search in alive nodes
        if (strcmp(Model.nodeArch.node(i).type, 'C')  &&  Model.nodeArch.node(i).energy > 0)
            Dist = calDistance(Model.nodeArch.node(i).x, Model.nodeArch.node(i).y,Model.nodeArch.node(i).parent.x, Model.nodeArch.node(i).parent.y);
            energy = Model.nodeArch.node(i).energy;

            % diss for DA & Rx 
            energy = energy - (packetLength * ERX * Model.nodeArch.node(i).child + ...
                     packetLength * EDA * (Model.nodeArch.node(i).child + 1));

            % diss for Tx
            if(Dist >= d0)
                 Model.nodeArch.node(i).energy = energy - (ETX * packetLength + Emp * packetLength * (Dist ^ 4));
            else
                 Model.nodeArch.node(i).energy = energy - (ETX * packetLength + Efs * packetLength * (Dist ^ 2));
            end
        end
    end
    
    Model.nodeArch = Model.nodeArch;
end