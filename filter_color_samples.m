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
        
    new_colors_pixel = zeros(3,spp);
    %current_pixel = makeStruct(bin_import, all_samples_pixel);
    % todo: use samples_struct instead of other stuff
    debug_weights = zeros(1, length(neighbourhood.color));
    %% This assumes, that the first 8 samples of the neighbourhood are the samples of the current pixel
    for i=1:spp
        squared_error_color = bsxfun(@minus, neighbourhood.color, neighbourhood.color(:,i)).^2;
        % Essential: use same alpha for every color channel to prevent discoloring
        weighted_error_color =  squared_error_color.*a;
        sum_wec = sum(weighted_error_color, 1);
        
        squarred_error_features = bsxfun(@minus, neighbourhood.features, neighbourhood.features(:,i)).^2;
        weighted_error_features = bsxfun(@times, squarred_error_features, b);
        sum_wef = sum(weighted_error_features, 1);
        
        relative_weights = exp(scale_c*sum_wec + scale_f*sum_wef);
        if (debug_pixel)
            debug_weights = debug_weights + relative_weights;
%             fprintf('squared error color: \n')
%             disp(squared_error_color(:, 1:14));
%             fprintf('weighted error features: \n')
%             disp(squarred_error_features(:, 1:14));
        end
        new_colors_pixel(:,i) = sum(bsxfun(@times, neighbourhood.color_unnormed, relative_weights),2)./ ...
                                                        sum(relative_weights); 
    end
    
    %% Debug: print weights
    if (debug_pixel)
        fprintf('printing weights of debug pixel...');
        % initialize red
        img = repmat(reshape([1 0 0], 1, 1, 3), [620, 362, 1]);
        % replace red with weight (grayscale) if available
        for i=1:length(debug_weights)
            pos = neighbourhood.pos_unnormed(:, i);
            before = reshape(img(pos(2) + 1, pos(1) + 1, :), 3, 1);
            if (before == [1;0;0])
                before = zeros(3, 1);
            end
            img(pos(2) + 1, pos(1) + 1, :) = before + repmat(debug_weights(i), 3, 1);
        end
        exrwrite(img, ['relative_weights_debug_pixel' num2str(iter_step) '.exr']);
        fprintf('done! \n');
    end
    %% HDR clamp
    new_colors_mean_before = mean(new_colors_pixel, 2);
    new_colors_std = std(new_colors_pixel, 0, 2); 
    new_colors_error = abs(bsxfun(@minus, new_colors_pixel, new_colors_mean_before));
    
    % could introduce larger error margin like 2*std
    outliers = any(bsxfun(@gt, new_colors_error, new_colors_std), 1);
    new_colors_pixel(:,outliers) = repmat(new_colors_mean_before, [1, sum(outliers)]);

    %% Reinsert energy lost from HDR clamp
    lost_energy_per_sample = new_colors_mean_before - mean(new_colors_pixel, 2);
    new_colors_pixel = bsxfun(@plus, new_colors_pixel, lost_energy_per_sample);
end