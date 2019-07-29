function Model = dissEnergyCH(Model, roundArch, netArch, clusterFun)
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
        if (strcmp(Model.nodeArch.node(i).type, 'C')  &&  Model.nodeArch.node(i).energy > 0)
      
            BroadcastDist = sqrt(xm*xm+ym*ym);
            energy = Model.nodeArch.node(i).energy;
            
            % Rx CM join msg
            energy = energy -  (ERX * ctrPacketLength) * Model.nodeArch.node(i).child;
            
            switch clusterFun 
                case{'proposed'}
                    % Rx CM join msg
                    energy = energy -  (ERX * ctrPacketLength) * Model.nodeArch.node(i).child;
                    % Rx RN broadcast
                    energy = energy -  (ERX * ctrPacketLength); 
                case{'leach'}
                    % broadcast
                    energy = energy -  (ETX * ctrPacketLength + Emp * ctrPacketLength * (BroadcastDist ^ 4));
                    % Rx CM join msg
                    energy = energy -  (ERX * ctrPacketLength) * Model.nodeArch.node(i).child;
                case{'TLleach'}
                    % broadcast
                    energy = energy -  (ETX * ctrPacketLength + Emp * ctrPacketLength * (BroadcastDist ^ 4));
                    % Rx Cv2 broadcast
                    energy = energy -  (ERX * ctrPacketLength) * Model.clusterNode.countCHv2;  
                    % Rx CM join msg
                    energy = energy -  (ERX * ctrPacketLength) * Model.nodeArch.node(i).child;
                case{'hhca'}
                    % broadcast
                    energy = energy -  (ETX * ctrPacketLength + Emp * ctrPacketLength * (BroadcastDist ^ 4));
                    % Rx GH broadcast
                    energy = energy -  (ERX * ctrPacketLength) * Model.numGrid; 
                    % Rx CM join msg
                    energy = energy -  (ERX * ctrPacketLength) * Model.nodeArch.node(i).child;
            end
                 
            % energy for aggregation & Rx 
            energy = energy - (packetLength * ERX * Model.nodeArch.node(i).child + ...
                     packetLength * EDA * (Model.nodeArch.node(i).child + 1));

                 
            Dist = calDistance(Model.nodeArch.node(i).x, Model.nodeArch.node(i).y,...
                        Model.nodeArch.node(i).parent.x, Model.nodeArch.node(i).parent.y);
            % energy for transferring
            if(Dist >= d0)
                 switch clusterFun 
                    case{'proposed'}
                        
                    case{'TLleach'}
                        % Control Packet (Join CHv2)
                        energy = energy - ...
                                (ctrPacketLength * ETX + Emp * ctrPacketLength * (Dist ^ 4));
                    case{'hhca'}
                        % Control Packet (Join GH)
                        energy = energy - ...
                                (ctrPacketLength * ETX + Emp * ctrPacketLength * (Dist ^ 4));
                 end
                 
                 % Data Packet
                 Model.nodeArch.node(i).energy = energy - ...
                     (ETX * packetLength + Emp * packetLength * (Dist ^ 4));
            else
                 switch clusterFun 
                    case{'proposed'}
                        
                    case{'TLleach'}
                        % Control Packet (Join CHv2)
                        energy = energy - ...
                                (ctrPacketLength * ETX + Emp * ctrPacketLength * (Dist ^ 2));
                    case{'hhca'}
                        % Control Packet (Join GH)
                        energy = energy - ...
                                (ctrPacketLength * ETX + Emp * ctrPacketLength * (Dist ^ 2));
                 end
                 
                 % Data Packet
                 Model.nodeArch.node(i).energy = energy - ...
                     (ETX * packetLength + Efs * packetLength * (Dist ^ 2));
            end
        end
    end
    
    
    Model.nodeArch = Model.nodeArch;
end