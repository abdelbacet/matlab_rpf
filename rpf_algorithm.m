%samples per pixel
global spp;
global bin_import; % only read from bin_import!
spp = 8;

progress = waitbar(0, 'zomfg..');
for boxsize=[55 35 17 7]
    max_samples_box = boxsize^2*spp/2;
    
    %iterate over every pixel
    for i = 1:(length(bin_import)/8)
        all_samples_pixel = (i-1)*8+1:((i-1)*8 + 7);
        neighbourhood = preprocess_samples(all_samples_pixel, boxsize, max_samples_box, spp);
        %[a, b] = compute_feature_weights(boxsize, N);
        waitbar(i*8/length(bin_import), progress, int2str(i))
    end 
end