close all
clear

fontsize = 18;
fname = 'Arial';

load('poly_mse_training.mat')
load('net_mse_training.mat')

colorspec = {[0.1540 0.4040 0.6260], [0.8500, 0.3250, 0.0980]};

poly1212(27) = []; poly1212(29) = [];

mean_mse_training = [mean(poly11) mean(poly22) mean(poly33) mean(poly44) mean(poly55) mean(poly66) ...
    mean(poly77) mean(poly88) mean(poly99) mean(poly1010) mean(poly1111) mean(poly1212) mean(net_mse)];

fig_width = 18*2;
fig_height = 12*2;
fighandle = figure('units','centimeters','Position',[1 1 fig_width fig_height]);   

plot(mean_mse_training,'-o','Color',colorspec{1},'MarkerSize',8,'LineWidth',2)
hold on
% grid on

load('poly_mse_validation.mat')
load('net_mse_validation.mat')

poly1212(27) = []; poly1212(29) = [];

mean_mse_validation = [mean(poly11) mean(poly22) mean(poly33) mean(poly44) mean(poly55) mean(poly66) ...
    mean(poly77) mean(poly88) mean(poly99) mean(poly1010) mean(poly1111) mean(poly1212) mean(net_mse)];
plot(mean_mse_validation,'-o','Color',colorspec{2},'MarkerSize',8,'LineWidth',2)

% names = {'poly1','poly2','poly3','poly4','poly5','poly6','poly7',...
%     'poly8','poly9','poly10','poly11','poly12','NN'};
names = {'1','2','3','4','5','6','7',...
    '8','9','10','11','12','NN'};
set(gca,'xtick',[1:13],'xticklabel',names)
legend('Training','Validation','FontSize',fontsize,'FontName',fname)
ylabel('Average Mean Squared Error (MSE)')
% xlabel('Polynomial order')

ylim([1.2 2.5]*1e-5)
xlim([1 13])

set(gca,'FontName',fname,'FontSize',fontsize) % Arial everywhere, the point size depends on the size of you Figure object, let's adjust that finally so they are close to identical in the final Figure
h = get(gca, 'title');
set(h ,'FontName',fname,'FontSize',fontsize)
h = get(gca, 'xlabel');
set(h,'FontName',fname,'FontSize',fontsize)
h = get(gca, 'ylabel');
set(h ,'FontName',fname,'FontSize',fontsize)
set(gcf,'color','w'); % white background
% grid on
box on
set(gca,'linewidth',1)

% 
print(gcf,'MSEs.png','-dpng','-r600');