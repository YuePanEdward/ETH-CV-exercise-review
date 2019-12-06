function visualizeSegmentationResults (map,vals)
 
% vals contains K values of dimension D
% in a K x D matrix

K = size(vals,1);
D = size(vals,2);

figure(1);
imagesc(map);

valImg = zeros(size(map,1),size(map,2),D);

for d=1:D
    valImgd = zeros(size(map,1),size(map,2));
    for k=1:K
        valImgd = valImgd + (map==k) * vals(k,d);
    end
    valImg(:,:,d) = valImgd;
end

figure(2);
imshow(uint8(valImg));

end