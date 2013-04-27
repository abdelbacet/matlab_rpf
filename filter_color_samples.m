function output_colors_pixel = filter_color_samples(neighbourhood, a, b, W_r_c, spp, debug_pixel, iter_step)
    sum_weights_col_rand = W_r_c;
    
    init_variance = 0.02; % indoor
    % init_variance = 0.002 % other
    variance = 8*init_variance/spp;
    
    %This could cause division by zero:
    variance_color = variance;
    variance_feature = variance_color;   
    % different from paper: swapped with numerical stable version
    scale_c = -(1-sum_weights_col_rand)^2/(2*variance_color);
    scale_f = -(1-sum_weights_col_rand)^2/(2*variance_feature);
        
    output_colors_pixel = zeros(3,spp);

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
        
        % printing weights of first 14 samples in neighbourhood
%        if (debug_pixel)
%            debug_weights = debug_weights + relative_weights;
%            if (i == 1)
%                fprintf('sum wec: \n')
%                disp(sum_wec(1:14));
%                fprintf('weighted error features: \n')
%                disp(sum_wef(1:14));
%                fprintf('resulting relative weights: \n')
%            end
%        end
        output_colors_pixel(:,i) = sum(bsxfun(@times, neighbourhood.input_colors, relative_weights),2)./ ...
                                                        sum(relative_weights); 
    end
    
    %% Debug: print weights
%     if (debug_pixel || any(any(new_colors_pixel < 0)))
%         fprintf('printing weights of debug pixel (overall %d)... ', sum(debug_weights));
%         % initialize red
%         img = repmat(reshape([1 0 0], 1, 1, 3), [620, 362, 1]);
%         % replace red with weight (grayscale) if available
%         for i=1:length(debug_weights)
%             pos = neighbourhood.pos_unnormed(:, i);
%             before = reshape(img(pos(2) + 1, pos(1) + 1, :), 3, 1);
%             if (before == [1;0;0])
%                 before = zeros(3, 1);
%             end
%             img(pos(2) + 1, pos(1) + 1, :) = before + repmat(debug_weights(i), 3, 1);
%         end
%         exrwrite(img, ['relative_weights_debug_pixel' num2str(iter_step) '.exr']);
%         fprintf('done! \n');
%     end
    %% HDR clamp
    new_colors_mean_before = mean(output_colors_pixel, 2);
    new_colors_std = std(output_colors_pixel, 0, 2); 
    new_colors_error = abs(bsxfun(@minus, output_colors_pixel, new_colors_mean_before));
    % only treat up spikes:
    % new_colors_error = abs(bsxfun(@minus, new_colors_pixel, new_colors_mean_before));
    
    % could introduce larger error margin like 2*std
    outliers = any(bsxfun(@gt, new_colors_error, new_colors_std), 1);
    output_colors_pixel(:,outliers) = repmat(new_colors_mean_before, [1, sum(outliers)]);

    %% Reinsert energy lost from HDR clamp
    lost_energy_per_sample = new_colors_mean_before - mean(output_colors_pixel, 2);
    output_colors_pixel = bsxfun(@plus, output_colors_pixel, lost_energy_per_sample);
    
    % printing colors before and after for debugging
%    if (debug_pixel)
%        fprintf('color before: \n')
%        disp(neighbourhood.color_input(:, 1:8))
%        fprintf('color after: \n')
%        disp(output_colors_pixel)
%    end
end
