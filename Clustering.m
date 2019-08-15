function [ Model, noOfk, cluster, centr ] = Clustering( Model, notLayerZero, Temp_xy, Temp_index, TH)
% _Clustering Phase
%
    if isempty(Temp_xy)
        return
    end
    nodeArch = Model.nodeArch;
    
    %%% Determine number of k using [Canopy algo].
    [ k ] = usingCanopy( Temp_xy, TH ); % T1 > T2 
    k
%     fprintf('Canopy %d',k);
    % Temp_xy is a 2 by n metrix with xy
    % Temp_index is a 1 by n metrix with id 
%     plot_canopy

    % %%% Determine number of k using [kOpt].
    % % notLayer0 = count;
    % % noOfk = round(notLayer0 * p);
    % % fprintf('Proposed : number of k = %d.\n',noOfk);
    % %%%
    
    %%% Determine number of k using [Spectral Clustering algo].
%     [noOfk, cluster, centr] = usingSpectralClustering(Model, Temp_xy, Temp_index);
%     k = noOfk;
%     k
    
    %%% Clustering using [K-means algo].   
    noOfk = k; % no. of cluster
%     N = length(intersect(find(Model.nodeArch.Layer > 0),find(~Model.nodeArch.dead)));
%     noOfk = round(N * 0.05);
%     if noOfk == 0
%         noOfk = 1;
%     end
    [cluster, centr] = usingKmeans(Temp_xy, noOfk);

    %%% mark cluster id (CID)
    for i = 1:size(Temp_xy,2)
        locNode = [nodeArch.node(i).x, nodeArch.node(i).y];
        % find minmum dis node to centr
        % [dist, id]
% % %         [minToCentr, index] = min(sqrt(sum((repmat(locNode, noOfk, 1) - (centr'))' .^ 2)));

        nodeArch.node(Temp_index(1,i)).CID = cluster(i); % CID = which cluster belongs to
    end
    

    % create [cluster-member] noOfk by no. of all nodes relation matrix     use find(clusterMember(noOfk,:))
    clusterMember = zeros(noOfk, nodeArch.init_numNodes);
    for i = 1:noOfk
        for j = 1:nodeArch.init_numNodes
            if nodeArch.node(j).CID == i
               clusterMember(i,j) = 1;
            end
        end
    end
    
    centr = zeros(2,noOfk);
    for i = 1:noOfk
        num = length(find(clusterMember(i,:)));
        x = 0;
        y = 0;
        for j = find(clusterMember(i,:))
            x = x + nodeArch.node(j).x;
            y = y + nodeArch.node(j).y;
        end
        centr(1,i) = x / num;
        centr(2,i) = y / num;
    end
    
    
    
    Model.centr = centr;
    Model.numCluster = noOfk;
    Model.nodeArch = nodeArch;
    Model.clusterMember = clusterMember;
end

