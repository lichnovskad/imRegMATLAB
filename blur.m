%% uncomment if needed
%loadvid('data/videa/IMG_0330.MOV', False);

%%
clc;clear;close all;
%str = 'data/videa/IMG_0330.MOV';
str = 'data/videa/vid2.mov';
vid = VideoReader(str);
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
%I = imfilter(double(rgb2gray(current_image)),M,'conv');

I = abs(I);
fm = sum(I(:));

fmVect(i) = fm;
frameVect(i) = i*K; 
end

%plot(frameVect, fmVect);
%% plovoucí okno
minDist = 15;
window = 30;
modulo = mod(frameNum, window);
K = (frameNum-modulo)/window;

frameList = zeros(K+1,1);

i = 1;
currFrame = fmVect((i-1)*window+1:i*window); 
frameList(i) = find(fmVect==max(currFrame));

for i = 2:K+1
    
    if i == K+1
        currFrame = fmVect(K*window+1:K*window+modulo-1);
    else
        currFrame = fmVect((i-1)*window+1:i*window);
    end
    
    frameList(i) = find(fmVect==max(currFrame));
    
    %kontrola zda nejsou blizko vedle sebe
    while frameList(i)-frameList(i-1) <= minDist
        
        currFrame = sort(currFrame,'descend');
        currFrame(1) = [];
        frameList(i) = find(fmVect==currFrame(2));
    end
 end

%plot(frameVect, fmVect,frameList, fmVect(frameList))
%%
%2 kolova registrace

%povedla se registrace?
%porovnanvani intenzit
%norm. kroskorelace, prah
%% nacte framy z frameList do slozky vidSet

%str = 'data/videa/IMG_0338.MOV';
vid = VideoReader(str);

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