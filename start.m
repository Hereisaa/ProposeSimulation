% MAIN
%% Parameter
clc, clear all, close all

numNodes = 300; % number of nodes
p = 0.05;% ¹w³]0.1
d = 87;
netArch  = newNetwork(500, 500, 250, 250);
nodeArch = newNodes(netArch, numNodes);
roundArch = newRound(); 

%% Kmeans clustering
noOfk = numNodes*p;
count = 1;
for i = 1:numNodes
    if( calDistance(nodeArch.node(i).x, nodeArch.node(i).y, netArch.Sink.x, netArch.Sink.y) > d)
        tmp(1, count) = nodeArch.node(i).x;
        tmp(2, count) = nodeArch.node(i).y;
        tmp2(1, count) = i;
        count = count + 1;
    end
end

[cluster, centr] = usingKmeans(tmp,noOfk);

for i = 1:count-1
    tmp(4, i) = cluster(i);
end

for i = 1:count-1
    nodeArch.node(tmp2(1,i)).km = cluster(i);
end

plot_kmeans


%% Round
par = struct;
% for r = 1:roundArch.numRound
for r = 1:1
    r
    clusterModel = newCluster(netArch, nodeArch, 'leach', r, p);
    clusterModel = dissEnergyCH(clusterModel, roundArch);
    clusterModel = dissEnergyNonCH(clusterModel, roundArch);
    nodeArch     = clusterModel.nodeArch; % new node architecture after select CHs
    
%     par = plotResults(clusterModel, r, par);
%     if nodeArch.numDead == nodeArch.numNode
%         break
%     end
end

plot_leach

