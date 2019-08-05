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
    packetLength = roundArch.packetLength;
    
    locAlive = find(~Model.nodeArch.dead);
    for i = locAlive
        if (strcmp(Model.nodeArch.node(i).type, 'R') &&  Model.nodeArch.node(i).energy > 0)
            Dist = calDistance(Model.nodeArch.node(i).x, Model.nodeArch.node(i).y,...
                        Model.nodeArch.node(i).parent.x, Model.nodeArch.node(i).parent.y);
            energy = Model.nodeArch.node(i).energy;

            % energy for aggregation & Rx 
%             energy = energy - (packetLength * ERX * Model.nodeArch.node(i).child + ...
%                      packetLength * EDA * (Model.nodeArch.node(i).child + 1));
            energy = energy - (packetLength * ERX * Model.nodeArch.node(i).child);      

            % energy for transferring      * Model.nodeArch.node(i).child
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