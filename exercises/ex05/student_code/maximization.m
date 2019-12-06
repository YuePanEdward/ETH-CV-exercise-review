function [mu, var, alpha] = maximization(P, X)

% sizes of parameters
K = size(P,2);
L=  size(X,1);
% declaration of outputs
alpha = [];
mu = [];
var = [];

mean_P=mean(P,1);

for k = 1:K
    alpha(k) = mean_P(k);
    mu(k,:) = P(:,k)'*X/(alpha(k)*L);
    var_temp=[];
    for i = 1:L
        var_temp(:,:,i) = P(i,k)*((X(i,:)-mu(k,:))'*(X(i,:)-mu(k,:)));
    end
    var(:,:,k) = sum(var_temp,3)/(alpha(k)*L);
end

end
