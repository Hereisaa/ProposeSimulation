function Model = dissEnergyCtl(Model, roundArch, netArch, func)
% Calculation of consumption of Control packet
%   Input:
%       Model            architecture of nodes
%       roundArch        round Architecture
%       netArch          network Architecture
    d0 = sqrt(netArch.Energy.freeSpace / ...
              netArch.Energy.multiPath);
        
          
    ETX = netArch.Energy.transfer;
    ERX = netArch.Energy.receive;
    Efs = netArch.Energy.freeSpace;
    Emp = netArch.Energy.multiPath;
    ctrPacketLength = roundArch.ctrPacketLength;
    
    locAlive = find(~Model.nodeArch.dead);
    for i = locAlive
        energy = Model.nodeArch.node(i).energy;
        if (strcmp(Model.nodeArch.node(i).type, 'N')  &&  Model.nodeArch.node(i).energy > 0)
            Dist = calDistance(Model.nodeArch.node(i).x, Model.nodeArch.node(i).y,Model.nodeArch.node(i).parent.x, Model.nodeArch.node(i).parent.y);
            switch func
                case{'proposed'}
                    if Model.recluster==true
                        energy = energy - (ctrPacketLength * ERX); % Rx from BS
                        energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (Dist ^ 2)); % Tx to CH
                        Model.nodeArch.node(i).energy = energy - (ctrPacketLength * ERX); % Rx from CH
                    else
                        energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (Dist ^ 2)); % Tx to CH
                        Model.nodeArch.node(i).energy = energy - (ctrPacketLength * ERX); % Rx from CH
                    end
                    
                case{'leach'}
                    energy = energy - (ctrPacketLength * ERX) * Model.numCluster; % Rx from CH
                    if Dist < d0
                         energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (Dist ^ 2)); % Tx to CH
                    else
                         energy = energy - (ETX * ctrPacketLength + Emp * ctrPacketLength * (Dist ^ 4)); % Tx to CH
                    end
                    
                    energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (Dist ^ 2)); % Tx to CH
                    Model.nodeArch.node(i).energy = energy - (ctrPacketLength * ERX); % Rx from CH
                    
                case{'TLleach'}
                    energy = energy - (ctrPacketLength * ERX) * Model.numCluster; % Rx from CH
                    if Dist < d0
                         energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (Dist ^ 2)); % Tx to CH
                    else
                         energy = energy - (ETX * ctrPacketLength + Emp * ctrPacketLength * (Dist ^ 4)); % Tx to CH
                    end
                    
                    energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (Dist ^ 2)); % Tx to CH
                    Model.nodeArch.node(i).energy = energy - (ctrPacketLength * ERX); % Rx from CH
                    
                case{'hhca'}
                    energy = energy - (ctrPacketLength * ERX); % Rx from BS
                    Model.nodeArch.node(i).energy = energy - (ctrPacketLength * ERX) * Model.clusterNode.countCHs; % Rx from CH

            end
            
        elseif (strcmp(Model.nodeArch.node(i).type, 'C')  &&  Model.nodeArch.node(i).energy > 0)
            parentDist = calDistance(Model.nodeArch.node(i).x, Model.nodeArch.node(i).y,Model.nodeArch.node(i).parent.x, Model.nodeArch.node(i).parent.y);
            switch func
                case{'proposed'}
                    Dist = netArch.Yard.Length/2;
                    if Model.recluster==true
                        Model.nodeArch.node(i).energy = energy - (ctrPacketLength * ERX); % Rx from BS
