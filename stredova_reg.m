%%
clc;clear;close all
%buildingDir = fullfile('data', 'set10');
buildingDir = fullfile('vidSet');
buildingScene = imageDatastore(buildingDir);
%preidexovat spatne nactene poradi
[~, reindex] = sort( str2double( regexp( buildingScene.Files, '\d+', 'match', 'once' )))
buildingScene.Files=buildingScene.Files(reindex)

colBorder = true;
cutNumber = 0.3;

numImages = numel(buildingScene.Files);
RES1 = 1;
RES2 = 0.5;
%Use only even/odd/all images
imOrder = [];
for i = 1:numImages
    %k = 2*i-1; %odd only
    k = 2*i; %even only
    %k = i; %normal
    if k > numImages
        break;
    end 
    imOrder(i) = k;
end

numImages = numel(imOrder);
%Find centre image
imCentre = round(numImages/2);

rightOrder = zeros(1,numel(imOrder(imCentre:end)));
leftOrder = zeros(1,numel(imOrder(1:imCentre)));

%split left/right sides
for i = 1:size(rightOrder,2)
    rightOrder(i) = imOrder(imCentre-1+i);
end
for i = 1:size(leftOrder,2)
    leftOrder(i) = imOrder(imCentre + 1 -i);
end
%% getTforms
[tforms, imSize] = computeTForms(imOrder, buildingScene,RES1);

normTforms = {};
move = {};
for i = 1:numel(imOrder)
   normTforms{i}= tforms(i).T/tforms(i).T(3,3);
   move{i} = normTforms{i}(1:2,3);
end
%% kontrola registrace

error = [];
pixNum = 1920*1080;
delete('vidSet/output/*');
for i = 1:numel(imOrder)-1
ord = [i+1 i];
[tforms, imSize] = computeTForms(ord, buildingScene,RES1);
[xLimits, yLimits] = computeLimits(tforms, imSize, RES2);
[error(i), result] = warpTwoImages(buildingScene, ord, RES2,tforms, xLimits, yLimits);
error(i) = error(i)/pixNum;
numStr = int2str(i);
imName = strcat('vidSet/output/reg',numStr,'.png');
imwrite(rot90(result,1),imName);
close all;
end
%plot(error);

% TODO: odstranit a nahradit snimky co se spatne transformuji
% TODO: spojit computeLimits a computeTforms do 1 funkce 
%% Registrace leve strany

%RES=1;
lPer = 0;
while min(lPer) < cutNumber
    [leftTforms, leftImSize] = computeTForms(leftOrder, buildingScene,RES1);
    [lxLimits, lyLimits] = computeLimits(leftTforms, leftImSize, RES2);
    [leftPan,lPer] = createPanorama(buildingScene, leftOrder, RES2, leftTforms, lxLimits, lyLimits, colBorder);
    cutLeft = find(lPer == min(lPer));
    if min(lPer) < cutNumber
        leftOrder(cutLeft) = [];
    end
end
imwrite(rot90(leftPan,1), "vidSet/output/panPart1.png");
%% Registrace prave strany
rPer = 0;
while min(rPer) < cutNumber
    [rightTforms, rightImSize] = computeTForms(rightOrder, buildingScene,RES1);
    [rxLimits, ryLimits] = computeLimits(rightTforms, rightImSize, RES2);
    [rightPan,rPer] = createPanorama(buildingScene, rightOrder, RES2, rightTforms, rxLimits, ryLimits, colBorder);
    cutRight = find(rPer == min(rPer));
    if min(rPer) < cutNumber
        rightOrder(cutRight) = [];
    end
end
imwrite(rot90(rightPan,1), "vidSet/output/panPart2.png");

%% Registrace 2 stran dohromady
panoParDir = fullfile('vidSet/output');
panoParts = imageDatastore(panoParDir);

colBorder = false;

[finTform, finImSize] = computeTForms([1 2], panoParts, RES1);
[finxLimits, finyLimits] = computeLimits(finTform, finImSize, RES1);
finalPan = createPanorama(panoParts, [1 2], RES1, finTform, finxLimits, finyLimits, colBorder);

imwrite(rot90(finalPan,3), "vidSet/output/final.png");
imshow(rot90(finalPan,1));