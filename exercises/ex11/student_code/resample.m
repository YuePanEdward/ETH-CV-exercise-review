function [particles, particles_w] = resample(particles,particles_w)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

K = size(particles,1);
% smaple with replacement according to the weight
cur_particles = datasample(particles, K, 'replace', true, 'Weights', particles_w); 

%assign weight directly
cur_particles_w = zeros(K,1) ;
for i = 1:K
    for j=1:K
        if (cur_particles(i,:) == particles(j,:))
             cur_particles_w(i) = particles_w(j);
        end
    end
end

% resampled results
particles_w = cur_particles_w/sum(cur_particles_w); %normalize
particles = cur_particles ;
end

