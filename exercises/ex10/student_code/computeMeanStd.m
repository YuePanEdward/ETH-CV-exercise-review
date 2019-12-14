function [mu sigma] = computeMeanStd(vBoW)
    mu = mean(vBoW);
    sigma = std(vBoW);

end