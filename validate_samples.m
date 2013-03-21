function bin_import = validate_samples(bin_import, spp) 
    %% Crop bin_import for using less ram
    bin_import = bin_import(1:30,:);
    % todo: make own struct for this
    
    %% validate hitpoints
    hitpoints = bin_import(19:24,:); 
    invalid_values = hitpoints(:,:) > 10000 | hitpoints(:,:) < -10000;
    invalid_samples = any(invalid_values, 1);
    fprintf('Need to fix %d samples... ', sum(invalid_samples == 1));
    for idx_i = 1:spp:length(bin_import)
        %fix if there is something to fix
        samples_idx = idx_i + (0:7);
        pixel_invalid_samples = invalid_samples(samples_idx);
        if any(pixel_invalid_samples)
            all_samples = bin_import(:, samples_idx);
            valid_samples = all_samples(:, ~pixel_invalid_samples);
            nr_invalid_samples = spp - size(valid_samples, 2);
            if (nr_invalid_samples == spp)
                bin_import(:, samples_idx) = zeros(size(bin_import, 1), spp);
            else
                all_samples(:, pixel_invalid_samples) = repmat(mean(valid_samples, 2), [1, nr_invalid_samples]);
                % make radiance black 
                all_samples(7:9, pixel_invalid_samples) = repmat([0;0;0], [1, nr_invalid_samples]);
                bin_import(:, samples_idx) = all_samples;
            end
        end
    end
    fprintf('Done!\n');
    %% TODO: turn geometric normals into smooth normals?
    smoothed_normals = zeros(4, length(bin_import));
    fw = 5; %size of patch to look at for smoothing
    normal_std = 0.5;
    weighted_n_var = 2*normal_std^2;
    xy_std = fw/2/2;
    weighted_xy_var = 2*xy_std^2;
    for idx_i=1:length(bin_import)
       xy_i = bin_import(1:2, idx_i);
       xy = floor(xy_i);
       normal_i = bin_import(13:15, idx_i);
       for dx = -2:2
           for dy = -2:2
               sxy = xy + [dx; dy];
               if all(sxy >= [0; 0] & sxy < [362; 620])
                   idx = getIndexByPosition(sxy, spp, 362);
                   for j = 0:7
                       % for spatial loc
                       idx_j = idx + j;
                       xy_j = bin_import(1:2, idx_j);
                       xy_dist2 = sum((xy_i - xy_j).^2);
                       d = xy_dist2/weighted_xy_var;
                       
                       % for normal
                       normal_j = bin_import(13:15, idx_j);
                       normal_dist2 = sum((normal_i - normal_j).^2);
                       d = d + normal_dist2/weighted_n_var;
                       
                       % combine
                       weight = exp(-d);
                       smoothed_normals = weight*[normal_j; 1];
                   end
               end
           end
       end
    end
    % normalize all 
    normalized_normals = bsxfun(@rdivide, smoothed_normals(1:3, :), smoothed_normals(4,:));
    bin_import(13:15) = normalized_normals;
%     
    %% fill used information into sample buffer
%     sample_buffer = struct('position', bin_import(1:2,:), ...
%                        'lens_pos', bin_import(4:5,:), ...
%                        'rgb', bin_import(7:9,:), ...
%                        'pri_normal', bin_import(13:15,:), ...
%                        'albedo', bin_import(16:18,:), ...
%                        'sec_origin', bin_import(19:21,:), ...
%                        'sec_hitpoint', bin_import(22:24,:), ...
%                        'sec_normal', bin_import(28:30,:));
                      
end