function bin_import = validate_samples(bin_import, spp) 
    %% Crop bin_import for using less ram
    bin_import = bin_import(1:30,:);
    % todo: make own struct for this
    
    %% validate hitpoints
    hitpoints = bin_import(19:24,:); 
    invalid_values = hitpoints(:,:) > 10000 | hitpoints(:,:) < -10000;
    invalid_samples = any(invalid_values, 1);
    fprintf('Need to fix %d samples \n', sum(invalid_samples == 1));
    for i = 1:spp:length(bin_import)
        %fix if there is something to fix
        samples_idx = i + (0:7);
        pixel_invalid_samples = invalid_samples(samples_idx);
        if any(pixel_invalid_samples)
            all_samples = bin_import(:, samples_idx);
            valid_samples = all_samples(:, ~pixel_invalid_samples);
            nr_invalid_samples = spp - size(valid_samples, 2);
            all_samples(:, pixel_invalid_samples) = repmat(mean(valid_samples, 2), [1, nr_invalid_samples]);
            % make radiance black 
            all_samples(7:9, pixel_invalid_samples) = repmat([0;0;0], [1, nr_invalid_samples]);
            bin_import(:, samples_idx) = all_samples;
        end
    end
    %% TODO: turn geometric normals into smooth normals?
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