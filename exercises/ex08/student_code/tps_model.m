function [w_a_x, w_a_y, E] = tps_model(X,Y,lambda)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Inputs:
% X: points in the template shape (k*2)
% Y: corresponding points in the target shape
% lambda: regularization parameter
% Outputs:
% w_a_x: the parameters (wi and ai) in TPS for x
% w_a_y: the parameters (wi and ai) in TPS for y
% E: the total bending energy

k = size(X,1);

P_mat = [ones(k,1) X];                                      % size k x 3
K_mat = zeros(k);                                           % size k x k
for i=1:k
    for j=1:k
        K_mat(i,j)=U_func(sqrt(dist2(X(i,:),X(j,:))));
    end
end                    
A_mat = [ [K_mat+lambda*eye(k) P_mat]; [P_mat' zeros(3)]];  % size (k+3) x (k+3)

b_x = [Y(:,1); zeros(3,1)];    % size (k+3) x 1
b_y = [Y(:,2); zeros(3,1)];    % size (k+3) x 1

% Ax=b
w_a_x = A_mat\b_x;
w_a_y = A_mat\b_y;

w_x = w_a_x(1:k,:);
w_y = w_a_y(1:k,:);

E = w_x'*K_mat*w_x + w_y'*K_mat*w_y;

end


