function new_colors = filter_color_samples(bin_import, all_samples_pixel, neighbourhood, a, b, weights_col_rand, spp)
    sum_weights_col_rand = sum(weights_col_rand)/3;
    
    init_variance = 0.02; % indoor
    % init_variance = 0.002 % other
    variance = 8*init_variance/spp;
    variance_color = variance/(1-sum_weights_col_rand)^2;
    variance_feature = variance_color;
    
    color_samples = % todo
    for 
end