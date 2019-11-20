function [map peak] = meanshiftSeg(img)
%1. Create density function X (L*3)
img = double(img);
row_num=size(img,1);
col_num=size(img,2);
L = row_num*col_num;
X = [reshape(img(:,:,1)',[L,1]),reshape(img(:,:,2)',[L,1]),reshape(img(:,:,3)',[L,1])];

%2. Mean shift
peak = []; 
map = zeros(L,1);
% change the radius
r = 5;

% Create k-d tree
kd_tree = createns(X,'nsmethod','kdtree');

for i=1:L
    % show progress
    if mod(i,100)==0
        i
    end
    
    %Find peak
    cur_peak = find_peak(X, X(i,:), r, kd_tree);
    
    %Generate the first peak
    if i==1
        peak = cur_peak;
        map(i) = 1;
    else
        %Check distance from current peak to all other peaks
        for j=1:size(peak,1)
            temp_dis=norm(cur_peak-peak(j,:));
            if (temp_dis<r/2) 
                 map(i) = j;
                 break;
            end
            if (j==size(peak,1))
                peak=[peak; cur_peak];
                map(i) = j+1;
            end
        end
    end
end

map=reshape(map,[col_num row_num])';
total_category=size(peak,1)

end