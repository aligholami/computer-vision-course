function [H, rhoScale, thetaScale] = myHoughTransform(Im, threshold, rhoRes, thetaRes)

    % Find rhos boundary based on x_max and y_max of the image
    [num_rows, num_cols] = size(Im);
    % Set up the accumulator
    theta_max = 2 * pi;
    rho_max = floor(sqrt(num_cols^2 + num_rows^2)) - 1;
    theta_range = [0:thetaRes:theta_max];
    rho_range = [0:rhoRes:rho_max];
    H = zeros(length(rho_range), length(theta_range));

    % Loop through Im
    for row=1:num_rows
        for col=1:num_cols
            % Suppress bullshit gradients
            if Im(row, col) > threshold
                x = row - 1;
                y = col - 1;
                for theta=theta_range
                    rho = round(x * cos(theta) + y * sin(theta));
                    if rho > 0 & rho < length(rho_range)
                        rho_idx = rho;
                        theta_idx = floor(theta) + 1;
                        H(rho_idx, theta_idx) = H(rho_idx, theta_idx) + 1;
                    end
                end
            end
        end
    end
    rhoScale = 0
    thetaScale = 0
end
        
        