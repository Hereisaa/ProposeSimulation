%CREATEFIGURE
color1 = '#118DF0'; color1 = sscanf(color1(2:end),'%2x%2x%2x',[1 3])/255; % light blue
color2 = '#78c0a8'; color2 = sscanf(color2(2:end),'%2x%2x%2x',[1 3])/255; % green
color3 = '#004182'; color3 = sscanf(color3(2:end),'%2x%2x%2x',[1 3])/255; % heavy blue
color4 = '#FF4B68'; color4 = sscanf(color4(2:end),'%2x%2x%2x',[1 3])/255; % red

% color5 = '#fcebb6'; color5 = sscanf(color5(2:end),'%2x%2x%2x',[1 3])/255; % yellow
% color6 = '#7FB8DE'; color6 = sscanf(color6(2:end),'%2x%2x%2x',[1 3])/255; % blue
% color6 = '#4695d6'; color6 = sscanf(color6(2:end),'%2x%2x%2x',[1 3])/255; % blue

color5 = '#fcebb6'; color5 = sscanf(color5(2:end),'%2x%2x%2x',[1 3])/255; % yellow
color6 = '#7FB8DE'; color6 = sscanf(color6(2:end),'%2x%2x%2x',[1 3])/255; % blue
% color6 = '#4695d6'; color6 = sscanf(color6(2:end),'%2x%2x%2x',[1 3])/255; % blue

color7 = '#ffffff'; color7 = sscanf(color7(2:end),'%2x%2x%2x',[1 3])/255; % white
color8 = '#F5F5F5'; color8 = sscanf(color8(2:end),'%2x%2x%2x',[1 3])/255; % gray
color9 = '#0F0F0F'; color9 = sscanf(color9(2:end),'%2x%2x%2x',[1 3])/255; % black
color10 = '#969696'; color10 = sscanf(color10(2:end),'%2x%2x%2x',[1 3])/255; % heavy gray

p1_Color=color9; p1_MarkerFaceColor=color10;
p2_Color=color9; p2_MarkerFaceColor=color8;
p3_Color=color9; p3_MarkerFaceColor=color7;
p4_Color=color9; p4_MarkerFaceColor=color8;

folder = 'result\';
%%%%%%%%%%%%%%%%%% FND vs. different energy %%%%%%%%%%%%%%%%%%
for k =1:1
    figure
    
    x = 1:4; 	
%     y = [p_FND_05J p_FND_1J p_FND_15J ;h_FND_05J h_FND_1J h_FND_15J ;tl_FND_05J tl_FND_1J tl_FND_15J ;l_FND_05J l_FND_1J l_FND_15J ;];
    y = [p_HND_05J p_HND_1J p_HND_15J ;h_HND_05J h_HND_1J h_HND_15J ;tl_HND_05J tl_HND_1J tl_HND_15J ;l_HND_05J l_HND_1J l_HND_15J ;];
    b = bar(x, y, 1,'FaceAlpha',.8);  	

%     ylim([0,1400]);
    ylim([0,3500]);
    
    hT = [];
    for i = 1:length(x)
        text(x(i)-0.215,y(i,1)+5,num2str(y(i,1)),'HorizontalAlignment','center', 'VerticalAlignment','bottom','FontSize',8);
        text(x(i),y(i,2)+5,num2str(y(i,2)),'HorizontalAlignment','center', 'VerticalAlignment','bottom','FontSize',8);
        text(x(i)+0.215,y(i,3)+5,num2str(y(i,3)),'HorizontalAlignment','center', 'VerticalAlignment','bottom','FontSize',8);
    end
    
    set(b(:,1),'FaceColor',color6);
    set(b(:,2),'FaceColor',color5);
    set(b(:,3),'FaceColor',color2);
    ylabel('Round','FontWeight','bold','FontSize',15);
    legend({'0.5J','1J','1.5J'},'FontSize',12,'Location','NorthEast');
    set(gca,'YGrid','on','GridLineStyle','-', 'xticklabel', {'PROPOSED','HHCA','TL-LEACH','LEACH'});
    
    
    
    s=strcat(folder,'HND_energy');
    savefig(s);
    s=strcat(s,'.png');
    saveas(gcf,s);
end


