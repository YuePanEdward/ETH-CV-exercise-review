function meanState = estimate(particles,particles_w)
%the mean state (1*2(4)) should be the weighted sum of all the particles (k*2(4))

meanState=(particles'*particles_w)';
end




