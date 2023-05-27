clear
close all

% Plotting Six repetitions of playing an identical sequence of notes
% and tracking the particle positions at % each step (see Fig. S7 of the paper)

for nn = 6:11
    color = [rand,rand,rand];
    nn
    for n = 1:53
        TempImage = strcat('Data\',int2str(nn),'\',int2str(n),'.png');
        frame = imread(TempImage);  
        warning off; % disable any warnings about the radius range
        [centre, ~, ~] = imfindcircles(frame,[2 10]);
        warning on;
        centre = (centre/length(frame))*50;
        plot(centre(:,1),centre(:,2),'.','Color',color,'MarkerSize',10)
        hold on    
    end
end
xlim([0 50]);
ylim([0 50]);
xlabel('x (mm)')
ylabel('y (mm)')
