function scd = sc_compute( X,nbBins_theta,nbBins_r,smallest_r,biggest_r )
%SC COMPUTE Summary of this function goes here
%   Detailed explanation goes here

% Input:
% X: set of points (2*k)
% nbBins_theta: number of bins in the angular dimension
% nbBins_r:number of bins in the radial dimension
% smallest_r: the length of the smallest radius
% biggest_r: the length of the biggest radius
% Output:
% d: shape context descriptors of all input points

X = X';                         % transpose to size k*2 
k = size(X,1);                  % k points in total
scd = cell(k,1);                % create shape context descriptors (cell structure instead of tensor)
norm_scale = mean2(sqrt(dist2(X,X))); % normalizing scale: the mean of all the pairwise distance (a bit time_consuming)

min_r_index = log(smallest_r);
max_r_index = log(biggest_r);
d_r_index = (max_r_index-min_r_index)/nbBins_r; % ln(r) divide into nbBins_r equally size grid 
r_grid = linspace(min_r_index,max_r_index-d_r_index,nbBins_r);

% divide grids
d_theta = 2*pi/nbBins_theta;
theta_grid = linspace(0,2*pi-d_theta,nbBins_theta);

% for each point
for i=1:k
    % store current point in cur
    cur = X(i,:);
    
    % calculate distance from current point to all other points of X
    cur_rep = repmat(cur,k,1);
    dist_vec = cur_rep - X;
    dist_vec(i,:) = []; % delete distance with the point itself
     
    % Transform from cart coordinate to polar coordinate
    [theta,r] = cart2pol(dist_vec(:,1),dist_vec(:,2));
    % apply normalization
    r_norm=r/norm_scale;
    % create 2-dimensional histogram (used as descriptor)
    scd{i} = hist3([theta log(r_norm)],'Edges',{theta_grid, r_grid});
  
    % show the feature of the point
    if mod(i,100)==0
        figure(6);
        imshow(scd{i},[0 20]);
        truesize([nbBins_theta*20 nbBins_r*20]);
    end
end

end

