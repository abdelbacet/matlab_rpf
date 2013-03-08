function [bin_import, spp] = read_binary()

    fid = fopen('samplebuffer_sanmiguel_diffuse_8spp.bin');
    spp = 8;

    % bin_import = single(fread (fid, [9+3*10, 362*620*8],'float'));
    % mutual information library only takes double
    bin_import = fread (fid, [9+3*10, 362*620*spp],'float');
    'finished reading'

    fclose(fid);
end
%
% Columns have these values:
% 1: x-coordinate
% 2: y-coordinate
% 3: angular bandwidth estimate of the reflectance function at the
% secondary hit
% 4: lens coordinate at which the sample was taken, in the range [-1,1]
% 5: lens coordinate at which the sample was taken, in the range [-1,1]
% 6: t is the time coordinate in the range [0,1]
% 7: red
% 8: green
% 9: blue
% 10, 11, 12: primary motion vector (when primary ray hit surface)
% 13, 14, 15: primary normal (when primary ray hit surface)
% 16, 17, 18: primary albedo (texture value of first intersection)
% 28, 29, 30: secondary normal
% 34, 35, 36: secondary albedo (texture value second intersection)