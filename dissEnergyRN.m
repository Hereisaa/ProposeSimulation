function Model = dissEnergyRN(Model, roundArch, netArch)
% Calculation of Energy dissipated for RN [Proposed]

    nodeArch = Model.nodeArch;
    cluster  = Model.relayNode;
    
    d0 = sqrt(netArch.Energy.freeSpace / ...
              netArch.Energy.multiPath);
          
    % Number of RNs
    if Model.relayNode.countRNs == 0
        return
    else
        n = Model.relayNode.countRNs; 
    end

    ETX = netArch.Energy.transfer;
    ERX = netArch.Energy.receive;
    Emp = netArch.Energy.multiPath;
    Efs = netArch.Energy.freeSpace;
    EDA = netArch.Energy.aggr;
    packetLength = roundArch.packetLength;
    
    locAlive = find(~Model.nodeArch.dead);
    for i = locAlive
        if (strcmp(Model.nodeArch.node(i).type, 'R') &&  Model.nodeArch.node(i).energy > 0)
            Dist = calDistance(Model.nodeArch.node(i).x, Model.nodeArch.node(i).y,...
                        Model.nodeArch.node(i).parent.x, Model.nodeArch.node(i).parent.y);
            energy = Model.nodeArch.node(i).energy;

            % diss for DA & Rx 
            energy = energy - (packetLength * ERX * Model.nodeArch.node(i).child + ...
                     packetLength * EDA * (Model.nodeArch.node(i).child + 1));

%             energy = energy - (packetLength * ERX * Model.nodeArch.node(i).child);      

            % diss for Tx
            if(Dist >= d0)
                 Model.nodeArch.node(i).energy = energy - ...
                     (ETX * packetLength + Emp * packetLength  * (Dist ^ 4));
            else
                 Model.nodeArch.node(i).energy = energy - ...
                     (ETX * packetLength + Efs * packetLength  * (Dist ^ 2));
            end
        end
    end
    
    Model.nodeArch = Model.nodeArch;
end