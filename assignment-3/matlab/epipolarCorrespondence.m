function [pts2] = epipolarCorrespondence(im1, im2, F, pts1)
    % epipolarCorrespondence:
    %   Args:
    %       im1:    Image 1
    %       im2:    Image 2
    %       F:      Fundamental Matrix from im1 to im2
    %       pts1:   coordinates of points in image 1
    %   Returns:
    %       pts2:   coordinates of points in image 2
    %

    % 1. Find the epipolar line in image 2 using F * pts1
    N = size(pts1, 1);
    pts1_t_aug = [pts1'; ones(1, N)];
    im2_lines = F * pts1_t_aug;   % [3, N]

    pts2 = [];
    for i=1:N
        im2_line = im2_lines(1:3, i);
        line_scale = sqrt(im2_line(1)^2 + im2_line(2)^2);

        % line_scaled is the epipolar line
        line_scaled = im2_line / line_scale;
        
        % Point of search
        l2 = [-line_scaled(2) line_scaled(1) line_scaled(2)*pts1(i, 1) - line_scaled(1)*pts1(i, 2)]';
        search_point = round(cross(line_scaled, l2));
        
        % Search parameters
        window_size = 5;
        kernel_size = 2 * window_size + 1;
        im1_patch = double(im1((pts1(i, 2) - window_size):(pts1(i, 2) + window_size), (pts1(i, 1) - window_size):(pts1(i, 1) + window_size), :));
        min_disimilarity = 3000;

        for k=search_point(1)-window_size:1:search_point(1)+window_size
            for m=search_point(2)-window_size:1:search_point(2)+window_size
                im2_patch = double(im1((m - window_size):(m + window_size), (k - window_size):(k + window_size), :));
                disimilarity = im2_patch - im1_patch;
                
                if disimilarity < min_disimilarity
                    min_disimilarity = disimilarity;
                    x = k;
                    y = m;
                end
            end
        end
        pts2 = [pts2; x, y];
    end
end