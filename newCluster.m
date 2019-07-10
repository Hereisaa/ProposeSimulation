function clusterModel = newCluster(netArch, nodeArch,clusterFun, clusterFunParam, p_numCluster, k)
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
    
    switch clusterFun 
        case{'leach'}
            % run leach.m
            [nodeArch, clusterNode, numCluster] = feval(clusterFun, clusterModel, clusterFunParam);
            
  
            
            clusterModel.nodeArch = nodeArch;       % new architecture of nodes
            clusterModel.clusterNode = clusterNode; % CHs
            clusterModel.numCluster = numCluster; % number of the CHs
        case{'hhca'}     
            % run hhca.m
            [nodeArch, clusterNode, gridNode, numCluster, numGrid] = feval(clusterFun, clusterModel, clusterFunParam, k);
            
            
            
            clusterModel.noOfk = k;
            clusterModel.nodeArch = nodeArch;       % new architecture of nodes
            clusterModel.clusterNode = clusterNode; % CHs
            clusterModel.gridNode = gridNode; % GHs
            clusterModel.numCluster = numCluster; % number of the CHs
            clusterModel.numGrid = numGrid; % number of the GHs
    end
    
    
    
%     clusterModel.nodeArch = nodeArch;       % new architecture of nodes
%     clusterModel.clusterNode = clusterNode; % CHs
%     clusterModel.numCluster = numCluster; % number of the CHs
end