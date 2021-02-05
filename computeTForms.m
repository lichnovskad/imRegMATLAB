function [tforms, imageSize] = computeTForms(imOrder, scene, type, RES)

% Read the first image from the image set.
I = scene{imOrder(1)};
% Initialize features for I(1)
grayImage = rgb2gray(I);
I = imresize(I,RES);

points = detectSURFFeatures(grayImage);
%points = selectStrongest(points, strongPoints);
[features, points] = extractFeatures(grayImage, points);

% Initialize all the transforms to the identity matrix. Note that the
% projective transform is used here because the building images are fairly
% close to the camera. Had the scene been captured from a further distance,
% an affine transform would suffice.
numImages = numel(imOrder);
if type == "projective"
    tforms(numImages) = projective2d(eye(3));
end
if or(type == "affine",type == "similarity")
    tforms(numImages) = affine2d(eye(3));
end

% Initialize variable to hold image sizes.
imageSize = zeros(numImages,2);
imageSize(1,:) = size(grayImage);
% Iterate over remaining image pairs
for n = 2:numImages
    
    % Store points and features for I(n-1).
    pointsPrevious = points;
    featuresPrevious = features;
        
    % Read I(n).
    I = scene{imOrder(n)};
    % Convert image to grayscale.
    grayImage = rgb2gray(I);
    I = imresize(I,RES);
    % Save image size.
    imageSize(n,:) = size(grayImage);
    
    % Detect and extract SURF features for I(n).
    points = detectSURFFeatures(grayImage);
    %points = selectStrongest(points, strongPoints);
    [features, points] = extractFeatures(grayImage, points);
  
    % Find correspondences between I(n) and I(n-1).
    indexPairs = matchFeatures(features, featuresPrevious, 'Unique', true,'Method', 'Approximate');
       
    matchedPoints = points(indexPairs(:,1), :);
    matchedPointsPrev = pointsPrevious(indexPairs(:,2), :);        

    % Estimate the transformation between I(n) and I(n-1).
    tforms(n) = estimateGeometricTransform(matchedPoints, matchedPointsPrev,...
        type, 'Confidence', 99, 'MaxNumTrials', 2000);

    % Compute T(n) * T(n-1) * ... * T(1)
    tforms(n).T = double(tforms(n).T) * tforms(n-1).T; 
end

end