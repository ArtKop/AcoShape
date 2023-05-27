function plotter(curPos,tarPos,cost,ID,step,maps)
    fontsize = 18;
    % plot the particle-target pairs and the ID's vector field
    [MX,MY] = meshgrid(0:1/21:1);
    if (ID <= 0) || (ID >= 60)
        x = zeros(22,22);
        y = zeros(22,22);
    else
        x = maps(ID).deltaX(MX,MY);
        y = maps(ID).deltaY(MX,MY);
    end
    quiver(MX,MY,x,y,'linewidth',1);
    set(gca,'ydir','reverse')
    hold on;
    plot(tarPos(:,1),tarPos(:,2),'g.','MarkerSize', 15);
    plot(curPos(:,1),curPos(:,2),'r.','MarkerSize', 20);
    xlim([0 1]);
    ylim([0 1]);
    title(sprintf('Step %d',...
    step),'FontSize',fontsize);
    set(gca,'FontSize',fontsize)
end