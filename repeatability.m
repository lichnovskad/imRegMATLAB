function [rep_rate,distLen, loc_err] = repeatability(I1, I2, e) %[rep_rate, distLen, loc_err] 
%loc_error chybi
%     A = rgb2gray(imread('vidSet/set6/vidFrame7_280.png'));
%     B = rgb2gray(imread('vidSet/set6/vidFrame8_320.png'));

    points1 = detectSURFFeatures(I1);
    [features1, points1] = extractFeatures(I1, points1);
    
    points2 = detectSURFFeatures(I2);
    [features2, points2] = extractFeatures(I2, points2);
    try
        indexPairs = matchFeatures(features1, features2, 'Unique', true,'Method', 'Approximate');

        matched2 = points2(indexPairs(:,2), :);
        matched1 = points1(indexPairs(:,1), :);        

        [tform, inlier1,inlier2] = estimateGeometricTransform(matched1, matched2,...
            'projective', 'Confidence', 99, 'MaxNumTrials', 1000,'MaxDistance', e);
        
        p1 = inlier1.Location;
        p2 = inlier2.Location;
        [predicted(:,1),predicted(:,2)] = transformPointsForward(tform,p1(:,1), p1(:,2));

        pnum = inlier2.Count;
        dist = zeros(pnum,1);
        for i = 1:pnum
            dist(i) =  norm(p2(i,:)-predicted(i,:));
        end

        %showMatchedFeatures(I2,I2,points2,predicted);
        distLen = matched2.Count;
        %indices = (dist>e);
        e_rep = dist;
        %e_rep(indices) = [];
        %rep_rate2 = length(e_rep)/distLen;
        rep_rate = inlier2.Count/distLen;
        loc_err = mean(e_rep);
    catch
        rep_rate = 0;
        %rep_rate2 = 0;
        loc_err = 0;
        distLen = 0;
    end
end