function [locs1, locs2] = matchPics( I1, I2 )
%MATCHPICS Extract features, obtain their descriptors, and match them!

%% Convert images to grayscale, if necessary
im1_gray = I1;
im2_gray = I2;

%% Detect features in both images
im1_corners = detectFASTFeatures(im1_gray);
im2_corners = detectFASTFeatures(im2_gray);

%% Obtain descriptors for the computed feature locations
[im1_desc, im1_locs] = computeBrief(im1_gray, im1_corners.selectStrongest(100).Location);
[im2_desc, im2_locs] = computeBrief(im2_gray, im2_corners.selectStrongest(100).Location);

index_pairs = matchFeatures(im1_desc, im2_desc, 'MatchThreshold', 10, 'MaxRatio', 0.9);

locs1 = im1_locs(index_pairs(:, 1), :);
locs2 = im2_locs(index_pairs(:, 2), :);
locs1_homo = [locs1, ones(size(locs1, 1), 1)]';   % [3, N]
locs2_homo = [locs2, ones(size(locs2, 1), 1)]';   % [3, N]

H = computeH(locs1, locs2);
% H = [0.0020, -0.0007, -0.0000; -0.0003, 0.0015, 0.0000; 0.7454, 0.6666, 0.0034]

locs1_homo = [locs1, ones(size(locs1, 1), 1)]';   % [3, N]
locs1_Hed = round(H * locs1_homo)';
locs1_Hed = locs1_Hed(:, 1:2);

figure;
scatter(locs1(:, 1), locs1(:, 2), 'r');
hold on;
scatter(locs1_Hed(:, 1), locs1_Hed(:, 2), 'g');
showMatchedFeatures(I1, I2, locs1, locs1_Hed, 'montage');

end

