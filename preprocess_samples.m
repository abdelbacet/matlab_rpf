function [neighbourhood, N] = preprocess_samples(bin_import, k, boxsize, max_samples_box, spp, input_colors)
    %img_width = 362;
    mean_position = [floor(bin_import(1,k(1))), floor(bin_import(2,k(1)))]';
    standard_deviation = boxsize/4;
    

    % Normal of first intersection => 13:15
    % primary albedo (texture value of first intersection) => 16:18
    % World-Space position of first intersection (sec_origin) => 19:21
    % World-Space position of second intersection (sec_hitpoint) => 22:24
    % secondary normal => 28:30

    idx_features = [13:24, 28:30];
    means        = sum(bin_import(idx_features, k), 2) / spp;
    st_deviation = std(bin_import(idx_features, k), 0, 2);

    adapted_std = [ 3*st_deviation(1:6) 
                    30*st_deviation(7:12) 
                    3*st_deviation(13:15)];
    mu = repmat(mean_position, [1, max_samples_box - spp]);
    sample_pos_array = round(normrnd(mu, standard_deviation));
    
    % min_boarder is now half of boxsize, this doesn't make too much
    % sense to crop it there, imho...
    min_boarder = max(mean_position - boxsize/2, [0;0]);
    max_boarder = min(mean_position + boxsize/2, [362; 620]);
    
    inside_img_and_box = all(bsxfun(@ge, sample_pos_array, min_boarder) & ...
                     bsxfun(@lt, sample_pos_array, max_boarder), 1);
    not_initial_pos = any(bsxfun(@ne, sample_pos_array, mean_position), 1);
    valid_sample_pos = sample_pos_array(:, inside_img_and_box & not_initial_pos);
    % contains img_width, works correct
    valid_sample_idxs = valid_sample_pos(1,:) + 362*valid_sample_pos(2,:);
    valid_sample_idxs = valid_sample_idxs*spp + 1;
    % samples might occur multiple times, but that's ok 
    % (importance sampling)
    valid_sample_idxs = valid_sample_idxs + randi([0, 7], size(valid_sample_idxs));
    % unique could be left out, not much impact after @jl
    %valid_sample_idxs = unique(valid_sample_idxs);
    feature_values = bin_import(idx_features, valid_sample_idxs);
    diff_features = abs(bsxfun(@minus, feature_values, means));
    larger_than_variance = bsxfun(@gt, diff_features, adapted_std);
    variance_is_significant = diff_features > 0.1 | repmat(st_deviation > 0.1, [1, length(valid_sample_idxs)]);
    chosen_samples = not(any(larger_than_variance & variance_is_significant, 1));
    
    % add all samples of current pixel and valid ones to neighbourhood
    N = [k, valid_sample_idxs(chosen_samples)];
    %Neighbourhood ready for statistical analysis    
    neighbourhood = makeStruct(bin_import, N, input_colors);
end