function [assigned_coords] = assigner(particles,coordinates) 
% 1. create the target points and assign the particles to them
% 2. return the target point coordinates in the assigned order
% always (!): number of targets = number of particles

particle_num = length(particles);
% dens = particle_num / area; % particle density
% coordinates = polygonizer(image,dens,B,N,A); % create the target points within the patterns
coord_num = length(coordinates);

if coord_num < particle_num
    pars = particles;
    assigned_coords = zeros(length(particles),2);
    while isempty(particles) == 0
        if length(coordinates) < length(particles)
            assigned_pars = costmartix(coordinates,particles);
            id = is_member(pars,assigned_pars);
            assigned_coords(id,:) = coordinates;
            id = is_member(particles,assigned_pars);
            particles(id,:) = [];
        else
            id = find((assigned_coords == [0 0]));
            assigned_coords(id) = costmartix(particles,coordinates);
            particles = [];
        end
    end
else
    assigned_coords = costmartix(particles,coordinates);
end
end