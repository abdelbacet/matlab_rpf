function new_colors = filter_color_samples(bin_import, all_samples_pixel, neighbourhood, a, b, weights_col_rand, spp)
    sum_weights_col_rand = sum(weights_col_rand)/3;
    
    init_variance = 0.02; % indoor
    % init_variance = 0.002 % other
    variance = 8*init_variance/spp;
    variance_color = variance/(1-sum_weights_col_rand)^2;
    variance_feature = variance_color;
    
    new_colors = zeros(3,spp);
    current_pixel = makeStruct(bin_import, all_samples_pixel);
    
    % todo: use samples_struct instead of other stuff
    for i=1:spp
        
       
        error_color = bsxfun(@minus, neighbourhood.color, current_pixel.color(:,i)).^2;
        weighted_error_color = bsxfun(@times, error_color, a);
        sum_wec = sum(weighted_error_color);
        
        error_features = bsxfun(@minus, neighbourhood.features, current_pixel.features(:,i)).^2;
        weighted_error_features = bsxfun(@times, error_features, b);
        sum_wef = sum(weighted_error_features);
        
        relative_weights =    exp(-1/(2*variance_color)*sum_wec) .* ...
                              exp(-1/(2*variance_feature)*sum_wef);
       
        new_colors(:,i) = sum(bsxfun(@times, neighbourhood.color_unnormed, relative_weights),2);
        sum_relative_weights = sum(relative_weights);
        new_colors(:,i) = new_colors(:,i)./sum_relative_weights;       
    end
end