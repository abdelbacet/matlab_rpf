% Assumes that all features are vectors with 3 dimensions
% f is the index that the first dimension is saved
function [mean_f, variance_f] = getFeatureMeanAndVariance(features, i)
    global bin_import;
    global spp;
    mean_f = zeros(3,length(features));
    variance_f = zeros(3,length(features));
    for f_nr = 1:length(features)
        mean_f(:,f_nr) = [mean(bin_import(features(f_nr),i:i+spp-1))
                        mean(bin_import(features(f_nr) + 1,i:i+spp-1))
                        mean(bin_import(features(f_nr) + 2,i:i+spp-1))];
        variance_f(:,f_nr) = [ var(bin_import(features(f_nr),i:i+spp-1)) 
                             var(bin_import(features(f_nr) + 1,i:i+spp-1)) 
                             var(bin_import(features(f_nr) + 2,i:i+spp-1))];
    end
end