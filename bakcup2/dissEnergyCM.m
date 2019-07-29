function Model = dissEnergyCM(Model, roundArch, netArch, clusterFun)
% Calculation of Energy dissipated for CHs
%   Input:
%       Model            architecture of nodes
%       roundArch        round Architecture
%       netArch          network Architecture
    
    nodeArch = Model.nodeArch;
    cluster  = Model.clusterNode;
%     if cluster.countCHs == 0
%         return
%     end
    d0 = sqrt(netArch.Energy.freeSpace / ...
              netArch.Energy.multiPath);
    ETX = netArch.Energy.transfer;
    ERX = netArch.Energy.receive;
    Emp = netArch.Energy.multiPath;
    Efs = netArch.Energy.freeSpace;
    packetLength = roundArch.packetLength;
    ctrPacketLength = roundArch.ctrPacketLength;
    
    locAlive = find(~Model.nodeArch.dead); % find the nodes that are alive
    for i = locAlive % search in alive nodes
        
        Dist = calDistance(Model.nodeArch.node(i).x, Model.nodeArch.node(i).y,...
                        netArch.Sink.x, netArch.Sink.y);
%         switch clusterFun
%             case{'proposed'}
%                 if Model.r==1
%                     % send info to BS for centralized clustering
%                     if (Dist >= d0)
%                         Model.nodeArch.node(i).energy = Model.nodeArch.node(i).energy - ...
%                             (ctrPacketLength * ETX + Emp * ctrPacketLength * (Dist ^ 4));
%                     else
%                         Model.nodeArch.node(i).energy = Model.nodeArch.node(i).energy - ...
%                             (ctrPacketLength * ETX + Efs * ctrPacketLength * (Dist ^ 2));
%                     end
%                     % Rx BS clustering info
%                     Model.nodeArch.node(i).energy = Model.nodeArch.node(i).energy - ...
%                             (ctrPacketLength * ERX);
%                 end
%             case{'hhca'}
%                 if Model.r==1
%                     % send info to BS for centralized clustering
%                     if (Dist >= d0)
%                         Model.nodeArch.node(i).energy = Model.nodeArch.node(i).energy - ...
%                             (ctrPacketLength * ETX + Emp * ctrPacketLength * (Dist ^ 4));
%                     else
%                         Model.nodeArch.node(i).energy = Model.nodeArch.node(i).energy - ...
%                             (ctrPacketLength * ETX + Efs * ctrPacketLength * (Dist ^ 2));
%                     end                
%                     % Rx BS clustering info
%                     Model.nodeArch.node(i).energy = Model.nodeArch.node(i).energy - ...
%                             (ctrPacketLength * ERX);
%                 end
%         end

        
        if (strcmp(Model.nodeArch.node(i).type, 'N') &&  Model.nodeArch.node(i).energy > 0)
            energy = Model.nodeArch.node(i).energy;
            countCHs = Model.numCluster; % Number of CHs
            if countCHs == 0
                Model.nodeArch.node(i).parent = netArch.Sink;
                Dist = calDistance(Model.nodeArch.node(i).x, Model.nodeArch.node(i).y,...
                        netArch.Sink.x, netArch.Sink.y);
                
                if (Dist >= d0)
                    Model.nodeArch.node(i).energy = energy - ...
                        (packetLength * ETX + Emp * packetLength * (Dist ^ 4));
                else
                    Model.nodeArch.node(i).energy = energy - ...
                        (packetLength * ETX + Efs * packetLength * (Dist ^ 2));
                end
            else
                Dist = calDistance(Model.nodeArch.node(i).x, Model.nodeArch.node(i).y,...
                        Model.nodeArch.node(i).parent.x, Model.nodeArch.node(i).parent.y);
                % Rx from CH broadcast  (countCHs)
                energy = energy - (ctrPacketLength * ERX)*countCHs; 
                % Tx to CH
                if (Dist >= d0)
                    % Control Packet (Join CH)
                    energy = energy - ...
                        (ctrPacketLength * ETX + Emp * ctrPacketLength * (Dist ^ 4));
                    % Data Packet
                    Model.nodeArch.node(i).energy = energy - ...
                        (packetLength * ETX + Emp * packetLength * (Dist ^ 4));
                else
                    % Control Packet (Join CH)
                    energy = energy - ...
                        (ctrPacketLength * ETX + Efs * ctrPacketLength * (Dist ^ 2));
                    % Data Packet
                    Model.nodeArch.node(i).energy = energy - ...
                        (packetLength * ETX + Efs * packetLength * (Dist ^ 2));
                end
            end
        end %if
    end %for
    Model.nodeArch = Model.nodeArch;
end