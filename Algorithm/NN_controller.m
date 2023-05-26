function [index,min_cost,id,opt_r,opt_U] = NN_controller(NNx,NNy,feasible,coor_array,curPos)

% 1. explore all possible displacements for feasible shape positions one step ahead
% 2. output the optimal note and shape position (rotation and translation matrix)

feas_len = length(feasible); % number of feasible assignments
costs = ones(2,feas_len) * inf; % initial costs as starting points
rot_m = zeros(2,2,feas_len); % 2x2 matrices of feasible rotations
tra_m = zeros(2,feas_len); % 2x1 vectors of feasible translations
mode_size = length(NNx);

for nn = 1:1:feas_len
    for ii = 1:1:mode_size
        netX = NNx{ii};
        netY = NNy{ii};
        newPos = curPos + [netX(curPos')' netY(curPos')'];
        tarPos = coor_array(:,:,feasible(nn));
        [U,r,~] = Kabsch(tarPos',newPos'); % translate/rotate the pattern
        dist = vecnorm((newPos - (U * tarPos' + r)')');
        cost = sum(dist.^2); % estimated new total distance
        if cost < costs(nn)
            % store the supplementary values
            costs(1,nn) = cost; % minimum cost
            costs(2,nn) = ii; % note ID
            tra_m(:,nn) = r; % translation vector
            rot_m(:,:,nn) = U;  % rotation matrix
        end
    end
end
ind = find(costs(1,:) <= min(costs(1,:))); % index of the minimum cost
min_cost = costs(1,ind(1)); % minimum cost
id = costs(2,ind(1)); % note ID
opt_r = tra_m(:,ind(1)); % associated translation vector
opt_U = rot_m(:,:,ind(1)); % associated rotation matrix
index = feasible(ind(1)); % associated assignment
end
