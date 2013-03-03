function out = makeStruct(bin_import, N)
%MAKESTRUCT Constructs a struct with all necessary information
%   Necessery information may be subject to change. For now it's
%   colors, positions, features (various) and random params (lens coordinate).
%   The given struct is also NORMALIZED
% 13:15, 19:21, 16:18, 21:23, 28:30
    out = struct(   'color', bin_import(7:9, N), ...
                    'color_unnormed', bin_import(7:9, N), ...
                    'pos', bin_import(1:2, N), ...
                    'features', [   bin_import(13:23, N); ...
                                	bin_import(28:30, N)], ...
                    'lens_coord', bin_import(4:5, N)); %random parameter!
                
    % Normalize all members of the struct except special color field
    f_names = fieldnames(out);
    for f_nr = 1:length(f_names)
        f_name = f_names{f_nr};
        if strcmp(f_name, 'color_unnormed');
            continue;
        end
        removed_mean = bsxfun(@minus, out.(f_name), mean(out.(f_name), 2));
        divided_by_std = bsxfun(@rdivide, removed_mean, std(removed_mean, 0, 2) + 1e-10);
        out.(f_name) = divided_by_std;
    end
end

