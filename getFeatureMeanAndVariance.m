% Assumes that all features are vectors with 3 dimensions
% f is the index that the first dimension is saved
function [mean_f, variance_f] = getFeatureMeanAndVariance(f, i)
    bin_import = evalin('base', 'bin_import');
    spp = evalin('base', 'spp');
    mean_f = [mean(bin_import(f,i:i+spp-1)), mean(bin_import(f + 1,i:i+spp-1)), mean(bin_import(f + 2,i:i+spp-1))];
    variance_f = [var(bin_import(f,i:i+spp-1)), var(bin_import(f + 1,i:i+spp-1)), var(bin_import(f + 2,i:i+spp-1))];
end