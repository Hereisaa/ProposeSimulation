function createfigure(X1, X2, A1, A2, B1, B2, C1, C2)
%CREATEFIGURE(X1,Y1,Y2,Y3)
%  X1:  vector of x data - round (proposed)
%  X2:  vector of x data - round (leach)
%  A1:  vector of y data - energy (proposed)
%  A2:  vector of y data - energy (leach)
%  B1:  vector of y data - dead (proposed)
%  B2:  vector of y data - dead (leach)
%  C1:  vector of y data - packetToBS (proposed)
%  C2:  vector of y data - packetToBS (leach)

%%%%%% Sum of energy of nodes vs. round
figure
% Create plot
p = plot(X1,A1,X2,A2,'LineWidth',1);
p(1).Color=[0 0 1]; p(2).Color=[0 0 0];

% Create x-label y-label
xlabel('Round','FontWeight','bold','FontSize',11,'FontName','Cambria');
ylabel('sum of energy','FontWeight','bold','FontSize',11,'FontName','Cambria');

% Create title
title('Sum of energy of nodes','FontWeight','bold',...
    'FontSize',12,...
    'FontName','Cambria');

grid on
box on

%%%%%% Number of dead node vs. round
figure
% Create plot
p = plot(X1,B1,X2,B2,'LineWidth',1);
p(1).Color=[0 0 1]; p(2).Color=[0 0 0];

% Create x-label y-label
xlabel('Round','FontWeight','bold','FontSize',11,'FontName','Cambria');
ylabel('# of dead nodes','FontWeight','bold','FontSize',11,'FontName','Cambria');

% Create title
title('Number of dead node','FontWeight','bold',...
    'FontSize',12,...
    'FontName','Cambria');

grid on
box on


%%%%%% Number of packet sent to BS vs. round
figure
% Create plot
p = plot(X1,C1,X2,C2,'LineWidth',1);
p(1).Color=[0 0 1]; p(2).Color=[0 0 0];

% Create x-label y-label
xlabel('Round','FontWeight','bold','FontSize',11,'FontName','Cambria');
ylabel('# of packets sent to BS nodes','FontWeight','bold','FontSize',11,'FontName','Cambria');

% Create title
title('Number of packet sent to BS','FontWeight','bold',...
    'FontSize',12,...
    'FontName','Cambria');

grid on
box on






