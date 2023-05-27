close all
clear
clc

% Calculate and plot Lyapnov exponents of particle pairs
% saved in "runset*.mat" files

lambdas = [];
ind = 1;

addpath('Data')

load('runset10.mat')
run_set1 = run_set;
load('runset7.mat')
[lambdas,ind] = plot_ln(run_set,run_set1,lambdas,ind);

load('runset9.mat')
run_set1 = run_set;
load('runset8.mat')
[lambdas,ind] = plot_ln(run_set,run_set1,lambdas,ind);

load('runset11.mat')
run_set1 = run_set;
load('runset6.mat')
[lambdas,ind] = plot_ln(run_set,run_set1,lambdas,ind);

sprintf('Lyapunov exponents range from %.3f to %.3f.',min(lambdas),max(lambdas))

function [lambdas,ind] = plot_ln(run_set,run_set1,lambdas,ind)

% fig_width = 9*2;
% fig_height = 6*2;
% fighandle = figure('units','centimeters','Position',[1 1 fig_width fig_height]); 
fontsize = 30;
linewidth = 3;
fname = 'Arial';

diver = [];
for n = 1:53
    prtc1 = run_set(:,:,n);
    prtc2 = run_set1(:,:,n);
    [assigned_prtc2] = assigner(prtc1,prtc2);
    delta = assigned_prtc2-prtc1;
    delta = delta * 50;
    diver = [diver vecnorm(delta')'];
end

t = 1:53;
for n = 1:9
    delta = diver(n,:);
    log_delta = log(diver(n,:));
    c = polyfit(t,log_delta,1);
    v = linspace(log_delta(1),log_delta(52),53);
    d1 = polyval(c,t);
    
    figure
    plot(t,log_delta,'LineWidth',linewidth)
    hold on
    plot(t,d1,'r','LineWidth',linewidth)
    ylabel('ln(‖\delta‖) (mm)') 
    xlabel('Time (steps)')
    
    lambda_text = sprintf(' %.3f',c(1));
    title(strcat('\lambda = ',lambda_text),'FontSize',24)
    xlim([1 53])
    lambdas = [lambdas; c(1)];

    set(gca,'FontName',fname,'FontSize',fontsize)
    h = get(gca, 'title');
    set(h ,'FontName',fname,'FontSize',fontsize)
    h = get(gca, 'xlabel');
    set(h,'FontName',fname,'FontSize',fontsize)
    h = get(gca, 'ylabel');
    set(h ,'FontName',fname,'FontSize',fontsize)
    set(gcf,'color','w'); % white background
    set(gca,'linewidth',1)
    
    title_text = sprintf('Experiment_%d.png',ind);
    ind = ind + 1;
    print(gcf,title_text,'-dpng','-r600');
    
    hold off
    close all
end
end