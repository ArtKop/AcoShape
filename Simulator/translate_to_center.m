function tarPos = translate_to_center(tarPos,curPos)
    % aling the centroid of targets with the one of particles
    particle_num = length(curPos);
    tar_num = length(tarPos);
    centre = curPos' * (ones(1,particle_num) / particle_num)';
    centre = repmat([centre(1); centre(2)], 1, tar_num);
    tarPos = (tarPos' - (tarPos' * (ones(1,tar_num) / tar_num)' - centre))';
end