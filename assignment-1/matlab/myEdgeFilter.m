function [img1] = myEdgeFilter(img0, sigma)
    % Get the Gaussian filter
    kernel_size = 2 * ceil(3 * sigma) + 1
    gaussian_kernel = fspecial('gaussian', [kernel_size kernel_size], sigma);
    img_smoothed = myImageFilter(img0, gaussian_kernel);
    
    h_sobel_kernel = [1, 0, -1; 2, 0, -2; 1, 0, -1];
    v_sobel_kernel = [1, 2, 1; 0, 0, 0; -1, -2, -1];

    imgx = myImageFilter(img_smoothed, h_sobel_kernel);
    imgy = myImageFilter(img_smoothed, v_sobel_kernel);

    img1 = imgx;
end