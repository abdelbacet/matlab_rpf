function featureValue = getFeatureForIndex(f, i)
    global bin_import;
    featureValue = [ bin_import(f,i)
                     bin_import(f + 1,i)
                     bin_import(f + 2,i)];
end