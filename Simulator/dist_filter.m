function newcurPos  = dist_filter(curPos,tarPos,dist_coeff)
    % filter out the particles located at distances farther than
    % threshold * minimum average particle-target distance
    dists = zeros(length(curPos),1);
    for jj = 1:size(curPos,1)
        dists(jj) = min(vecnorm((curPos(jj,:) - tarPos)'));
    end
    ind = find(dists > dist_coeff * mean(dists));
    if isempty(ind) == 1
        newcurPos = curPos;
    else
        curPos(ind,:) = [];
        newcurPos = curPos;
    end
end