folder = 'result\';

%%%%%%%%%%%%%%%%%% FND vs. TH/dth trade-off %%%%%%%%%%%%%%%%%%
for k =1:1
    x_0 = 10:10:90;
    y_0 = 20:10:90;
    [xx_0,yy_0] = meshgrid(x_0,y_0); 
    
    z_0=[tradeOff_FND(2,1) tradeOff_FND(2,2) tradeOff_FND(2,3) tradeOff_FND(2,4) tradeOff_FND(2,5) tradeOff_FND(2,6) tradeOff_FND(2,7) tradeOff_FND(2,8) tradeOff_FND(2,9) ;
         tradeOff_FND(3,1) tradeOff_FND(3,2) tradeOff_FND(3,3) tradeOff_FND(3,4) tradeOff_FND(3,5) tradeOff_FND(3,6) tradeOff_FND(3,7) tradeOff_FND(3,8) tradeOff_FND(3,9) ;
         tradeOff_FND(4,1) tradeOff_FND(4,2) tradeOff_FND(4,3) tradeOff_FND(4,4) tradeOff_FND(4,5) tradeOff_FND(4,6) tradeOff_FND(4,7) tradeOff_FND(4,8) tradeOff_FND(4,9) ;
         tradeOff_FND(5,1) tradeOff_FND(5,2) tradeOff_FND(5,3) tradeOff_FND(5,4) tradeOff_FND(5,5) tradeOff_FND(5,6) tradeOff_FND(5,7) tradeOff_FND(5,8) tradeOff_FND(5,9) ;
         tradeOff_FND(6,1) tradeOff_FND(6,2) tradeOff_FND(6,3) tradeOff_FND(6,4) tradeOff_FND(6,5) tradeOff_FND(6,6) tradeOff_FND(6,7) tradeOff_FND(6,8) tradeOff_FND(6,9) ;
         tradeOff_FND(7,1) tradeOff_FND(7,2) tradeOff_FND(7,3) tradeOff_FND(7,4) tradeOff_FND(7,5) tradeOff_FND(7,6) tradeOff_FND(7,7) tradeOff_FND(7,8) tradeOff_FND(7,9) ;
         tradeOff_FND(8,1) tradeOff_FND(8,2) tradeOff_FND(8,3) tradeOff_FND(8,4) tradeOff_FND(8,5) tradeOff_FND(8,6) tradeOff_FND(8,7) tradeOff_FND(8,8) tradeOff_FND(8,9) ;
         tradeOff_FND(9,1) tradeOff_FND(9,2) tradeOff_FND(9,3) tradeOff_FND(9,4) tradeOff_FND(9,5) tradeOff_FND(9,6) tradeOff_FND(9,7) tradeOff_FND(9,8) tradeOff_FND(9,9) ;];
     
    minFND = min(min(z_0));
    
    h1=meshz(xx_0,yy_0,z_0);
    colormap('cool');
    axis([10 90 20 90 0 800]);
    axis tight;
    set(gca,'xtick',[10:10:90]);
    set(gca,'ytick',[20:10:90]);
    set(gca,'ztick',[0:100:800]);
    set(gca,'fontsize',12,'FontName','Arial');
    set( h1 , 'linewidth' , 1 );   
    zlabel('FND','FontSize', 24);
    xlabel('$d_{th}$(m)','Interpreter','latex','FontSize', 24);	
    ylabel('$T\!H$(m)','Interpreter','latex','FontSize', 24);	

    rotate3d on

    s=strcat(folder,'TH_dth');
    savefig(s);
    s=strcat(s,'.png');
    saveas(gcf,s);
end


