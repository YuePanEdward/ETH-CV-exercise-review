function [map cluster] = EM(img)

%1. Create density function X (L*3)
img = double(img);
row_num=size(img,1);
col_num=size(img,2);
L = row_num*col_num
X = [reshape(img(:,:,1)',[L,1]),reshape(img(:,:,2)',[L,1]),reshape(img(:,:,3)',[L,1])];

%Number of segments
K = 3;

%Size of the L*a*b space
delta_L = max(X(:,1)) - min(X(:,1));
delta_a = max(X(:,2)) - min(X(:,1));
delta_b = max(X(:,3)) - min(X(:,3));

% 2. Generate initial parameters
% alpha
cur_alpha = 1/K * ones(1,K);

% use function generate_mu to initialsize mus
cur_mu = generate_mu(delta_L, delta_a, delta_b, K);

% use function generate_cov to initialize covariances
cur_cov = generate_cov(delta_L, delta_a, delta_b, K);
 
% 3. Iterate between maximization and expectation
thre = 0.5;
delta_mu = realmax;
iter_count = 0;

while delta_mu > thre
    % use function expectation
    L = expectation(cur_mu,cur_cov,cur_alpha,X);
    
    % use function maximization
    [new_mu, new_cov, new_alpha] = maximization(L, X);
    
    % termination_calculation
    delta_mu_k=[];
    for i=1:K
        delta_mu_k(i,:)=norm(new_mu(i,:)-cur_mu(i,:));
    end
    delta_mu = max(delta_mu_k);
    
    % update variables
    cur_mu = new_mu;
    cur_cov = new_cov;
    cur_alpha = new_alpha;
   
    iter_count = iter_count + 1
    
    cur_mu
    cur_cov
    cur_alpha
end

[~,k_index] = max(L,[],2);
map = reshape(k_index,[col_num row_num])';
cluster = cur_mu;

end