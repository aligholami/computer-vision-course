function [M1, M2, K1n, K2n, R1n, R2n, t1n, t2n] = ...
                        rectify_pair(K1, K2, R1, R2, t1, t2)
% RECTIFY_PAIR takes left and right camera paramters (K, R, T) and returns left
%   and right rectification matrices (M1, M2) and updated camera parameters. You
%   can test your function using the provided script q4rectify.m

% 1. Find the optical center of each camera
oc1 = -inv(K1 * R1) * (K1 * t1);
oc2 = -inv(K2 * R2) * (K2 * t2);

% 2. Get the new rotation matrix
r1 = (oc1-oc2) / ((sum((oc1 - oc2) .* (oc1 - oc2))) ^ 0.5);
r2 = (cross(R1(3, :), r1))';
r3 = (cross(r2, r1));
R_hat = [r1 r2 r3]';

R1n = R_hat;
R2n = R_hat;
t1n = R_hat * oc1;
t2n = R_hat * oc2;
Kn = K2;
K1n = Kn; 
K2n = Kn;
M1 = (Kn * R_hat) * inv(K1 * R1);
M2 = (Kn * R_hat) * inv(K2 * R2);