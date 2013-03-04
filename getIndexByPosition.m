function index = getIndexByPosition(position)
    % y-position is multiplied by width
    index = position(1)+362*position(2);
    index = index*8 + 1; % multiply by spp, usual adaption for matlab lists
end