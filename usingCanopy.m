function [ k ] = usingCanopy( S, TH )
    Omega = S; % Temp_xy is a 2 by n metrix
    size_S = size(S, 2); 
%     fprintf('[Canopy] size of S = %d.\n',size_S);
    k = 0; % size of C
    
    while size(Omega, 2)~=0
%         fprintf('[Canopy] size of Omega = %d.\n',size(Omega, 2));
        k = k + 1;
%         fprintf('[Canopy] k = %d.\n',k);
        Tau = Omega(:,randi([1 size(Omega, 2)]));
        for i = 1:size_S
            if(calDistance(S(1, i), S(2, i), Tau(1, 1), Tau(2, 1)) <= TH)                 
                    for j = 1:size(Omega, 2)
                        if(Omega(:,j)==S(:,i))
                            Omega(:,j) = [];
                            break;
                        end
                    end
            end
        end
    end
end