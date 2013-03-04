bin_import = evalin('base', 'bin_import');
%initialize image
img = zeros(620, 362, 3);
% Number of samples per pixel
spp = 8;

N = size(bin_import, 2);

for i = 1:spp:N
    x = floor(mean(bin_import(1,i:i+spp-1)));
    y = floor(mean(bin_import(2,i:i+spp-1)));
    rgb = mean(bin_import(22:24,i:i+spp-1), 2);
    img(y+1, x+1, :) = reshape(rgb, [1 1 3]);
end

imtool(img)
exrwrite(img, 'img_sec_world_position.exr');
