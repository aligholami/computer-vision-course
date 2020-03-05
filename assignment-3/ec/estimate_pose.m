function P = estimate_pose(x, X)
    A = [];
    for i=1:size(X, 2)
        xdash = x(1, i);
        ydash = x(2, i);
        Ai = [X(:, i)', 1, 0, 0, 0, 0 -xdash*([X(:, i)', 1]);
              0, 0, 0, 0, X(:, i)', 1, -ydash*([X(:, i)', 1])];
        A = [A; Ai];
    end
    
    [U, S, V] =  svd(A);
    p = V(:, end);
    P = reshape(p, [4, 3])';