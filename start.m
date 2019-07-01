%% MAIN
clc, clear all, close all
%% PARAMETER
numNodes   = 300;  % number of nodes
Length     = 500;  % network length
Width      = 500;  % network width
d0       = 87;  % tx distance threshold
sinkX    = Length / 2;
sinkY    = Width / 2;
initEnergy  = 0.5;
transEnergy = 50*0.000000001;
recEnergy   = 50*0.000000001;
fsEnergy    = 10*0.000000000001;
mpEnergy    = 0.0013*0.000000000001;
aggrEnergy  = 5*0.000000001;
packetLength    = 6400;
ctrPacketLength = 200;
r       = 99999;


netArch       = newNetwork(Length, Width, sinkX, sinkY, initEnergy, transEnergy, recEnergy, fsEnergy, mpEnergy, aggrEnergy);
roundArch     = newRound(r, packetLength, ctrPacketLength);
init_nodeArch = newNodes(netArch, numNodes);

%% PROPOSED ROUND LOOP
p_clusterModel.nodeArch   = init_nodeArch; % node's arch for Proposed
p_clusterModel.clusterFun = 'proposed';
p_clusterModel.nodeArch.init_numNodes = numNodes;
recluster    = true;
T1 = 100;
T2 = 87;

FND = 1; HND = 1; LND = 1;
% par = struct;
for r = 1:roundArch.numRound  
    Temp_xy = [];
    Temp_index = [];
    notLayerZero = 0;
    cluster = [];
    centr = [];
    centr_node = [];
    % first time or recluster
    if recluster == true
        p_clusterModel.numCluster = 0;

        p_clusterModel.clusterNode.no = [];
        p_clusterModel.clusterNode.CID = [];
        p_clusterModel.clusterNode.loc = [];
        p_clusterModel.clusterNode.distance = [];   
        p_clusterModel.clusterNode.countCHs = 0;

        locAlive = find(~p_clusterModel.nodeArch.dead); % alive node's index
        % reset
        for i = locAlive
            p_clusterModel.nodeArch.node(i).type    = 'N';                
            p_clusterModel.nodeArch.node(i).parent  = [];
            p_clusterModel.nodeArch.node(i).CID     = [];
            p_clusterModel.nodeArch.node(i).child   = 0;
        end
        %%% Network Dimension Phase
        [ p_clusterModel, Temp_xy, Temp_index, notLayerZero ] = NetworkDimension( p_clusterModel, d0, netArch );
        if ~isempty(Temp_xy)
            %%% Clustering Phase
            [ p_clusterModel, noOfk, cluster, centr ] = Clustering( p_clusterModel, notLayerZero, Temp_xy, Temp_index, T1, T2 );
            %%% CH & RN Selection Phase
            [ p_clusterModel ] = CHRNselection( p_clusterModel, locAlive, noOfk, centr, netArch );
            % centr_node -> plot_kmeans
        end
        recluster = false;
    end
    
    %%% Transmission Phase
    p_clusterModel = dissEnergyCM(p_clusterModel, roundArch, netArch);
    p_clusterModel = dissEnergyCH(p_clusterModel, roundArch, netArch);
    %%% Checking if there is a new dead node
    locAlive = find(~p_clusterModel.nodeArch.dead); % alive node's index
    numAlive = length(locAlive);
    
    % avgEnergy
    avgEnergy = 0;
    for i = locAlive
        avgEnergy = avgEnergy + p_clusterModel.nodeArch.node(i).energy;
    end
    avgEnergy = avgEnergy / length(locAlive);
    
    for i = locAlive
        if p_clusterModel.nodeArch.node(i).energy <= 0
            p_clusterModel.nodeArch.node(i).type = 'D';
            p_clusterModel.nodeArch.dead(i) = 1;
            p_clusterModel.nodeArch.node(i).parent = []; 
            p_clusterModel.nodeArch.node(i).CID = []; 
            p_clusterModel.nodeArch.node(i).child = 0; 
            
            recluster = true; % have to exec new clustering phase 
%         elseif p_clusterModel.nodeArch.node(i).energy < avgEnergy &&... % If CH.energy < avgEnergy, recluster.
%                p_clusterModel.nodeArch.node(i).type == 'C'
%            
%             recluster = true;% have to exec new clustering phase 
        end
    end
    
    p_clusterModel.nodeArch.numDead = sum(p_clusterModel.nodeArch.dead);
    p_clusterModel.nodeArch.numNode = numAlive; % number of Alive nodes
    p_clusterModel.nodeArch.avgEnergy = avgEnergy; % averagy
    
    %%% statistics
%     par = plotResults(p_clusterModel, round, par);
    

    %%% FND and HND and LND 
    if p_clusterModel.nodeArch.numDead > 0 && FND
        fprintf('[Proposed] ***FND*** round = %d.\n', r);
%         for i = 1:init_nodeArch.numNode
%             if ( p_clusterModel.nodeArch.node(i).type == 'D' )  
%                 fprintf('DEAD loc = [ %f, %f ].\nid = %d\ntype = %s\n', p_clusterModel.nodeArch.node(i).x, p_clusterModel.nodeArch.node(i).y,...
%                         i, p_clusterModel.nodeArch.node(i).type);
%             end
%         end
%         break;
        FND = 0;
    end
    if (p_clusterModel.nodeArch.numDead >= (init_nodeArch.numNode / 2)) && HND
        fprintf('[Proposed] ***HND*** round = %d.\n', r);
        HND = 0;
    end
    if (p_clusterModel.nodeArch.numDead == init_nodeArch.numNode) && LND
        fprintf('[Proposed] ***LND*** round = %d.\n', r);
        AND = 0;
        break
    end
    
end% for

plot_kmeans





%% LEACH ROUND LOOP
clusterModel.nodeArch   = init_nodeArch; % node's arch for LEACH
numAliveNode = numNodes;
p   = 0.1; % ratio of number of CH (default)
FND = 1; HND = 1; LND = 1;

par = struct;

for r = 1:roundArch.numRound
    %%% Clustering Phase
    clusterModel = newCluster(netArch, clusterModel.nodeArch, 'leach', r, p);
%     fprintf('[LEACH] number of CH  = %d\n',clusterModel.numCluster);

    %%% Transmission Phase
    clusterModel = dissEnergyCM(clusterModel, roundArch, netArch);
    clusterModel = dissEnergyCH(clusterModel, roundArch, netArch);

%     par = plotResults(clusterModel, r, par, netArch);
    
    %%% FND and HND and LND 
    if (clusterModel.nodeArch.numDead >= 1) && FND % FND
        fprintf('[LEACH] ***FND*** round = %d.\n', r);
        FND = 0;
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

plot_leach


