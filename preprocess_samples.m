function n = preprocess_samples(i, boxsize, max_samples_box, ssp)
    if nargin < 4
        ssp = 8;
    end
    standard_deviation = boxsize/4;
    N = i; 
    % Normal of first intersection
    % NOT THERE World-Space position of first intersection
    % primary albedo (texture value of first intersection)
    % NOT THERE World-Space position of second intersection
    % secondary normal
    % secondary albedo (texture value second intersection)
    features = [13, 16, 28, 34];    
    
    [means, variances] = getFeatureMeanAndVariance(features, i);
    
    for q = 1:(max_samples_box - ssp)
        sample_pos = normrnd(mean_position, standard_deviation);
        j = getIndexByPosition(sample_pos);
        sampleNumber = randi([0, 7]);
        flag = 1;
        normal = 
        for f = features
            feature_value = getFeatureForIndex(f, j);
            % TODO: loop over multiple features?
            if ( abs(normal - ) > 3*variances[f]
                && abs(normal - ) % TODO
                flag = 0;
                % break; %only needed if looping over several features
            end

            if flag == 1
                N = [N, i];
            end
    end
    end
end