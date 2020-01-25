function [img1] = myEdgeFilter(img0, sigma)
    % Get the Gaussian filter
    kernel_size = 2 * ceil(3 * sigma) + 1
    kernel = fspecial('gaussian', [kernel_size kernel_size], sigma);

    img_smoothed = myImageFilter(img0, kernel);
    img1 = img_smoothed
end
    
                
        
        
