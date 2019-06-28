function clusterModel = newCluster(netArch, nodeArch,clusterFun, clusterFunParam, p_numCluster)
% Create the network architecture with desired parameters
% This function is called by start.m in every round
%   Input:
%       netArch             Network model
%       nodeArch            Nodes model
%       clusterFun          Function name for clustering algorithm.
%       clusterFunParam     = round = Parameters for the cluster function
%       p_numCluster        Number of clusters (CHs)
%   Example:
%       clusterModel = newCluster();

   
    clusterModel.netArch = netArch;
    clusterModel.nodeArch = nodeArch;
    clusterModel.clusterFun = clusterFun;
    clusterModel.clusterFunParam = clusterFunParam;
    clusterModel.p = p_numCluster;
    clusterModel.numCluster = 0;
    
%     if ~exist('p_numCluster','var')
%         dBS        = sqrt((netArch.Sink.x - netArch.Yard.Length) ^ 2 + ...
%                           (netArch.Sink.y - netArch.Yard.Width) ^ 2);
%         kOpt = clusterOptimum(netArch, nodeArch, dBS); 
%         p = kOpt / nodeArch.numNode;
%     else
%         p = p_numCluster;
%     end

    % run leach.m
    [nodeArch, clusterNode, numCluster] = feval(clusterFun, clusterModel, clusterFunParam);
    
    
    clusterModel.nodeArch = nodeArch;       % new architecture of nodes
    clusterModel.clusterNode = clusterNode; % CHs
    clusterModel.numCluster = numCluster; % number of the CHs
end