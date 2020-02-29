function F = eightpoint(pts1, pts2, M)
    % eightpoint algorithm:
    %   pts1: Nx2 matrix of (x,y) coordinates corresponding to the first image
    %   pts2: Nx2 matrix of (x,y) coordinates corresponding to the second image
    %   M: Used for the normalization: M = max (imwidth, imheight)
    % A try to solve AF = 0 here using SVD.
    % 1. Normalize the points (pts1 and pts2)
    pts1_normalized = pts1 ./ M;
    pts2_normalized = pts2 ./ M;
    
    N = size(pts1, 1);
    
    % 2. Construct the M*9 matrix A
    A = [];
    for i=1:N
        % Each row will be [x'x, x'y, x', y'x, y'y, y', x, y, 1]
        x = pts1_normalized(i, 1);
        y = pts1_normalized(i, 2);
        x_p = pts2_normalized(i, 1);
        y_p = pts2_normalized(i, 2);
        A = [A; x_p*x, x_p*y, x_p, y_p*x, y_p*y, y_p, x, y, 1];
    end

    % 3. Find [U, S, V] = SVD(A)
    [U, S, V] = svd(A);

    % 4. F = V[:, -1]
    f = V(:, 9);
    f = reshape(f, [3, 3])';

    % 5. Enforce rank 2
    [U, S, V] = svd(f);
    S(3, 3) = 0;
    f_rank2_enforced = U * S * V';

    % 6. Refine F
    refined_F = refineF(f_rank2_enforced, pts1_normalized, pts2_normalized);

    % 7. Unnormalize F (based on https://en.wikipedia.org/wiki/Eight-point_algorithm)
    T = [1/M, 0, 0; 0, 1/M, 0; 0, 0, 1];
    F = T' * refined_F * T;

end

