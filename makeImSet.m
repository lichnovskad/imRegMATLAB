function [frameList, fmVect, info] = makeImSet(inStr,outStr,dist)

vid = VideoReader(inStr);
%_____________________________________________________________
%spocita focus measure
[~, fmVect] = computeFM(vid, 1);

%PLOVOUCI OKNO
%odhad velikosti okna
frameNum = vid.NumFrames;
frameRate = round(vid.FrameRate);
maxDist = dist(2);
minDist = dist(1);
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
[h, ~, ~] = size(current_image);
if h ~= 1920
    current_image = rot90(current_image,3);
end   
%numStr = int2str(frameList(i));
%numStr2 = int2str(i);
imName = strcat(outStr,'/vidFrame01.png');
imwrite(current_image,imName);

while last + minDist <= frameNum
    i = i+1;
    
    if last + maxDist >= frameNum
        fmWind = fmVect(last+minDist:frameNum-1); %error Index exceeds the number of array elements
        idxWind = (last+minDist:frameNum-1)';
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
        [~, error] = transformCheck(scene,"projective");
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
    %numStr = int2str(frameList(i));
    if i < 10
        numStr = strcat('0',int2str(i));
    else
        numStr = int2str(i);
    end
    imName = strcat(fullfile(outStr),'/vidFrame',numStr,'.png');
    imwrite(rot90(current_image,3),imName);
    disp(frameList(i));
    
    

    info = {frameNum, frameRate, errThresh};
end

%plot(frameVect, fmVect,frameList, fmVect(frameList))