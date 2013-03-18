[bin_import, spp] = read_binary();
bin_import = validate_samples(bin_import, spp);

%initializes random generator
%rng(42);
boxsizes=[55 35 17 7];
for iter_step = 1:4
    boxsize = boxsizes(iter_step);
    max_samples_box = boxsize^2*spp/2;
    
    %% get neighbourhood of inspected pixel:
    inspected_pos = [14, 619 - 20];
    
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
    exrwrite(img, ['neighbourhood' num2str(iter_step) '.exr']);
end