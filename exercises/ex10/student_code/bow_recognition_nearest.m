function sLabel = bow_recognition_nearest(histogram,vBoWPos,vBoWNeg)
  
 % Find the nearest neighbor (using knnsearch) in the positive and negative sets
  % and decide based on this neighbor
  [~, DistPos] = knnsearch(vBoWPos, histogram);
  [~, DistNeg] = knnsearch(vBoWNeg, histogram);
  
  if (DistPos<DistNeg)
    sLabel = 1;
  else
    sLabel = 0;
  end
  
end
