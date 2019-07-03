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

%  Auto-generated by MATLAB on 31-Jan-2013 18:49:05

% % Create figure
% figure1 = figure(2);
% 
% %%%%%% Sum of energy of nodes vs. round
% % Create sub-plot
% subplot1 = subplot(1,3,3,'Parent',figure1);
% box(subplot1,'on');
% hold(subplot1,'all');

figure
grid on
box on 

% Create plot
p = plot(X1,A1,X2,A2,'LineWidth',2);
p(1).Color=[0 0 1]; p(2).Color=[0 0 0];

% Create x-label
xlabel('Round','FontWeight','bold','FontSize',11,'FontName','Cambria');

% Create y-label
ylabel('sum of energy','FontWeight','bold','FontSize',11,...
    'FontName','Cambria');

% Create title
title('Sum of energy of nodes vs. round','FontWeight','bold','FontSize',12,...
    'FontName','Cambria');


% %%%%%% Number of dead node vs. round
% % Create sub-plot
% subplot2 = subplot(1,3,1,'Parent',figure1);
% box(subplot2,'on');
% hold(subplot2,'all');

figure
grid on
box on 
% Create plot
p = plot(X1,B1,X2,B2,'LineWidth',2);
p(1).Color=[0 0 1]; p(2).Color=[0 0 0];

% Create x-label
xlabel('Round','FontWeight','bold','FontSize',11,'FontName','Cambria');

% Create y-label
ylabel('# of dead nodes','FontWeight','bold','FontSize',11,...
    'FontName','Cambria');

% Create title
title('Number of dead node vs. round','FontWeight','bold','FontSize',12,...
    'FontName','Cambria');


% %%%%%% Number of packet sent to BS vs. round
% % Create sub-plot
% subplot3 = subplot(1,3,2,'Parent',figure1);
% box(subplot3,'on');
% hold(subplot3,'all');
figure
grid on
box on 
% Create plot
p = plot(X1,C1,X2,C2,'LineWidth',2);
p(1).Color=[0 0 1]; p(2).Color=[0 0 0];

% Create x-label
xlabel('Round','FontWeight','bold','FontSize',11,'FontName','Cambria');

% Create y-label
ylabel('# of packets sent to BS nodes','FontWeight','bold','FontSize',11,...
    'FontName','Cambria');

% Create title
title('Number of packet sent to BS vs. round','FontWeight','bold',...
    'FontSize',12,...
    'FontName','Cambria');






