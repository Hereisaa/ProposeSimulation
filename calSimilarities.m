function [ result ] = calSimilarities(Model, S_xy, S_id, max_dist ,similaritySigma)
%SIMILARIT Summary of this function goes here
%   Temp_xy ,Temp_index 
%   S_xy    ,S_id       ,similaritySigma
    var_dist=similaritySigma^2;
%     S_xy = [1 1 1 0 0;1 1 1 0 0;1 1 1 0 0;0 0 0 1 1;0 0 0 1 1;];
    

    
    for i=1:length(S_xy)
        location_differences=[];
        for j=1:length(S_xy)
            sDist=calDistance(S_xy(1,i), S_xy(2,i), S_xy(1,j), S_xy(2,j));
            if sDist < 87
                location_differences=[location_differences,sDist];
            end
        end
        maxD = max(location_differences);
        minD = min(location_differences);
        for j=1:length(S_xy)
            sDist=calDistance(S_xy(1,i), S_xy(2,i), S_xy(1,j), S_xy(2,j));
%             rescale_dist = (sDist- minD)/(maxD- minD);
%             similarity_matrix(i,j) = exp( -( (rescale_dist^2) / (2*var_dist) ) );
            if sDist < 87
                rescale_matrix(i,j) = (sDist- minD)/(maxD- minD);
            end
        end
    end
    
    for i=1:length(S_xy)
        for j=1:length(S_xy)
            sDist=calDistance(S_xy(1,i), S_xy(2,i), S_xy(1,j), S_xy(2,j));
            if (i==j) || (sDist >= 87)
                similarity_matrix(i,j) = 0;
            else
                similarity_matrix(i,j) = exp( -( (rescale_matrix(i,j)^2) / (2*var_dist) ) );
            end
        end
    end
    
    
    result=similarity_matrix;
    
%     location_differences=[];
%     for i=1:length(S_xy)
%         for j=1:length(S_xy)
%             sDist=calDistance(S_xy(1,i), S_xy(2,i), S_xy(1,j), S_xy(2,j));
%             if(sDist < 87)
%                 location_differences=[location_differences,sDist];
%             end
%         end
%     end
% 
% 
%     % standardization
%     re_location_differences=[];
%     for i=1:length(location_differences)
%         re_location_differences=[re_location_differences,(location_differences(i)-min(location_differences))/(max(location_differences)-min(location_differences))];
%     end
%     
%     
%     
%     for i=1:length(S_xy)
%         for j=1:length(S_xy)
%             sDist=calDistance(S_xy(1,i),  S_xy(2,i), S_xy(1,j),S_xy(2,j));
%             maxDist=calDistance(S_xy(1,i),  S_xy(1,j),Model.netArch.Sink.x,Model.netArch.Sink.y);
%             if (i==j) || (sDist >= 87)
%                 similarity_matrix(i,j)=0;
%             else
%                 rescale_dist=(sDist-min(location_differences))/(max(location_differences)-min(location_differences));
%                 similarity_matrix(i,j)=exp( -( (rescale_dist^2) / (2*var_dist) ) );
%                 
%             end
%         end
%     end
%     result=similarity_matrix;


    location_differences=[];
    for i=1:length(S_xy)
        for j=1:length(S_xy)
            sDist=calDistance(S_xy(1,i), S_xy(1,j), S_xy(2,i), S_xy(2,j));
            if(sDist<=max_dist)
                location_differences=[location_differences,sDist];
            end
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
            sDist=calDistance(S_xy(1,i), S_xy(1,j), S_xy(2,i), S_xy(2,j));
            if (sDist>max_dist)
                similarity_dist=0;
            else
                rescale_dist=(sDist-min(location_differences))/(max(location_differences)-min(location_differences));
                similarity_dist=exp(-(rescale_dist^2/(2*var_dist)));
            end
            if (sDist>max_dist)
                similarity_matrix(i,j)=0;
            else
                similarity_matrix(i,j)=similarity_dist;
            end
        end
    end
    result=similarity_matrix;
end

