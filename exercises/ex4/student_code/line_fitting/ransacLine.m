function [best_k, best_b] = ransacLine(data, iter, threshold)
% data: a 2xn dataset with n data points
% iter: the number of iterations
% threshold: the threshold of the distances between points and the fitting line

num_pts = size(data, 2); % Total number of points
best_num_inliers = 0;   % Best fitting line with largest number of inliers
best_k = 0; best_b = 0;     % parameters for best fitting line

for i=1:iter
    % Randomly select 2 points and fit line to these
    % Tip: Matlab command randperm / randsample is useful here
    random_sample=randperm(num_pts);
    pt1=data(:,random_sample(1));
    pt2=data(:,random_sample(2));
    
    % Model is y = k*x + b. You can ignore vertical lines for the purpose
    % of simplicity.
    k=(pt1(2)-pt2(2))/(pt1(1)-pt2(1));
    b=(pt1(1)*pt2(2)-pt2(1)*pt1(2))/(pt1(1)-pt2(1));
    
    % Compute the distances between all points with the fitting line
    dis=abs([k -1]*data+ones(1,num_pts)*b)/sqrt(k*k+1);
    
    % Compute the inliers with distances smaller than the threshold
    inlier_idx=find(dis<threshold);
    inlier_count=size(inlier_idx,2);
    
    % Update the number of inliers and fitting model if the current model
    % is better.
    if(inlier_count>best_num_inliers)
        best_num_inliers=inlier_count;
        best_k=k;
        best_b=b;
    end
    
end


end
