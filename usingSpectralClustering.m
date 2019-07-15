function [k, cluster, centr] = usingSpectralClustering( S_xy, S_index )
%USINGSPECTRALCLUSTERING Summary of this function goes here
%   Detailed explanation goes here
	s_matrix = calSimilarities(S_xy, S_index, 87 ,0.3);
    D_matrix=diag(sum(s_matrix));
    L_matrix=D_matrix-s_matrix; % L = D - A
    
    [eig_vectors,eig_values]=eig((L_matrix+L_matrix')./2,(D_matrix+D_matrix')./2); 
    
    [sorted_result,sorted_indices]=sort(diag(eig_values));
    sorted_eig_values=eig_values(sorted_indices,sorted_indices);
    sorted_eig_vectors=eig_vectors(:,sorted_indices);

    % calculate the appropriate number of clusters
    eig_gaps=[];
    for i=3:length(sorted_indices)
       eig_gaps=[eig_gaps,sorted_eig_values(i,i)-sorted_eig_values(i-1,i-1)];
    end
    [~,gap] = max(eig_gaps);
    k = gap + 2;
    k
    sorted_eig_vectors=sorted_eig_vectors(:,1:k);
    [cluster, centr] = usingKmeans(sorted_eig_vectors', k, []);


%     affinity = calSimilarities(S_xy, S_index, 87 ,0.3);
%     sz = size(affinity,1);
%     D = zeros(sz,sz);
%     for i=1:sz
%         D(i,i) = sum(affinity(i,:));
%     end
% 
%     L = D - affinity;
%     [eigVec, eigVal] = eig( inv(D) * L);
% 
%     cEigVal =  circshift(diag(eigVal),1);
%     [~, idx] = max(cEigVal - diag(eigVal));
% 
%     KEigenVectors = eigVec(:,idx:size(eigVec,1)-1);
    
    


end

