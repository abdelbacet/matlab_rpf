[bin_import, spp] = read_binary();

%initializes random generator
rng(42);
boxsizes=[55 35 17 7];
for iter_step = 1
    tic
    boxsize = boxsizes(iter_step);
    max_samples_box = boxsize^2*spp/2;
    
    % a good pixel:
    inspected_pos = [115, (620 - 390)];
    
    % a bad pixel:
    inspected_pos = [168, 470];
    
    i = getIndexByPosition(inspected_pos);
    
    all_samples_pixel = i + (0:7);
    
    [neighbourhood, neighbourhood_idxs] = preprocess_samples(bin_import, all_samples_pixel, boxsize, max_samples_box, spp);
    
    img = zeros(620, 362, 3);
    % Number of samples per pixel
    size(neighbourhood.features, 2)
    for i = neighbourhood_idxs
        x = floor(mod(i/8, size(img,2)));
        y = floor(i/8/size(img,2));
        img(y , x, :) = [1,1,1];
    end
    img(inspected_pos(2), inspected_pos(1), :) = [1,0,0];
    imtool(img)
end