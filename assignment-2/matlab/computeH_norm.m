function [H2to1] = computeH_norm(x1, x2)

x1 = x1';
x2 = x2';
x1_homo = [x1 ; ones(1,size(x1,2))];
x2_homo = [x2 ; ones(1,size(x2,2))];

centroid1 = mean(x1_homo, 2);
centroid2 = mean(x2_homo, 2);

%% Shift the origin of the points to the centroid
x1_shifted = x1_homo - centroid1;
x2_shifted = x2_homo - centroid2;

%% Normalize the points so that the average distance from the origin is equal to sqrt(2).

%% Find the norm of of rows of the shifted poin  ts matrix
x1_norms = sqrt(sum(x1_shifted.^2, 1));
x2_norms = sqrt(sum(x2_shifted.^2, 1));

avg_dis_org_1 = mean(x1_norms);
avg_dis_org_2 = mean(x2_norms);

scale_factor_1 = sqrt(2) / avg_dis_org_1;
scale_factor_2 = sqrt(2) / avg_dis_org_2;

x1_scaled = scale_factor_1 * x1_shifted;
x2_scaled = scale_factor_2 * x2_shifted;

T1 = [scale_factor_1 0 scale_factor_1*-centroid1(1); 0 scale_factor_1 scale_factor_1*-centroid1(2); 0 0 1];
T2 = [scale_factor_2 0 scale_factor_2*-centroid2(1); 0 scale_factor_2 scale_factor_2*-centroid2(2); 0 0 1];

%% Compute Homography
%% Compute Homography
H2to1_hat = computeH(x1_scaled, x2_scaled);

%% Denormalization
H2to1 = inv(T2) * H2to1_hat * T1;
