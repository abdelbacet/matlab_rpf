function print_8s_mc_normals()
    bin_import = evalin('base', 'bin_import');
    %initialize image
    img = zeros(620, 362, 3);
    % Number of samples per pixel
    spp = 8;

    N = size(bin_import, 2);
    for i = 1:spp:N
        x = floor(mean(bin_import(1,i:i+spp-1)));
        y = floor(mean(bin_import(2,i:i+spp-1)));
        r = shiftNormalToColor(mean(bin_import(28,i:i+spp-1)));
        g = shiftNormalToColor(mean(bin_import(29,i:i+spp-1)));
        b = shiftNormalToColor(mean(bin_import(30,i:i+spp-1)));
        img(y+1, x+1, :) = [r g b];
    end

    imtool(img)
    exrwrite(img, 'img_sec_normals.exr');
end

function color = shiftNormalToColor(normal)
    color = (normal + 1) /2;
end
