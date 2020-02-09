function [ H2to1 ] = computeH( x1, x2 )
%COMPUTEH Computes the homography between two sets of points

num_crspnds = size(x1, 1);
A = [];
for i=1:num_crspnds
    A_i = [-x1(i, 1), -x1(i, 2), -1, 0, 0, 0, x1(i, 1)*x2(i, 1), x1(i, 2)*x2(i, 1), x2(i, 1);
    0, 0, 0, -x1(i, 1), -x1(i, 2), -1, x1(i, 1)*x2(i, 2), x1(i, 2)*x2(i, 2), x2(i, 2)];
    A = [A; A_i];
end

[U, S, V] = svd(A);
h = V(:, 9);
H2to1 = reshape(h, [3, 3])';
% h = V(:, 9);
% H2to1 = reshape(h, [3, 3])';

% [V, D] = eig(A'*A);
% e = eig(A'*A);
% [val, idx] = max(e);
% h = D(idx, :)
% H2to1 = reshape(h, [3, 3])';
end
