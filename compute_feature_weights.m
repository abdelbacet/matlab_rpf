function [a, b, weights_col_rand] = compute_feature_weights(iter_step, N)
    dependency_col_rand = zeros(3,1); %summed up dependency to random parameter and channels
    dependency_col_pos = zeros(3,1);
    dependency_col_f = zeros(3,size(N.features, 1));
    weights_col_rand = zeros(3,1);
    a = zeros(3,1);
    for channel = 1:3     
        channel_info = N.color(channel,:)';
        for random_par = N.random_pars'
            dependency_col_rand(channel) = dependency_col_rand(channel) + mutualinfo(channel_info, random_par);
        end
        
        for pos_par = N.pos' 
            dependency_col_pos(channel) = dependency_col_pos(channel) + mutualinfo(channel_info, pos_par);
        end
        
        f_nr = 1;
        for f_par = N.features'
            dependency_col_f(channel, f_nr) = mutualinfo(channel_info, f_par);
            f_nr = f_nr + 1;
        end
        % added epsilon to prevent degeneration?
        weights_col_rand(channel) = dependency_col_rand(channel)/ ...
            (dependency_col_rand(channel) + dependency_col_pos(channel) + 1e-10);
        
        % with optimization from tech repport, not as in original paper
        a(channel) = max(1 - (1 + 0.1*(iter_step - 1))*weights_col_rand(channel), 0);
    end
    dependency_f_col_over_f = sum(dependency_col_f, 1); % for each feature, summed up over channels
    sum_dependency_col_f = sum(dependency_f_col_over_f); % for each channel, summed up over all features
    sum_dependency_col_rand = sum(dependency_col_rand);
    sum_dependency_col_pos = sum(dependency_col_pos);
    sum_dependency_col_overall = sum_dependency_col_rand + sum_dependency_col_pos + sum_dependency_col_f;
    b = zeros(size(N.features,1), 1);
    for f_nr=1:size(N.features, 1)
        f_par = N.features(f_nr,:)';
        dependency_f_rand = 0;
        dependency_f_pos = 0;
        for random_par = N.random_pars'
            dependency_f_rand = dependency_f_rand + mutualinfo(random_par, f_par);
        end

        for pos_par = N.pos'
            dependency_f_pos = dependency_f_pos + mutualinfo(pos_par, f_par);
        end
        
        % added epsilon to prevent degeneration
        weight_f_rand = dependency_f_rand/(dependency_f_rand + dependency_f_pos + 1e-10);
        
        % added epsilon to prevent degeneration (is this ok here?)
        weight_f_col = dependency_f_col_over_f(f_nr)/ (...
                                                sum_dependency_col_overall + 1e-10);
                        
        b(f_nr) = weight_f_col * max(1 - (1 + 0.1*iter_step)*weight_f_rand, 0);
    end
end