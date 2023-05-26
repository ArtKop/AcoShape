function plotter(curPos,tarPos,cost,ID,step,NNx,NNy)
    plot_NN_quiver(NNx,NNy,ID,1)
    hold on
    plot(tarPos(:,1),tarPos(:,2),'go');
    p = plot(curPos(:,1),curPos(:,2),'r.');
    p.MarkerSize = 20;
    xlim([0 1]);
    ylim([0 1]);
    title(sprintf('st: %d; cost: %.5f; p: %d; ID: %d',...
        step, (cost/length(curPos))*1e3,length(curPos), ID));
    hold off
end
