function Model = dissEnergyGH(Model, roundArch, netArch)
% Calculation of Energy dissipated for GH [HHCA]

    nodeArch = Model.nodeArch;
    cluster  = Model.gridNode;
    
    d0 = sqrt(netArch.Energy.freeSpace / ...
              netArch.Energy.multiPath);

    if Model.noOfk == 0
        return
    end

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
        if (strcmp(Model.nodeArch.node(i).type, 'G') &&  Model.nodeArch.node(i).energy > 0)
            Dist = calDistance(Model.nodeArch.node(i).x, Model.nodeArch.node(i).y, netArch.Sink.x, netArch.Sink.y);
            energy = Model.nodeArch.node(i).energy;

%             % diss for DA & Rx 
%             if Model.nodeArch.node(i).child > 0
%                 energy = energy - (packetLength * ERX * Model.nodeArch.node(i).child + ...
%                          packetLength * EDA * (Model.nodeArch.node(i).child + 1));
%             else
                energy = energy - (packetLength * ERX * Model.nodeArch.node(i).child);
%             end
            
            % diss for Tx
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