function [K, R, t] = estimate_params(P)
    % ESTIMATE_PARAMS computes the intrinsic K, rotation R and translation t from
    % given camera matrix P.
    
    M = P(1:3, 1:3);
    P = sign(det(M)) * P;
    
    [U, S, V] = svd(P);
    c = V(:, end);
    c = c / c(end);
    c = c(1:3, :);
    
    [Q, R] = qr(rot90(M,3));
    K = rot90(R,2)';
    R = rot90(Q);
    
    T = diag(sign(diag(K)));
    K = K * T;
    R = T * R;
    
    K = K / K(end, end);
    t = -R * c;
end