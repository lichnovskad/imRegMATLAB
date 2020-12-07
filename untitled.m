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
    imList{i} = readimage(buildingScene, i);
end

[pan, imOrder] = registrace(imList, false);