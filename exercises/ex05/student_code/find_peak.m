function peak = find_peak(X, x0, r, kd_tree)

    cur_x = x0;
    thre = 1; 
    shift_dis = realmax;
    
    while(shift_dis>thre)
       neighbor_idx = rangesearch(kd_tree,cur_x,r);
       
       window=X(neighbor_idx{1},:);
       new_x=mean(window,1);
       shift_dis=norm(new_x-cur_x);
       cur_x=new_x;
    end
    
    peak = cur_x;

end