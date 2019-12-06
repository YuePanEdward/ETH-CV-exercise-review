function C = chi2_cost(scd1, scd2)
%CHI2_COST Summary of this function goes here
%   Detailed explanation goes here
% Inputs:
% s1 and s2: shape context descriptors of two point sets
% C: cost matrix 

% For hungarian algorithm, C should be square matrix 
% So if you don't smaple the point to the same size, you should add some
% dummy nodes to both side of the bipartite graph and assign a relatively 
% large threshold value for it.
k1 = numel(scd1);
k2 = numel(scd2);

% C size: k1*k2 mutual similarity
C=zeros(k1,k2);

for i=1:k1
    for j=1:k2
       cost = (scd1{i}-scd2{j}).^2 ./(scd1{i}+scd2{j});
       % get rid of possible nan_s
       cost(isnan(cost)) = 0;
       C(i,j) = 0.5*sum(sum(cost));
    end
end
end

