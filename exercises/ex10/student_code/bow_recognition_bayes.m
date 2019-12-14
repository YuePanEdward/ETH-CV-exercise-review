function label = bow_recognition_bayes( histogram, vBoWPos, vBoWNeg)

[muPos sigmaPos] = computeMeanStd(vBoWPos);
[muNeg sigmaNeg] = computeMeanStd(vBoWNeg);

% Calculating the probability of appearance each word in observed histogram
% according to normal distribution in each of the positive and negative bag of words

p_pos = 0; 
p_neg = 0 ;

for i = 1:size(vBoWPos,2)
    if (sigmaPos(i) < 0.5)
        sigmaPos(i) = 0.5 ;
    end
    log_add=log(normpdf(histogram(i),muPos(i), sigmaPos(i)));
    p_pos = p_pos + log_add;

    if (sigmaNeg(i) < 0.5)
        sigmaNeg(i) = 0.5 ;
    end
    log_add=log(normpdf(histogram(i),muNeg(i), sigmaNeg(i)));
    p_neg = p_neg + log_add; 
end

label = 0;
if p_pos > p_neg
    label = 1;
end

end