clear
clc
close all

% Simulator of the assembly algorithm

inputPattern = 'shape.png'; % picture name
pNum = 50; % number of particles

% Upload the models
load('vectorField_RL_2019_P2.mat');
maps = mapFunc;

% Read the shape
inputPattern = imread(inputPattern);
pic_size = length(inputPattern);
BW = im2bw(inputPattern);
[B,~,N,A] = bwboundaries(BW);
area = calc_area(B,N,A);

% Create particles
X = linspace(0+pic_size*0.1,pic_size-pic_size*0.1,sqrt(pNum));
Y = X;
[X,Y] = meshgrid(X,Y);
curPos = [X(:),Y(:)];
particle_num = length(curPos);
curPos = curPos / pic_size;
curPos = convert_y(curPos);

% Simulated plate
plate = simulatedPlate(curPos, maps);

% Create targets
dens = particle_num / area;
tarPos = polygonizer(BW,dens,B,N,A) / pic_size;
tarPos = convert_y(tarPos);
tarPos = translate_to_center(tarPos,curPos);

% Parameters
num_of_steps = 1500;
incs = 16;
dist_coeff = 7;
thresh = 1.05;

% Control loop
tic;
J = []; % cost function
step = 1;
ID = -1;
rand_note = 0;
costs = zeros(2,incs);
while step < num_of_steps
    n = 0;
    tar_num = length(tarPos);
    coor_array = zeros(length(curPos),2,incs);
    tic
    while n < incs
        theta = pi * n / 8;
        centre = tarPos' * (ones(1,tar_num) / tar_num)';
        centre = repmat([centre(1); centre(2)], 1, tar_num); 
        R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
        RotTarPos = ((R * (tarPos' - centre) + centre))';
        RotTarPos = traslate_back(RotTarPos,1,1/100); 
        n = n + 1;
        costs(1,n) = theta * 180 / pi;
        assigned_coors = assigner(curPos,RotTarPos);    
        [U,r,~] = Kabsch(assigned_coors',curPos');
        coor_array(:,:,n) = (U * assigned_coors' + r)';
        costs(2,n) = sum((vecnorm((coor_array(:,:,n) - curPos)')).^2);
    end
    toc
    
    feasible = find(costs(2,:) <= min(costs(2,:)) * thresh);
    
    [ind,min_cost,ID,opt_r,opt_U] = controller(maps,feasible,coor_array,curPos);
    J = [J; min_cost];
    
    tarPos = (opt_U * coor_array(:,:,ind)' + opt_r)';

    if (0 < ID) && (ID < 52) && (rand_note == 0)
        plate.play(ID)
    else
        plate.play(ceil(rand(1,1)*52))
        rand_note = 0;
    end
    
    curPos = plate.getPositions();
    plotter(curPos,tarPos,min_cost,ID,step,maps)
  
    F(step) = getframe(gcf);
    hold off
    
    tarPos = translate_to_center(tarPos,curPos);
 
    filt_curPos = dist_filter(curPos,tarPos,5);
    if length(filt_curPos) ~= length(curPos)
        % create new targets based on the particles located
        % at acceptable distances
        dens = length(filt_curPos) / area; % particle density
        tarPos = polygonizer(BW,dens,B,N,A) / pic_size;
        tarPos = convert_y(tarPos);
        tarPos = (opt_U * tarPos' + opt_r)';
        tarPos = translate_to_center(tarPos,curPos);
    end
    curPos = filt_curPos;
     
    step = step + 1;
end

% Plot the cost function dynamics
figure
plot(J,'-o')
xlabel('Steps')
ylabel('Cost')

% finalize the recording
writerObj = VideoWriter(strcat(date,'.avi')); % name of the video is 'current date'.avi
writerObj.FrameRate = 100;
writerObj.Quality = 50;
open(writerObj);
% write the frames to the video
for i=1:length(F)
    % convert the image to a frame
    frame = F(i);    
    writeVideo(writerObj, frame);
end
% close the writer object
close(writerObj);
