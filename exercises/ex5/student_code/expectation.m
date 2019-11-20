function P = expectation(mu,var,alpha,X)
% Expectation part: Calculate the possibility of belonging to one certain gaussian 
% for each sample point  
K = length(alpha);

P = [];

for i = 1:size(X,1)
    for k = 1:K
        index = -0.5*(X(i,:)-mu(k,:))*pinv(var(:,:,k))*(X(i,:)-mu(k,:))';
        P(i,k) = alpha(k)/((2*pi)^(3/2)*(det(var(:,:,k)))^(1/2))* exp(index);
    end
    P(i,:) = P(i,:)/sum(P(i,:));
end

end

