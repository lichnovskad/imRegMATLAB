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
current_image = read(vid, frameList(i));
numStr = int2str(frameList(i));
numStr2 = int2str(i);
imName = strcat('vidSet/vidFrame',numStr2,'_',numStr,'.png');
imwrite(rot90(current_image,3),imName);

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
        end
        
    end
    
    last = frameList(i);
    
    %save image
    current_image = read(vid, frameList(i));
    numStr = int2str(frameList(i));
    numStr2 = int2str(i);
    imName = strcat('vidSet/vidFrame',numStr2,'_',numStr,'.png');
    imwrite(rot90(current_image,3),imName);
    disp(frameList(i));
    

end