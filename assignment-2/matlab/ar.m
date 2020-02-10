% Q3.3.1
vision = loadVid('./data/book.mov');
panda = loadVid('./data/ar_source.mov');
cover = imread('./data/cv_cover.jpg');

num_vision_frames = size(vision, 2);
num_panda_frames = size(panda, 2);

if num_vision_frames < num_panda_frames
    num_frames = num_vision_frames;
else
    num_frames = num_panda_frames;
end

aug = VideoWriter('./data/newmov');

open(aug);

for i=1:num_frames
    vision_f = vision(i).cdata;
    panda_f = panda(i).cdata;
    [h, w, c] = size(panda_f);
    panda_f = panda_f(50:end-50, :, :);

    %% Extract features and match
    [locs1, locs2] = matchPics(cover, vision_f);

    %% Compute homography
    bestH2to1 = computeH_ransac(locs1, locs2);

    %% Scale harry potter image to template size
    % Why is this is important?
    scaled_panda_f = imresize(panda_f, [440 350]);

    updated_frame = compositeH(inv(bestH2to1), scaled_panda_f, vision_f);
    writeVideo(aug, updated_frame);
end

close(aug);