clear
clc
close

httpcommand('ShowVectorField','flag',0);
httpcommand('RecordRawImage','flag',1);
httpcommand('TriggedRecording','flag',0);
httpcommand('StopRecording');
httpcommand('StartRecording');

TempImage = 'Shape.png';

load('vectorField_RL_2019_P2.mat'); % plate info
load('NNs.mat');  % neural networks

NNx = NN{1};
NNy = NN{2};

inputPattern = 'C.png'; % input shape
inputPattern = imread(inputPattern);
pic_size = length(inputPattern);
BW = im2bw(inputPattern); % turn the picture grayscale

% trace region boundaries: B = the boundaries of patterns, N = the number of patterns found,
% A = the adjacency matrix of boundaries B, N = number of boundaries
[B,~,N,A] = bwboundaries(BW);
area = calc_area(B,N,A); % calculate the shape total area

httpcommand('GrabImage','filename', TempImage); pause(0.1);
frame = imread(TempImage);
warning off
[centre, ~, ~] = imfindcircles(frame,[1 10]);
warning on
curPos = centre / size(frame,1);

% create targets
particle_num = length(curPos);
dens = particle_num / area; % particle density
tarPos = polygonizer(BW,dens,B,N,A) / pic_size;
tarPos = convert_y(tarPos);

% translate the targets to the centroid of the particles
tarPos = translate_to_center(tarPos,curPos);

% control inputs
num_of_steps = 1000;
incs = 16; % number of guessed assignments = rotation increments
dist_coeff = 2.5; % distance priority coefficient
costs = zeros(2,incs);
step = 1;
ID = -1;
tic
notes = [];
J = []; % cost vs time steps
while step < num_of_steps
    
    n = 0;
    tar_num = length(tarPos);
    coor_array = zeros(length(curPos),2,incs);

    while n < incs
        % rotate targets around their centroid
        theta = pi * n / (incs/2);
        centre = tarPos' * (ones(1,tar_num) / tar_num)';
        centre = repmat([centre(1); centre(2)], 1, tar_num); 
        R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
        RotTarPos = ((R * (tarPos' - centre) + centre))';
        
        % return the shape to the plate
        RotTarPos = traslate_back(RotTarPos,1,1/100); 
        
        n = n + 1;
        
        % store the rotation angle associated with the cost
        costs(1,n) = theta * 180 / pi;
        
        % assign the particle-target pairs
        assigned_coors = assigner(curPos,RotTarPos);
        
        [U,r,~] = Kabsch(assigned_coors',curPos');
        coor_array(:,:,n) = (U * assigned_coors' + r)';
        
        % store the cost
        costs(2,n) = sum((vecnorm((coor_array(:,:,n) - curPos)')).^2);
    end

    feasible = find(costs(2,:) <= min(costs(2,:)) * 1);
    
    % select the optimal note
    [ind,min_cost,ID,opt_r,opt_U] = NN_controller(NNx,NNy,feasible,coor_array,curPos);
    
    J = [J; min_cost];
    
    % extract the optimal targets
    tarPos = coor_array(:,:,ind);
    
    % plot
    plotter(convert_y(curPos),convert_y(tarPos),(min_cost/length(curPos))*1e3,ID,step,NNx,NNy);
    
    % record the frame
    F(step) = getframe(gcf);
  
    if (0 < ID) && (ID <= 52)
        play(ID,modeInfo);
    end
    notes(step) = ID;
    
    % grab an image and track the particles
    TempImage = strcat(int2str(step+1),'.png');
    httpcommand('GrabImage', 'filename', TempImage);
    pause(0.1);
    frame = imread(TempImage);
    warning off
    [centre, ~, ~] = imfindcircles(frame,[1 10]);
    warning on
    
    filt_curPos = centre / size(frame,2);
    % trace particles and adapt NNs
    learn_coeff = 1.5; % learning coefficient
    if length(filt_curPos) <= length(curPos) % some particles were lost
        corresp_curPos = costmartix(filt_curPos,curPos);
        D = filt_curPos - corresp_curPos;
        [NNx,NNy] = adapt_NN(NNx,NNy,ID,learn_coeff,corresp_curPos,D); 
        dens = length(filt_curPos) / area; % particle density
        tarPos = polygonizer(BW,dens,B,N,A) / pic_size;
        tarPos = convert_y(tarPos);
    %   tarPos = assigner(filt_curPos,tarPos);
        tarPos = (opt_U * tarPos' + opt_r)';
        tarPos = translate_to_center(tarPos,filt_curPos);
    else
        corresp_filt_curPos = costmartix(curPos,filt_curPos);
        D = corresp_filt_curPos - curPos;
        [NNx,NNy] = adapt_NN(NNx,NNy,ID,learn_coeff,curPos,D);
        dens = length(filt_curPos) / area; % particle density
        tarPos = polygonizer(BW,dens,B,N,A) / pic_size;
        tarPos = convert_y(tarPos);
    %   tarPos = assigner(filt_curPos,tarPos);
        tarPos = (opt_U * tarPos' + opt_r)';
        tarPos = translate_to_center(tarPos,filt_curPos);        
    end
    curPos = filt_curPos;
    
    filt_curPos = dist_filter(curPos,tarPos,dist_coeff);
    if length(filt_curPos) ~= length(curPos)
        dens = length(filt_curPos) / area;
        tarPos = polygonizer(BW,dens,B,N,A) / pic_size;
        tarPos = convert_y(tarPos);
    %   tarPos = assigner(filt_curPos,tarPos);
        tarPos = (opt_U * tarPos' + opt_r)';
        tarPos = translate_to_center(tarPos,filt_curPos);
    end
    curPos = filt_curPos;

    step = step + 1;
    step_time = toc / step
end

httpcommand('StopRecording');

% finalize the recording
writerObj = VideoWriter(strcat(date,'.avi')); % name of the video is 'current date'.avi
writerObj.FrameRate = 10; % 10 fps
open(writerObj);
for i=1:length(F)
    frame = F(i);    
    writeVideo(writerObj, frame);
end
close(writerObj);

% store the note IDs used
txt_name = strcat(date,'.txt');
fid = fopen(txt_name,'wt');
if fid > 0
    fprintf(fid,'%d\t',notes');
    fclose(fid);
end

function play(ID,modeInfo)               
    if (ID < 1 || ID > length(modeInfo.freq))
        error('Invalid note id, should be between 1..%d (was: %d)',length(modeInfo.freq),ID);
    end
    freq = modeInfo.freq(ID);
    duration = modeInfo.duration(ID);
    coef = 1.3;
    amp = min(max(modeInfo.amp(ID)*coef,0),1);
    httpcommand('PlaySmoothSignal', 'amp', amp * 4.5, 'bias', 3, 'freq', freq, 'duration', duration,...
        'envelope','Triangular');        
    pause(duration/1000 + 0.2);
end
