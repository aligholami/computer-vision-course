function depthM = get_depth(dispM, K1, K2, R1, R2, t1, t2)
    % GET_DEPTH creates a depth map from a disparity map (DISPM).
    
    depthM = zeros(size(dispM), 'double');
    c1 = (-R1) \ t1;
    c2 = (-R2) \ t2;
    
    b = norm(c1-c2);
    f = K1(1, 1);
    num_rows = size(dispM, 1);
    num_cols = size(dispM, 2);

    for y=1:num_rows
        for x=1:num_cols
            if (dispM(y, x) == 0)
                depthM(y, x) = 0;
            else
                depthM(y, x) = (b * f) / dispM(y, x);
            end
        end
    end