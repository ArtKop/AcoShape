function filt_curPos = bound_filter(curPos,bound)
    % filter out the particles located outside the bounds of the plate [0, 1]
    filt_curPos = zeros(1,2);
    for p = 1:length(curPos)
        if (0 < curPos(p,1)) && (curPos(p,1) < bound) &&...
                (0 < curPos(p,2)) && (curPos(p,2) < bound)
            if filt_curPos == zeros(1,2)
                filt_curPos(1,:) = curPos(p,:);
            else
                filt_curPos = [filt_curPos; curPos(p,:)];
            end
        end
    end
end