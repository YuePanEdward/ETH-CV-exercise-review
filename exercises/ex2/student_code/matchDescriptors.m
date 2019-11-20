% Match descriptors.
%
% Input:
%   descr1        - k x q descriptor of first image
%   descr2        - k x q' descriptor of second image
%   matching      - matching type ('one-way', 'mutual', 'ratio')
%   
% Output:
%   matches       - 2 x m matrix storing the indices of the matching
%                   descriptors
function matches = matchDescriptors(descr1, descr2, matching)
    distances = ssd(descr1, descr2);
    
    if strcmp(matching, 'one-way')
        [min_dis,descr2_idx]=min(distances,[],2); % for each one in desrc1, find its nn in desrc2
        matches=zeros(2,size(distances,1));
        for i=1:size(distances,1)
            matches(1,i)=i;
            matches(2,i)=descr2_idx(i);
        end
        
        %error('Not implemented.');    
    elseif strcmp(matching, 'mutual')
        [min_dis,descr2_idx]=min(distances,[],2); % for each one in desrc1, find its nn in desrc2
        [min_dis,descr1_idx]=min(distances,[],1); % for each one in desrc2, find its nn in desrc1
        matches=[];
        for i=1:size(distances,1)
            if descr1_idx(descr2_idx(i))==i
               matches=[matches [i;descr2_idx(i)]];
            end 
        end
        
        %error('Not implemented.');
    elseif strcmp(matching, 'ratio')
        
        threshold=0.5;
        
        [min_dis_first,descr2_first_idx]=min(distances,[],2); % for each one in desrc1, find its first nn in desrc2
        distances(:,descr2_first_idx)= realmax;
        [min_dis_second,descr2_second_idx]=min(distances,[],2); % for each one in desrc1, find its second nn in desrc2
        matches=[];
        for i=1:size(distances,1)
            if (min_dis_first(i)/min_dis_second(i)<threshold)
               matches=[matches [i;descr2_first_idx(i)]];
            end 
        end
        % there's no mink function in current version of matlab (R2016a)
        
        %error('Not implemented.');
    else
        error('Unknown matching type.');
    end
end

function distances = ssd(descr1, descr2)
   distances=zeros(size(descr1,2),size(descr2,2));
   for i=1:size(distances,1)
       for j=1:size(distances,2)
           distances(i,j)=sum((descr1(:,i)-descr2(:,j)).^2);
       end
   end
   
   %error('Not implemented.');
end