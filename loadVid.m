%%
%function loadVid(str,SHOW)
clc;clear;close all;

%TODO: pridat output

str = 'data/videa/IMG_0330.MOV';
vid = VideoReader(str);

K = 5; %kazdy i-ty snimek


frameNum = vid.NumFrames;
n = round(frameNum/K) - 1;
delete('vidSet/*');

for i=1:n
current_image = read(vid,i*K);
current_image = rot90(current_image,3);
%imshow(current_image);

numStr = int2str(i);
imName = strcat('vidSet/vidFrame',numStr,'.png');
imwrite(current_image,imName);
close all;
end

%end
%%
%%

%clc;clear;close all;

%TODO: pridat output

str = 'data/videa/IMG_0330.MOV';
vid = VideoReader(str);

frameNum = vid.NumFrames;
n = round(frameNum/K) - 1;
delete('vidSet/*');

for i=1:n
current_image = read(vid,frameList(i));
current_image = rot90(current_image,3);
%imshow(current_image);

numStr = int2str(i);
imName = strcat('vidSet/vidFrame',numStr,'.png');
imwrite(current_image,imName);
close all;
end
