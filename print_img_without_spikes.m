function print_img_without_spikes(bin_import, name, std_factor, spp)
    %initialize image
    img = zeros(620, 362, 3);
    % Number of samples per pixel

    N = size(bin_import, 2);
    for i = 1:spp:N
        [x, y] = getPositionByIndex(i, size(img, 2), spp);
        indirect = bin_import(7:9,i + (0:(spp-1)));
        albedo = bin_import(16:18,i + (0:(spp-1)));
        samples = indirect.*albedo;
        samples_mean = sum(samples,2)/spp;
        samples_std = std(samples,0,2).*std_factor;
        samples_error = abs(bsxfun(@minus, samples, samples_mean));
        samples_spikes = any(bsxfun(@gt, samples_error, samples_std));
        unspiky_samples = samples(:, ~samples_spikes);
        a = size(unspiky_samples, 2);
        img(y + 1 , x + 1, :) = (sum(unspiky_samples,2) + (spp - a) * samples_mean) ...
                                        /spp;
    end
    exrwrite(img, [name 'std_' num2str(std_factor) '.exr']);
end