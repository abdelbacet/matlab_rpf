% Assumes that all features are vectors with 3 dimensions
% f is the index that the first dimension is saved
function [mean_f, std_f] = getFeatureMeanAndStd(bin_import, features, i)
    global spp;
    mean_f = zeros(3,length(features));
    std_f = zeros(3,length(features));
    for f_nr = 1:length(features)
        mean_f(:,f_nr) = [mean(bin_import(features(f_nr),i:i+spp-1))
                        mean(bin_import(features(f_nr) + 1,i:i+spp-1))
                        mean(bin_import(features(f_nr) + 2,i:i+spp-1))];
        std_f(:,f_nr) = [ std(bin_import(features(f_nr),i:i+spp-1)) 
                               std(bin_import(features(f_nr) + 1,i:i+spp-1)) 
                               std(bin_import(features(f_nr) + 2,i:i+spp-1))];
    end
end