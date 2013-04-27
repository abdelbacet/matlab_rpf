% Starts the random parameter filtering algorithm

version = '1.4.3';
img_width = 362;

if matlabpool('size') == 0
    matlabpool open
end

%[bin_import, spp] = read_binary();
%bin_import = validate_samples(bin_import, spp);

% faster: load from existing matlab space, no validation needed
load('validated_bin_import.mat', 'bin_import')
load('validated_bin_import.mat', 'spp')

%progress = waitbar(0, 'zomfg..');
%initializes random generator
%rng(42);
tic
boxsizes=[55 35 17 7];
%max_samples_factor = [0.5 0.5 0.5 0.5]; % Sen
max_samples_factor = [0.02, 0.04, 0.3, 0.5]; % for prototyping, jl

%% Specify debug window
inspected_pixel = [125; 314];
window_size = 80;
window_min = max(inspected_pixel - window_size, [0;0]);
%window_min = inspected_pixel;
window_max = min(inspected_pixel + window_size, [361; 619]);
idx_min = getIndexByPosition(window_min, 1, img_width);
idx_max = getIndexByPosition(window_max, 1, img_width);
idx_inspected_pixel = getIndexByPosition(inspected_pixel, 1, img_width);

nr_pixels = length(bin_import)/8;

%% Compute initial energy
initial_energy = sum(sum(bsxfun(@times, bin_import(7:9, :), [.3; .59; .11;])));

% Setting output color to initial values
% TODO: check if this works with reshape to input_colors below
input_colors = bin_import(7:9, :);
output_colors = zeros(nr_pixels, 3, 8);

%% RPF algorithm itself
for iter_step = 1:4
    boxsize = boxsizes(iter_step);
    max_samples_box = round(boxsize^2*spp*max_samples_factor(iter_step));
    
    
    % convert output to new input if not first iteration
    if (iter_step > 1)
        input_colors = reshape(permute(output_colors, [2 3 1]), 3, []);
    end
    
    print_img(input_colors, bin_import(16:18, :), ...
            ['before_iter_' num2str(iter_step) '_' version '_npc_jlet_factor_own_mi'], spp);
    
    % iterate over every pixel
    % This is designed to run parallel!
    parfor i = idx_min:idx_max 
        all_samples_pixel = (i-1)*8+(1:8);
        pixel_x = bin_import(1, all_samples_pixel(1));
        if ( pixel_x > window_max(1) || pixel_x < window_min(1))
            continue;
        end
        neighbourhood = preprocess_samples(bin_import, all_samples_pixel, boxsize, max_samples_box, spp, input_colors);
        debug_pixel = false;
%         if (i == idx_inspected_pixel)
%             debug_pixel = true;
%         end
        [a, b, W_r_c] = compute_feature_weights_jleth(iter_step, neighbourhood, debug_pixel);
        output_colors(i,:,:) = filter_color_samples(neighbourhood, a, b, W_r_c, spp, debug_pixel, iter_step);
    end
    
    fprintf('finished iteration step %d ! \n', iter_step);
end

final_colors = reshape(permute(output_colors, [2 3 1]), 3, []);

final_energy = sum(sum(bsxfun(@times, final_colors, [.3; .59; .11;])));
fprintf('Lost %.2f percent energy \n', 100*(1 - final_energy/initial_energy));

print_img(final_colors, bin_import(16:18,:), ...
            ['final_npc_jlet_factor_own_mi'], spp);


toc
