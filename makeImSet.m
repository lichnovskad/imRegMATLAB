<<<<<<< HEAD
function [frameList, fmVect] = makeImSet(video)
% strabs = '/home/daniela/Plocha/Bakalářka';
% str = 'dataset/video/vid9.mov';
% vid = VideoReader(fullfile(strabs,str));

vid = VideoReader(video);

%_____________________________________________________________
%spocita focus measure
[~, fmVect] = computeFM(vid, 1);

%PLOVOUCI OKNO
%odhad velikosti okna
frameNum = vid.NumFrames;
frameRate = round(vid.FrameRate);
maxDist = 100;
minDist = 37;
i = 1;
% modulo = mod(frameNum, maxDist);
% K = (frameNum-modulo)/maxDist);

frameList = [];

currFrame = [fmVect(1:frameRate), (1:frameRate)']; 
frameList(i) = find(fmVect==max(currFrame(:,1)));
last = frameList(1);

%compute errThresh
I = rgb2gray(read(vid, frameList(i)));
st = round(sum(I(:))/(1080*1920));
A = uint8(ones(1080,1920)*st);
B = (I-A).^2;
b = sum(B(:))/(1080*1920);
errThresh = sqrt(b);
disp('errThresh = ')
disp(errThresh);

%save image
=======
%% uncomment if needed
%loadvid('data/videa/IMG_0330.MOV', False);

%%
clc;clear;close all;
%str = 'data/videa/IMG_0330.MOV';
strabs = '/home/daniela/Plocha/Bakalářka';
str = 'dataset/video/vid9.mov';
vid = VideoReader(fullfile(strabs,str));
%%
M = [0 1 0; 1 -4 1; 0 1 0];
K = 1; %kazdy i-ty snimek

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
%% plovoucí okno

% strabs = '/home/daniela/Plocha/Bakalářka';
% str = 'dataset/video/vid2.mov';
% vid = VideoReader(fullfile(strabs,str));

minDist = 7;
window = 40;
modulo = mod(frameNum, window);
K = (frameNum-modulo)/window;
errorCheck = true;
frameList = zeros(K+1,1);

i = 1;
currFrame = [fmVect((i-1)*window+1:i*window), ((i-1)*window+1:i*window)']; 
frameList(i) = find(fmVect==max(currFrame(:,1)));

>>>>>>> 2b4c688a8712ec98a03c4aaf83f3196ca7feac6c
current_image = read(vid, frameList(i));
numStr = int2str(frameList(i));
numStr2 = int2str(i);
imName = strcat('vidSet/vidFrame',numStr2,'_',numStr,'.png');
imwrite(rot90(current_image,3),imName);

<<<<<<< HEAD
while last + minDist <= frameNum
    i = i+1;
    
    if last + maxDist > frameNum
        fmWind = fmVect(last+minDist:frameNum);
        idxWind = (last+minDist:frameNum)';
    else
        fmWind = fmVect(last+minDist:last+maxDist);
        idxWind = (last+minDist:last+maxDist);
    end
    
    [~, sortIdx] = sort(fmWind,'descend');
    idxWind = idxWind(sortIdx);
    
    %kontrola transformace
    errorCheck = true; 
    j = 0;
    errList = zeros(maxDist-minDist, 2);
   
    while errorCheck == true
        j = j + 1;
        scene = {read(vid,frameList(i-1)), read(vid,idxWind(1))};
        [~, error] = transformCheck(scene);
        errList(j,:) = [error, idxWind(1)];
        disp(error);
        if error > errThresh
            errorCheck = true;
            idxWind(1) = [];
        else
            errorCheck = false;
            frameList(i) = idxWind(1) ;
            
        end
        
        %all errors per pix too large
        if and(j==maxDist-minDist, errorCheck==true)
            warning('Error always over threshold, picking smallest one');
            errorCheck = false;
            fErr = find(errList(:,1)==max(errList(:,1)));
            frameList(i) = errList(fErr,2);
=======
for i = 2:K+1
    
    if i == K+1
        currFrame = [fmVect(K*window+1:K*window+modulo-1), (K*window+1:K*window+modulo-1)'];
    else
        currFrame = [fmVect((i-1)*window+1:i*window), ((i-1)*window+1:i*window)'];
    end
    
    currFrame = sort(currFrame,1,'descend');
    frameList(i) = currFrame(1,2);
    
    errorCheck = true;
    while errorCheck == true
        
        %kontrola zda nejsou blizko vedle sebe
        while frameList(i)-frameList(i-1) < minDist

            currFrame(1,:) = [];
            frameList(i) = currFrame(1,2);
        end

        %kontrola transformace
        scene = {read(vid,frameList(i-1)), read(vid,currFrame(1,2))};
        [res, error] = transformCheck(scene);
        disp(error);
        if error > 6
            errorCheck = true;
            currFrame(1,:) = [];
        else
            errorCheck = false;
            frameList(i) = currFrame(1,2);
>>>>>>> 2b4c688a8712ec98a03c4aaf83f3196ca7feac6c
        end
        
    end
    
<<<<<<< HEAD
    last = frameList(i);
    
    %save image
=======
    %zapsat
>>>>>>> 2b4c688a8712ec98a03c4aaf83f3196ca7feac6c
    current_image = read(vid, frameList(i));
    numStr = int2str(frameList(i));
    numStr2 = int2str(i);
    imName = strcat('vidSet/vidFrame',numStr2,'_',numStr,'.png');
    imwrite(rot90(current_image,3),imName);
    disp(frameList(i));
    

<<<<<<< HEAD
end
=======
 end

%plot(frameVect, fmVect,frameList, fmVect(frameList))

%% nacte framy z frameList do slozky vidSet

frameNum = vid.NumFrames;
n = round(frameNum/K) - 1;
delete('vidSet/*.png');

for i=1:n
current_image = read(vid,frameList(i));
current_image = rot90(current_image,3);
%imshow(current_image);

numStr = int2str(frameList(i));
numStr2 = int2str(i);
imName = strcat('vidSet/vidFrame',numStr2,'_',numStr,'.png');
imwrite(current_image,imName);
close all;
end

%% kontrola registrace

buildingDir = fullfile('vidSet');
buildingScene = imageDatastore(buildingDir);
%preidexovat spatne nactene poradi
[~, reindex] = sort( str2double( regexp( buildingScene.Files, '\d+', 'match', 'once' )))
buildingScene.Files=buildingScene.Files(reindex)

numImages = numel(buildingScene.Files);
RES1 = 1;
RES2 = 0.5;
%Use only even/odd/all images
imOrder = [];
for i = 1:numImages
    k = i; %normal
    if k > numImages
        break;
    end 
    imOrder(i) = k;
end

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
plot(error);

% TODO: odstranit a nahradit snimky co se spatne transformuji
%%
for i = 1:numel(error)
    if error(i) > 3
        badIndx = i;
    end
end

badImg = buildingScene.Files{badIndx+1};

>>>>>>> 2b4c688a8712ec98a03c4aaf83f3196ca7feac6c