function n = preprocess_samples(k, boxsize, max_samples_box, spp)
    global bin_import;
    if nargin < 4
        spp = 8;
    end
    mean_position = [floor(mean(bin_import(1,k:k+spp-1))), floor(mean(bin_import(2,k:k+spp-1)))];
    standard_deviation = boxsize/4;
    N = k; 
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
        j = getIndexByPosition(sample_pos);
        sample_number = randi([0, 7]); %TODO: make sure a sample isn't chosen twice
        flag = 1;
        for f = [features 
                1:length(features)]
            feature_value = getFeatureForIndex(f(1), j + sample_number);
            % TODO: loop over multiple features?
            if (abs(feature_value - means(f(2))) < 3*variances(f(2))) && (abs(feature_value - means(f(2)) > 0.1 | variances(f(2)) > 0.1))                
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
end