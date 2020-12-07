clc;clear;close all;
warning('off');
buildingDir = fullfile('vidSet','set1');
buildingScene = imageDatastore(buildingDir);
%preidexovat spatne nactene poradi
[~, reindex] = sort( str2double( regexp( buildingScene.Files, '\d+', 'match', 'once' )));
buildingScene.Files=buildingScene.Files(reindex);

numImages = numel(buildingScene.Files);
%%
n=20;
e = 10;
len = [1,5,10,15,20,25,30,35,40,45,50];
for i = 1:numImages-1
%i=1;
    A = rgb2gray(readimage(buildingScene, i));
    B = rgb2gray(readimage(buildingScene, i+1));

    for j=1:11
        
        %repOrg = [0,0,0];
        %[repOrg(1),repOrg(2),repOrg(3)] = repeatability(A, B, e);
        [Im1,Im2, blurLen] = genBlur(A,B,n,len(j));
        repList= zeros(n,1);
        
        for k = 1:n
            [repList(k,1), repList(k,2), repList(k,3)] = repeatability(Im1{k}, Im2{k}, e);
            [repList(k,1), repList(k,2), repList(k,3)]
        end
        j
        a{i,j} = repList;
    end
    i
end
%%
for j = 1:14
rozpt = [];
rep_mean = [];
loc_mean = [];
    for i=1:11
        b= a{j,i};
        rep = b(:,1);
        locerr = b(:,3);
        rep_mean(i) = mean(rep); 
        rozpt(i) = var(rep);
        loc_mean(i) = mean(locerr);

    end
    
plotNum = int2str(j);
plotName = strcat('plots/set1all_',plotNum,'.png');

errorbar(rep_mean,rozpt);
saveas(gcf, plotName);
end
%%

imwrite(A, 'output/setOrg_A.png');
imwrite(B, 'output/setOrg_B.png');
for i =1:n
    str_i =string(i);
    imName1 = strcat('output/set', str_i,'_A.png'); 
    imName2 = strcat('output/set', str_i,'_B.png'); 
    imwrite(Im1{i}, imName1);
    imwrite(Im2{i}, imName2);
end
%%
clc;clear;close all;
e=10;
I1 = rgb2gray(imread('vidSet/set6/vidFrame7_280.png'));
I2= rgb2gray(imread('vidSet/set6/vidFrame8_320.png'));
points1 = detectSURFFeatures(I1);
[features1, points1] = extractFeatures(I1, points1);

points2 = detectSURFFeatures(I2);
[features2, points2] = extractFeatures(I2, points2);
[indexPairs,matchmetric] = matchFeatures(features1, features2, 'Unique',...
    true,'Method', 'Approximate');

matched2 = points2(indexPairs(:,2), :);
matched1 = points1(indexPairs(:,1), :);        
[tform,inlier1,inlier2] = estimateGeometricTransform(matched1, matched2,...
            'projective', 'Confidence', 99, 'MaxNumTrials', 1000,'MaxDistance', e);
        
showMatchedFeatures(I1,I2, matched1, matched2,'montage');