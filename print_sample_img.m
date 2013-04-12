function img = print_sample_img(bin_import, name, spp, s)
    %% only one sample is considered per pixel, choose s between 0 and 7
    %initialize image
    img = zeros(620, 362, 3);
    % Number of samples per pixel
    N = size(bin_import, 2);
    for i = 1:spp:N
        [x, y] = getPositionByIndex(i, size(img, 2), spp);
        indirect = bin_import(7:9,i + s);
        albedo = bin_import(16:18,i + s);
        img(y + 1 , x + 1, :) = indirect.*albedo;
    end
    exrwrite(img, [name 's_' num2str(s) '.exr']);
end