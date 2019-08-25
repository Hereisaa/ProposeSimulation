function [ minCostid ] = Find_minCost_NextHop( Model, s, dth, E_th, delta )
    nodeArch = Model.nodeArch;
    netArch = Model.netArch;
    relayNode = Model.relayNode;
    d_th = dth;
    r = 1;
    R = [];
    RelayCost = [];
    toBS = calDistance(nodeArch.node(s).x, nodeArch.node(s).y, netArch.Sink.x, netArch.Sink.y);
    
    d0 = sqrt(netArch.Energy.freeSpace / netArch.Energy.multiPath);
    
    if isempty(relayNode.no)
        minCostid = 0; % to BS
        return
    end
    
    
    while (d_th < toBS)
        R = [];
        RelayCost = [];
        Rid = [];
        for j = relayNode.no
%             s
%             j
            if j == 0
                continue
            end

%             C_ij = calDistance(nodeArch.node(s).x, nodeArch.node(s).y, nodeArch.node(j).x, nodeArch.node(j).y);
            C_ij = calDistance(nodeArch.node(s).x, nodeArch.node(s).y, nodeArch.node(j).x, nodeArch.node(j).y);
            if C_ij < d_th
                R = [R, j];
            end
        end
        for j = R
            if E_th < nodeArch.node(j).energy 
                C_ij = calDistance(nodeArch.node(s).x, nodeArch.node(s).y, nodeArch.node(j).x, nodeArch.node(j).y);
                C_jBS = calDistance(nodeArch.node(j).x, nodeArch.node(j).y, netArch.Sink.x, netArch.Sink.y);
                C_iBS = calDistance(nodeArch.node(s).x, nodeArch.node(s).y, netArch.Sink.x, netArch.Sink.y);
                if C_ij >= d0
                    C_ij = (C_ij + delta)^4;
                else
                    C_ij = (C_ij + delta)^2;
                end
                if C_jBS >= d0
                    C_jBS = (C_jBS + delta)^4;
                else
                    C_jBS = (C_jBS + delta)^2;
                end
                if C_iBS >= d0
                    C_iBS = (C_iBS + delta)^4;
                else
                    C_iBS = (C_iBS + delta)^2;
                end

                if C_ij + C_jBS < C_iBS
                    Rid = [Rid, j];
                    RelayCost = [RelayCost, (C_ij + C_jBS)];
                end
            end
        end
        if ~isempty(Rid)
            minCost = inf;
            mid = [];
            for j = 1:length(Rid)
                if RelayCost(j) < minCost
                    minCost =  RelayCost(j);
                    mid = Rid(j);
                end
            end
            minCostid = mid;
            return
        else
            r = r + 1;
            d_th = dth * r;
        end
    end
    minCostid = 0;
    return
end


