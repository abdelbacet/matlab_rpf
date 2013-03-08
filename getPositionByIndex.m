function [x, y] = getPositionByIndex(idx, img_width, spp )
% position returned is between [0,0] and [width - 1, height - 1]
    idx = floor((idx - 1)/spp);
    x = mod(idx, img_width);
    y = floor(idx/img_width);
end

