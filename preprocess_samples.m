function n = preprocess_samples(i, boxsize, max_samples_box)
    standard_deviation = boxsize/4;
    N = i; 
    mean_normal = [mean(bin_import(13,i:i+spp-1)), mean(bin_import(14,i:i+spp-1)), mean(bin_import(15,i:i+spp-1))];
    var_normal = [var(bin_import(13,i:i+spp-1)), var(bin_import(14,i:i+spp-1)), var(bin_import(15,i:i+spp-1))];
    
    for q = 1, q < max_samples_box - ssp, q++
end