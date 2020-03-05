dataDir = "../data/";
PnP = load(sprintf("%sPnP.mat", dataDir));

X = PnP.X;
cad = PnP.cad;
img = PnP.image;
x = PnP.x;

P = estimate_pose(x, X);
[K, R, t] = estimate_params(P); 

homo = [X;ones(1, size(X,2))];
xProj = P * homo;
xProj(1, :) = xProj(1, :)./xProj(3, :);
xProj(2, :) = xProj(2, :)./xProj(3, :);
xProj = xProj(1:2, :);

figure; 
imshow(img); hold on;
plot(xProj(1, :), xProj(2, :), 'o', 'MarkerFaceColor', 'g', 'MarkerSize', 6, 'LineWidth', 1.8);
title("Projected W/ Markers");

rotVerts = (R * cad.vertices')'; 

figure; 
trimesh(cad.faces, rotVerts(:,1), rotVerts(:, 2), rotVerts(:, 3), 'FaceColor', 'g', 'FaceAlpha', 0.5);
title("Rotated Mesh");

cadT = cad.vertices';
homoCad = [cadT; ones(1, size(cadT,2))];
xProj_c = P * homoCad;
xProj_c(1, :) = xProj_c(1, :)./xProj_c(3, :);
xProj_c(2, :) = xProj_c(2, :)./xProj_c(3, :);
xProj_c = xProj_c(1:2, :);
xProj_c = int16(xProj_c);

figure; 
imshow(img); hold on;
p = patch('Faces', cad.faces, 'Vertices', xProj_c', 'FaceColor', 'black', 'EdgeColor', 'none');
p.FaceAlpha = 0.3;
title("Patch");
hold off
