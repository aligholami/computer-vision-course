% Your solution to Q2.1.5 goes here!

%% Read the image and convert to grayscale, if necessary
cv_cover_gray = imread('./data/cv_cover.jpg');
% cv_cover_gray = rgb2gray(cv_cover);

%% Compute the features and descriptors
cv_cover_corners = detectFASTFeatures(cv_cover_gray);
[cv_cover_desc, cv_cover_locs] = computeBrief(cv_cover_gray, cv_cover_corners.selectStrongest(100).Location);

histo_x = 0:10:360;
histo_y = [];
for i = 0:36
    %% Rotate image
    rot = imrotate(cv_cover_gray, i * 10);

    %% Compute features and descriptors
    rot_corners = detectFASTFeatures(rot);
    [rot_desc, rot_locs] = computeBrief(rot, rot_corners.selectStrongest(100).Location);

    %% Match features
    index_pairs = matchFeatures(rot_desc, cv_cover_desc, 'MatchThreshold', 10, 'MaxRatio', 0.9);
    
    num_matches = size(index_pairs, 1); 
    
    %% Update histogram
    histo_y = [histo_y num_matches];
end

bar(histo_x, histo_y)


%% Compute the features and descriptors
cv_cover_corners = detectSURFFeatures(cv_cover_gray);
[cv_cover_desc, cv_cover_locs] = extractFeatures(cv_cover_gray, cv_cover_corners.selectStrongest(100).Location, 'Method', 'SURF');

histo_x = 0:10:360;
histo_y = [];
for i = 0:36
    %% Rotate image
    rot = imrotate(cv_cover_gray, i * 10);

    %% Compute features and descriptors
    rot_corners = detectSURFFeatures(rot);
    [rot_desc, rot_locs] = extractFeatures(rot, rot_corners.selectStrongest(100).Location, 'Method', 'SURF');

    %% Match features
    index_pairs = matchFeatures(rot_desc, cv_cover_desc, 'MatchThreshold', 10, 'MaxRatio', 0.9);
    
    num_matches = size(index_pairs, 1); 
    
    %% Update histogram
    histo_y = [histo_y num_matches];
end

bar(histo_x, histo_y);

%% Display histogram