function print_img(bin_import, name, spp)
    %initialize image
    img = zeros(620, 362, 3);
    % Number of samples per pixel

    N = size(bin_import, 2);
    for i = 0:spp:N-1
        %yx = floor(mean(bin_import(1:2,i:i+spp-1), 2)); 
        x = mod(i/8, size(img,2)) + 1;
        y = floor(i/8/size(img,2)) + 1;
        img(y , x, :) = sum(bin_import(7:9,i+1:i+spp),2)/spp;
    end
    imtool(img)
    exrwrite(img, [name '.exr']);
end