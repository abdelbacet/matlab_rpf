function print_img(bin_import, name, spp)
    %initialize image
    img = zeros(620, 362, 3);
    % Number of samples per pixel

    N = size(bin_import, 2);
    for i = 1:spp:N
        x = floor(mean(bin_import(1,i:i+spp-1)));
        y = floor(mean(bin_import(2,i:i+spp-1)));
        r = mean(bin_import(7,i:i+spp-1));
        g = mean(bin_import(8,i:i+spp-1));
        b = mean(bin_import(9,i:i+spp-1));
        img(y+1, x+1, :) = [r g b];
    end
    imtool(img)
    exrwrite(img, name);
end