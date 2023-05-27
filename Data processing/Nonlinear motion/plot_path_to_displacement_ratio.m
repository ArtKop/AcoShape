close all
clear

load('assigned_particle_trail_L.mat')

path_lengths = [];
for ii = 1:length(assigned_particle_trail)
    new_particles = assigned_particle_trail(:,:,ii)/791;
    if ii > 1
        path_lengths(:,ii-1) = vecnorm((old_particles - new_particles)')';
    end
    for jj = 1:90 % filter out outliers
         if vecnorm(new_particles(jj,:) - assigned_particle_trail(jj,:,length(assigned_particle_trail))/791) < 0.009 && ii > 1
             path_lengths(jj,ii-1) = 0;
         end
    end
    old_particles = new_particles;     
end

path_lengths = ((sum(path_lengths'))')*50;

old_particles = assigned_particle_trail(:,:,1)/791;
new_particles = assigned_particle_trail(:,:,length(assigned_particle_trail))/791;

path_displacements = (vecnorm((old_particles - new_particles)')')*50;
ratios = path_lengths./path_displacements;

fig_width = 9*2;
fig_height = 6*2;
fighandle = figure('units','centimeters','Position',[1 1 fig_width fig_height]); 

fontsize = 22;
fname = 'Arial';

bar(sort(ratios,'descend'))

xlabel('Particle')
ylabel('Distance to displacement ratio')
yticks(0:10:80)
xticks(0:10:90)
ylim([0 80])
xlim([0 91])

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

print(gcf,'Distance_to_displacement_ratio.png','-dpng','-r1200');