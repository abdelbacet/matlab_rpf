%[bin_import, spp]= read_binary;
%initialize image
img = zeros(620, 362, 3);
% Number of samples per pixel

N = size(bin_import, 2);

for i = 1:spp:N
    x = floor(mean(bin_import(1,i:i+spp-1)));
    y = floor(mean(bin_import(2,i:i+spp-1)));
    rgb = mean(bin_import(13:15,i:i+spp-1), 2);
    img(y+1, x+1, :) = (reshape(rgb, [1 1 3]) + 1)./ 2;
end

imtool(img)
exrwrite(img, 'img_normals_smoothed_new_approach.exr');
