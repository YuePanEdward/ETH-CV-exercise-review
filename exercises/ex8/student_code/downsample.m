function downsample_X = downsample(X,sample_num)
%DOWNSAMPLE Summary of this function goes here
%   Detailed explanation goes here
%  Inputs:
%  X: k*2
%  sample_num: number of samples

%  random downsample
original_num=size(X,1);
sample_num=min(sample_num,original_num);
rand_idx=randperm(original_num);
rand_idx_sample=rand_idx(1:sample_num);

X_x=X(:,1);
X_y=X(:,2);

downsample_X(:,1)=X_x(rand_idx_sample);
downsample_X(:,2)=X_y(rand_idx_sample);

end


