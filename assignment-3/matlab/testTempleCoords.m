im1=imread('./data/im1.png');
im2=imread('./data/im2.png');
load('./data/someCorresp.mat')

F = eightpoint(pts1, pts2, 640);
load('./data/templeCoords.mat')
pts2 = epipolarCorrespondence(im1, im2, F, pts1);
load('./data/intrinsics.mat')
E = essentialMatrix(F, K1, K2);
P1 = K1 * [1 0 0 0; 0 1 0 0; 0 0 1 0];

m2s = camera2(E);
for i=1:4
    cnt(i)=0;
    P2 = K2 * m2s(:, :, i);
    X(:, :, i) = triangulate(P1, pts1, P2, pts2);
    temp = X(:, :, i);
    cnt(i) = sum(temp(:, 3) > 0);
end

awesome_triangulation = X(:, :, find(cnt == max(cnt)));

scatter3(awesome_triangulation(:, 1), awesome_triangulation(:, 2), awesome_triangulation(:, 3), 'filled')
xlabel('X');
ylabel('Y');
zlabel('Z');

R1 = P1(1:3, 1:3);
t1 = P1(:, end);

P2 = K2 * m2s(:, :, find(cnt==max(cnt)));

R2 = P2(1:3, 1:3);
t2 = P2(:, end);

save('./data/extrinsics.mat', 'R1', 'R2', 't1', 't2')