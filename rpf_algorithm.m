version = '1.0.1';
[bin_import, spp] = read_binary();

if matlabpool('size') == 0
    matlabpool open
end
%progress = waitbar(0, 'zomfg..');
%initializes random generator
rng(42);
boxsizes=[55 35 17 7];
for iter_step = 4
    boxsize = boxsizes(iter_step);
    max_samples_box = boxsize^2*spp/2;
    
    %iterate over every pixel
    nr_pixels = length(bin_import)/8;
    %new_colors = zeros(3, length(bin_import));
    new_colors = zeros(length(bin_import)/8, 3, 8);
    parfor i = 1:nr_pixels
        all_samples_pixel = (i-1)*8+1:((i-1)*8 + 8);
        neighbourhood = preprocess_samples(bin_import, all_samples_pixel, boxsize, max_samples_box, spp);
        [a, b, weights_col_rand] = compute_feature_weights(iter_step, neighbourhood);
        new_colors(i,:,:) = filter_color_samples(bin_import, all_samples_pixel, neighbourhood, a, b, weights_col_rand, spp);
    end
    
    % write new_colors back into bin_import 
    % (don't question the matlab magic)
    bin_import(7:9, :) = reshape(new_colors, [], size(new_colors, 2), 1)';
    fprintf('finished iteration step!');
    print_img(bin_import, ['iter_' num2str(iter_step) '_v' version], spp);
end