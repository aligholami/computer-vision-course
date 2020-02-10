function [ bestH2to1, inliers] = computeH_ransac(locs1, locs2)
N = 4000;
dis = 0.6;
Threshold = 1000000;
locs1 = locs1';
locs2 = locs2';
len = size(locs1, 2);
inlier_max = 0;
h_min  = ones(3,3);
for n = 1:N
    rand = randperm(len);
    index = rand(1:4);
    h = computeH(locs1(:,index)', locs2(:,index)');
    error = 0;
    tform = projective2d(h');
    forward = transformPointsForward(tform, locs1');
    backward = transformPointsInverse(tform, locs2');
    inlier = (((forward(:,1)-locs2(1,:)').^2 + (forward(:,2)-locs2(2,:)').^2 + (backward(:,1)-locs1(1,:)').^2 +(backward(:,2)-locs1(2,:)').^2) < dis);
    if inlier_max < sum(inlier)
        h_min = h;
        inlier_max = sum(inlier);
        if inlier_max > Threshold
            break
        end
    end
end
tform = projective2d(h_min');
forward = transformPointsForward(tform,locs1');
backward = transformPointsInverse(tform,locs2');
inlier = (((forward(:,1)-locs2(1,:)').^2 + (forward(:,2)-locs2(2,:)').^2 + (backward(:,1)-locs1(1,:)').^2 +(backward(:,2)-locs1(2,:)').^2)< dis);
size(locs1(:,inlier));
h = computeH(locs1(:,inlier)',locs2(:,inlier)');
bestH2to1 = h;
inliers = inlier;
end

