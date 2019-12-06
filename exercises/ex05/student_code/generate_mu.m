function mu = generate_mu(delta_L, delta_a, delta_b, K)
% Generate initial values of mu
mu=[];
for i = 1:K
    %mu(i,:) = rand(1,3).*[delta_L delta_a delta_b];
    % A good way to initialize is to spread them equally in the L*a*b* space
    mu(i,:)=i/(K+1)*[delta_L delta_a delta_b];
end

end