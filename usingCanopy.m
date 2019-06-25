function [ k, canopy_centr, canopy_centr_node ] = usingCanopy( S, T1, T2 )
%Canopy algorithm
    Omega = S; % Temp_xy is a 2 by n metrix
    size_S = size(S, 2); 
    fprintf('[Canopy] size of S = %d.\n',size_S);
    k = 0; % size of C
    
    while size(Omega, 2)~=0
%         fprintf('[Canopy] size of Omega = %d.\n',size(Omega, 2));
        k = k + 1;
%         fprintf('[Canopy] k = %d.\n',k);
        Tau = Omega(:,randi([1 size(Omega, 2)]));
        Theta = [];
        Theta_star = [0;0];
        count = 1;
        for i = 1:size_S
            if(calDistance(S(1, i), S(2, i), Tau(1, 1), Tau(2, 1)) <= T1) 
                Theta(:,count) = S(:,i);
                count = count + 1;
            end
            if(calDistance(S(1, i), S(2, i), Tau(1, 1), Tau(2, 1)) <= T2)                 

                    for j = 1:size(Omega, 2)
%                         j
                        if(Omega(:,j)==S(:,i))
                            Omega(:,j) = [];
%                             fprintf('[Canopy*] size of Omega = %d.\n',size(Omega, 2));
                            break;
                        end
                    end
           
            end
        end
        
        % means for centroids
        for i = 1:size(Theta, 2)
           Theta_star(1,1) =  Theta_star(1,1) + Theta(1,i);
           Theta_star(2,1) =  Theta_star(2,1) + Theta(2,i);
        end
        Theta_star(1,1) = Theta_star(1,1)/size(Theta, 2);
        Theta_star(2,1) = Theta_star(2,1)/size(Theta, 2);
        
        C(:,k) = Theta_star(:,1);
        C2(:,k) = Tau(:,1);
        
%         clear Tau Theta Theta_star 
    end
    canopy_centr = C;
%     C
    canopy_centr_node = C2;
%     C2
    fprintf('[Canopy] number of canopies = %d.\n',k);
end