function [locs1, locs2] = matchPics( I1, I2 )
%MATCHPICS Extract features, obtain their descriptors, and match them!
%% Convert images to grayscale, if necessary
[i1_rows, i1_cols, i1_channels] = size(I1);
[i2_rows, i2_cols, i2_channels] = size(I2);

if i1_channels == 3
    im1_gray = rgb2gray(I1);
else
    im1_gray = I1;
end

if i2_channels == 3
    im2_gray = rgb2gray(I2);
else
    im2_gray = I2;
end

rand('seed', 1);

%% Detect features in both images
im1_corners = detectFASTFeatures(im1_gray);
im2_corners = detectFASTFeatures(im2_gray);

%% Obtain descriptors for the computed feature locations
[im1_desc, im1_locs] = computeBrief(im1_gray, im1_corners.selectStrongest(500).Location);
[im2_desc, im2_locs] = computeBrief(im2_gray, im2_corners.selectStrongest(500).Location);

index_pairs = matchFeatures(im1_desc, im2_desc, 'MatchThreshold', 10, 'MaxRatio', 0.7);

locs1 = im1_locs(index_pairs(:, 1), :);
locs2 = im2_locs(index_pairs(:, 2), :);

[H, inliers] = computeH_ransac(locs1, locs2)
% H = computeH(locs1, locs2);
num_points = 20
transformed_locs1 = [];

random_locs_x = randi(i1_cols, num_points, 1);
random_locs_y = randi(i1_rows, num_points, 1);
random_locs = cat(2, random_locs_x, random_locs_y);
for i=1:num_points
    homo_point = [random_locs(i, 1); random_locs(i, 2); 1];
    transformed_homo_point = H * homo_point;
    transformed_point = transformed_homo_point(1:2) ./ transformed_homo_point(3);
    transformed_locs1 = [transformed_locs1; transformed_point'];
end

figure;
showMatchedFeatures(I1, I2, random_locs, transformed_locs1, 'montage');

end

