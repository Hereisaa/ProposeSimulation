function NetArch = newNetwork(Length, Width, sinkX, sinkY, initEnergy...
    , transEnergy, recEnergy, fsEnergy, mpEnergy, aggrEnergy)
% Create the network architecture with desired parameters
%   Input:
%       Length      Length of the yard
%       Width       Width of the yard
%       sinkX       x coordination of base station
%       sinkY       y coordination of base station
%       initEnergy  Initial energy of each node
%       transEnergy Energy for transferring of each bit
%       recEnergy   Energy for receiving of each bit
%       fsEnergy    Energy of free space model
%       mpEnergy    Energy of multi path model
%       aggrEnergy  Data aggregation energy     


    %%%% Create the yard
    Yard.Type = 'Rect'; % Rectangular
    if ~exist('Length','var')
        Yard.Length = 300; % default of the yard is 100 in x coordination
    else
        Yard.Length = Length;
    end
    if ~exist('Width','var')
        Yard.Width = 300; % default of the yard is 100 in y coordination
    else
        Yard.Width = Width;
    end
    
    %%%% Create base station
    % x and y Coordinates of the base station
    % default of the base station is in the centre of the yard
    if ~exist('sinkX','var')
        Sink.x = Yard.Length / 2;
    else
        Sink.x = sinkX;
    end
    if ~exist('sinkY','var')
        Sink.y = Yard.Width + 50;
    else
        Sink.y = sinkY;
    end

    %%%% Energy Model (all values in Joules)
    % Initial Energy
    if ~exist('initEnergy','var')
        Energy.init = 0.5; 
    else
        Energy.init = initEnergy; 
    end
    
    % Energy for transferring of each bit (ETX)
    if ~exist('transEnergy','var')
        Energy.transfer = 50*0.000000001;
    else
        Energy.transfer = transEnergy; 
    end
    if ~exist('recEnergy','var')
        Energy.receive = 50*0.000000001;
    else
        Energy.receive = recEnergy; 
    end
    
    % Transmit Amplifier types
    if ~exist('fsEnergy','var')
        Energy.freeSpace = 10*0.000000000001;
    else
        Energy.freeSpace = fsEnergy; 
    end
    if ~exist('mpEnergy','var')
        Energy.multiPath = 0.0013*0.000000000001;
    else
        Energy.multiPath = mpEnergy; 
    end
    
    %Data Aggregation Energy
    if ~exist('aggrEnergy','var')
        Energy.aggr = 5*0.000000001;
    else
        Energy.aggr = aggrEnergy; 
    end

    NetArch = struct('Yard',   Yard, ...
                     'Sink',   Sink, ...
                     'Energy', Energy);
end