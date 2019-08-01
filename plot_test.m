% % Number of nodes
% N=numNodes;
% % Initial Energy
% E=initEnergy;
% % Each method Last round a.k.a LND
% X1=p_clusterModel.LND;        
% X2=clusterModel.LND;       
% X3=h_clusterModel.LND;     
% X4=tl_clusterModel.LND;
% % Resisdual energy of each round
% proposedEnergy=par_proposed.energy;       
% leachEnergy=par_leach.energy;       
% hhcaEnergy=par_hhca.energy;        
% tlleachEnergy=par_TLleach.energy;
% % Number of alive nodes od each round
% proposedAlive=par_proposed.numAlive;     
% leachAlive=par_leach.numAlive;     
% hhcaAlive=par_hhca.numAlive;      
% tlleachAlive=par_TLleach.numAlive;
% % FND
% pFND=p_clusterModel.FND;        
% FND=clusterModel.FND;
% hFND=h_clusterModel.FND;
% tlFND=tl_clusterModel.FND;
% % HND
% pHND=p_clusterModel.HND;
% HND=clusterModel.HND;
% hHND=h_clusterModel.HND;  
% tlHND=tl_clusterModel.HND;
% % Througput
% packetToBS=par_proposed.packetToBS;    
% packetToBS2=par_leach.packetToBS;   
% packetToBS3=par_hhca.packetToBS;     
% packetToBS4=par_TLleach.packetToBS;
         
%CREATEFIGURE
color1 = '#118DF0'; color1 = sscanf(color1(2:end),'%2x%2x%2x',[1 3])/255; % light blue
color2 = '#20938b'; color2 = sscanf(color2(2:end),'%2x%2x%2x',[1 3])/255; % green
color3 = '#004182'; color3 = sscanf(color3(2:end),'%2x%2x%2x',[1 3])/255; % heavy blue
color4 = '#FF4B68'; color4 = sscanf(color4(2:end),'%2x%2x%2x',[1 3])/255; % red

color5 = '#fed95c'; color5 = sscanf(color5(2:end),'%2x%2x%2x',[1 3])/255; % yellow
color6 = '#7FB8DE'; color6 = sscanf(color6(2:end),'%2x%2x%2x',[1 3])/255; % blue
% color6 = '#4695d6'; color6 = sscanf(color6(2:end),'%2x%2x%2x',[1 3])/255; % blue

color7 = '#ffffff'; color7 = sscanf(color7(2:end),'%2x%2x%2x',[1 3])/255; % white
color8 = '#F5F5F5'; color8 = sscanf(color8(2:end),'%2x%2x%2x',[1 3])/255; % gray
color9 = '#0F0F0F'; color9 = sscanf(color9(2:end),'%2x%2x%2x',[1 3])/255; % black
color10 = '#969696'; color10 = sscanf(color10(2:end),'%2x%2x%2x',[1 3])/255; % heavy gray



folder = 'result\';



