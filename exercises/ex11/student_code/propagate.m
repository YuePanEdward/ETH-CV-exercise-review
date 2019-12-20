function particles = propagate(particles,sizeFrame,params)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% update the particles 
% variance of position and velocity (k*2)
d_pos = normrnd(0,params.sigma_position,params.num_particles,2);
d_vel = normrnd(0,params.sigma_velocity,params.num_particles,2);

if (params.model == 0) % under no velocity assumption
    A = eye(2);
    particles = particles*A + d_pos; %(k*2)
else   % under constant velocity assumption 
    A =   [ 1 0 0 0;
            0 1 0 0;
            1 0 1 0;
            0 1 0 1];  
        
    particles = particles*A + [d_pos  d_vel] ; %(k*4)
end

% block the particules inside the image
particles(:,1) = min(particles(:,1),sizeFrame(2)); % max y of the image (row)
particles(:,1) = max(particles(:,1),1);            % min y of the image (row)
particles(:,2) = min(particles(:,2),sizeFrame(1)); % max x of the image (col)
particles(:,2) = max(particles(:,2),1);            % min x of the image (col)

end


