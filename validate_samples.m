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
    %% turn geometric normals into smooth normals
    smoothed_normals = zeros(4, length(bin_import));
    fw = 5; %size of patch to look at for smoothing
    normal_std = 0.5;
    weighted_n_var = 2*normal_std^2;
    xy_std = fw/2/2;
    weighted_xy_var = 2*xy_std^2;
    neighbourhood = [-2:2, -2:2, -2:2, -2:2, -2:2
      repmat(-2, [1 5]), repmat(-1, [1 5]), zeros([1 5]), ones([1 5]), repmat(2, [1 5])];
    fprintf('Smoothing normals... ');
    tic
    parfor idx_i=1:length(bin_import);
        
       % TODO: make neighbourhood crap only once every 8 pixels
       xy_i = bin_import(1:2, idx_i);
       xy = floor(xy_i);
       normal_i = bin_import(13:15, idx_i);
       sxy = bsxfun(@plus, neighbourhood, xy);
       valid_sxy = all(bsxfun(@ge, sxy, [0; 0]) & bsxfun(@lt, sxy, [362; 620]));
       sxy = sxy(:, valid_sxy);
       idx_j = sxy(1,:) + 362*sxy(2,:);
       idx_j = idx_j*spp + 1;
       idx_j_samples = cell2mat(arrayfun(@(x) x + (0:7), idx_j, 'UniformOutput', false));
       
       % for spatial loc
       xy_j = bin_import(1:2, idx_j_samples);
       xy_dist2 = sum(bsxfun(@minus, xy_j, xy_i).^2);
       d = xy_dist2./weighted_xy_var;

       % for normal
       normal_j = bin_import(13:15, idx_j_samples);
       normal_dist2 = sum(bsxfun(@minus, normal_j, normal_i).^2);
       d = d + normal_dist2./weighted_n_var;

       % combine
       weight = exp(-d);
       smoothed_normals(:, idx_i) = sum(bsxfun(@times, [normal_j; ones(1, length(normal_j))], weight), 2);
    end
    % normalize all 
    normalized_normals = bsxfun(@rdivide, smoothed_normals(1:3, :), smoothed_normals(4,:));
    bin_import(13:15, :) = normalized_normals;
    fprintf('Done!\n');
    toc
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