%                         Model.nodeArch.node(i).energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (87 ^ 2)); % Broadcast in cluster
%                         Model.nodeArch.node(i).energy = energy - (ctrPacketLength * ERX)*Model.nodeArch.node(i).child; % Rx from CM
                    else
                        energy = energy - (ctrPacketLength * ERX)*Model.nodeArch.node(i).child; % Rx from CM
                        if Dist >= d0
                            Model.nodeArch.node(i).energy = energy - (ETX * ctrPacketLength + Emp * ctrPacketLength * (Dist ^ 4)); 
                        else
                            Model.nodeArch.node(i).energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (Dist ^ 2)); % Broadcast in cluster
                        end
                    end
                    
                case{'leach'}
                    Dist = netArch.Yard.Length / 2;
                    if Dist >= d0
                        energy = energy - (ETX * ctrPacketLength + Emp * ctrPacketLength * (Dist ^ 4)); 
                    else
                        energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (Dist ^ 2)); % Broadcast in network
                    end
                    energy = energy - (ctrPacketLength * ERX) * Model.nodeArch.node(i).child; % Rx from CM join
                    if Dist >= d0
                         Model.nodeArch.node(i).energy = energy - (ETX * ctrPacketLength + Emp * ctrPacketLength * (Dist ^ 4)); 
                    else
                         Model.nodeArch.node(i).energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (Dist ^ 2)); % Broadcast in cluster
                    end
                    
                case{'TLleach'}
                    Dist = netArch.Yard.Length / 2;
                    if Dist >= d0
                        energy = energy - (ETX * ctrPacketLength + Emp * ctrPacketLength * (Dist ^ 4)); 
                    else
                        energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (Dist ^ 2)); % Broadcast in network
                    end
                    energy = energy - (ctrPacketLength * ERX) * Model.nodeArch.node(i).child; % Rx from CM join
                    Model.nodeArch.node(i).energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (Dist ^ 2)); % Tx to CM

                case{'hhca'}
                    energy = energy - (ctrPacketLength * ERX); % Rx from BS
                    Dist = netArch.Yard.Length/2;
                    if Dist >= d0
                        energy = energy - (ETX * ctrPacketLength + Emp * ctrPacketLength * (Dist ^ 4)); 
                    else
                        energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (Dist ^ 2)); % Broadcast in network
                    end
                    Model.nodeArch.node(i).energy = energy - (ctrPacketLength * ERX) * Model.nodeArch.node(i).child; % Rx from CM
            end   
            
        elseif (strcmp(Model.nodeArch.node(i).type, 'Cv2')  &&  Model.nodeArch.node(i).energy > 0) % TLleach
            Dist = netArch.Yard.Length/2;
            if Dist >= d0
                energy = energy - (ETX * ctrPacketLength + Emp * ctrPacketLength * (Dist ^ 4)); 
            else
                energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (Dist ^ 2)); % Broadcast in network
            end
            Model.nodeArch.node(i).energy = energy - (ctrPacketLength * ERX) * Model.nodeArch.node(i).child; % Rx from CH
  
        elseif (strcmp(Model.nodeArch.node(i).type, 'G')  &&  Model.nodeArch.node(i).energy > 0) % hhca
            energy = energy - (ctrPacketLength * ERX); % Rx from BS
                    Dist = netArch.Yard.Length/2;
                    if Dist >= d0
                        Model.nodeArch.node(i).energy = energy - (ETX * ctrPacketLength + Emp * ctrPacketLength * (Dist ^ 4)); 
                    else
                        Model.nodeArch.node(i).energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (Dist ^ 2)); % Broadcast in network
                    end
        elseif (strcmp(Model.nodeArch.node(i).type, 'R')  &&  Model.nodeArch.node(i).energy > 0)  % proposed 
            if Model.recluster==true
                energy = energy - (ctrPacketLength * ERX); % Rx from BS
                Dist = netArch.Yard.Length/2;
                if Dist >= d0
                    Model.nodeArch.node(i).energy = energy - (ETX * ctrPacketLength + Emp * ctrPacketLength * (Dist ^ 4)); 
                else
                    Model.nodeArch.node(i).energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (Dist ^ 2)); % Broadcast in network
                end
            else
                energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (87 ^ 2)); % Tx to CH
                energy = energy - (ctrPacketLength * ERX); % Rx from CH
                Dist = netArch.Yard.Length/2;
                if Dist >= d0
                    Model.nodeArch.node(i).energy = energy - (ETX * ctrPacketLength + Emp * ctrPacketLength * (Dist ^ 4)); 
                else
                    Model.nodeArch.node(i).energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (Dist ^ 2)); % Broadcast in network
                end
%                 Model.nodeArch.node(i).energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (87 ^ 2)); % Tx to CH
            end
        end
    end
%     Model.nodeArch = Model.nodeArch;
end