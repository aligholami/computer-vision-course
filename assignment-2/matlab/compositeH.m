function [ composite_img ] = compositeH( H2to1, template, img )
%COMPOSITE Create a composite image after warping the template image on top
%of the image using the homography

% Note that the homography we compute is from the image to the template;
% x_template = H2to1*x_photo
% For warping the template to the image, we need to invert it.
H_template_to_img = inv(H2to1);

%% Create mask of same size as template
[num_rows, num_cols] = size(template);
mask = ones(num_rows, num_cols);

%% Warp mask by appropriate homography
warped_mask = warpH(mask, H_template_to_img, size(img));
% warped_mask = ~warped_mask;

%% Warp template by appropriate homography
warped_template = warpH(template, H_template_to_img, size(img));

%% Use mask to combine the warped template and the image
composite_img = uint8(warped_mask) .* warped_template + uint8(~warped_template) .* img;

end