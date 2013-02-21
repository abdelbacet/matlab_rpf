function index = getIndexByPosition(position)
    % y-position is multiplied by width
    index = round(position(1))-1+362*round(position(2) - 1);
    index = index*8 + 1; % multiply by spp, usual adaption for matlab lists
end