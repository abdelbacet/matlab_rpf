function neighbourhood = preprocess_samples(k, boxsize, max_samples_box, spp)
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
    [means, st_deviation] = getFeatureMeanAndStd(features, k);
    for q = 1:(max_samples_box - spp)
        sample_pos = round(normrnd(mean_position, standard_deviation));
        % skip if out of range or at initial position
        if (any(sample_pos < [1,1] | sample_pos > [620, 362]) || all(sample_pos == mean_position))
            continue;
        end
        j = getIndexByPosition(sample_pos);
        sample_number = randi([0, 7]); %TODO: make sure a sample isn't chosen twice?
        inspected_sample = j + sample_number;
        flag = 1;
        for f_nr = 1:length(features)
            feature_value = getFeatureForIndex(features(f_nr), inspected_sample);
            larger_than_variance = abs(feature_value - means(:,f_nr)) > 3*st_deviation(:,f_nr);
            variance_is_significant = abs(feature_value - means(:,f_nr)) > 0.1 | st_deviation(:,f_nr) > 0.1;
            if any(larger_than_variance & variance_is_significant)             
                flag = 0;
                break;
            end
        end
        if flag == 1
            % append to neighbourhood, not sure how many are added
            N = [N, inspected_sample];
        end
    end
    %Neighbourhood ready for statistical analysis
    neighbourhood = [];
    for ns=N
        neighbourhood = [neighbourhood, struct('index', ns, ...
                        'normal', getFeatureForIndex(13, ns), ...
                        'pri_albedo', getFeatureForIndex(16, ns), ...
                        'sec_normal', getFeatureForIndex(28, ns), ...
                        'sec_albedo', getFeatureForIndex(34, ns)) ];
    end
    
    means_neighbourhood = struct( 'normal', mean([neighbourhood.normal], 2), ...
                    'pri_albedo', mean([neighbourhood.pri_albedo], 2), ...
                    'sec_normal', mean([neighbourhood.sec_normal], 2), ...
                    'sec_albedo', mean([neighbourhood.sec_albedo], 2));
    std_neighbourhood = struct( 'normal', std([neighbourhood.normal], 0, 2), ...
                    'pri_albedo', std([neighbourhood.pri_albedo], 0, 2), ...
                    'sec_normal', std([neighbourhood.sec_normal], 0, 2), ...
                    'sec_albedo', std([neighbourhood.sec_albedo], 0, 2));
    for n = neighbourhood
        n.normal = (n.normal - means_neighbourhood.normal) / std_neighbourhood.normal;
        n.pri_albedo = (n.pri_albedo - means_neighbourhood.pri_albedo) / std_neighbourhood.pri_albedo;
        n.sec_normal = (n.sec_normal - means_neighbourhood.sec_normal) / std_neighbourhood.sec_normal;
        n.sec_albedo = (n.sec_albedo - means_neighbourhood.sec_albedo) / std_neighbourhood.sec_albedo;
    end
end