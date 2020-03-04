function pts3d = triangulate(P1, pts1, P2, pts2)
    N = size(pts1, 1);
    
    pts1 = [pts1'; ones(1, N)];
    pts2 = [pts2'; ones(1, N)];
    P = zeros(4, N);
    
    for i=1:N
        x = [0 pts1(3,i) -pts1(2,i); -pts1(3,i) 0 pts1(1,i); pts1(2,i) -pts1(1,i) 0];
        y = [0 pts2(3,i) -pts2(2,i); -pts2(3,i) 0 pts2(1,i); pts2(2,i) -pts2(1,i) 0];
    
        Q = [x * P1; y * P2];
        [U, S, V] = svd(Q);
        z = V(:, end);
        P(:,i) = z / z(4);
    end
    
    pts1_hat = P1 * P;
    pts2_hat = P2 * P;
    
    pts3d = P(1:3,:)';

    pts1 = pts1 ./ norm(pts1);
    pts2 = pts2 ./ norm(pts2);
    pts1_hat = pts1_hat ./ norm(pts1_hat);
    pts2_hat = pts2_hat ./ norm(pts2_hat);
    d1 = pts1-pts1_hat;
    d2 = pts2-pts2_hat;
    error1 = mean(sqrt(sum(d1.^2, 1)), 'all')
    error2 = mean(sqrt(sum(d2.^2, 1)), 'all')

end