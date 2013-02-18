fid = fopen('samplebuffer_sanmiguel_diffuse_8spp.bin');

image = fread (fid, [9+3*10, 362*620*8],'float');
'finished reading'