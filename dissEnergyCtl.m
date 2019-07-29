function Model = dissEnergyCtl(Model, roundArch, netArch, func)
% Calculation of consumption of Control packet
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
    
    locAlive = find(~Model.nodeArch.dead);
    for i = locAlive
        Dist = calDistance(Model.nodeArch.node(i).x, Model.nodeArch.node(i).y,Model.nodeArch.node(i).parent.x, Model.nodeArch.node(i).parent.y);
        energy = Model.nodeArch.node(i).energy;
        
        if (strcmp(Model.nodeArch.node(i).type, 'N')  &&  Model.nodeArch.node(i).energy > 0)
            switch func
                case{'proposed'}
                    if Model.recluster==true
                        energy = energy - (ctrPacketLength * ERX); % Rx from BS
                        Model.nodeArch.node(i).energy = energy - (ctrPacketLength * ERX); % Rx from CH
                    else
                        energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (Dist ^ 2)); % Tx to CH
                        Model.nodeArch.node(i).energy = energy - (ctrPacketLength * ERX); % Rx from CH
                    end
                case{'leach'}
                    Model.nodeArch.node(i).energy = energy - (ctrPacketLength * ERX) * Model.clusterNode.countCHs; % Rx from CH
                case{'TLleach'}
                    Model.nodeArch.node(i).energy = energy - (ctrPacketLength * ERX) * Model.clusterNode.countCHs; % Rx from CH
                case{'hhca'}
                    energy = energy - (ctrPacketLength * ERX); % Rx from BS
                    Model.nodeArch.node(i).energy = energy - (ctrPacketLength * ERX); % Rx from CH
            end
            
        elseif (strcmp(Model.nodeArch.node(i).type, 'C')  &&  Model.nodeArch.node(i).energy > 0)
            switch func
                case{'proposed'}
                    if Model.recluster==true
                        energy = energy - (ctrPacketLength * ERX); % Rx from BS
                        Model.nodeArch.node(i).energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (87 ^ 2)); % Broadcast in cluster
                    else
                        energy = energy - (ctrPacketLength * ERX)*Model.nodeArch.node(i).child; % Rx from CM
                        Model.nodeArch.node(i).energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (87 ^ 2)); % Broadcast in cluster
                    end
                case{'leach'}
                    energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (87 ^ 2)); % Broadcast in cluster
                    Model.nodeArch.node(i).energy = energy - (ctrPacketLength * ERX)*Model.nodeArch.node(i).child; % Rx from CM
                case{'TLleach'}
                    energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (87 ^ 2)); % Broadcast in cluster
                    Model.nodeArch.node(i).energy = energy - (ctrPacketLength * ERX)*Model.nodeArch.node(i).child; % Rx from CM
                case{'hhca'}
                    energy = energy - (ctrPacketLength * ERX); % Rx from BS
                    energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (87 ^ 2)); % Broadcast in cluster
                    Model.nodeArch.node(i).energy = energy - (ctrPacketLength * ERX)*Model.nodeArch.node(i).child; % Rx from CM
            end   
            
        elseif (strcmp(Model.nodeArch.node(i).type, 'Cv2')  &&  Model.nodeArch.node(i).energy > 0) % TLleach
            energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (150 ^ 2)); % Broadcast in cluster
            Model.nodeArch.node(i).energy = energy - (ctrPacketLength * ERX) * Model.nodeArch.node(i).child; % Rx from CM                
            
        elseif (strcmp(Model.nodeArch.node(i).type, 'G')  &&  Model.nodeArch.node(i).energy > 0) % hhca
            energy = energy - (ctrPacketLength * ERX); % Rx from BS
            Model.nodeArch.node(i).energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (87 ^ 2)); % Broadcast in cluster
        
        elseif (strcmp(Model.nodeArch.node(i).type, 'R')  &&  Model.nodeArch.node(i).energy > 0)  % proposed 
            if Model.recluster==true
                energy = energy - (ctrPacketLength * ERX); % Rx from BS
                Model.nodeArch.node(i).energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (87 ^ 2)); % Broadcast in cluster
            else
                energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (87 ^ 2)); % Tx to CH
                Model.nodeArch.node(i).energy = energy - (ctrPacketLength * ERX); % Rx from CH
            end
        end
    end
    Model.nodeArch = Model.nodeArch;
end