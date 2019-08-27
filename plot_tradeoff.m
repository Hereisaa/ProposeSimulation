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

for k =1:1
    figure
    
    x = 1:11; 	
    y =[70   ;
        88   ;
        126  ;
        218  ;
        422  ;
        725  ;
        897  ;
        889  ;
        884  ;
        873  ;
        870  ;];
%     y =[70 1024 ;
%         88 1027 ;
%         126 1023 ;
%         218 1012 ;
%         422 997 ;
%         725 980 ;
%         897 982 ;
%         889 981 ;
%         884 980 ;
%         873 974;
%         870 972;];
    b = bar(x, y, 0.5,'FaceAlpha',.8);  	
    
    hT = [];
    for i = 1:length(x)
%         text(x(i)-0.15,y(i,1)+5,num2str(y(i,1)),'HorizontalAlignment','center', 'VerticalAlignment','bottom','FontSize',8);
%         text(x(i)+0.15,y(i,2)+5,num2str(y(i,2)),'HorizontalAlignment','center', 'VerticalAlignment','bottom','FontSize',8);
        text(x(i),y(i)+5,num2str(y(i)),'HorizontalAlignment','center', 'VerticalAlignment','bottom','FontSize',10);
    end

    
    set(b(:,1),'FaceColor',color6);
%     set(b(:,2),'FaceColor',color5);
    ylabel('Round','FontSize',15);
    xlabel('(\alpha,\beta)','FontSize',15);
    axis([0.5 11.5 0 1000]);  
%     legend({'FND','HND'},'FontSize',12,'Location','NorthWest');
    legend({'FND'},'FontSize',12,'Location','NorthWest');
    set(gca,'YGrid','on','GridLineStyle','-', 'xticklabel', {'(0,1)','(0.1,0.9)','(0.2,0.8)','(0.3,0.7)','(0.4,0.6)',...
        '(0.5,0.5)','(0.6,0.4)','(0.7,0.3)','(0.8,0.2)','(0.9,0.1)','(1,0)'});

    s=strcat(folder,'tradeoff');
    savefig(s);
    s=strcat(s,'.png');
    saveas(gcf,s);
end


