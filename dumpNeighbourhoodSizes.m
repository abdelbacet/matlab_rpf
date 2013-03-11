% Starts the random parameter filtering algorithm

[bin_import, spp] = read_binary();

if matlabpool('size') == 0
    matlabpool open
end

%initializes random generator
rng(42);
boxsizes=[55 35 17 7];
for iter_step = 1
    boxsize = boxsizes(iter_step);
    max_samples_box = boxsize^2*spp/2;
    
    nr_pixels = length(bin_import)/8;

    img_arry = zeros(nr_pixels,3);
    parfor i = 1:nr_pixels
        all_samples_pixel = (i-1)*8+1:((i-1)*8 + 8);
        [neighbourhood, neighbourhood_idxs] = preprocess_samples(bin_import, all_samples_pixel, boxsize, max_samples_box, spp);
        img_arry(i, :) = repmat(size(neighbourhood_idxs, 2), 1, 3);
    end
    
    img = zeros(620, 362, 3);
    for i = 0:(nr_pixels -1)
        x = floor(mod(i, size(img,2))) + 1;
        y = floor(i/size(img,2)) + 1;
        img(y , x, :) = img_arry(i + 1);
    end
    
    exrwrite(img, 'neighbourhoods_bs55.exr');
end