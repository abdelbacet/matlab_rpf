function n = preprocess_samples(k, boxsize, max_samples_box, spp)
    global bin_import;
    if nargin < 4
        spp = 8;
    end
    mean_position = [floor(mean(bin_import(1,k:k+spp-1))), floor(mean(bin_import(2,k:k+spp-1)))];
    standard_deviation = boxsize/4;
    % add all samples of current pixel
    N = k:k+7; 
    % Normal of first intersection
    % NOT THERE World-Space position of first intersection
    % primary albedo (texture value of first intersection)
    % NOT THERE World-Space position of second intersection
    % secondary normal
    % secondary albedo (texture value second intersection)
    features = [13, 16, 28, 34];
    [means, variances] = getFeatureMeanAndVariance(features, k);
    
    for q = 1:(max_samples_box - spp)
        sample_pos = normrnd(mean_position, standard_deviation);
        % skip if out of range
        if (any(sample_pos < [1,1] | sample_pos > [620, 362]))
            continue;
        end
        j = getIndexByPosition(sample_pos);
        sample_number = randi([0, 7]); %TODO: make sure a sample isn't chosen twice
        flag = 1;
        for f_nr = 1:length(features)
            feature_value = getFeatureForIndex(features(f_nr), j + sample_number);
            larger_than_variance = abs(feature_value - current_pixel_feature_value(f_nr, means)) > 3*current_pixel_feature_value(f_nr, variances);
            variance_is_significant = abs(feature_value - current_pixel_feature_value(f_nr, means)) > 0.1 | current_pixel_feature_value(f_nr, variances) > 0.1;
            if any(larger_than_variance & variance_is_significant)             
                flag = 0;
                break;
            end
        end
        if flag == 1
            % append to neighbourhood
            N = [N, k];
        end
    end
    n = N;
    %Neighbourhood ready for statistical analysis
    
    % todo: normalize N, return it
end

function f_mean = current_pixel_feature_value(f_nr, type)
    f_mean = type(f_nr:(f_nr+2));
end