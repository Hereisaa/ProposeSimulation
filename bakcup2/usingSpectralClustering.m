function [noOfk, cluster, centr] = usingSpectralClustering(Model, S_xy, S_index )
%USINGSPECTRALCLUSTERING Summary of this function goes here
%   Detailed explanation goes here
    
	s_matrix = calSimilarities(Model, S_xy, S_index, 87 ,0.03);
    D_matrix=diag(sum(s_matrix));
%     
%     %  L = D - A (unnormalized)
%     L_matrix=D_matrix-s_matrix;


    
    %  L = I-(D^-1/2)*A*(D^-1/2) (normalized)
    [t,r]=eig(D_matrix);
    p=size(D_matrix,1);
    b=zeros(p);
    for i=1:p
        b=b+r(i,i)^-.5*t(:,i)*t(:,i)';
    end
    
    for i = 1:size(b)
        for j = 1:size(b)
            if (isnan(b(i,j))==1) || (isinf(b(i,j))==1)
                b(i,j) = 0;
            end
        end
    end
    L_matrix = eye(length(S_xy)) - (b * s_matrix * b);
    
%      % L = D^-1 * A (random walk)
%     L_matrix = inv(D_matrix) * s_matrix;


%     [eig_vectors,eig_values]=eig((L_matrix+L_matrix')./2,(D_matrix+D_matrix')./2); 
    [eig_vectors,eig_values]=eig(L_matrix);
    eig_values(1,1) = 0;
    
    [sorted_result,sorted_indices]=sort(diag(eig_values));
    sorted_eig_values=eig_values(sorted_indices,sorted_indices);
    sorted_eig_vectors=eig_vectors(:,sorted_indices);

    % calculate the appropriate number of clusters
    eig_gaps=[];
    for i=2:length(sorted_indices)
       eig_gaps=[eig_gaps,sorted_eig_values(i,i)-sorted_eig_values(i-1,i-1)];
    end
    [~,gap] = max(eig_gaps);
    noOfk = gap + 1;
    fprintf('number of cluster = %d\n',noOfk);
    
    sorted_eig_vectors=sorted_eig_vectors(:,1:noOfk);
    
    % renormalizing
    for i = 1:size(sorted_eig_vectors,1)
        vec = sorted_eig_vectors(i,:);
        nor = sum(vec.^2)^(1/2);
        for j = 1:noOfk
            sorted_eig_vectors(i,j) = sorted_eig_vectors(i,j) / nor;
        end
    end    
  
%     % Normalize eigvector(1:k)
%     for i=1:length(S_xy)
%         maxD = max(sorted_eig_vectors(i,:));
%         minD = min(sorted_eig_vectors(i,:));
%         for j=1:k
%             sorted_eig_vectors(i,j) = ( sorted_eig_vectors(i,j) - minD) / ( maxD - minD );
%         end
%     end

%     s_matrix = calSimilarities(Model, S_xy, S_index, 87 ,0.03);
%     D_matrix=diag(sum(s_matrix));
%     L_matrix=D_matrix-s_matrix;
%     [eig_vectors,eig_values]=eig((L_matrix+L_matrix')./2,(D_matrix+D_matrix')./2);
%     [sorted_result,sorted_indices]=sort(diag(eig_values));
%     sorted_eig_values=eig_values(sorted_indices,sorted_indices);
%     sorted_eig_vectors=eig_vectors(:,sorted_indices);
%     % calculate the appropriate number of clusters
%     eig_gaps=[];
%     for i=2:length(sorted_indices)
%        eig_gaps=[eig_gaps,sorted_eig_values(i,i)-sorted_eig_values(i-1,i-1)];
%     end
%     [~,gap] = max(eig_gaps);
%     noOfk = gap + 1;
%     fprintf('number of cluster = %d\n',noOfk);
%     sorted_eig_vectors=sorted_eig_vectors(:,1:noOfk);
    
    [cluster, centr] = usingKmeans(sorted_eig_vectors', noOfk, []);
end

