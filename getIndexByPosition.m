function index = getIndexByPosition(position, spp, img_width)
% takes rguments between [0,0] and [width - 1, height - 1], returns the
% index of the first sample that is on this positions. Get all samples by
% adding (0:7)!

    % y-position is multiplied by width
    % usually img_width = 362
    index = position(1)+img_width*position(2);
    index = index*spp + 1; % multiply by spp, usual adaption for matlab lists
end