function Ifin = cylWarp(I, K)

[h, w, ~] = size(I);
Kinv = inv(K);

yi_ = (1:h)';
yi = repmat(yi_, 1, w);
xi_ = (1:w);
xi = repmat(xi_, h, 1);

X = zeros(h,w,3);
X(:,:,1) = xi;
X(:,:,2) = yi;
X(:,:,3) = ones(size(xi));
X = reshape(X, h*w, 3);

X = (Kinv*X')';

A = [sin(X(:,1)), X(:,2), cos(X(:,1))];
B = (K*A')';
B = B(:,1:end-1)./B(:,end);
B(B(:,1) < 0) = 0;
B(B(:,1) >= w) =0;
B(B(:,2) < 0) = 0;
B(B(:,2) >= h) = 0;
B = reshape(B,h,w,2);

I1 = double(I(:,:,1));
I2 = double(I(:,:,2));
I3 = double(I(:,:,3));

I1_ = interp2(I1, B(:,:,1), B(:,:,2));
I2_ = interp2(I2, B(:,:,1), B(:,:,2));
I3_ = interp2(I3, B(:,:,1), B(:,:,2));

Ifin = zeros(size(I));
Ifin(:,:,1) = I1_;
Ifin(:,:,2) = I2_;
Ifin(:,:,3) = I3_;

Ifin = uint8(Ifin);
%imshow(uint8(Ifin));
end