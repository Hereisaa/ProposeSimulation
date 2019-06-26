function clusterModel = newCluster(netArch, nodeArch,clusterFun, clusterFunParam, p_numCluster)
% Create the network architecture with desired parameters
% This function is called by start.m in every round
%   Input:
%       netArch             Network model
%       nodeArch            Nodes model
%       clusterFun          Function name for clustering algorithm.
%       clusterFunParam     Parameters for the cluster function
%       p_numCluster        Number of clusters (CHs)
%   Example:
%       clusterModel = newCluster();

    if ~exist('clusterFun','var')
        clusterFun = 'leach'; % default for clustering the node is leach algorithm
    end
    if strcmp(clusterFun, 'def')
        clusterFun = 'leach'; % default for clustering the node is leach algorithm
    end
    clusterModel.clusterFun = clusterFun;
   
    if ~exist('clusterFunParam','var')
        clusterFunParam = [];
    end
    clusterModel.clusterFunParam = clusterFunParam;
   
    if ~exist('netArch','var')
        netArch = newNetwork();
    end
    clusterModel.netArch = netArch;
    
    if ~exist('nodeArch','var')
        nodeArch = newNodes();
    end
    clusterModel.nodeArch = nodeArch;
    
%     if ~exist('numCluster','var')
%         numCluster = 0;
%     end
    clusterModel.numCluster = 0;
    
    
    if ~exist('p_numCluster','var')
        dBS        = sqrt((netArch.Sink.x - netArch.Yard.Length) ^ 2 + ...
                          (netArch.Sink.y - netArch.Yard.Width) ^ 2);
        kOpt = clusterOptimum(netArch, nodeArch, dBS); 
        p = kOpt / nodeArch.numNode;
    else
        p = p_numCluster;
    end

    % p = Optimal Election Probability of a node to become cluster head
    clusterModel.p          = p;
    fprintf('[LEACH] p = %d\n',p);
    
    % run leach.m
    [nodeArch, clusterNode] = feval(clusterFun, clusterModel, clusterFunParam); % execute the cluster function
    
    clusterModel.nodeArch = nodeArch;       % new architecture of nodes
    clusterModel.clusterNode = clusterNode; % the CHs
end