% %%%%%%%%%%%%%%%%%% Residual energy of WSN vs. round %%%%%%%%%%%%%%%%%%
% for k=1:1
%     figure
%     hold on
%     xr = ceil(X1/200)*200+200;
%     Y1 = zeros(1,xr+1);
%     Y2 = zeros(1,xr+1);
%     Y3 = zeros(1,xr+1);
%     Y4 = zeros(1,xr+1);
%     Y1(1:X1) = proposedEnergy(1:X1);
%     Y2(1:X2) = leachEnergy(1:X2);
%     Y3(1:X3) = hhcaEnergy(1:X3);
%     Y4(1:X4) = tlleachEnergy(1:X4);
% %     X = 1:100:xr+1;
%     X = 0:100:xr;
%     Z = 1:100:xr+1;
%     p = plot(X,Y2(Z),'-s',...
%              X,Y4(Z),'-d',...
%              X,Y1(Z),'-o',...
%              X,Y3(Z),'-*');
%              
%     p(1).LineWidth =1; p(1).MarkerSize=9; p(1).Color=color9; p(1).MarkerFaceColor=color10;
%     p(2).LineWidth =1; p(2).MarkerSize=9; p(2).Color=color9; p(2).MarkerFaceColor=color8;
%     p(3).LineWidth =1; p(3).MarkerSize=9; p(3).Color=color9; p(3).MarkerFaceColor=color7;
%     p(4).LineWidth =1; p(4).MarkerSize=9; p(4).Color=color9; p(4).MarkerFaceColor=color8;
%     
%     axis([0,xr,0,N*E]);
%     set(gca,'XTick',[0:200:xr]);
%     set(gca,'YTick',[0:25:N*E]);
%     % Create x-label y-label
%     xlabel('Round','FontWeight','bold','FontSize',15);
%     ylabel('Residual energy of WSNs','FontWeight','bold','FontSize',15);
%     legend([p(1),p(2),p(4),p(3)],{'LEACH','TL-LEACH','HHCA','Proposed'},'FontSize',12,'Location','NorthEast');
%     % Create title
% %     title('300M �� 300M , 300 Nodes , 0.5J','FontWeight','bold',...
% %         'FontSize',12,...
% %         'FontName','Cambria');
%     grid on
%     box on
%     
%     s=strcat(folder,'Residual_energy_of_WSN');
%     savefig(s);
%     s=strcat(s,'.png');
%     saveas(gcf,s);
% end
% 
% %%%%%%%%%%%%%%%%%% FND HND vs. protocol %%%%%%%%%%%%%%%%%%
% for k =1:1
%     figure
%     x = 1:4; 	
%     y = [pFND pHND; hFND hHND; tlFND tlHND; FND HND];
%     b = bar(x, y, 1,'FaceAlpha',.8);  	
%     hT = [];
%     for i = 1:length(x)
%         text(x(i)-0.136,y(i,1)+5,num2str(y(i,1)),'HorizontalAlignment','center', 'VerticalAlignment','bottom');
%         text(x(i)+0.136,y(i,2)+5,num2str(y(i,2)),'HorizontalAlignment','center', 'VerticalAlignment','bottom');
%     end
%     set(b(:,1),'FaceColor',color6);
%     set(b(:,2),'FaceColor',color5);
%     ylabel('Round','FontWeight','bold','FontSize',15);
%     legend({'FND','HND'},'FontSize',12,'Location','NorthEast');
%     set(gca,'YGrid','on','GridLineStyle','-', 'xticklabel', {'PROPOSED','HHCA','TL-LEACH','LEACH'});
%     ylim([0 ceil(pHND/100)*100+100]);
%     
%     s=strcat(folder,'FND_HND');
%     savefig(s);
%     s=strcat(s,'.png');
%     saveas(gcf,s);
% end
% 
% 
% 
% %%%%%%%%%%%%%%%%%% Number of Alive Nodes  vs. round %%%%%%%%%%%%%%%%%%
% for k=1:1
%     figure
%     hold on;
%     xr = ceil(X1/200)*200+200;
% %     xr = 1200+200;
%     Y1 = zeros(1,xr+1);
%     Y2 = zeros(1,xr+1);
%     Y3 = zeros(1,xr+1);
%     Y4 = zeros(1,xr+1);
%     Y1(1:X1) = proposedAlive(1:X1);
%     Y2(1:X2) = leachAlive(1:X2);
%     Y3(1:X3) = hhcaAlive(1:X3);
%     Y4(1:X4) = tlleachAlive(1:X4);
%     
%     X = 0:100:xr;
%     Z = 1:100:xr+1;
%     p = plot(X,Y2(Z),'-s',...
%              X,Y4(Z),'-d',...
%              X,Y1(Z),'-o',...
%              X,Y3(Z),'-*');
%     p(1).LineWidth =1; p(1).MarkerSize=9; p(1).Color=color9; p(1).MarkerFaceColor=color10;
%     p(2).LineWidth =1; p(2).MarkerSize=9; p(2).Color=color9; p(2).MarkerFaceColor=color8;
%     p(3).LineWidth =1; p(3).MarkerSize=9; p(3).Color=color9; p(3).MarkerFaceColor=color7;
%     p(4).LineWidth =1; p(4).MarkerSize=9; p(4).Color=color9; p(4).MarkerFaceColor=color8;
%     axis([0,ceil(xr/200)*200,0,N]);
%     set(gca,'XTick',[0:200:ceil(xr/200)*200]);
%     set(gca,'YTick',[0:25:N]);
%     % Create x-label y-label
%     xlabel('Round','FontWeight','bold','FontSize',15);
%     ylabel('Number of alive nodes','FontWeight','bold','FontSize',15);
%     legend([p(1),p(2),p(4),p(3)],{'LEACH','TL-LEACH','HHCA','Proposed'},'FontSize',12,'Location','NorthEast');
%     % Create title
% %     title('300M �� 300M , 300 Nodes , 0.5J','FontWeight','bold',...
% %         'FontSize',12,...
% %         'FontName','Cambria');
% 
%     grid on
%     box on
%     
%     s=strcat(folder,'Number_of_alive_nodes');
%     savefig(s);
%     s=strcat(s,'.png');
%     saveas(gcf,s);
% end
% 
% 
% 
% 
% %%%%%%%%%%%%%%%%%% Throughput vs. round %%%%%%%%%%%%%%%%%%
% for k=1:1
%     figure
%     hold on;
%     xr = ceil(X1/200)*200+200;
% %     xr = 1200;
%     Y1 = zeros(1,xr+1);
%     Y2 = zeros(1,xr+1);
%     Y3 = zeros(1,xr+1);
%     Y4 = zeros(1,xr+1);
%     Y1(1:xr+1) = packetToBS(X1);
%     Y2(1:xr+1) = packetToBS2(X2);
%     Y3(1:xr+1) = packetToBS3(X3);
%     Y4(1:xr+1) = packetToBS4(X4);
%     Y1(1:X1) = packetToBS(1:X1); %proposed
%     Y2(1:X2) = packetToBS2(1:X2); %leach
%     Y3(1:X3) = packetToBS3(1:X3); %hhca
%     Y4(1:X4) = packetToBS4(1:X4); %tlleach
%     
%     maxTP = max([packetToBS(X1),packetToBS2(X2),packetToBS3(X3),packetToBS4(X4)]);
%     
%     X = 0:100:xr;
%     Z = 1:100:xr+1;
%     p = plot(X,Y2(Z),'-s',...
%              X,Y4(Z),'-d',...
%              X,Y1(Z),'-o',...
%              X,Y3(Z),'-*');
%     p(1).LineWidth =1; p(1).MarkerSize=9; p(1).Color=color9; p(1).MarkerFaceColor=color10;
%     p(2).LineWidth =1; p(2).MarkerSize=9; p(2).Color=color9; p(2).MarkerFaceColor=color8;
%     p(3).LineWidth =1; p(3).MarkerSize=9; p(3).Color=color9; p(3).MarkerFaceColor=color7;
%     p(4).LineWidth =1; p(4).MarkerSize=9; p(4).Color=color9; p(4).MarkerFaceColor=color8;
%     axis([0,xr,0,ceil(maxTP/(10^8))*(10^8)]);
%     set(gca,'XTick',[0:200:xr]);
%     set(gca,'YTick',[0:(10^8):ceil(maxTP/(10^8))*(10^8)]);
%     % Create x-label y-label
%     xlabel('Round','FontWeight','bold','FontSize',15);
%     ylabel('Throughput','FontWeight','bold','FontSize',15);
%     legend([p(1),p(2),p(4),p(3)],{'LEACH','TL-LEACH','HHCA','Proposed'},'FontSize',12,'Location','SouthEast');
%     % Create title
% %     title('300M �� 300M , 300 Nodes , 0.5J','FontWeight','bold',...
% %         'FontSize',12,...
% %         'FontName','Cambria');
%     grid on
%     box on
%     s=strcat(folder,'Throughput');
%     savefig(s);
%     s=strcat(s,'.png');
%     saveas(gcf,s);
% end
% 
% 
% %%%%%%%%%%%%%%%%%% Energy vs. Packets %%%%%%%%%%%%%%%%%%
% for k=1:1
%     figure
%     hold on;
%     % energy consumption
%     Y1 = N*E - zeros(1,xr+1);
%     Y2 = N*E - zeros(1,xr+1);
%     Y3 = N*E - zeros(1,xr+1);
%     Y4 = N*E - zeros(1,xr+1);
%     Y1(1:X1) = N*E - proposedEnergy(1:X1);
%     Y2(1:X2) = N*E - leachEnergy(1:X2);
%     Y3(1:X3) = N*E - hhcaEnergy(1:X3);
%     Y4(1:X4) = N*E - tlleachEnergy(1:X4);
%     % packets
%     P1(1:xr+1) = packetToBS(X1);
%     P2(1:xr+1) = packetToBS2(X2);
%     P3(1:xr+1) = packetToBS3(X3);
%     P4(1:xr+1) = packetToBS4(X4);
%     P1(1:X1) = packetToBS(1:X1);
%     P2(1:X2) = packetToBS2(1:X2);
%     P3(1:X3) = packetToBS3(1:X3);
%     P4(1:X4) = packetToBS4(1:X4);
% 
%     XY1=[];
%     for i =1:10
%         Temp = find(Y1 >= 15*i);
%         XY1 = [XY1,Temp(1)];
%     end
%     XY1 = [1,XY1];
%     
%     XY2=[];
%     for i =1:10
%         Temp = find(Y2 >= 15*i);
%         XY2 = [XY2,Temp(1)];
%     end
%     XY2 = [1,XY2];
%     
%     XY3=[];
%     for i =1:10
%         Temp = find(Y3 >= 15*i);
%         XY3 = [XY3,Temp(1)];
%     end
%     XY3 = [1,XY3];
%     
%     XY4=[];
%     for i =1:10
%         Temp = find(Y4 >= 15*i);
%         XY4 = [XY4,Temp(1)];
%     end
%     XY4 = [1,XY4];
% 
%     p = plot(Y2(XY2),P2(XY2),'-s',...
%              Y4(XY4),P4(XY4),'-d',...
%              Y1(XY1),P1(XY1),'-o',...
%              Y3(XY3),P3(XY3),'-*');
%          
%     p(1).LineWidth =1; p(1).MarkerSize=9; p(1).Color=color9; p(1).MarkerFaceColor=color10;
%     p(2).LineWidth =1; p(2).MarkerSize=9; p(2).Color=color9; p(2).MarkerFaceColor=color8;
%     p(3).LineWidth =1; p(3).MarkerSize=9; p(3).Color=color9; p(3).MarkerFaceColor=color7;
%     p(4).LineWidth =1; p(4).MarkerSize=9; p(4).Color=color9; p(4).MarkerFaceColor=color8;
% %     axis([0,N*E,0,300]);
%     set(gca,'XTick',[0:N*E/10:N*E]);
% %     set(gca,'YTick',[0:30:300]);
%     % Create x-label y-label
%     xlabel('Energy consumption (J)','FontWeight','bold','FontSize',15);
%     ylabel('Number of Received Data Packets','FontWeight','bold','FontSize',15);
%     legend([p(1),p(2),p(4),p(3)],{'LEACH','TL-LEACH','HHCA','Proposed'},'FontSize',12,'Location','NorthWest');
%     % Create title
% %     title('300M �� 300M , 300 Nodes , 0.5J','FontWeight','bold',...
% %         'FontSize',12,...
% %         'FontName','Cambria');
%     grid on
%     box on
%     s=strcat(folder,'EnergyVSPackets');
%     savefig(s);
%     s=strcat(s,'.png');
%     saveas(gcf,s);
% end
%     
%     
% %%%%%%%%%%%%%%%%%% Number of alive nodes vs. Number of Received Data Packets %%%%%%%%%%%%%%%%%%
% for k=1:1
%     figure
%     hold on;
% 
%     xr = ceil(X1/200)*200+200;
% %     xr = 1200+200;
%     Y1 = zeros(1,xr+1);
%     Y2 = zeros(1,xr+1);
%     Y3 = zeros(1,xr+1);
%     Y4 = zeros(1,xr+1);
%     Y1(1:X1) = proposedAlive(1:X1);
%     Y2(1:X2) = leachAlive(1:X2);
%     Y3(1:X3) = hhcaAlive(1:X3);
%     Y4(1:X4) = tlleachAlive(1:X4);
%     
%     Y1 = zeros(1,xr+1);
%     Y2 = zeros(1,xr+1);
%     Y3 = zeros(1,xr+1);
%     Y4 = zeros(1,xr+1);
%     P1(1:X1) = packetToBS(1:X1);
%     P2(1:X2) = packetToBS2(1:X2);
%     P3(1:X3) = packetToBS3(1:X3);
%     P4(1:X4) = packetToBS4(1:X4);
%     
%     X = 0:100:xr;
%     Z = 1:100:xr+1;
%     p = plot(X,Y2(Z),'-s',...
%              X,Y4(Z),'-d',...
%              X,Y1(Z),'-o',...
%              X,Y3(Z),'-*');
%     p(1).LineWidth =1; p(1).MarkerSize=9; p(1).Color=color9; p(1).MarkerFaceColor=color10;
%     p(2).LineWidth =1; p(2).MarkerSize=9; p(2).Color=color9; p(2).MarkerFaceColor=color8;
%     p(3).LineWidth =1; p(3).MarkerSize=9; p(3).Color=color9; p(3).MarkerFaceColor=color7;
%     p(4).LineWidth =1; p(4).MarkerSize=9; p(4).Color=color9; p(4).MarkerFaceColor=color8;
% %     axis([0,N*E,0,300]);
%     set(gca,'XTick',[0:N*E/10:N*E]);
% %     set(gca,'YTick',[0:30:300]);
%     % Create x-label y-label
%     xlabel('Energy consumption (J)','FontWeight','bold','FontSize',15);
%     ylabel('Number of Received Data Packets','FontWeight','bold','FontSize',15);
%     legend([p(1),p(2),p(4),p(3)],{'LEACH','TL-LEACH','HHCA','Proposed'},'FontSize',12,'Location','NorthWest');
%     % Create title
% %     title('300M �� 300M , 300 Nodes , 0.5J','FontWeight','bold',...
% %         'FontSize',12,...
% %         'FontName','Cambria');
%     grid on
%     box on
%     s=strcat(folder,'EnergyVSPackets');
%     savefig(s);
%     s=strcat(s,'.png');
%     saveas(gcf,s);
%     
% end
% 


