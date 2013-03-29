[bin_import, spp] = read_binary();
bin_import = validate_samples(bin_import, spp);

%initializes random generator
%rng(42);
boxsizes=[55 35 17 7];
max_samples_factor = [0.02, 0.04, 0.2, 0.5]; % for prototyping, jl
%max_samples_factor = [0.5 0.5 0.5 0.5] % Sen
for iter_step = 1
    boxsize = boxsizes(iter_step);
    max_samples_box = boxsize^2*spp*max_samples_factor(iter_step);
    
    %% get neighbourhood of inspected pixel:
    inspected_pos = [173, 337];
    
    inspected_pos_idx = getIndexByPosition(inspected_pos, spp, 362);
    
    all_samples_pixel = inspected_pos_idx + (0:7);
    
    [neighbourhood, neighbourhood_idxs] = preprocess_samples(bin_import, all_samples_pixel, boxsize, max_samples_box, spp);
    
    %% draw neighbourhood in image
    img = zeros(620, 362, 3);
    size(neighbourhood.features, 2);
    for i = neighbourhood_idxs
        [x, y] = getPositionByIndex(i, size(img,2), spp);
        img(y + 1 , x + 1, :) = img(y + 1,x + 1, :) + reshape([1,1,1], [1, 1, 3]);
    end
    [x, y] = getPositionByIndex(inspected_pos_idx, size(img,2), spp);
    img(y + 1, x + 1, 1) = 0;
    exrwrite(img, ['neighbourhood_interesting.exr']);
end