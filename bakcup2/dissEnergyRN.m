function Model = dissEnergyRN(Model, roundArch, netArch, clusterFun)
% Calculation of Energy dissipated for CHs
%   Input:
%       Model            architecture of nodes
%       roundArch        round Architecture
%       netArch          network Architecture

    nodeArch = Model.nodeArch;
    cluster  = Model.relayNode;
    
    d0 = sqrt(netArch.Energy.freeSpace / ...
              netArch.Energy.multiPath);

    if Model.relayNode.countRNs == 0
        return
    end
    
    xm = netArch.Yard.Length;
    ym = netArch.Yard.Width;
    n = Model.relayNode.countRNs; % Number of RNs
    ETX = netArch.Energy.transfer;
    ERX = netArch.Energy.receive;

    Emp = netArch.Energy.multiPath;
    Efs = netArch.Energy.freeSpace;
    packetLength = roundArch.packetLength;
    ctrPacketLength = roundArch.ctrPacketLength;

    
    locAlive = find(~Model.nodeArch.dead); % find the nodes that are alive
    for i = locAlive % search in alive nodes
        %find Associated CH for each normal node
        if (strcmp(Model.nodeArch.node(i).type, 'R') &&  Model.nodeArch.node(i).energy > 0)
            Dist = calDistance(Model.nodeArch.node(i).x, Model.nodeArch.node(i).y,...
                        Model.nodeArch.node(i).parent.x, Model.nodeArch.node(i).parent.y);
                    
            energy = Model.nodeArch.node(i).energy;
            
%             BroadcastDist = sqrt(xm*xm+ym*ym);
%             % Broadcast
%             energy = energy -  (ETX * ctrPacketLength + Emp * ctrPacketLength * (BroadcastDist ^ 4));
            
            % Rx CH join msg
            energy = energy -  (ERX * ctrPacketLength);

            % energy for Rx 
            energy = energy - (packetLength * ERX * Model.nodeArch.node(i).child);      

            % energy for transferring
            if(Dist >= d0)
                 Model.nodeArch.node(i).energy = energy - ...
                     (ETX * packetLength + Emp * packetLength * 1 * (Dist ^ 4)); %Model.nodeArch.node(i).child
            else
                 Model.nodeArch.node(i).energy = energy - ...
                     (ETX * packetLength + Efs * packetLength * 1 * (Dist ^ 2));
            end
        end
    end
    
    Model.nodeArch = Model.nodeArch;
end