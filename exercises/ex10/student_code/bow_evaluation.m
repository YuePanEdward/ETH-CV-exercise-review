%
% BAG OF WORDS RECOGNITION EXERCISE
% Alex Mansfield and Bogdan Alexe, HS 2011
% Denys Rozumnyi, HS 2019

%training
disp('creating codebook');
sizeCodebook = 10;
vCenters = create_codebook('../data/cars-training-pos','../data/cars-training-neg',sizeCodebook);
%keyboard;
disp('processing positve training images');
vBoWPos = create_bow_histograms('../data/cars-training-pos',vCenters);
disp('processing negative training images');
vBoWNeg = create_bow_histograms('../data/cars-training-neg',vCenters);
%vBoWPos_test = vBoWPos;
%vBoWNeg_test = vBoWNeg;
%keyboard;
disp('processing positve testing images');
vBoWPos_test = create_bow_histograms('../data/cars-testing-pos',vCenters);
disp('processing negative testing images');
vBoWNeg_test = create_bow_histograms('../data/cars-testing-neg',vCenters);

nrPos = size(vBoWPos_test,1);
nrNeg = size(vBoWNeg_test,1);

test_histograms = [vBoWPos_test;vBoWNeg_test];
labels = [ones(nrPos,1);zeros(nrNeg,1)];

disp('______________________________________')
disp('Nearest Neighbor classifier')
bow_recognition_multi(test_histograms, labels, vBoWPos, vBoWNeg, @bow_recognition_nearest);
disp('______________________________________')
disp('Bayesian classifier')
bow_recognition_multi(test_histograms, labels, vBoWPos, vBoWNeg, @bow_recognition_bayes);
disp('______________________________________')
