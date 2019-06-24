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
    
    if ~exist('p_numCluster','var')
        % Optimal calculation of p
        dBS = 0;
        for i = 1:nodeArch.numNode
           dBS = dBS + sqrt((netArch.Sink.x - nodeArch.nodesLoc(i, 1)) ^ 2 + ...
                          (netArch.Sink.y - nodeArch.nodesLoc(i, 2)) ^ 2);
        end
        dBS = dBS / nodeArch.numNode;
        display(dBS);
        numCluster = clusterOptimum(netArch, nodeArch, dBS); 
        p = numCluster / nodeArch.numNode;
        fprintf('LEACH : p = %d',p);
    else
        numCluster = nodeArch.numNode * p_numCluster;
        p = numCluster / nodeArch.numNode;
        fprintf('LEACH : p = %d',p);
    end
    
    % p = Optimal Election Probability of a node to become cluster head
    clusterModel.numCluster = numCluster;
    clusterModel.p          = p;
    
    % run leach
    [nodeArch, clusterNode] = feval(clusterFun, clusterModel, clusterFunParam); % execute the cluster function
    
    clusterModel.nodeArch = nodeArch;       % new architecture of nodes
    clusterModel.clusterNode = clusterNode; % the CHs
end