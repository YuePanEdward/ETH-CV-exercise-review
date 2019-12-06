sample_num=8;
inlier_ratio=linspace(0.05,0.5,10);
bbb=1-inlier_ratio.^sample_num;

p_thre=[0.9 0.95 0.99 0.999];
iter_num=[];

for i=1:size(p_thre,2)
    for j=1:size(inlier_ratio,2)
        iter_num(i,j)=logn(1-p_thre(i),bbb(j));
    end
end

iter_num