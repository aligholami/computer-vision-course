function pts3d = triangulate(P1, pts1, P2, pts2)
    % triangulate estimate the 3D positions of points from 2d correspondence
    %   Args:
    %       P1:     projection matrix with shape 3 x 4 for image 1
    %       pts1:   coordinates of points with shape N x 2 on image 1
    %       P2:     projection matrix with shape 3 x 4 for image 2
    %       pts2:   coordinates of points with shape N x 2 on image 2
    %
    %   Returns:
    %       Pts3d:  coordinates of 3D points with shape N x 3
    %

    num_points = size(pts1, 1);
    P =[];
    A =[];

    for i = 1:num_points
        x1 = pts1(i, 1);
        x2 = pts2(i, 1);
        y1 = pts1(i, 2);
        y2 = pts2(i, 2);
        A = [
              P1(1,:) - x1*P1(3,:);
              P1(2,:) - y1*P1(3,:);
              P2(1,:) - x2*P2(3,:);
              P2(2,:) - y2*P2(3,:)
            ];

        [U, S, V] = svd(A);
        p = V(:, end);
        p = p ./ norm(p);
        p = p / p(4);
        P = [P, p];
    end

    P1_hat = P1 * P; % [3 * 4] * [4 * 110] = [3 * 110]
    P1_hat = P1_hat(1:2,:) ./ P1_hat(3,:);
    P2_hat = P2 * P; % [3 * 4] * [4 * 110] = [3* 110]
    P2_hat = P2_hat(1:2,:) ./ P2_hat(3,:);
    e1 = (pts1 - P1_hat').^2;
    e1 = sqrt(sum(e1(:))) / num_points
    e2 = (pts2 - P2_hat').^2;
    e2 = sqrt(sum(e2(:))) / num_points
    pts3d = P(1:3, :);
end 