%%%%%%%%%%%%%%%%%% FND vs. different energy %%%%%%%%%%%%%%%%%%
for k =1:1
    figure
    
    x = 1:4; 	
%     y = [p_FND_0p5J p_FND_1J p_FND_1p5J ;h_FND_0p5J h_FND_1J h_FND_1p5J ;tl_FND_0p5J tl_FND_1J tl_FND_1p5J ;l_FND_0p5J l_FND_1J l_FND_1p5J ;];
    y = [p_HND_0p5J p_HND_1J p_HND_1p5J ;h_HND_0p5J h_HND_1J h_HND_1p5J ;tl_HND_0p5J tl_HND_1J tl_HND_1p5J ;l_HND_0p5J l_HND_1J l_HND_1p5J ;];
    b = bar(x, y, 1,'FaceAlpha',.8);  	

%     ylim([0,1400]);
    ylim([0,ceil(p_HND_1p5J/100)*100+100]);
    
    hT = [];
    for i = 1:length(x)
        text(x(i)-0.21,y(i,1)+5,num2str(y(i,1)),'HorizontalAlignment','center', 'VerticalAlignment','bottom','FontSize',8);
        text(x(i),y(i,2)+5,num2str(y(i,2)),'HorizontalAlignment','center', 'VerticalAlignment','bottom','FontSize',8);
        text(x(i)+0.215,y(i,3)+5,num2str(y(i,3)),'HorizontalAlignment','center', 'VerticalAlignment','bottom','FontSize',8);
    end
    
    set(b(:,1),'FaceColor',color6);
    set(b(:,2),'FaceColor',color5);
    set(b(:,3),'FaceColor',color2);
    ylabel('Round','FontWeight','bold','FontSize',15);
    legend({'0.5J','1J','1.5J'},'FontSize',12,'Location','NorthEast');
    set(gca,'YGrid','on','GridLineStyle','-', 'xticklabel', {'PROPOSED','HHCA','TL-LEACH','LEACH'});
    
    
    
    s=strcat(folder,'FND_energy');
    savefig(s);
    s=strcat(s,'.png');
    saveas(gcf,s);
end

