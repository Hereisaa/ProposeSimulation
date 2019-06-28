%% Main
clc, clear all, close all
%% Parameter
numNodes   = 100;  % number of nodes
Length     = 300;  % network length
Width      = 300;  % network width
sinkX    = Length / 2;
sinkY    = Width / 2;
initEnergy  = 0.5;
transEnergy = 50*0.000000001;
recEnergy   = 50*0.000000001;
fsEnergy    = 10*0.000000000001;
mpEnergy    = 0.0013*0.000000000001;
aggrEnergy  = 5*0.000000001;
r       = 99999;
packetLength    = 6400;
ctrPacketLength = 200;
d0       = 87;  % tx distance threshold

netArch       = newNetwork(Length, Width, sinkX, sinkY, initEnergy, transEnergy, recEnergy, fsEnergy, mpEnergy, aggrEnergy);
roundArch     = newRound(r, packetLength, ctrPacketLength);
init_nodeArch = newNodes(netArch, numNodes);

%% PROPOSED ROUND LOOP
p_clusterModel.nodeArch   = init_nodeArch; % node's arch for Proposed
p_clusterModel.clusterFun = 'proposed';
numAliveNode = numNodes;
recluster    = true;
T1 = 100;
T2 = 87;

% par = struct;
for r = 1:roundArch.numRound    
    
    if recluster == true
        % reset
        locAlive = find(~p_clusterModel.nodeArch.dead); % alive node's index
        for i = locAlive
            p_clusterModel.nodeArch.node(i).type = 'N';                
            p_clusterModel.nodeArch.node(i).parent = [];
            p_clusterModel.nodeArch.node(i).CID = [];
            p_clusterModel.nodeArch.node(i).child = 0;
        end
        %%% Network Dimension Phase
        [ p_clusterModel, Temp_xy, Temp_index, notLayerZero ] = NetworkDimension( p_clusterModel, d0, netArch );
        %%% Clustering Phase
        [ p_clusterModel, noOfk, centr ] = Clustering( p_clusterModel, notLayerZero, Temp_xy, Temp_index, T1, T2 );
        %%% CH & RN Selection Phase
        [ p_clusterModel, centr_node ] = CHRNselection( p_clusterModel, locAlive, noOfk, centr, netArch );
        
        recluster = false;
    end
    
    %%% Transmission Phase
    p_clusterModel = dissEnergyNonCH(p_clusterModel, roundArch, netArch);
    p_clusterModel = dissEnergyCH(p_clusterModel, roundArch, netArch);
    %%% Checking if there is a new dead node
    locAlive = find(~p_clusterModel.nodeArch.dead); % alive node's index
    numAliveNode = length(locAlive);
    for i = locAlive
        if p_clusterModel.nodeArch.node(i).energy <= 0
            p_clusterModel.nodeArch.node(i).type = 'D';
            p_clusterModel.nodeArch.dead(i) = 1;
            p_clusterModel.nodeArch.node(i).parent = []; 
            p_clusterModel.nodeArch.node(i).CID = []; 
            p_clusterModel.nodeArch.node(i).child = 0; 
            
            recluster = true; % have to exec new clustering phase
        end
    end
    p_clusterModel.nodeArch.numDead = sum(p_clusterModel.nodeArch.dead);
    
    %%% statistics
%     par = plotResults(p_clusterModel, round, par);
    

    %%% FND and HND and LND 
    if p_clusterModel.nodeArch.numDead > 0 % nodeArch.numNode
        fprintf('[Proposed (without rotation)] ***FND*** round = %d.\n', r);
        for i = 1:init_nodeArch.numNode
            if ( p_clusterModel.nodeArch.node(i).type == 'D' )  
                fprintf('DEAD loc = [ %f, %f ].\nid = %d\ntype = %s\n', p_clusterModel.nodeArch.node(i).x, p_clusterModel.nodeArch.node(i).y,...
                        i, p_clusterModel.nodeArch.node(i).type);
            end
        end
        break;
    end
end% for

plot_kmeans





%% LEACH ROUND LOOP
clusterModel.nodeArch   = init_nodeArch; % node's arch for LEACH
numAliveNode = numNodes;
p   = 0.1; % ratio of number of CH (default)
FND = 1; HND = 1; LND = 1;

% par = struct;

for r = 1:roundArch.numRound
    %%% Clustering Phase
    clusterModel = newCluster(netArch, clusterModel.nodeArch, 'leach', r, p);
%     fprintf('[LEACH] number of CH  = %d\n',clusterModel.numCluster);

    %%% Transmission Phase
    clusterModel = dissEnergyNonCH(clusterModel, roundArch, netArch);
    clusterModel = dissEnergyCH(clusterModel, roundArch, netArch);

%     par = plotResults(clusterModel, round, par, netArch);
    
    %%% FND and HND and LND 
    if (clusterModel.nodeArch.numDead >= 1) && FND % FND
        fprintf('[LEACH] ***FND*** round = %d.\n', r);
        FND = 0;
        break
    end
    if (clusterModel.nodeArch.numDead >= (init_nodeArch.numNode / 2)) && HND % HND
        fprintf('[LEACH] ***HND*** round = %d.\n', r);
        HND = 0;
    end
    if (clusterModel.nodeArch.numDead == init_nodeArch.numNode) && LND % LND
        fprintf('[LEACH] ***LND*** round = %d.\n', r);
        AND = 0;
        break
    end
end

% plot_leach


