% Compute the fundamental matrix using the eight point algorithm
% Input
% 	x1s, x2s 	Point correspondences 3xN
%
% Output
% 	Fh 		Fundamental matrix with the det F = 0 constraint
% 	F 		Initial fundamental matrix obtained from the eight point algorithm
%
function [Fh, F] = fundamentalMatrix(x1s, x2s)

   corr_num=size(x1s,2);

   % 1. normalization
   [nx1s, T1] = normalizePoints2d(x1s);
   [nx2s, T2] = normalizePoints2d(x2s);
   
   % 2. assign value for A matrix
   A=[];
   for i=1:corr_num
       A(i,1)=nx1s(1,i)*nx2s(1,i);
       A(i,2)=nx1s(1,i)*nx2s(2,i);
       A(i,3)=nx1s(1,i);
       A(i,4)=nx1s(2,i)*nx2s(1,i);
       A(i,5)=nx1s(2,i)*nx2s(2,i);
       A(i,6)=nx1s(2,i);
       A(i,7)=nx2s(1,i);
       A(i,8)=nx2s(2,i);
       A(i,9)=1;
   end
   
   % 3. slove initial fundamental matrix
   % A f = 0 -> f: right null space of A
   [U,D,V]=svd(A);
   fn=V(:,size(V,2));
   Fn=reshape(fn,[3 3])';
   F=T2'*Fn*T1;
   
   % 4. enforce singularity constraint
   [U,D,V]=svd(F);
   Dh=zeros(3);
   Dh(1,1)=D(1,1);
   Dh(2,2)=D(2,2);
   Fh=U*Dh*V';
   

end