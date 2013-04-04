function new_colors = filter_color_samples(bin_import, all_samples_pixel, neighbourhood, a, b, weights_col_rand, spp)
    sum_weights_col_rand = weights_col_rand;
    
    init_variance = 0.02; % indoor
    % init_variance = 0.002 % other
    variance = 8*init_variance/spp;
    
    %This could cause division by zero:
    variance_color = variance;
    variance_feature = variance_color;   
    % different from paper: swapped with numerical stable version
    scale_c = -(1-sum_weights_col_rand)^2/(2*variance_color);
    scale_f = -(1-sum_weights_col_rand)^2/(2*variance_feature);
        
    new_colors = zeros(3,spp);
    current_pixel = makeStruct(bin_import, all_samples_pixel);
    % todo: use samples_struct instead of other stuff
    for i=1:spp
        squared_error_color = bsxfun(@minus, neighbourhood.color, current_pixel.color(:,i)).^2;
        weighted_error_color =  squared_error_color.*a;
        sum_wec = sum(weighted_error_color);
        
        squarred_error_features = bsxfun(@minus, neighbourhood.features, current_pixel.features(:,i)).^2;
        weighted_error_features = bsxfun(@times, squarred_error_features, b);
        sum_wef = sum(weighted_error_features);
        
        relative_weights =    exp(scale_c*sum_wec + scale_f*sum_wef);
       
        new_colors(:,i) = sum(bsxfun(@times, neighbourhood.color_unnormed, relative_weights),2)./ ...
                                                        sum(relative_weights); 
    end
    
    %% HDR clamp
    new_colors_mean = mean(new_colors, 2);
    % could introduce larger error margin like 2*std
    new_colors_std = std(new_colors,0,2); 
    new_colors_error = abs(bsxfun(@minus, new_colors, new_colors_mean));
    outliers = any(bsxfun(@gt, new_colors_error, new_colors_std), 1);
    new_colors(:,outliers) = repmat(new_colors_mean, [1, sum(outliers == 1)]);

    %% Reinsert energy
    lost_energy_per_sample = new_colors_mean - mean(new_colors, 2);
    new_colors = bsxfun(@plus, new_colors, lost_energy_per_sample);
end