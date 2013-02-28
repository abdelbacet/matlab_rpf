function neighbourhood = preprocess_samples(bin_import, k, boxsize, max_samples_box, spp)
    if nargin < 4
        spp = 8;
    end
    %img_width = 362;
    mean_position = [floor(bin_import(1,k)), floor(bin_import(2,k))]';
    standard_deviation = boxsize/4;
    % add all samples of current pixel
    N = k:k+7; 
    % Normal of first intersection
    % World-Space position of first intersection
    % primary albedo (texture value of first intersection) = sec_origin
    % World-Space position of second intersection
    % secondary normal
    % secondary albedo (texture value second intersection)
    idx_features = [13:15, 19:21, 16:18, 21:23, 28:30, 34:36];
    means        = sum(bin_import(idx_features, N), 2) / numel(N);
    st_deviation = std(bin_import(idx_features, N), 0, 2);
    mu = repmat(mean_position, [1, max_samples_box - spp]);
    sample_pos_array = round(normrnd(mu, standard_deviation));
    % todo: rework first if into:
    %bsxfun(@lt, sample_pos_array, [1,1]');
    %bsxfun(@gt, sample_pos_array, [620, 362]');
    %bsxfun(@eq, sample_pos_array, mean_position);
    for sample_pos = sample_pos_array
        % skip if out of range or at initial position
        if (any(sample_pos < [1,1]' | sample_pos > [620, 362]') || all(sample_pos == mean_position))
            continue;
        end
        % find out index in bin_import of this position
        j = round(sample_pos(1) - 1) + 362*round(sample_pos(2) - 1);
        j = j*spp + 1; % multiply by spp, usual adaption for matlab lists
        
        sample_number = randi([0, 7]); %TODO: make sure a sample isn't chosen twice?
        inspected_sample = j + sample_number;
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