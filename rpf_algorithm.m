[bin_import, spp] = read_binary();

if matlabpool('size') == 0
    matlabpool open
end
%progress = waitbar(0, 'zomfg..');
boxsizes=[55 35 17 7]
for iter_step = 1:4
    boxsize = boxsizes(iter_step);
    max_samples_box = boxsize^2*spp/2;
    
    %iterate over every pixel
    nr_pixels = length(bin_import)/8;
    for i = 1:nr_pixels
        all_samples_pixel = (i-1)*8+1:((i-1)*8 + 7);
        neighbourhood = preprocess_samples(bin_import, all_samples_pixel, boxsize, max_samples_box, spp);
        [a, b] = compute_feature_weights(iter_step, neighbourhood);
    end 
end