function n = preprocess_samples(k, boxsize, max_samples_box, ssp)
    if nargin < 4
        ssp = 8;
    end
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
    
    for q = 1:(max_samples_box - ssp)
        sample_pos = normrnd(mean_position, standard_deviation);
        j = getIndexByPosition(sample_pos);
        sample_number = randi([0, 7]); %TODO: make sure a sample isn't chosen twice
        flag = 1;
        for f = [features 
                1:length(features)]
            feature_value = getFeatureForIndex(f(0), j + sample_number);
            % TODO: loop over multiple features?
            if (abs(feature_value - means(f(1))) < 3*variances(f(1))) && (abs(feature_value - means(f(1)) > 0.1 || variances(f(1)) > 0.1))                
                flag = 0;
                break;
            end
        end
        if flag == 1
            % append to neighbourhood
            N = [N, k];
        end
    end
    
    %Neighbourhood ready for statistical analysis
end