%CREATEFIGURE
color1 = '#fcebb6'; color1 = sscanf(color1(2:end),'%2x%2x%2x',[1 3])/255; % yellow
color2 = '#7FB8DE'; color2 = sscanf(color2(2:end),'%2x%2x%2x',[1 3])/255; % blue

folder = 'result\';

for k =1:1
    figure
    
    x = 1:9; 	
    y =[p_FND_100 p_HND_100 ;
        p_FND_200 p_HND_200 ;
        p_FND_300 p_HND_300 ;
        p_FND_400 p_HND_400 ;
        p_FND_500 p_HND_500 ;
        p_FND_600 p_HND_600 ;
        p_FND_700 p_HND_700 ;
        p_FND_800 p_HND_800 ;
        p_FND_900 p_HND_900 ;];
    b = bar(categorical(x), y, 1,'FaceAlpha',.8); 
    
    hT = [];
    for i = 1:length(x)
        text(x(i)-0.15,y(i,1)+5,num2str(y(i,1)),'HorizontalAlignment','center', 'VerticalAlignment','bottom','FontSize',8);
        text(x(i)+0.15,y(i,2)+5,num2str(y(i,2)),'HorizontalAlignment','center', 'VerticalAlignment','bottom','FontSize',8);
    end
    
    set(b(:,1),'FaceColor',color2);
    set(b(:,2),'FaceColor',color1);
    ylabel('Round','FontSize',15);
    xlabel('Number of Nodes','FontSize',15);
    axis([0.5 9.5 0 1200]);  
    legend({'FND','HND'},'FontSize',12,'Location','NorthWest');
    set(gca,'YGrid','on','GridLineStyle','-', 'xticklabel', {'100','200','300','400','500','600','700','800','900'});

    s=strcat(folder,'NoNodes_energy');
    savefig(s);
    s=strcat(s,'.png');
    saveas(gcf,s);
end


