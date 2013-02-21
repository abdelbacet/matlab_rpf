function index = getIndexByPosition(position)
    index = round(position(1))-1+362*round(position(2) - 1);
    index = index*8 + 1; % multiply by spp, usual adaption for matlab
end