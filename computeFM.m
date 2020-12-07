function [frameVect, fmVect] = computeFM(vid, K)
%
M = [0 1 0; 1 -4 1; 0 1 0];
%K = 1; %kazdy i-ty snimek

frameNum = vid.NumFrames;
n = round(frameNum/K) - 1;

fmVect = zeros(n,1);
frameVect = zeros(n,1);

for i=1:n
    current_image = read(vid,i*K);

    I = conv2(double(rgb2gray(current_image)), M,'valid');

    I = abs(I);
    fm = sum(I(:));

    fmVect(i) = fm;
    frameVect(i) = i*K; 
end
%plot(frameVect, fmVect);
end