function par = plotResults(Model, r, par, roundArch)
    nodeArch = Model.nodeArch;
    switch (Model.clusterFun)
         case {'proposed'}
            %%%%% Number of data sent from CH RN to BS   
            if r == 1
                par.packetToBS(r) = Model.nodeArch.numAlive * roundArch.packetLength;
            else
                par.packetToBS(r) = par.packetToBS(r-1) + Model.nodeArch.numAlive * roundArch.packetLength;
            end
            
            %%%%% Number of alive node [v]
            par.numAlive(r) = nodeArch.numAlive;

            %%%%% Residual energy [v]
            par.energy(r) = 0;
            node = Model.nodeArch;
            for i = find(~node.dead)
                if node.node(i).energy > 0
                    par.energy(r) = par.energy(r) + node.node(i).energy;
                end
            end

        case {'leach'}
            %%%%% Number of data sent to BS
            if r == 1
                par.packetToBS(r) = Model.nodeArch.numAlive * roundArch.packetLength;
            else
                par.packetToBS(r) = par.packetToBS(r-1) + Model.nodeArch.numAlive * roundArch.packetLength;
            end
            
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
            
            
        case {'TLleach'}
            %%%%% Number of data sent to BS
            if r == 1
                par.packetToBS(r) = Model.nodeArch.numAlive * roundArch.packetLength;
            else
                par.packetToBS(r) = par.packetToBS(r-1) + Model.nodeArch.numAlive * roundArch.packetLength;
            end
            
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

        case {'hhca'}
            %%%%% Number of data sent to BS
            if r == 1
                par.packetToBS(r) = Model.nodeArch.numAlive * roundArch.packetLength;
            else
                par.packetToBS(r) = par.packetToBS(r-1) + Model.nodeArch.numAlive * roundArch.packetLength;
            end
            
            
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
            
    end

    
%     createfigure(1:r, par.energy, par.packetToBS, par.numDead);
end
