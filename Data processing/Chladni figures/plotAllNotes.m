function plotAllNotes
    close all;
    % page size after margins is 229 x 170 mm    
    fs =[];
    basescale = {'C','C^#','D','D^#','E','F','F^#','G','G^#','A','A^#','B'};    
    cachefile = '../output/allcache.mat';    
    
    gamma = 0.02;
    Cexp = 0.184355181520987;
    w = 50e-3;            
    NS = 10;
    gain = 150;

    D = load('trackModesChromatic.mat');
    
    load('NN.mat')
    load('modeInfo.mat')
    
    [freqs,ind] = sort(modeInfo.freq);
    
    notenumbers = round(log2(freqs/440)*12+9);
    octaves = fix(notenumbers/12)+4;
    notenames = arrayfun(@(x,y) sprintf('%s_{%d}',x{1},y),basescale(mod(notenumbers,12)+1),octaves,'UniformOutput', false);
    NNx = NN{1};
    NNy = NN{2};
    
    D.modeInfo.freq = freqs;    
    D.Map = D.Map(ind);
    D.modeInfo.amp = modeInfo.amp(ind);
    D.modeInfo.duration = modeInfo.duration(ind);
%     D.modeInfo.material = D.modeInfo.material(ind);        
    numfigs = (fix((length(modeInfo.freq)-1) / 60)+1);
    %width = 16.35;
    %height = 22.8;
    width = 25;
    height = 15;
    for i = 1:numfigs
        fs(i) = figure('Units','centimeters','Position',[1 1 width height]);                    
        set(gcf,'color','w');
    end        
    modes = {};
    
    if ~exist(cachefile,'file')
        
        N = length(D.modeInfo.freq);
        npoints = 100;
        s = 1/(npoints*2);
        [pX,pY] = meshgrid(linspace(s,1-s,npoints),linspace(s,1-s,npoints));
%         stdimages = cell(1,N); 
        absimages = cell(1,N); 
        parfor i = 1:N        
            fitU = D.Map(i).fitU;
            fitV = D.Map(i).fitV;              
            fitVar = D.Map(i).fitVar;                    
%             stdimages{i} = sqrt(max(fitVar(pX,pY),0));            
            absimages{i} = sqrt(fitU(pX,pY) .^ 2 + fitV(pX,pY) .^ 2);            
        end       
        quivercache = cell(1,N);        
        npoints = 20;
        s = 1/(npoints*2);
        [pX,pY] = meshgrid(linspace(s,1-s,npoints),linspace(s,1-s,npoints));
        parfor i = 1:N
            fitU = D.Map(i).fitU;
            fitV = D.Map(i).fitV;           
            pU = fitU(pX,pY);
            pV = fitV(pX,pY);            
            quivercache{i} = {pX,pY,pU,pV};            
        end
        
        [foo,modes] = computeChladniFigure(1,gamma,NS,1);
        
%         save(cachefile,'quivercache','stdimages','modes','absimages');
    else
        C = load(cachefile);
        quivercache = C.quivercache;
        stdimages = C.stdimages;
        absimages = C.absimages;
        modes = C.modes;
    end
    
    W = (width-0.5)/20;
    H = W;
    TH = 0;
    RH = H*4+TH;
    marg = 0.45;
    for i = 1:51
        c = mod(i-1,20);
        rp = fix((i-1)/20);
        r = 2 - mod(rp,3);
        p = fix(rp/3)+1;
        figure(fs(p));
        freq = D.modeInfo.freq(i);
        axes('Units','centimeters','Position',[W*c+TH+marg r*RH+2*H W H]);
%         plot_quiver(D,freq,15,0.2,'b-',quivercache);
        plot_NN_quiver(NNx,NNy,i,1);
        absimage = calc_abs(NNx,NNy,i);
%         plot_quiver2(NNx{i},NNy{i},freq,D,npoints,lw,linetype,cache)   
%         box on;       
        if (c == 0)
            text(-0.1,H/2,'{\bfu}_n','Rotation',90,'Units','centimeters','HorizontalAlignment','center','VerticalAlignment','bottom','FontName','Arial','FontSize',7);  
        end     
%         axes('Units','centimeters','Position',[W*c+TH r*RH+H W H]);
%         G = gain;
%         if i == 1
%             G = 30;
%         elseif i == 26 || i == 27   
%             G = 20;
%         else
%             G = gain;
%         end
%         imshow(absimage*G);
%         set(gca,'xtick',[])
%         set(gca,'xticklabel',[])
%         set(gca,'ytick',[])
%         set(gca,'yticklabel',[])  
        box on;        
        if (c == 0)
            text(-0.1,H/2,'{\bfu}_n','Rotation',90,'Units','centimeters','HorizontalAlignment','center','VerticalAlignment','bottom','FontName','Arial','FontSize',7);  
        end     
        axes('Units','centimeters','Position',[W*c+TH+marg r*RH+H W H]);
%         imshow(stdimages{i}*gain);
%         set(gca,'xtick',[])
%         set(gca,'xticklabel',[])
%         set(gca,'ytick',[])
%         set(gca,'yticklabel',[])  
%         if (c == 0)
%             text(-0.002,H/2,'\it\xi_n','Rotation',90,'Units','centimeters','HorizontalAlignment','center','VerticalAlignment','bottom','FontName','Arial','FontSize',7);  
%         end     
%         box on; 
%         axes('Units','centimeters','Position',[W*c+TH r*RH+3*H W H]);        
        k = sqrt(freq / Cexp);
        knorm = k * w / pi;        
        [foo,modes] = computeChladniFigure(knorm,gamma,NS,'reuse',modes);
        set(gca,'xtick',[]);
        set(gca,'xticklabel',[]);
        set(gca,'ytick',[]);
        set(gca,'yticklabel',[]);    
        if (c == 0)
            text(-0.1,H/2,'Theory','Rotation',90,'Units','centimeters','HorizontalAlignment','center','VerticalAlignment','bottom','FontName','Arial','FontSize',7);  
        end     
%         text(W/2,H+0.002,sprintf('%s %dHz',notenames{i},round(freq)),'Units','centimeters','HorizontalAlignment','center','VerticalAlignment','bottom','FontName','Arial','FontSize',5); 
        text(W/2,H+1.25,sprintf('%d Hz',round(freq)),'Units','centimeters','HorizontalAlignment','center','VerticalAlignment','bottom','FontName','Arial','FontSize',5);          
%         colormap hot
        colormap (gca,'gray')
        i
    end  
    margin = 0.2;
    axBar = axes('Units','centimeters','Position',[W*(c+1)+TH-0.44 0*RH+margin 1e-6 2*H-margin]);
    axis off;
    umlocs = 100:100:1000; % µm
    ticks = umlocs/50e3*gain; % colorvalues
    ticklabels = cellstr(num2str(umlocs', '%g µm'))
%     h = colorbar('eastoutside','Ticks',ticks,'TickLabels',ticklabels,'FontSize',5.5);  
%     h.Position(1) = h.Position(1)+0.02;
%     print(gcf,'Chladni figures.png','-dpng','-r500'); 
    %colorbar('eastoutside');    
%     addpath('export_fig');
%     for i = 1:numfigs
%         figure(fs(i));
%         export_fig(sprintf('../output/All_H%d.png',i),'-r1800');
%     end
%     for i = 1:numfigs
%          figure(fs(i));
%          export_fig(sprintf('../output/All%d.pdf',i));
%     end
end
    