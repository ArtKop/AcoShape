mapGrid = struct('gU',[],'gV',[],'STD',[],'SE',[]);
mapFunc = struct('deltaX',[],'deltaY',[],'variance',[]);

[GX,GY] = meshgrid(linspace(0,1,21),linspace(0,1,21));

alpha = 3;


for i = 1:length(data)
    fprintf('Clustering %d / %d\n',i,length(data));

    span = 1/20;
 	[d,w] = binning(data{i},span);              	    
         
    fprintf('Fitting %d / %d\n',i,length(data));
    
 	[fitU gof] = makefit(d(:,1),d(:,2),d(:,3),span,w);
    [fitV gof] = makefit(d(:,1),d(:,2),d(:,4),span,w);
              
    UVhat = [fitU(d(:,1),d(:,2)) fitV(d(:,1),d(:,2))];
    e = d(:,3:4) - UVhat;
    variance = sum(e .^ 2,2);
        
    fitVar = makefit(d(:,1),d(:,2),variance,span,w);              
 
    fitStd = @(x,y) sqrt(max(0,fitVar(x,y)));
     
    fprintf('Making PPMAP U %d / %d\n',i,length(data));
    
    mapGrid(i).gU = fitU(GX,GY);
    mapFunc(i).deltaX = fitU;
    
    fprintf('Making PPMAP V %d / %d\n',i,length(data));
    
    mapGrid(i).gV = fitV(GX,GY);    
    mapFunc(i).deltaY = fitV;
    
    fprintf('Making PPMAP STD %d / %d\n',i,length(data));
    
    mapGrid(i).STD = fitStd(GX,GY); 
    mapFunc(i).variance = fitVar;
    
%      h = 1/30;
%     [X,Y] = meshgrid(0:h:1,0:h:1);
%     U = fitU(X,Y);
%     V = fitV(X,Y);
%     figure(1);
%     
%     qscale = 10;    
%     
%     h = quiver(X,Y,U,V,0);    
%     hU = get(h,'UData') ;
%     hV = get(h,'VData') ;
%     set(h,'UData',qscale*hU,'VData',qscale*hV)
%     axis([0 1 0 1]);
%     
%     figure(2);
%     
%     h = quiver(d(:,1),d(:,2),d(:,3),d(:,4),0);
%     hU = get(h,'UData') ;
%     hV = get(h,'VData') ;
%     set(h,'UData',qscale*hU,'VData',qscale*hV)
%     
%     hold on;    
%     
%     h = quiver(data{i}(:,1),data{i}(:,2),data{i}(:,3),data{i}(:,4),0);
%     hU = get(h,'UData') ;
%     hV = get(h,'VData') ;
%     set(h,'UData',qscale*hU,'VData',qscale*hV)
%     
%     hold off;
%     axis([0 1 0 1]);
%     
%     title(sprintf('Freq = %.2f Hz',modeInfo.freq(i)));
%     
%     figure(3);
%     
%     image(sqrt(abs(fitVar(X,Y)))*10000);    
          
end