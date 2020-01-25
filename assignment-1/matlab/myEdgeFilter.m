function [img1] = myEdgeFilter(img0, sigma)
    % Get the Gaussian filter
    kernel = fspecial('gaussian', [5 5], sigma);

    img_smoothed = myImageFilter(img0, kernel);
    img1 = img_smoothed
end
    
                
        
        
