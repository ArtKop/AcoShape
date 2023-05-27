 function ret = find_blobs(frame)
    gf = double(rgb2gray(frame))/255;                  
    original = adaptiveThreshold(gf,5);    
    
    filled = imfill(original, 'holes');
    holes = filled & ~original;
    bigholes = bwareaopen(holes, 40);
    smallholes = holes & ~bigholes;
    bw = original | smallholes;
        
    %D = bwdist(~bw); % TODO: watershedding
    %D = -D;
    %D(~bw) = -Inf;
    %L = watershed(D);
    %bw(L == 0) = 0;
    
    s = regionprops(bwlabel(bw),'centroid','FilledArea','Eccentricity');
    centroids = cat(1, s.Centroid);
    areas = cat(1, s.FilledArea);
    eccs = cat(1, s.Eccentricity);
    ind = 80 < areas & areas < 400 & eccs < 0.9;
%     ind = 20 < areas & areas < 200; % Under water
    ret = centroids(ind,:);
    ret(:,1) = ret(:,1) / size(frame,2);
    ret(:,2) = ret(:,2) / size(frame,1);        
 end