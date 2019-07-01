function Model = dissEnergyRN(Model, roundArch, netArch)
% Calculation of Energy dissipated for CHs
%   Input:
%       clusterModel     architecture of nodes, network
%       roundArch        round Architecture
%   Example:
%       r = 10; % round no = 10
%       clusterModel = newCluster(netArch, nodeArch, 'def', r);
%       clusterModel = dissEnergyCH(clusterModel);
%
% Mohammad Hossein Homaei, Homaei@wsnlab.org & Homaei@wsnlab.ir
% Ver 1. 10/2014

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

    for i = 1:n
        chNo = Model.clusterNode.no(i);
        distance = Model.clusterNode.distance(i); % to BS
        energy = Model.nodeArch.node(chNo).energy;
        % energy for transferring
        if(distance >= d0)
             Model.nodeArch.node(chNo).energy = energy - ...
                 (ETX * packetLength + Emp * packetLength * (distance ^ 4));
        else
             Model.nodeArch.node(chNo).energy = energy - ...
                 (ETX * packetLength + Efs * packetLength * (distance ^ 2));
        end
        % energy for aggregation & Rx 
        Model.nodeArch.node(chNo).energy = energy - ...
                 (packetLength * ERX * Model.nodeArch.node(chNo).child + ...
                 packetLength * EDA * (Model.nodeArch.node(chNo).child + 1));
    end
    
    Model.nodeArch = Model.nodeArch;
end