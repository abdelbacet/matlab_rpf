function neighbourhood = preprocess_samples(bin_import, k, boxsize, max_samples_box, spp)
    %img_width = 362;
    mean_position = [floor(bin_import(1,k(1))), floor(bin_import(2,k(1)))]';
    standard_deviation = boxsize/4;
    % add all samples of current pixel 
    N = k;
    % Normal of first intersection
    % World-Space position of first intersection
    % primary albedo (texture value of first intersection) = sec_origin
    % World-Space position of second intersection
    % secondary normal
    % secondary albedo (texture value second intersection)
    idx_features = [13:15, 19:21, 16:18, 21:23, 28:30, 34:36];
    means        = sum(bin_import(idx_features, k), 2) / numel(k);
    st_deviation = std(bin_import(idx_features, k), 0, 2);
    mu = repmat(mean_position, [1, max_samples_box - spp]);
    sample_pos_array = round(normrnd(mu, standard_deviation));
    % todo: rework first if into various bsxfun/logical operators:
    inside_img = all(bsxfun(@ge, sample_pos_array, [0,0]') & bsxfun(@le, sample_pos_array, [620, 362]'), 1);
    not_initial_pos = any(bsxfun(@ne, sample_pos_array, mean_position), 1);
    valid_sample_pos = sample_pos_array(:, inside_img & not_initial_pos);
    valid_sample_index = valid_sample_pos(1,:) + 362*valid_sample_pos(2,:);
    valid_sample_index = valid_sample_index*spp + 1;
    valid_sample_index = valid_sample_index + randi([0, 7], size(valid_sample_index));
    for inspected_sample = valid_sample_index
        
        feature_values = bin_import(idx_features, inspected_sample);
        larger_than_variance = abs(feature_values - means) > 3*st_deviation;
        variance_is_significant = abs(feature_values - means) > 0.1 | st_deviation > 0.1;
        if not(any(larger_than_variance & variance_is_significant))
            % append to neighbourhood, not sure how many are added
            N = [N, inspected_sample];
        end
    end
    %Neighbourhood ready for statistical analysis
    
    neighbourhood = makeStruct(bin_import, N);
end