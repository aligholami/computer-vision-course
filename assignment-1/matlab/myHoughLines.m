function [rhos, thetas] = myHoughLines(H, nLines)

    [num_rows, num_cols] = size(H);
    threshold = 0.5 * max(H(:))
    receptive_field_x_axis = floor(size(H, 1) / 100.0) * 2 + 1
    receptive_field_y_axis = floor(size(H, 2) / 100.0) * 2 + 1
    
    p_rhos = []
    p_thetas = []
    for i=1:nLines
        H_sorted = sort(H(:), 'descend');
        peak_value = H_sorted(1);
        if peak_value >= threshold
            [row, col] = find(H == peak_value, 1)

            % Non Maximum Suppression along x and y
            x_low = max([floor(row-receptive_field_y_axis) 1]);
            x_high = min([ceil(row+receptive_field_y_axis) num_rows]);
            y_low = max([floor(col-receptive_field_x_axis) 1]);
            y_high = min([ceil(col+receptive_field_x_axis) num_cols]);

            H(x_low:x_high,y_low:y_high) = 0;

            p_rhos = [p_rhos; row]
            p_thetas = [p_thetas; col]
        end
    end
    rhos = p_rhos
    thetas = p_thetas
end
        