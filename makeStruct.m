function out = makeStruct(bin_import, N)
%MAKESTRUCT Constructs a struct with all necessary information
%   Necessery information may be subject to change. For now it's
%   colors, positions, features (various) and random params (lens coordinate).
%   The given struct is also NORMALIZED
% 13:15, 19:21, 16:18, 22:24, 28:30
    out = struct(   'color', bin_import(7:9, N), ...
                    'pos', bin_import(1:2, N), ...
                    'features', [   bin_import(13:24, N); ...
                                	bin_import(28:30, N)], ...
                    'random_pars', [ bin_import(4:5, N); ... lens pos
                                     bin_import(22:24, N) - bin_import(19:21, N)] ); % first reflection dir
    
    % Print neighbourhood positions for debugging purposes
    neighb_mat_pos = bsxfun(@minus, floor(out.pos), floor(out.pos(:, 1)) - [27; 27]);
    neighb_mat_idxs = neighb_mat_pos(1,:) + neighb_mat_pos(2,:)*55;
    neighb = zeros(55);
    for i = neighb_mat_idxs
        neighb(i) = sum(neighb_mat_idxs == i);
    end
    disp(neighb);
    % Normalize all members of the struct except special color field
    f_names = fieldnames(out);
    for f_nr = 1:length(f_names)
        f_name = f_names{f_nr};
        removed_mean = bsxfun(@minus, out.(f_name), mean(out.(f_name), 2));
        divided_by_std = bsxfun(@rdivide, removed_mean, std(removed_mean, 0, 2) + 1e-10);
        out.(f_name) = divided_by_std;
    end
    out.color_unnormed = bin_import(7:9, N);
end

