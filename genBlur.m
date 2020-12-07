<<<<<<< HEAD
function [Im1,Im2, lenght]=genBlur(I1,I2, n, lenght)
%vem 2 obrazky a vygeneruj n paru s blurem s pevnou orientaci a random
%delkou
Im1= {};
Im2 = {};
%A = imread('vidSet/vidFrame2_78.png')
%B = imread('vidSet/vidFrame4_158.png');
% imwrite(I1, 'orig1.png');
% imwrite(I2, 'orig1.png');
%lenght = randi([1 50], 1);
%lenght = 10;
for i = 1:n

    theta1 = randi([1 180], 1);
    theta2 = randi([1 180], 1);

    % Generate motion-blur mask of length s, tilt k, width w, and shifted by t
    %b = motionblur(10, 45, 5);

    b1 = fspecial('motion',lenght, theta1);
    b2 = fspecial('motion',lenght, theta2);

    blurred1 = imfilter(I1,b1);
    blurred2 = imfilter(I2,b2);

%     numStr = int2str(i);
%     imName1 = strcat('vidSet/blurSet/bset',numStr,'_1.png');
%     imName2 = strcat('vidSet/blurSet/bset',numStr,'_2.png');
%     imwrite(blurred1, imName1);
%     imwrite(blurred2, imName2);
    Im1{i} = blurred1; 
    Im2{i} = blurred2; 
end

=======
function genBlur(I1,I2, n)
%vem 2 obrazky a vygeneruj n paru s blurem s pevnou orientaci a random
%delkou

%A = imread('vidSet/vidFrame2_78.png')
%B = imread('vidSet/vidFrame4_158.png');
imwrite(I1, 'orig1.png');
imwrite(I2, 'orig1.png');
for i = 1:n

    theta = randi([1 190], 1);
    lenght1 = randi([1 50], 1);
    lenght2 = randi([1 50], 1);
    
    % Generate motion-blur mask of length s, tilt k, width w, and shifted by t
    %b = motionblur(10, 45, 5);
    
    b1 = fspecial('motion',lenght1, theta);
    b2 = fspecial('motion',lenght2, theta);

    blurred1 = imfilter(I1,b1);
    blurred2 = imfilter(I2,b2);
    
    numStr = int2str(i);
    imName1 = strcat('vidSet/blurSet/bset',numStr,'_1.png');
    imName2 = strcat('vidSet/blurSet/bset',numStr,'_2.png');
    imwrite(blurred1, imName1);
    imwrite(blurred2, imName2);

end


>>>>>>> 2b4c688a8712ec98a03c4aaf83f3196ca7feac6c
end