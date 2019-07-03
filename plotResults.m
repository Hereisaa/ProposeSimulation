function par = plotResults(Model, r, par)
    nodeArch = Model.nodeArch;
    switch (Model.clusterFun)
        case {'leach'}
            %%%%% number of packets sent from CHs to BS
            if r == 1
                par.packetToBS(r) = Model.clusterNode.countCHs;
            else
                par.packetToBS(r) = par.packetToBS(r-1) + Model.clusterNode.countCHs;
            end
            %%%%% Number of dead neurons
            par.numDead(r) = nodeArch.numDead;
            %%%%% Energy
            par.energy(r) = 0;
            node = Model.nodeArch;
            for i = find(~node.dead)
                if node.node(i).energy > 0
                    par.energy(r) = par.energy(r) + node.node(i).energy;
                end
            end
%             par.energy(r) = par.energy(r) / nodeArch.numNode;
            
        case {'proposed'}
            %%%%% number of packets sent from CHs to BS
            if r == 1
                par.packetToBS(r) = Model.clusterNode.countCHs;
            else
                par.packetToBS(r) = par.packetToBS(r-1) + Model.clusterNode.countCHs;
            end
            %%%%% Number of dead neurons
            par.numDead(r) = nodeArch.numDead;
            %%%%% Energy
            par.energy(r) = 0;
            node = Model.nodeArch;
            for i = find(~node.dead)
                if node.node(i).energy > 0
                    par.energy(r) = par.energy(r) + node.node(i).energy;
                end
            end
%             par.energy(r) = par.energy(r) / nodeArch.numNode;
    end

    
%     createfigure(1:r, par.energy, par.packetToBS, par.numDead);
end
