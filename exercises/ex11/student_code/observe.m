function particles_w = observe(particles,frame,HeightBB,WidthBB,hist_bin,hist,sigma_observe)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

K =size(particles,1) ;
particles_w = zeros(K,1) ; 
hist = reshape(hist,1,3*hist_bin); %rgb->one vector

for i = 1:K % for each particle
    % get estimated bbx
    min_x = particles(i,1) - WidthBB/2;
    max_x = particles(i,1) + WidthBB/2;
    min_y = particles(i,2) - HeightBB/2;
    max_y = particles(i,2) + HeightBB/2;
    % calculate color_histogram vector in the estimated bbx
    cur_particle_hist = color_histogram(min_x,min_y,max_x,max_y,frame,hist_bin); 
    cur_particle_hist = reshape(cur_particle_hist,1,3*hist_bin); %rgb->one vector
    % observation: difference of the histogram vector
    dist = chi2_cost(hist,cur_particle_hist);
    
    %update weight (smaller the difference (distance),larger the weight)
    particles_w(i) = 1/(sqrt(2*pi)*sigma_observe)* exp(-(dist^2)/(2*sigma_observe^2));
end

%normalize
particles_w = particles_w/sum(particles_w);
end
