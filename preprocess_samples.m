function n = preprocess_samples(i, boxsize, max_samples_box, ssp)
    if nargin < 4
        ssp = 8;
    end
    standard_deviation = boxsize/4;
    N = i; 
    mean_position = [floor(mean(bin_import(1,i:i+spp-1))), floor(mean(bin_import(2,i:i+spp-1)))];
    mean_normal = getNormal(i);
    var_normal = [var(bin_import(13,i:i+spp-1)), var(bin_import(14,i:i+spp-1)), var(bin_import(15,i:i+spp-1))];
    
    for q = 1:(max_samples_box - ssp)
        j = normrnd(mean_position, standard_deviation);
        flag = 1;
        normal = getNormal(j);
        % TODO: loop over multiple features?
        if ( abs(normal - mean_normal) > duno?) % TODO
            flag = 0;
            % break; %only needed if looping over several features
        end
        
        if flag == 1
            N = [N, i];
        end
    end
end

function normal = getNormal(i)
    normal = [mean(bin_import(13,i:i+spp-1)), mean(bin_import(14,i:i+spp-1)), mean(bin_import(15,i:i+spp-1))];
end