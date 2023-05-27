function [newPoints] = polygonizer(image,dens,B,N,A)

% return the target points within the patters

% find the bounding rectangle
dim = size(image);
xv = [1 dim(2)]; yv = [1 dim(1)];
lower_x = min(xv);
higher_x = max(xv);
lower_y = min(yv);
higher_y = max(yv);

% create a grid of points within the bounding rectangle
inc_x = 1/sqrt(dens);
inc_y = 1/sqrt(dens);
interval_x = lower_x : inc_x : higher_x;
interval_y = lower_y : inc_y : higher_y;
[bigGridX, bigGridY] = meshgrid(interval_x, interval_y);
	
% 1. filter out the points located inside the holes and outside the patterns
% 2. merge the target points located inside different patterns and remove
% the target points inside the holes in the patterns

for k = 1:N
    if (nnz(A(:,k)) > 0)
        boundary = B{k};
        in = inpolygon(bigGridX(:), bigGridY(:), boundary(:,2), higher_x - boundary(:,1));
        if k == 1 % first iteration
            newPoints = [bigGridX(in), bigGridY(in)];
        else
            newPoints = [newPoints; [bigGridX(in), bigGridY(in)]];
        end
        % loop through the children of boundary k to remove the target
        % points inside the holes in the patterns
        for l = find(A(:,k))'
            boundary = B{l};
            in = inpolygon(bigGridX(:), bigGridY(:), boundary(:,2), higher_x- boundary(:,1));
            redPoints = [bigGridX(in), bigGridY(in)];
            newPoints(ismember(newPoints,redPoints,'rows'),:) = [];
        end
    else
        boundary = B{k};
        in = inpolygon(bigGridX(:), bigGridY(:), boundary(:,2), higher_x - boundary(:,1));
        if k == 1 % first iteration
            newPoints = [bigGridX(in), bigGridY(in)];
        else
            newPoints = [newPoints; [bigGridX(in), bigGridY(in)]];
        end
    end
end
end