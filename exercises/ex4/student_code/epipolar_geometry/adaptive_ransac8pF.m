% Compute the fundamental matrix using the eight point algorithm and RANSAC
% Input
%   x1, x2 	  Point correspondences 3xN
%   threshold     RANSAC threshold
%
% Output
%   best_inliers  Boolean inlier mask for the best model
%   best_F        Best fundamental matrix
%
function [best_inliers, best_F] = adaptive_ransac8pF(x1, x2, threshold)

iter = 1000;

num_pts = size(x1, 2); % Total number of correspondences
best_num_inliers = 0; best_inliers = [];
best_F = 0;
p = 0;
M = 0;

iter_count=0;

while p<0.99
    x1_rand = [];
    x2_rand = [];
    % Randomly select 8 points and estimate the fundamental matrix using these.
    pts_index = randsample(num_pts, 8);
    for j = 1:8
        x1_rand =[x1_rand x1(:, pts_index(j))];
        x2_rand =[x2_rand x2(:, pts_index(j))];
    end
    [Fh, F] = fundamentalMatrix(x1_rand, x2_rand);
    % Compute the Sampson error.
    epi_lines2 = Fh*x1;
    epi_lines1 = Fh'*x2;
    S1 = distPointsLines(x1, epi_lines1);
    S2 = distPointsLines(x2, epi_lines2);
    S = S1+S2;
    % Compute the inliers with errors smaller than the threshold.
    inliers = [];
    for j = 1:num_pts
        if S(j)<threshold
           inliers = [inliers j]; 
        end
    end
    % Update the number of inliers and fitting model if the current model
    % is better.
    num_inliers = size(inliers, 2);
    if num_inliers>best_num_inliers
        best_num_inliers = num_inliers
        best_inliers = inliers;
        best_F = Fh;
    end
    r = best_num_inliers/num_pts;
    M = M+1;% number of trials conducted so far
    N = 8;
    p = 1-((1-r^N))^M;
    best_num_inliers;
    p;
    M;
    
    iter_count=iter_count+1;
end

iter_count

end


