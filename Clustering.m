function [ Model, noOfk, cluster, centr ] = Clustering( Model, notLayerZero, Temp_xy, Temp_index, T1, T2 )
% _Clustering Phase
%
    nodeArch = Model.nodeArch;
    
    %%% Determine number of k using [Canopy algo].
    [ k, canopy_centr, canopy_centr_node ] = usingCanopy( Temp_xy, T1, T2 ); % T1 > T2
    % plot_canopy

    % %%% Determine number of k using [kOpt].
    % % notLayer0 = count;
    % % noOfk = round(notLayer0 * p);
    % % fprintf('Proposed : number of k = %d.\n',noOfk);

    %%% Clustering using [K-means algo].   
    noOfk = k; % no. of cluster
    [cluster, centr] = usingKmeans(Temp_xy, noOfk, canopy_centr_node);
    
    % mark cluster id (CID) of each node
    for i = 1:notLayerZero
        locNode = [nodeArch.node(i).x, nodeArch.node(i).y];
        % find minmum dis node to centr
        % [dist, id]
        [minToCentr, index] = min(sqrt(sum((repmat(locNode, noOfk, 1) - (centr'))' .^ 2)));

        nodeArch.node(Temp_index(1,i)).CID = cluster(i); % CID = which cluster belongs to
    end
    

    % create [cluster-member] noOfk by no. of all nodes relation matrix     use find(clusterMember(noOfk,:))
    clusterMember = zeros(1, nodeArch.init_numNodes);
    for i = 1:noOfk
        for j = 1:nodeArch.init_numNodes
            if nodeArch.node(j).CID == i
               clusterMember(i,j) = 1;
            end
        end
    end
    
    Model.centr = centr;
    Model.numCluster = noOfk;
    Model.nodeArch = nodeArch;
    Model.clusterMember = clusterMember;
end

