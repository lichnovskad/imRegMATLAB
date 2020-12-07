function [result, error] = transformCheck(scene)
    ord = [1 2];
    RES = 0.5;
<<<<<<< HEAD
    try
        [tforms, imSize] = computeTForms(ord, scene,RES);
        [xLimits, yLimits] = computeLimits(tforms, imSize, RES);
        [error, result] = warpTwoImages(scene, ord, RES,tforms, xLimits, yLimits);
        pixNum = imSize(1,1)*imSize(1,2);
        error = error/pixNum;
    catch
        warning('Error during transformCheck.');
        result = 0;
        error = 10000;
    end
=======
    [tforms, imSize] = computeTForms(ord, scene,RES);
    [xLimits, yLimits] = computeLimits(tforms, imSize, RES);
    [error, result] = warpTwoImages(scene, ord, RES,tforms, xLimits, yLimits);
    pixNum = imSize(1,1)*imSize(1,2);
    error = error/pixNum;
>>>>>>> 2b4c688a8712ec98a03c4aaf83f3196ca7feac6c
    
end