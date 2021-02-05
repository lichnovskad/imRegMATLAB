function [err, panorama] = warpTwoImages(scene, imOrder,tforms, xLimits, yLimits, RES)

% Width and height of panorama.
width  = round(xLimits(2) - xLimits(1));
height = round(yLimits(2) - yLimits(1));

% Initialize the "empty" panorama.
I = scene{imOrder(1)};
I = imresize(I,RES);
panorama = zeros([width height  3], 'like', I);

blender = vision.AlphaBlender('Operation', 'Binary mask', ...
    'MaskSource', 'Input port');  

% Create a 2-D spatial reference object defining the size of the panorama.
panoramaView = imref2d([width height], xLimits, yLimits);
S = [RES 0 0; 0 RES 0; 0 0 1];

mask = {};
images = {};
% Create the panorama.
for i = 1:numel(imOrder)
    
    I = scene{imOrder(i)};
    I = imresize(I,RES);
    % Make tform for different size RES
    tforms(i).T = S\tforms(i).T*S;
    
    % Transform I into the panorama.
    warpedImage = imwarp(I, tforms(i), 'OutputView', panoramaView);
    images{i} = warpedImage;
    
    % Generate a binary mask.    
    mask{i} = imwarp(true(size(I,1),size(I,2)), tforms(i), 'OutputView', panoramaView);
    
end
% spocitam chybu
% pracovat v doublu! uint8 prevadi zaporne hodnoty na 0
difrMask = (mask{1} == 1) & (mask{2} == 1);

im1 = rgb2gray(images{1});
im2 = rgb2gray(images{2});

im1(difrMask==0) = 0;
im2(difrMask==0) = 0;

errMat = abs(im2 - im1);
%imshow v doublu je (0,1)
%imshow(rot90(errMat,1));

err = sum(sum(errMat));

% Overlay the warpedImage onto the panorama.
panorama = step(blender, panorama, images{1}, mask{1});
panorama = step(blender, panorama, images{2}, mask{2});

%panorama = imoverlay(panorama, edge(mask{1}),'blue');
%panorama = imoverlay(panorama, edge(mask{2}),'red');
end