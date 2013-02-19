%samples per pixel
spp = 8;
for boxsize=[55 35 17 7]
    max_samples_box = boxsize^2*spp/2;
    
    for i = 1:spp:N
        N = preprocess_samples(i, boxsize, max_samples_box);
        [a, b] = compute_feature_weights(boxsize, N);
        
    end
end