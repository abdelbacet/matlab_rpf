function neighbourhood = preprocess_samples(bin_import, k, boxsize, max_samples_box, spp)
    %img_width = 362;
    mean_position = [floor(bin_import(1,k(1))), floor(bin_import(2,k(1)))]';
    standard_deviation = boxsize/4;
    

    % Normal of first intersection
    % World-Space position of first intersection
    % primary albedo (texture value of first intersection) = sec_origin
    % World-Space position of second intersection
    % secondary normal

    idx_features = [13:15, 19:21, 16:18, 21:23, 28:30];
    means        = sum(bin_import(idx_features, k), 2) / numel(k);
    st_deviation = std(bin_import(idx_features, k), 0, 2);
    % todo: weight std here as follows: 
    % world-position x 30
    % everything else x 3
    adapted_std = [ 3*st_deviation(1:3, :) 
                    30*st_deviation(4:6,:) 
                    3*st_deviation(7:9, :)
                    30*st_deviation(10:12,:)
                    3*st_deviation(13:15,:)];
    mu = repmat(mean_position, [1, max_samples_box - spp]);
    sample_pos_array = round(normrnd(mu, standard_deviation));
    % todo: rework first if into various bsxfun/logical operators:
    inside_img = all(bsxfun(@ge, sample_pos_array, [0,0]') & bsxfun(@le, sample_pos_array, [620, 362]'), 1);
    not_initial_pos = any(bsxfun(@ne, sample_pos_array, mean_position), 1);
    valid_sample_pos = sample_pos_array(:, inside_img & not_initial_pos);
    valid_sample_idxs = valid_sample_pos(1,:) + 362*valid_sample_pos(2,:);
    valid_sample_idxs = valid_sample_idxs*spp + 1;
    valid_sample_idxs = valid_sample_idxs + randi([0, 7], size(valid_sample_idxs));
    
    feature_values = bin_import(idx_features, valid_sample_idxs);
    diff_features = abs(bsxfun(@minus, feature_values, means));
    larger_than_variance = bsxfun(@gt, feature_values, adapted_std);
    variance_is_significant = diff_features > 0.1 | repmat(st_deviation > 0.1, size(valid_sample_idxs));
    chosen_samples = not(any(larger_than_variance & variance_is_significant, 1));
    
    % add all samples of current pixel and valid ones to neighbourhood
    N = [k, valid_sample_idxs(chosen_samples)];
    %Neighbourhood ready for statistical analysis    
    neighbourhood = makeStruct(bin_import, N);
end