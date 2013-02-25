function featureValue = getFeatureForIndex(bin_import, f, i)
    featureValue = [ bin_import(f,i)
                     bin_import(f + 1,i)
                     bin_import(f + 2,i)];
end