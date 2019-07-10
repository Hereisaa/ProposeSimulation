function par = plotResults(Model, r, par)
    nodeArch = Model.nodeArch;
    switch (Model.clusterFun)
         case {'proposed'}
            %%%%% Number of packets sent from CH RN to BS
            if r == 1
                par.packetToBS(r) = Model.clusterNode.countCHs;
            else
                par.packetToBS(r) = par.packetToBS(r-1) + Model.clusterNode.countCHs + Model.relayNode.countRNs;
            end
            
            %%%%% Number of dead node
            par.numDead(r) = nodeArch.numDead;
            
            %%%%% Number of alive node
            par.numAlive(r) = nodeArch.numAlive;
            
            %%%%% Number of alive node
            par.numAlive(r) = nodeArch.init_numNodes - nodeArch.numDead;
            
            %%%%% Residual energy
            par.energy(r) = 0;
            node = Model.nodeArch;
            for i = find(~node.dead)
                if node.node(i).energy > 0
                    par.energy(r) = par.energy(r) + node.node(i).energy;
                end
            end
%             par.energy(r) = par.energy(r) / nodeArch.numNode;

            %%%%% Sum of Energy consumption
%             par.consumption(r) = 0;
%             node = Model.nodeArch;
%             for i = find(~node.dead)
%                 if node.node(i).energy > 0
%                     par.energy(r) = par.energy(r) + node.node(i).energy;
%                 end
%             end
            
            
            %%%%% Energy efficiency
            
            %%%%% Packet delivery ratio
            


        case {'leach'}
            %%%%% number of packets sent from CHs to BS
            if r == 1
                par.packetToBS(r) = Model.clusterNode.countCHs;
            else
                par.packetToBS(r) = par.packetToBS(r-1) + Model.clusterNode.countCHs;
            end
            %%%%% Number of dead neurons
            par.numDead(r) = nodeArch.numDead;
            
            %%%%% Number of alive node
            par.numAlive(r) = nodeArch.numAlive;
            
            %%%%% Residual Energy
            par.energy(r) = 0;
            node = Model.nodeArch;
            for i = find(~node.dead)
                if node.node(i).energy > 0
                    par.energy(r) = par.energy(r) + node.node(i).energy;
                end
            end
%             par.energy(r) = par.energy(r) / nodeArch.numNode;

        case {'hhca'}
            %%%%% number of packets sent from CHs to BS
            if r == 1
                par.packetToBS(r) = Model.clusterNode.countCHs;
            else
                par.packetToBS(r) = par.packetToBS(r-1) + Model.clusterNode.countCHs;
            end
            %%%%% Number of dead nodes
            par.numDead(r) = nodeArch.numDead;
            
            %%%%% Number of alive node
            par.numAlive(r) = nodeArch.numAlive;
            
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
