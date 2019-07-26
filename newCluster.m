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
%     clusterModel.p = p_numCluster;
    clusterModel.numCluster = 0;
    
    switch clusterFun 
        case{'leach'}
            % run leach.m

            dBS        = sqrt((netArch.Sink.x - netArch.Yard.Length) ^ 2 + ...
                           (netArch.Sink.y - netArch.Yard.Width) ^ 2);
            numCluster = clusterOptimum(netArch, nodeArch, dBS); 
            numCluster
%                 p = 1 / numCluster;
            p = numCluster / clusterModel.nodeArch.numAlive;
            p
            %p = Optimal Election Probability of a node to become cluster head
            clusterModel.numCluster = numCluster;
            clusterModel.p          = p;
            
            [nodeArch, clusterNode, numCluster] = feval(clusterFun, clusterModel, clusterFunParam);

            clusterModel.nodeArch = nodeArch;       % new architecture of nodes
            clusterModel.clusterNode = clusterNode; % CHs
            clusterModel.numCluster = numCluster; % number of the CHs
            
        case{'TLleach'}
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