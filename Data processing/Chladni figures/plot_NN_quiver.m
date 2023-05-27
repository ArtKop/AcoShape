function [] = plot_NN_quiver(NNx,NNy,note,W)

netX = NNx{note};
netY = NNy{note};

x_list = [];
y_list = [];
dx_list = [];
dy_list = [];

numGrid = 21;

x = 1/(2*numGrid):1/numGrid:1;
y = 1/(2*numGrid):1/numGrid:1;
[X,Y] = meshgrid(x,y);

NN_valuesX = zeros(size(X));
NN_valuesY = zeros(size(Y));

for i = 1:numGrid
    for j = 1:numGrid
        x_list = [x_list; X(i,j)];
        y_list = [y_list; Y(i,j)];
    end
end

inputs = [x_list y_list]';

NNoutputsX = netX(inputs);
NNoutputsY = netY(inputs);

for i = 1:numGrid
    for j = 1:numGrid
        NN_valuesX(i,j) = NNoutputsX((i-1)*numGrid + j);
        NN_valuesY(i,j) = NNoutputsY((i-1)*numGrid + j);
    end
end

x = W/(2*numGrid):W/numGrid:W;
y = W/(2*numGrid):W/numGrid:W;
[X,Y] = meshgrid(x,y);

lh = quiver(X,Y,NN_valuesX,NN_valuesY,3,'b-');
set(gca,'YDir','reverse');
axis([0 1 0 1]);
set(gca, 'YDir', 'reverse');
set(gca,'xtick',[])
set(gca,'xticklabel',[])
set(gca,'ytick',[])
set(gca,'yticklabel',[])        
axis([0 1 0 1]);
set(lh,'linewidth',0.2);    
box off;
end