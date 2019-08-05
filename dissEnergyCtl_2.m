function Model = dissEnergyCtl_2(Model, roundArch, netArch, func)
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
        Dist = calDistance(Model.nodeArch.node(i).x, Model.nodeArch.node(i).y,Model.nodeArch.node(i).parent.x, Model.nodeArch.node(i).parent.y);
        DistBS = calDistance(Model.nodeArch.node(i).x, Model.nodeArch.node(i).y, netArch.Sink.x, netArch.Sink.y);
        DistBoard = sqrt(netArch.Yard.Length*netArch.Yard.Length + netArch.Yard.Width*netArch.Yard.Width);
%         DistBoard = 87;
        energy = Model.nodeArch.node(i).energy;
        if (strcmp(Model.nodeArch.node(i).type, 'N')  &&  Model.nodeArch.node(i).energy > 0)
            Dist = calDistance(Model.nodeArch.node(i).x, Model.nodeArch.node(i).y,Model.nodeArch.node(i).parent.x, Model.nodeArch.node(i).parent.y);
            switch func
                case{'proposed'}
                    if Model.recluster==true
                        if DistBS >= d0
                         energy = energy - (ETX * ctrPacketLength + Emp * ctrPacketLength * (DistBS ^ 4)); % Tx to BS
                        else
                             energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (DistBS ^ 2)); 
                        end
                        Model.nodeArch.energy = energy - (ctrPacketLength * ERX); % Rx from BS
                    else
                        if Dist >= d0
                             energy = energy - (ETX * ctrPacketLength + Emp * ctrPacketLength * (Dist ^ 4)); % Tx to CH
                        else
                             energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (Dist ^ 2)); 
                        end
                        Model.nodeArch.node(i).energy = energy - (ctrPacketLength * ERX); % Rx from CH
                    end
                    
                case{'leach'}
                    energy = energy - (ctrPacketLength * ERX) * Model.numCluster; % Rx from CH
                    if Dist < d0
                         energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (Dist ^ 2)); % Tx to CH
                    else
                         energy = energy - (ETX * ctrPacketLength + Emp * ctrPacketLength * (Dist ^ 4)); % Tx to CH
                    end
                    Model.nodeArch.node(i).energy = energy - (ctrPacketLength * ERX); % Rx from CH
                    
                case{'TLleach'}
                    energy = energy - (ctrPacketLength * ERX) * Model.numCluster; % Rx from CH
                    if Dist >= d0
                         energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (DistBS ^ 2)); % Tx to CH
                    else
                         energy = energy - (ETX * ctrPacketLength + Emp * ctrPacketLength * (DistBS ^ 4)); % Tx to CH
                    end
                    Model.nodeArch.node(i).energy = energy - (ctrPacketLength * ERX); % Rx from CH
                    
                case{'hhca'}
                    if DistBS >= d0
                         energy = energy - (ETX * ctrPacketLength + Emp * ctrPacketLength * (DistBS ^ 4)); % Tx to BS
                    else
                         energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (DistBS ^ 2)); 
                    end
                    energy = energy - (ctrPacketLength * ERX); % Rx from BS
                    energy = energy - (ctrPacketLength * ERX) * Model.clusterNode.countCHs; % Rx from CH
                    if Dist >= d0
                         Model.nodeArch.node(i).energy = energy - (ETX * ctrPacketLength + Emp * ctrPacketLength * (Dist ^ 4)); % Tx to CH
                    else
                         Model.nodeArch.node(i).energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (Dist ^ 2)); 
                    end
                    
                    
            end
            
        elseif (strcmp(Model.nodeArch.node(i).type, 'C')  &&  Model.nodeArch.node(i).energy > 0)
            
            switch func
                case{'proposed'}
                    if Model.recluster==true    
                        if DistBS >= d0
                             energy = energy - (ETX * ctrPacketLength + Emp * ctrPacketLength * (DistBS ^ 4)); % Tx to BS
                        else
                             energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (DistBS ^ 2)); 
                        end
                        Model.nodeArch.node(i).energy = energy - (ctrPacketLength * ERX); % Rx from BS                        
                    else
                        energy = energy - (ctrPacketLength * ERX) * Model.nodeArch.node(i).child; % Rx from CM
                        if DistBoard >= d0
                            Model.nodeArch.node(i).energy = energy - (ETX * ctrPacketLength + Emp * ctrPacketLength * (DistBoard ^ 4)); % Broadcast in cluster
                        else
                            Model.nodeArch.node(i).energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (DistBoard ^ 2)); 
                        end
                    end
                    
                case{'leach'}
                    if DistBoard >= d0
                        energy = energy - (ETX * ctrPacketLength + Emp * ctrPacketLength * (DistBoard ^ 4)); 
                    else
                        energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (DistBoard ^ 2)); % Broadcast in network
                    end
                    energy = energy - (ctrPacketLength * ERX) * Model.nodeArch.node(i).child; % Rx from CM join
                    if DistBoard >= d0
                         Model.nodeArch.node(i).energy = energy - (ETX * ctrPacketLength + Emp * ctrPacketLength * (DistBoard ^ 4)); 
                    else
                         Model.nodeArch.node(i).energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (DistBoard ^ 2)); % Broadcast in cluster
                    end
                    
                case{'TLleach'}
                    if DistBoard >= d0
                        energy = energy - (ETX * ctrPacketLength + Emp * ctrPacketLength * (DistBoard ^ 4)); 
                    else
                        energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (DistBoard ^ 2)); % Broadcast in network
                    end
                    energy = energy - (ctrPacketLength * ERX) * Model.nodeArch.node(i).child; % Rx from CM join
                    Model.nodeArch.node(i).energy = energy - (ctrPacketLength * ERX) * Model.numCluster; % Rx from CH

                case{'hhca'}
                    if DistBS >= d0
                        energy = energy - (ETX * ctrPacketLength + Emp * ctrPacketLength * (DistBS ^ 4)); % Tx to BS
                    else
                        energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (DistBS ^ 2)); 
                    end
                    energy = energy - (ctrPacketLength * ERX); % Rx from BS
                    energy = energy - (ctrPacketLength * ERX) * Model.nodeArch.node(i).child; % Rx from CM
                    if DistBoard >= d0
                         Model.nodeArch.node(i).energy = energy - (ETX * ctrPacketLength + Emp * ctrPacketLength * (DistBoard ^ 4)); 
                    else
                         Model.nodeArch.node(i).energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (DistBoard ^ 2)); % Broadcast in cluster
                    end
            end   
            
        elseif (strcmp(Model.nodeArch.node(i).type, 'Cv2')  &&  Model.nodeArch.node(i).energy > 0) % TLleach
            if DistBoard >= d0
                energy = energy - (ETX * ctrPacketLength + Emp * ctrPacketLength * (DistBoard ^ 4)); % Broadcast in network
            else
                energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (DistBoard ^ 2)); 
            end
            energy = energy - (ctrPacketLength * ERX) * Model.numCluster; % Rx from CH
            energy = energy - (ctrPacketLength * ERX) * Model.nodeArch.node(i).child; % Rx from CH join
            if DistBoard >= d0
                Model.nodeArch.node(i).energy = energy - (ETX * ctrPacketLength + Emp * ctrPacketLength * (DistBoard ^ 4)); 
            else
                Model.nodeArch.node(i).energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (DistBoard ^ 2)); % Broadcast in cluster
            end
  
        elseif (strcmp(Model.nodeArch.node(i).type, 'G')  &&  Model.nodeArch.node(i).energy > 0) % hhca
            if DistBS >= d0
                energy = energy - (ETX * ctrPacketLength + Emp * ctrPacketLength * (DistBS ^ 4)); 
            else
                energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (DistBS ^ 2)); % Tx to BS
            end
            energy = energy - (ctrPacketLength * ERX); % Rx from BS
                    if DistBoard >= d0
                         energy = energy - (ETX * ctrPacketLength + Emp * ctrPacketLength * (DistBoard ^ 4)); 
                    else
                         energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (DistBoard ^ 2)); % Broadcast in cluster
                    end
            Model.nodeArch.node(i).energy = energy - (ctrPacketLength * ERX) * Model.nodeArch.node(i).child; % Rx from CH
            
        elseif (strcmp(Model.nodeArch.node(i).type, 'R')  &&  Model.nodeArch.node(i).energy > 0)  % proposed 
            if Model.recluster==true
                if DistBS >= d0
                    energy = energy - (ETX * ctrPacketLength + Emp * ctrPacketLength * (DistBS ^ 4)); % To BS
                else
                    energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (DistBS ^ 2)); 
                end
                Model.nodeArch.node(i).energy = energy - (ctrPacketLength * ERX); % Rx from BS
            else
                if Model.nodeArch.node(i).Layer >=0
                    node = Model.nodeArch.node(i);
                    Dist = calDistance(node.x, node.y, Model.nodeArch.node(node.CH).x, Model.nodeArch.node(node.CH).y);
                    if Dist >= d0
                        energy = energy - (ETX * ctrPacketLength + Emp * ctrPacketLength * (Dist ^ 4)); % Tx to CH
                    else
                        energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (Dist ^ 2)); 
                    end
                    if DistBoard >= d0
                        energy = energy - (ETX * ctrPacketLength + Emp * ctrPacketLength * (DistBoard ^ 4)); % Broadcast
                    else
                        energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (DistBoard ^ 2)); 
                    end
                    Model.nodeArch.node(i).energy = energy - (ctrPacketLength * ERX); % Rx from CH
                else % Layer 0
%                     if DistBoard >= d0
%                         Model.nodeArch.node(i).energy = energy - (ETX * ctrPacketLength + Emp * ctrPacketLength * (DistBoard ^ 4)); % Broadcast
%                     else
%                         Model.nodeArch.node(i).energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (DistBoard ^ 2)); 
%                     end
                end
            end
        end
    end
%     Model.nodeArch = Model.nodeArch;
end