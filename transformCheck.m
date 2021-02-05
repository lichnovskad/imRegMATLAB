function [result, error] = transformCheck(scene,type)
    ord = [1 2];

    try
        [tforms, imSize] = computeTForms(ord, scene,type);
        [xLimits, yLimits] = computeLimits(tforms, imSize);
        [error, result] = warpTwoImages(scene, ord,tforms, xLimits, yLimits);
        pixNum = imSize(1,1)*imSize(1,2);
        error = error/pixNum;
    catch
        warning('Error during transformCheck.');
        result = 0;
        error = 10000;
    end
end