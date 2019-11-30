function matchingCost = shape_matching_bak(X,Y,display_flag)

%Model matching
%computes the matching cost between template contour points X and target contour points Y  

%%%
%%%Define flags and parameters:
%%%

if nargin < 3
    display_flag = 0;
end

nbSamples = size(X,1);
nbBins_theta = 12;
nbBins_r = 5;
smallest_r = 1/8;  %length of the smallest radius (assuming normalized distances)
biggest_r = 3;     %length of the biggest radius (assuming normalized distances)
maxIterations = 6;


if display_flag
   figure(1)
   subplot(1,2,1)
   plot(X(:,1),X(:,2),'b+')
   axis('ij'), title('X');
   subplot(1,2,2)
   plot(Y(:,1),Y(:,2),'ro')
   axis('ij'), title('Y');
   drawnow	
end

if display_flag
   [x,y] = meshgrid(linspace(min(X(:,1))-10,max(X(:,1))+10,36),...
                    linspace(min(X(:,2))-10,max(X(:,2))+10,36));
   x = x(:);
   y = y(:);
   M = length(x);
end

%set lambda here  (then you can just calculate it once since Y would not transform)
mean_dist = mean(mean(sqrt(dist2(Y,Y)))); % normalizing scale: the mean of all the pairwise distance
lambda = mean_dist^2;  


% matching energy for each iteration
E_iter=zeros(maxIterations,1);

%%%
%%% compute correspondences
%%%
currentX = X;
currentIteration = 1;



while currentIteration <= maxIterations
   
   figure_index=currentIteration+1;
    
   disp(['iter=' int2str(currentIteration)]);

   %write the sc_compute.m function
   % compute shape context desciptors for each point in both point sets
   disp('computing shape contexts for (deformed) model...')
   ShapeDescriptors1 = sc_compute(currentX',nbBins_theta,nbBins_r,smallest_r,biggest_r);
   disp('done.')
      
   disp('computing shape contexts for target...')
   ShapeDescriptors2 = sc_compute(Y',nbBins_theta,nbBins_r,smallest_r,biggest_r);
   disp('done.')
   
   %write the chi2_cost.m function 
   % Use chi2_cost to calculate pairwise similarity between points
   costMatrixC = chi2_cost(ShapeDescriptors1,ShapeDescriptors2);   
   
   % Use hungarian to calculate the correspondences by applying a bipartite
   % graph maximum weight matching
   corespondencesIndex = hungarian(costMatrixC);   
       
   Xwarped = currentX(corespondencesIndex,:);   
   Xunwarped = X(corespondencesIndex,:);         

   if display_flag       
      figure(figure_index)
      subplot(1,3,2)
      plot(Xwarped(:,1),Xwarped(:,2),'b+',Y(:,1),Y(:,2),'ro')
      hold on
      plot([Xwarped(:,1) Y(:,1)]',[Xwarped(:,2) Y(:,2)]','k-');      
      hold off
      axis('ij')
      title(' correspondences (warped X)', 'fontName','Times New Roman','fontSize',16)
      drawnow	
   end
   
   if display_flag
      % show the correspondences between the untransformed images
      figure(figure_index)
      subplot(1,3,1)
      plot(X(:,1),X(:,2),'b+',Y(:,1),Y(:,2),'ro')      
      hold on
      plot([Xunwarped(:,1) Y(:,1)]',[Xunwarped(:,2) Y(:,2)]','k-')
      hold off
      axis('ij')
      title(' correspondences (unwarped X)', 'fontName','Times New Roman','fontSize',16)
      drawnow	
   end
   
   % Use tps_model to estimate the transformation from correspondences
   [w_x,w_y,E] = tps_model(Xunwarped,Y,lambda);
   E_iter(currentIteration)=E;
   disp(['#iter:',num2str(currentIteration),', bending energy:',num2str(E)]);
   
   % warp each coordinate   
   fx_aff = w_x(nbSamples+1:nbSamples+3)'*[ones(1,nbSamples); X'];
   d2 = max(dist2(Xunwarped,X),0);  
   U = d2.*log(d2+eps);
   fx_wrp = w_x(1:nbSamples)'*U;
   fx = fx_aff+fx_wrp;   
   
   fy_aff = w_y(nbSamples+1:nbSamples+3)'*[ones(1,nbSamples); X'];
   fy_wrp = w_y(1:nbSamples)'*U;
   fy = fy_aff+fy_wrp;

   % update currentX for the next iteration
   currentX = [fx; fy]';   

   if display_flag
      figure(figure_index)
      subplot(1,3,3)
      plot(currentX(:,1),currentX(:,2),'b+',Y(:,1),Y(:,2),'ro');
      axis('ij')
      title(['iteration=' int2str(currentIteration) ',  I_f=' num2str(E) ], 'fontName','Times New Roman','fontSize',16)
      % show warped coordinate grid
      fx_aff=w_x(nbSamples+1:nbSamples+3)'*[ones(1,M); x'; y'];
      d2 = dist2(Xunwarped,[x y]);
      fx_wrp = w_x(1:nbSamples)'*(d2.*log(d2+eps));
      fx = fx_aff+fx_wrp;
      fy_aff = w_y(nbSamples+1:nbSamples+3)'*[ones(1,M); x'; y'];
      fy_wrp = w_y(1:nbSamples)'*(d2.*log(d2+eps));
      fy = fy_aff+fy_wrp;
      hold on
      plot(fx,fy,'k.','markersize',1)
      hold off
      drawnow
   end         

   %update currentIteration
   currentIteration = currentIteration + 1;
   
end

figure(10)
plot(E_iter)
xlabel('iteration')
ylabel('bending energy')


matchingCost = E_iter;