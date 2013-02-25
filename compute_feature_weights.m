function [a, b] = compute_feature_weights(iter_step, N)
    features = {'normals', 'pri_albedos', 'pri_intersec', 'sec_normals', 'sec_intersec'};
    dependency_col_rand = zeros(3,1); %summed up dependency to random parameter and channels
    dependency_col_pos = zeros(3,1);
    dependency_col_f = zeros(3,1);
    a = zeros(3,1);
    for channel = 1:3     
        channel_info = N.color(channel,:)';
        for random_par = N.lens_coord'
            dependency_col_rand(channel) = mutualinfo(channel_info, random_par);
        end
        
        for pos_par = N.pos' 
            dependency_col_pos(channel) = mutualinfo(channel_info, pos_par);
        end
        
        for f_par = N.features'
            dependency_col_f(channel) = dependency_col_f(channel) + mutualinfo(channel_info, f_par);
        end
        end
        % also apply error-term to this?
        weight = dependency_col_rand(channel)/(dependency_col_rand(channel) + dependency_col_pos(channel));
        
        % with optimization from tech repport, not as in original paper
        a(channel) = max(1 - 2*(1 + 0.1*(iter_step - 1))*weight, 0);
    end
    
    b = zeros(length(features)*3, 1);
    for feature_name = features
        f = N.(feature_name{1});
        for f_par = f'
            dependency_f_rand = 0;
            dependency_f_pos = 0;
            for random_par = N.lens_coord'
                dependency_f_rand = dependency_f_rand + mutualinfo(random_par, f_par);
            end
            
            for pos_par = N.pos'
                dependency_f_pos = dependency_f_pos + mutualinfo(pos_par, f_par);
            end
            
            dependency_col_f_all = sum(dependency_col_f);
            
            weight_rand_pos = dependency_f_rand/(dependency_f_pos + dependency_f_rand);
            
            weight_f_col = dependency_col_f_all/(sum(dependency_col_rand)
        end
    end
end


%Computes mutual informatin of two variables
