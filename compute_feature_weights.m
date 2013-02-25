function [a, b] = compute_feature_weights(iter_step, N)
    features = {'normals', 'pri_albedos', 'pri_intersec', 'sec_normals', 'sec_intersec'};
    dependency_col_rand = zeros(3,1); %summed up dependency to random parameter and channels
    dependency_col_pos = zeros(3,1);
    dependency_col_f = zeros(3,1);
    weight = zeros(3,1);
    a = zeros(3,1);
    for channel = 1:3     
        channel_info = N.color(channel,:)';
        for random_par = N.lens_coord'
            dependency_col_rand(channel) = dependency_col_rand(channel) + mutualinfo(channel_info, random_par);
        end
        
        for pos_par = N.pos' 
            dependency_col_pos(channel) = dependency_col_pos(channel) + mutualinfo(channel_info, pos_par);
        end
        
        for feature_name = features
            f = N.(feature_name{1});
            for f_par = f'
                dependency_col_f(channel) = dependency_col_f(channel) + mutualinfo(channel_info, f_par);
            end
        end
        % also apply error-term to this?
        weight(channel) = dependency_col_rand(channel)/(dependency_col_rand(channel) + dependency_col_pos(channel));
        
        % with optimization from tech repport, not as in original paper
        a(channel) = max(1 - 2*(1 + 0.1*(iter_step - 1))*weight(channel), 0);
    end
    
    for feature_name = features
        f = N.(feature_name{1});
        for f_par = f'
            for random_par = N.lens_coord'
                dependency_f_rand(channel) = dependency_f_rand(channel) + mutualinfo(channel_info, f_par);
            end
        end
    end
end


%Computes mutual informatin of two variables
