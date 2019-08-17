function Model = dissEnergyCtl(Model, roundArch, netArch, func)
% Calculation of consumption of Control packet
%   Input:
%       Model            architecture of nodes
%       roundArch        round Architecture
%       netArch          network Architecture
    
    return

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
                        Model.nodeArch.node(i).energy = energy - (ctrPacketLength * ERX); % Rx from BS
                    else
                        if Dist >= d0
                             energy = energy - (ETX * ctrPacketLength + Emp * ctrPacketLength * (Dist ^ 4)); % Tx to CH
                        else
                             energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (Dist ^ 2)); 
                        end
                        Model.nodeArch.node(i).energy = energy - (ctrPacketLength * ERX); % Rx from CH
                    end
%                case{'proposed2'}
%                     if Model.recluster==true
%                         if DistBS >= d0
%                          energy = energy - (ETX * ctrPacketLength + Emp * ctrPacketLength * (DistBS ^ 4)); % Tx to BS
%                         else
%                              energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (DistBS ^ 2)); 
%                         end
%                         Model.nodeArch.node(i).energy = energy - (ctrPacketLength * ERX); % Rx from BS
%                     else
%                         if Dist >= d0
%                              energy = energy - (ETX * ctrPacketLength + Emp * ctrPacketLength * (Dist ^ 4)); % Tx to CH
%                         else
%                              energy = energy - (ETX * ctrPacketLength + Efs * ctrPacketLength * (Dist ^ 2)); 
%                         end
%                         Model.nodeArch.node(i).energy = energy - (ctrPacketLength * ERX); % Rx from CH
%                     end
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
                case{'proposed2'}
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
            end   
            
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
                end
            end
        end
    end
end