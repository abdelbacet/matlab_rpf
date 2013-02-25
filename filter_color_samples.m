function new_colors = filter_color_samples(bin_import, all_samples_pixel, neighbourhood, a, b, weights_col_rand, spp)
    sum_weights_col_rand = sum(weights_col_rand)/3;
    
    init_variance = 0.02; % indoor
    % init_variance = 0.002 % other
    variance = 8*init_variance/spp;
    variance_color = variance/(1-sum_weights_col_rand)^2;
    variance_feature = variance_color;
    
    color_samples = bin_import(7:9,all_samples_pixel);
    for i=color_samples
        new_color = zeros(3,1);
        w = zeros(3,1);
        % This loop doesn't work at all!
        for j=neighbourhood
            relative_weight = exp(-1/(2*variance_color)*sum(a*(j - i)^2) * ...
                              exp(-1/(2*variance_feature)*sum(b*(1));
            new_color = new_color + sum_weights_col_rand*j;
%             w = w + ;
        end
    end
end