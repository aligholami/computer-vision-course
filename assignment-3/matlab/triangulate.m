function pts3d = triangulate(P1, pts1, P2, pts2 )
    N = size(pts1,1);
    pts3d = zeros(N,3);
    for i = 1:N
        x1 = pts1(i,1);
        y1 = pts1(i,2);
        x2 = pts2(i,1);
        y2 = pts2(i,2);
        A = [x1 .* P1(3,:) - P1(1,:);
             y1 .* P1(3,:) - P1(2,:);
             x2 .* P2(3,:) - P2(1,:);
             y2 .* P2(3,:) - P2(2,:)];
        [~, ~, V] = svd(A);
        v = V(:,end);
        pts3d(i,:) = v(1:3) ./ v(4);
    end
p1_hat = P1'*pts3d';
p2_hat = P2'*pts3d';
p1_hat = p1_hat(1:3,:) ./ p1_hat(4,:);
p1_hat = p1_hat(1:2,:) ./ p1_hat(3,:);
p1_hat = round(p1_hat);
p2_hat = p2_hat(1:3,:) ./ p2_hat(4,:);
p2_hat = p2_hat(1:2,:) ./ p2_hat(3,:);
p2_hat = round(p2_hat);

error1 = (pts1-p1_hat').^2;
error2 = (pts2-p2_hat').^2;
err1 = sqrt(mean(error1(:))) / N
err2 = sqrt(mean(error2(:))) / N

end