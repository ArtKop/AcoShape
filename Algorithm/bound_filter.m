function filt_curPos = bound_filter(curPos,pic_size)
    % filter out the particles located outside the bounds of the plate [0, 1]
    filt_curPos = zeros(1,2);
    for p = 1:length(curPos)
        if (0 < curPos(p,1)) && (curPos(p,1) < pic_size) &&...
                (0 < curPos(p,2)) && (curPos(p,2) < pic_size)
            if filt_curPos == zeros(1,2)
                filt_curPos(1,:) = curPos(p,:);
            else
                filt_curPos = [filt_curPos; curPos(p,:)];
            end
        end
    end
end