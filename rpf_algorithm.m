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
window_size = 60;
window_min = max(inspected_pixel - window_size, [0;0]);
window_min = inspected_pixel;
window_max = min(inspected_pixel + window_size, [361; 619]);
idx_min = getIndexByPosition(window_min, 1, img_width);
idx_max = getIndexByPosition(window_max, 1, img_width);
idx_inspected_pixel = getIndexByPosition(inspected_pixel, 1, img_width);

%% Compute initial energy
initial_energy = sum(sum(bsxfun(@times, bin_import(7:9, :), [.3; .59; .11;])));
%% RPF algorithm itself
for iter_step = 1:4
    boxsize = boxsizes(iter_step);
    max_samples_box = round(boxsize^2*spp*max_samples_factor(iter_step));
    
    %iterate over every pixel
    nr_pixels = length(bin_import)/8;
    %new_colors = zeros(3, length(bin_import));
    new_colors = zeros(length(bin_import)/8, 3, 8);
    % This is designed to run parallel!
   
    for i = idx_min:idx_max 
        all_samples_pixel = (i-1)*8+(1:8);
        pixel_x = bin_import(1, all_samples_pixel(1));
        if ( pixel_x > window_max(1) || pixel_x < window_min(1))
            continue;
        end
        neighbourhood = preprocess_samples(bin_import, all_samples_pixel, boxsize, max_samples_box, spp);
        debug_pixel = false;
        if (i == idx_inspected_pixel)
            debug_pixel = true;
        end
        [a, b, W_r_c] = compute_feature_weights_jleth(iter_step, neighbourhood, debug_pixel);
        new_colors(i,:,:) = filter_color_samples(neighbourhood, a, b, W_r_c, spp, debug_pixel, iter_step);
    end
    
    % write new_colors back into bin_import 
    % Some conversion is necessary due to parallel support of new_colors matrix
    new_colors = permute(new_colors, [2 3 1]);
    bin_import(7:9, :) = reshape(new_colors, 3, []);
    fprintf('finished iteration step %d ! \n', iter_step);
    img = print_img(bin_import, ['iter_' num2str(iter_step) '_' version '_npc_jlet_factor'], spp);
end

final_energy = sum(sum(bsxfun(@times, bin_import(7:9, :), [.3; .59; .11;])));
fprintf('Lost %d percent energy \n', 100*(1 - final_energy/initial_energy));


toc