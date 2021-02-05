function [panorama, per]=createPanorama(scene, imOrder,tforms, xLimits, yLimits, colBorder, RES)

width  = round(xLimits(2) - xLimits(1));
height = round(yLimits(2) - yLimits(1));

% Initialize the "empty" panorama.
I = scene{imOrder(1)};
I = imresize(I,RES);
panorama = zeros([height width 3], 'like', I);

% Width and height of panorama.

blender = vision.AlphaBlender('Operation', 'Binary Mask', ...
    'MaskSource', 'Input port');  

% Create a 2-D spatial reference object defining the size of the panorama.
panoramaView = imref2d([height width], xLimits, yLimits);
S = [RES 0 0; 0 RES 0; 0 0 1];

mask = {};
images = {};
points = {};
% Create the panorama.
for i = 1:numel(imOrder)
    
    I = scene{imOrder(i)};
    I = imresize(I,RES);
    % Make tform for different size RES
    tforms(i).T = S\tforms(i).T*S;
    
    % Tranform points
    imPoints = [0 0 size(I,2) size(I,2); 0 size(I,1) size(I,1) 0];
   
    [x, y] = transformPointsForward(tforms(i),imPoints(1,:), imPoints(2,:));
    [x, y] = worldToIntrinsic(panoramaView, x,y );
    points{i} = [x; y];
    
    % Transform I into the panorama.
    warpedImage = imwarp(I, tforms(i), 'OutputView', panoramaView);
    images{i} = warpedImage;         

    % Generate a binary mask.    
    mask{i} = imwarp(true(size(I,1),size(I,2)), tforms(i), 'OutputView', panoramaView);
    maskCyl = rgb2gray(warpedImage) > 1;
    maskCyl = imfill(maskCyl, 'holes');
    % Overlay the warpedImage onto the panorama.
    panorama = step(blender, panorama, warpedImage, maskCyl);
    %panorama = insertShape(panorama,'Polygon',reshape(points{i}, [1,8]),'LineWidth',5, 'Color', {['blue']});
end

% Make colored borders
if colBorder == true
    
    K=1;
    for i = 1:numel(imOrder)

        colorNames = {'blue','red','green','yellow'};
        panorama = insertShape(panorama,'Polygon',reshape(points{i}, [1,8]),'LineWidth',5, 'Color', colorNames(K));
        K = K+1;
        if K>4
            K=1;
        end
    end
end  
% Find overlapping images

if numel(imOrder) > 2

    for k = 1:numel(mask)-2
        A = mask{k} + mask{k+2};
        C = mask{k+1};
        C(A~=0) = 0; 
        B = mask{k+1};
        per(k) = (sum(sum(C))/sum(sum(B)))*100; 
    end
end
end