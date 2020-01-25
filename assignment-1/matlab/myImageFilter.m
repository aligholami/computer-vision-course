function [img1] = myImageFilter(img0, h)

    h = fliplr(h)
    [num_img_rows, num_img_cols] = size(img0);
    [num_filter_rows, num_filter_cols] = size(h);
    pad_value = floor(num_filter_rows / 2);

    % Pad the image (post and pre)
    img0_padded = padarray(img0, [pad_value, pad_value], 'replicate', 'pre');
    img0_padded = padarray(img0_padded, [pad_value, pad_value], 'replicate', 'post');
    [num_padded_img_rows, num_padded_img_cols] = size(img0_padded);
    returning_img = zeros(num_padded_img_rows, num_padded_img_cols);
    
    for i=1:num_padded_img_rows - num_filter_rows
        for j=1:num_padded_img_cols - num_filter_cols
            acc = 0;
            for m=1:num_filter_rows
                for n=1:num_filter_cols
                    acc = acc + h(m, n) * img0_padded(i + m, j + n);
                end
            end
            returning_img(i + pad_value, j + pad_value) = acc;
        end
    end

    % Unpad the image
    [ret_img_num_rows, ret_img_num_cols] = size(returning_img);
    img1 = returning_img(pad_value:ret_img_num_rows - pad_value - 1, pad_value:ret_img_num_cols - pad_value - 1);
end
