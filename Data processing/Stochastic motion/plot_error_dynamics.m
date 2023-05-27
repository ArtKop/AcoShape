close all
clear
clc

dist_mean = [];
dist_std = [];

addpath('Data')

load('runset10.mat')
run_set1 = run_set;
load('runset7.mat')

mean_coeff = [];
peaks = [];

for n = 1:53
    prtc1 = run_set(:,:,n);
    prtc2 = run_set1(:,:,n);
    [assigned_prtc2] = assigner(prtc1,prtc2);
    delta = assigned_prtc2-prtc1;
    dist_mean(n) = mean(vecnorm(delta'));
    dist_std(n) = std(vecnorm(delta'));
end

dist_mean = dist_mean * 50;
dist_std = dist_std * 50;

peaks(1) = max(dist_mean);
coefs = polyfit(1:53,dist_mean,1);
mean_coeff(1) = coefs(1);

fig_width = 9*2;
fig_height = 6*2;
fighandle = figure('units','centimeters','Position',[1 1 fig_width fig_height]); 
fontsize = 22;
fname = 'Arial';

curve1 = dist_mean + dist_std;
curve2 = dist_mean - dist_std;
x = 1:53;
x2 = [x, fliplr(x)];
inBetween = [curve1, fliplr(curve2)];
p1 = fill(x2, inBetween, [0.6000    0.8000    1.0000],'FaceAlpha', 0.3,'LineStyle','none');

hold on;
plot(x, curve1, 'Color',[0.6000    0.8000    1.0000]);
plot(x, curve2,  'Color',[0.6000    0.8000    1.0000]);
p2 = plot(x, dist_mean, 'Color',[0    0.4471    0.7412], 'LineWidth', 2);
ylabel('Euclidean distance (mm)')
xlabel('Time (steps)')

load('runset9.mat')
run_set1 = run_set;
load('runset8.mat')

for n = 1:53
    prtc1 = run_set(:,:,n);
    prtc2 = run_set1(:,:,n);
    [assigned_prtc2] = assigner(prtc1,prtc2);
    delta = assigned_prtc2-prtc1;
    dist_mean(n) = mean(vecnorm(delta'));
    dist_std(n) = std(vecnorm(delta'));
end

dist_mean = dist_mean * 50;
dist_std = dist_std * 50;

peaks(2) = max(dist_mean);
coefs = polyfit(1:53,dist_mean,1);
mean_coeff(2) = coefs(1);

curve1 = dist_mean + dist_std;
curve2 = dist_mean - dist_std;
x = 1:53;
x2 = [x, fliplr(x)];
inBetween = [curve1, fliplr(curve2)];
p3 = fill(x2, inBetween, [0.5216    0.6588    0.3569],'FaceAlpha', 0.3,'LineStyle','none');
hold on;
plot(x, curve1, 'Color',[0.5216    0.6588    0.3569]);
plot(x, curve2,  'Color',[0.5216    0.6588    0.3569]);
p4 = plot(x, dist_mean, 'Color',[0.4660 0.6740 0.1880], 'LineWidth', 2);
ylabel('Euclidean distance (mm)')
xlabel('Time (steps)')

load('runset11.mat')
run_set1 = run_set;
load('runset6.mat')

for n = 1:53
    prtc1 = run_set(:,:,n);
    prtc2 = run_set1(:,:,n);
    [assigned_prtc2] = assigner(prtc1,prtc2);
    delta = assigned_prtc2-prtc1;
    dist_mean(n) = mean(vecnorm(delta'));
    dist_std(n) = std(vecnorm(delta'));
end

dist_mean = dist_mean * 50;
dist_std = dist_std * 50;

peaks(3) = max(dist_mean);
coefs = polyfit(1:53,dist_mean,1);
mean_coeff(3) = coefs(1);

curve1 = dist_mean + dist_std;
curve2 = dist_mean - dist_std;

x = 1:53;
x2 = [x, fliplr(x)];
inBetween = [curve1, fliplr(curve2)];
p3 = fill(x2, inBetween, [0.9216    0.6588    0.3569],'FaceAlpha', 0.3,'LineStyle','none');
hold on;
plot(x, curve1, 'Color',[0.9216    0.6588    0.3569]);
plot(x, curve2,  'Color',[0.9216    0.6588    0.3569]);
p4 = plot(x, dist_mean, 'Color',[1.0000    0.4118    0.1608], 'LineWidth', 2);
ylabel('Euclidean distance (mm)')
xlabel('Time (steps)')
% xticks(0:2:53)
% legend([p1 p2 p3 p4],'\sigma_{experiment}','\mu_{experiment}','\sigma_{simulation}','\mu_{simulation}','FontSize',12)

yticks(0:1:6)

xlim([1 53])
ylim([-0.5 6])

set(gca,'FontName',fname,'FontSize',fontsize)
h = get(gca, 'title');
set(h ,'FontName',fname,'FontSize',fontsize)
h = get(gca, 'xlabel');
set(h,'FontName',fname,'FontSize',fontsize)
h = get(gca, 'ylabel');
set(h ,'FontName',fname,'FontSize',fontsize)
set(gcf,'color','w'); % white background
set(gca,'linewidth',2)
box on
% grid on

% print(gcf,'Stochastic_motion.png','-dpng','-r1200');

sprintf('Average error growth rate is %.2f micrometers.',mean(mean_coeff)*1e3)
sprintf('Average maximum error is %.2f mm.',mean(peaks))