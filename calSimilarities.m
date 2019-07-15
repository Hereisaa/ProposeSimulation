function [ result ] = calSimilarities(S_xy, S_id, max_dist ,similaritySigma)
%SIMILARIT Summary of this function goes here
%   Temp_xy ,Temp_index 
%   S_xy    ,S_id       ,similaritySigma

    location_differences=[];
    for i=1:length(S_xy)
        for j=1:length(S_xy)
            sDist=calDistance(S_xy(1,i), S_xy(2,i), S_xy(1,j), S_xy(2,j));
%             if(sDist<=max_dist)
                location_differences=[location_differences,sDist];
%             end
        end
    end
    % standardization
    re_location_differences=[];
    for i=1:length(location_differences)
        re_location_differences=[re_location_differences,(location_differences(i)-min(location_differences))/(max(location_differences)-min(location_differences))];
    end
    
    var_dist=similaritySigma^2;
    
    for i=1:length(S_xy)
        for j=1:length(S_xy)
            sDist=calDistance(S_xy(1,i), S_xy(2,i), S_xy(1,j), S_xy(2,j));
            if (i==j || sDist > max_dist)%
                similarity_matrix(i,j)=0;
            else
                rescale_dist=(sDist-min(location_differences))/(max(location_differences)-min(location_differences));
                similarity_matrix(i,j)=exp( -( (rescale_dist^2) / (2*var_dist) ) );
                
            end
        end
    end
    result=similarity_matrix;
end

