function [a, b] = compute_feature_weights(boxsize, N)
    for channel = 1:3
        dependency_rand = 0; %summed up dependency to random parameter
        channel_info = N.color(channel,:)';
        for random_par = N.lens_coord'
            dependency_rand = dependency_rand + mutualinfo(channel_info, random_par);
        end
        
        dependency_pos = 0;
        for pos_par = N.pos' 
            dependency_pos = dependency_pos + mutualinfo(channel_info, pos_par);
        end
        
        dependency_f = 0;
        
        for feature_name = ['normals', 'pri_albedos', 'pri_intersec', 'sec_normals', 'sec_intersec']
            f = N.get(feature_name);
            for f_par = f'
                dependency_f = dependency_f + mutualinfo(channel_info, f_par);
            end
        end
        
    end
end


%Computes mutual informatin of two variables
