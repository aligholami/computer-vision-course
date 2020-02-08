function [ H2to1 ] = computeH( x1, x2 )
%COMPUTEH Computes the homography between two sets of points

num_crspds = size(x1, 1);
A = [];
if num_crspds >= 4
    for i=1:4
        A_i = [-x1(i, 1), -x1(i, 2), -1, 0, 0, 0, x1(i, 1)*x2(i, 1), x1(i, 2)*x2(i, 1), x2(i, 1); 0, 0, 0, -x1(i, 1), -x1(i, 2), -1, x1(i, 1)*x2(i, 2), x1(i, 2)*x2(i, 2), x2(i, 2)];
        A = [A; A_i];
    end
end

[U, S, V] = svd(A);
s = svds(A);
[val, idx] = min(s);
h = V(:, idx);

H2to1 = reshape(h, [3, 3])';

end
