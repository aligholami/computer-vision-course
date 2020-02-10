function [ locs1, locs2] = matchPics( I1, I2 )
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

%% Detect features in both images
im1_corners = detectFASTFeatures(im1_gray);
im2_corners = detectFASTFeatures(im2_gray);

%% Obtain descriptors for the computed feature locations
[im1_desc, im1_locs] = computeBrief(im1_gray, im1_corners.selectStrongest(300).Location);
[im2_desc, im2_locs] = computeBrief(im2_gray, im2_corners.selectStrongest(300).Location);

%% Match features using the descriptors
index_pairs = matchFeatures(im1_desc, im2_desc, 'MatchThreshold', 10, 'MaxRatio', 0.72);

locs1 = im1_locs(index_pairs(:, 1), :);
locs2 = im2_locs(index_pairs(:, 2), :);

% figure;
% showMatchedFeatures(I1, I2, locs1, locs2, 'montage');

end

