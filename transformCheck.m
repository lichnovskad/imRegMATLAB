function [result, error] = transformCheck(scene)
    ord = [1 2];
    RES = 0.5;
    [tforms, imSize] = computeTForms(ord, scene,RES);
    [xLimits, yLimits] = computeLimits(tforms, imSize, RES);
    [error, result] = warpTwoImages(scene, ord, RES,tforms, xLimits, yLimits);
    pixNum = imSize(1,1)*imSize(1,2);
    error = error/pixNum;
    
end