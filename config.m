%% makeImSet
clc;clear;close all;

inStr = '/home/daniela/Plocha/Bakalářka/dataset/video/new/vid13.mov';
outStr = 'vidSet/set13';
dist = [37 75]; %minDist maxDist frames
 
[frameList, fmVect, info] = makeImSet(inStr, outStr, dist);
%% registrace
clc;clear;close all;

inputFold = 'vidSet/set1/';
outputName = 'simil2_';
outputFold = strcat(inputFold,'panos');

colBorder = false;
type = 'similarity'; %% 'affine', 'projective'
RES1=1;
RES2=0.5;

[pan, imOrder] = registrace(inputFold,{outputFold, outputName}, {RES1,RES2},colBorder, type);
