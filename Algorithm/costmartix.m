function [assigned_coords] = costmartix(particles,coordinates)
% 1. construct the cost matrix, whose entries are particle-target distances
% 2. solve the assignment problem based on the cost matrix by applying
% the Hungarian method
% 3. return the target coordinates in the assigned order

particle_num = size(particles);
particle_num = particle_num(1);
tar_num = size(coordinates);
tar_num = tar_num(1);
cost_matrix = zeros(particle_num,tar_num);
for part = 1:1:particle_num
    for targ = 1:1:tar_num
        cost_matrix(part,targ) = (norm([particles(part,1) - coordinates(targ,1), ...
            particles(part,2) - coordinates(targ,2)]))^2;
    end
end
indeces = munkres(cost_matrix);
assigned_coords = [coordinates(indeces,1), coordinates(indeces,2)];
end
