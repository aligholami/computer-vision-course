function [H, rhoScale, thetaScale] = myHoughTransform(Im, threshold, rhoRes, thetaRes)
    Im(Im < threshold) = 0;
    [num_rows, num_cols] = size(Im);
    theta_max = pi;
    rho_max = ceil(sqrt(num_cols^2 + num_rows^2));
    thetaScale = 0:thetaRes:theta_max;
    rhoScale = -rho_max:rhoRes:rho_max;
    H = zeros(2*rho_max/rhoRes+1, pi/thetaRes+1);
    cos_theta = cos(thetaScale);
    sin_theta = sin(thetaScale);
           
    for i=1:num_rows
        for j=1:num_cols
            if Im(i, j) > 0
                y = i;
                x = j;
                for theta_idx=1:size(thetaScale, 2)
                    rho = x * cos_theta(theta_idx) + y * sin_theta(theta_idx);
                    rho_idx = floor((rho + rho_max) / rhoRes) + 1;
                    H(rho_idx, theta_idx) = H(rho_idx, theta_idx) + 1;
                end
            end
        end
    end
    H = H / 255;
end
