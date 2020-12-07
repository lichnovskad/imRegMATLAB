function [pan, imOrder] = registrace(vidSet, colBorder)

%CONFIQ
RES1 = 1;
RES2 = 1;
%colBorder = false;
per = 0;
cutNumber = 1;

numImages = numel(vidSet);
imOrder = (1:numImages);

scene = vidSet;

%REGISTRACE
while min(per) < cutNumber
    [tforms, ImSize] = computeTForms(imOrder, scene,RES1);
    [xLimits, yLimits] = computeLimits(tforms, ImSize, RES2);
    [pan,per] = createPanorama(scene, imOrder, RES2, tforms, xLimits, yLimits, colBorder);
    cut = find(per == min(per));
    if or(cut == 1, cut == numImages)
        break;
    end
    
    if min(per) < cutNumber
        imOrder(cut) = [];
    end
end
pan = rot90(pan,1);
imshow(pan);

end