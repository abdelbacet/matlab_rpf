function out = makeStruct(bin_import, N)
%MAKESTRUCT Constructs a struct with all necessary information
%   Necessery information may be subject to change. For now it's
%   colors, positions, features (various) and random params (lens coordinate).
%   The given struct is also NORMALIZED
% 13:15, 19:21, 16:18, 22:24, 28:30
% features order: n1, albedo, pos1, pos2, n2
    out = struct(   'color', bin_import(7:9, N), ...
                    'pos', bin_import(1:2, N), ...
                    'features', [   bin_import(13:24, N);
                                	bin_import(28:30, N)], ...
                    'random_pars', normc(bin_import(22:24, N) - bin_import(19:21, N))); % first reflection dir
                                   % jleth uses first reflection direction 
                                   % bin_import(4:5, N) ); %; ... lens pos
                                   
                                    % TODO: precompute reflection dir once
    
    %% Print neighbourhood positions for debugging purposes
%     neighb_mat_pos = bsxfun(@minus, floor(out.pos), floor(out.pos(:, 1)) - [27; 27]);
%     % something along these lines... whole neighbourhood could be
%     % shifted by one, but dont care
%     neighb_mat_idxs = neighb_mat_pos(1,:) + (neighb_mat_pos(2,:)-1)*55 + 1;
%     neighb = zeros(55);
%     for i = neighb_mat_idxs
%         neighb(i) = sum(neighb_mat_idxs == i);
%     end
%     neighb = neighb';
%     disp(neighb);
    %% Normalize all members of the struct except special color field
    f_names = fieldnames(out);
    for f_nr = 1:length(f_names)
        f_name = f_names{f_nr};
        removed_mean = bsxfun(@minus, out.(f_name), mean(out.(f_name), 2));
        divided_by_std = bsxfun(@rdivide, removed_mean, std(removed_mean, 0, 2) + 1e-10);
        out.(f_name) = divided_by_std;
    end
    out.color_unnormed = bin_import(7:9, N);
    %% for debugging only
    out.pos_unnormed = floor(bin_import(1:2, N));
end

