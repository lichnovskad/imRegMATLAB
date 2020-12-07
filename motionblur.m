function h = motionblur(s,k,w,t)

% h = motionblur(s,k,w)
% Generate motion-blur mask of length s, tilt k, width w, and shifted by t
%

if nargin < 4
    t = [ 0 0];
end
if length(s) == 1 
    s = [s s];
end
[X Y] = meshgrid([-s(2)/2:s(2)/2] + t(2), [-s(1)/2:s(1)/2] + t(1));
h = zeros(size(X)-1);
I = [vec(X(1:end-1,1:end-1)),vec(X(1:end-1,2:end)),...
        vec(Y(1:end-1,1:end-1)),vec(Y(2:end,1:end-1))];
j = 1;
for i = I'
    h(j) = dblquad(@afun, i(1),i(2),i(3),i(4),[],[],w,k);
    j = j+1;
end
h = h/sum(h(:));

function r = afun(x,y,w,k)
v = x*cos(k)+y*sin(k);
r = [v < w/2] & [v > -w/2];
