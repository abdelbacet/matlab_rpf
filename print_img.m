function print_img(bin_import, name, spp)
    %initialize image
    img = zeros(620, 362, 3);
    % Number of samples per pixel

    N = size(bin_import, 2);
    for i = 1:spp:N
        [x, y] = getPositionByIndex(i, size(img, 2), spp);
        img(y + 1 , x + 1, :) = sum(bin_import(7:9,i + (0:(spp-1))),2)/spp;
    end
    exrwrite(img, [name '.exr']);
end