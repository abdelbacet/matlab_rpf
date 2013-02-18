% fid = fopen('samplebuffer_sanmiguel_diffuse_8spp.bin');
% 
% bin_import = fread (fid, [9+3*10, 362*620*8],'float');
% 
% fclose(fid);

%initialize image
img = zeros(620, 362, 3);
prg = progress();
% Number of samples per pixel
spp = 8;

N = size(bin_import, 2);
for i = 1:spp:N
    x = floor(mean(bin_import(1,i:i+spp-1)));
    y = floor(mean(bin_import(2,i:i+spp-1)));
    r = mean(bin_import(7,i:i+spp-1));
    g = mean(bin_import(8,i:i+spp-1));
    b = mean(bin_import(9,i:i+spp-1));
    img(y+1, x+1, :) = [r g b];
    if mod(i, 80) == 0
        progress(prg, i/(N-8));
    end
end

imtool(img)
exrwrite(img, 'img_01.exr');
