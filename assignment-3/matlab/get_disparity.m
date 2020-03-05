function dispM = get_disparity(im1, im2, maxDisp, windowSize)

    w = (windowSize-1) / 2;
    max_disparity = maxDisp;
    num_map_rows = size(im1, 1);
    num_map_cols = size(im1, 2);
    dispM = zeros(num_map_rows, num_map_cols);
    
    for i=max_disparity+w+1:size(im1,1)-(max_disparity+w+1)
        for j=w+1:size(im1,2)-(w+1)
            for d=0:maxDisp
                dstnc(d+1) = norm(double(im1(i-w:i+w, j-w:j+w) - im2(i-w-d:i+w-d, j-w:j+w)));
            end
            dispM(i,j) = find(dstnc == min(dstnc), 1);
        end
    end

end 