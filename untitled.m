%%
clc;clear;close all;
%str = '/home/daniela/Dropbox/vid16.mov';
str = '/home/daniela/Plocha/Bakalářka/dataset/video/vid7.mov';
[frameList, fmVect] = makeImSet(str);
%%
buildingDir = fullfile('vidSet');

buildingScene = imageDatastore(buildingDir);
%preidexovat spatne nactene poradi
[~, reindex] = sort( str2double( regexp( buildingScene.Files, '\d+', 'match', 'once' )));
buildingScene.Files=buildingScene.Files(reindex);

numImages = numel(buildingScene.Files);

imList = {};
for i = 1:numImages
    I = readimage(buildingScene, i);
%     [h, w, ~] = size(I);
%     K = [1500, 0, w/2; 0, 1500, h/2; 0, 0, 1];
%     I = cylWarp(I,K);
%     imshow(I);
    imList{i} = I;
end

[pan, imOrder] = registrace(imList, false);
%%
cylPan = rot90(pan,1);
[h, w, ~] = size(cylPan);
K = [1200, 0, w/2; 0, 800, h/2; 0, 0, 1];
cylPan = cylWarp(cylPan,K);
cylPan = rot90(cylPan,3);
imshow(cylPan);