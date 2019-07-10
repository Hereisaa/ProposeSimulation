% PLOT THE LEACH DEPLOYMENT
%%
figure, hold on
% grid on

%% Color para
% Convert color code to 1-by-3 RGB array (0~1 each) [must do this way, if MATLAB version is R2018b or older]
color1 = '#00FFFF'; color1 = sscanf(color1(2:end),'%2x%2x%2x',[1 3])/255;

%% Sensors
for i = 1:init_nodeArch.numNode
    plot(init_nodeArch.nodesLoc(i, 1), init_nodeArch.nodesLoc(i, 2),'Color', 'k','Marker','o', 'MarkerSize',2);
end

%% BS
plot(netArch.Sink.x, netArch.Sink.y,'o', ...
    'MarkerSize',8, 'MarkerFaceColor', 'g');

% hold off

s=strcat('result\','Network_300x300_300n');
savefig(s);
s=strcat(s,'.png');
saveas(gcf,s);