% Starts the random parameter filtering algorithm

version = '1.2.9';
[bin_import, spp] = read_binary();
img_width = 362;
bin_import = validate_samples(bin_import, spp);

if matlabpool('size') == 0
    matlabpool open
end
%progress = waitbar(0, 'zomfg..');
%initializes random generator
rng(42);
tic
boxsizes=[55 35 17 7];
%max_samples_factor = [0.5 0.5 0.5 0.5] % Sen
max_samples_factor = [0.02, 0.04, 0.2, 0.5]; % for prototyping, jl
window_min = [70, 620 - 200];
window_max = [200, 620 - 100];
idx_min = getIndexByPosition(window_min, 1, img_width);
idx_max = getIndexByPosition(window_max, 1, img_width);

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
    parfor i = idx_min:idx_max %1:nr_pixels
        all_samples_pixel = (i-1)*8+(1:8);
        neighbourhood = preprocess_samples(bin_import, all_samples_pixel, boxsize, max_samples_box, spp);
        [a, b, weights_col_rand] = compute_feature_weights(iter_step, neighbourhood);
        new_colors(i,:,:) = filter_color_samples(bin_import, all_samples_pixel, neighbourhood, a, b, weights_col_rand, spp);
    end
    
    % write new_colors back into bin_import 
    % Some conversion is necessary due to parallel support of new_colors
    % matrix
    new_colors = permute(new_colors, [2 3 1]);
    bin_import(7:9, :) = reshape(new_colors, 3, []);
    fprintf('finished iteration step! \n');
    img = print_img(bin_import, ['iter_' num2str(iter_step) '_v' version], spp);
end

final_energy = sum(sum(bsxfun(@times, bin_import(7:9, :), [.3; .59; .11;])));
fprintf('Lost %d percent energy', 100*(1 - final_energy/initial_energy));


toc