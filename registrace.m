function [pan, imOrder] = registrace(input,output, resize,colBorder,type)

inputFolder = fullfile(input);
buildingScene = imageDatastore(inputFolder);

numImages = numel(buildingScene.Files);
imOrder = (1:numImages);

scene = {};
for i = 1:numImages
    I = readimage(buildingScene, i);
    scene{i} = I;
end

[tforms, ImSize] = computeTForms(imOrder, scene,type,resize{1});
mkdir(output{1});
save(strcat(output{1},'tforms'));

% Compute the output limits  for each transform
centerImageIdx = floor(numel(imOrder)/2)+1;

Tinv = invert(tforms(centerImageIdx));
for j = 1:numel(tforms)    
    tforms(j).T = tforms(j).T * Tinv.T;
end

[xLimits, yLimits] = computeLimits(tforms, ImSize,resize{2});
[pan,~] = createPanorama(scene, imOrder, tforms, xLimits, yLimits, colBorder,resize{2});
imName = strcat(fullfile(output{1}),output{2},'.png');
imwrite(pan,imName);


end