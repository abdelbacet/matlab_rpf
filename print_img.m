function img = print_img(all_indirect, all_albedo, name, spp)
    %initialize image
    img = zeros(620, 362, 3);
    % Number of samples per pixel

    N = size(bin_import, 2);
    for i = 1:spp:N
        [x, y] = getPositionByIndex(i, size(img, 2), spp);
        indirect = all_indirect(:,i + (0:(spp-1)));
        albedo = all_albedo(:,i + (0:(spp-1)));
        img(y + 1 , x + 1, :) = sum(indirect.*albedo, 2)/spp;
    end
    exrwrite(img, [name '.exr']);
end
