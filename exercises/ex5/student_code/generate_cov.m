function cov = generate_cov(delta_L, delta_a, delta_b, K)
% Generate initial values of covariance matrix
cov=[];
for i=1:K
    % cov(:,:,i) = diag(rand(1,3).*[delta_L delta_a delta_b]);
    % could be initialized as a diagonal matrix with elements corresponding 
    % to the range of the L*, a* and b* values.
    cov(:,:,i) = diag([delta_L delta_a delta_b]);
end

end