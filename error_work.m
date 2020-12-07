buildingDir = fullfile('vidSet');

buildingScene = imageDatastore(buildingDir);
%preidexovat spatne nactene poradi
[~, reindex] = sort( str2double( regexp( buildingScene.Files, '\d+', 'match', 'once' )));
buildingScene.Files=buildingScene.Files(reindex);

numImages = numel(buildingScene.Files);

imList = {};y
for i = 1:numImages
    imList{i} = readimage(buildingScene, i);
end
%%
pixNum = 1920*1080;
A = zeros(pixNum,8);
for i=1:numel(imList)
    I = imList{i};
    I = rgb2gray(I);
    A(:,i) = I(:);
end
%%
mean(std(A))