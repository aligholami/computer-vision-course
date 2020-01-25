function [res] = myEdgeFilter(img0, sigma)
    % Get the Gaussian filter
    kernel_size = 2 * ceil(3 * sigma) + 1
    gaussian_kernel = fspecial('gaussian', [kernel_size kernel_size], sigma);
    img_smoothed = myImageFilter(img0, gaussian_kernel);

    % To be tested with the actual conv2 by Matlab
    % img_smoothed = conv2(img0, gaussian_kernel);

    h_sobel_kernel = [1, 0, -1; 2, 0, -2; 1, 0, -1];
    v_sobel_kernel = [1, 2, 1; 0, 0, 0; -1, -2, -1];

    g_x = myImageFilter(img_smoothed, h_sobel_kernel);
    g_y = myImageFilter(img_smoothed, v_sobel_kernel);
    
    res = g_x
    g_directions = atan2(g_y, g_x)

    [num_g_rows, num_g_cols] = size(g_directions)
    discrete_directions = [0, pi/4, pi/2, 3*pi/4, pi, -3*pi/4. -pi/2, -pi/4]
    neighbors_offset_x = [+1, +1, 0, -1, -1, -1, 0, 1]
    neighbors_offset_y = [0, -1, -1, -1, 0, +1, +1, 1]
    
    for i=1:num_g_rows
        for j=1:num_g_cols
            gradient_direction = g_directions(i, j);
            
            % Find the closest number in the discrete_directions list
            min_difference = 100;
            min_difference_idx = 0;
            for k=1:length(discrete_directions)
                difference = abs(gradient_direction - discrete_directions(k));
                if difference < min_difference
                    min_difference = difference;
                    min_difference_idx = k;
                end
            end

            offset_x = neighbors_offset_x(k);
            offset_y = neighbors_offset_y(k);
            
            new_x_idx = j + offset_x;
            new_y_idx = i + offset_y;
            if (new_y_idx > 1) & (new_y_idx < num_g_rows)
                if (new_x_idx > 1) & (new_x_idx < num_g_cols)
                    neighbor_pixel = g_x(new_y_idx, new_x_idx);
                    if neighbor_pixel > g_x(i, j)
                        g_x(i, j) = 0;
                    end
                end
            end
        end
    end

    % res = g_x
end