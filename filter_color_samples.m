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
    for i=1:(spp-1)
        sum_relative_weights = zeros(3,1);
        % This loop doesn't work at all!
        for j=1:length(neighbourhood.color)
            relative_weight = exp(-1/(2*variance_color)*sum(a.*(current_pixel.color(:,i) - neighbourhood.color(:,j)).^2)) .* ...
                              exp(-1/(2*variance_feature)*sum(b.*(current_pixel.features(:,i) - neighbourhood.features(:,j)).^2));
            % for this we have to use unnormalized color!
            new_colors(:,i) = new_colors(:,i) + relative_weight*bin_import(7:9,neighbourhood.index(j));
            sum_relative_weights = sum_relative_weights + relative_weight;
        end
        new_colors(:,i) = new_colors(:,i)./sum_relative_weights;
    end
end