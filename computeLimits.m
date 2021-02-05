function [xLimits, yLimits] = computeLimits(tforms, imageSize, RES)

maxThresh = 20000;

imageSize = imageSize*RES;
S = [RES 0 0; 0 RES 0; 0 0 1];
% Compute the output limits  for each transform
for i = 1:numel(tforms)
    tforms(i).T = S\tforms(i).T*S;
    [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 imageSize(i,2)], [1 imageSize(i,1)]);    
end

maxImageSize = max(imageSize);

% Find the minimum and maximum output limits 
xMin = min([1; xlim(:)]);
xMax = max([maxImageSize(2); xlim(:)]);

yMin = min([1; ylim(:)]);
yMax = max([maxImageSize(1); ylim(:)]);

xLimits = [xMin xMax];
yLimits = [yMin yMax] ;

width  = round(xLimits(2) - xLimits(1));
height = round(yLimits(2) - yLimits(1));

if or(width > maxThresh, height > maxThresh)
    xLimits = [0 0];
    yLimits = [0 0];
    error(strcat('limit over threshold.W:',int2str(width),'|H:',int2str(height)));
end


end