% 
% tic
% for i=1:1000
%     mutualinfo(a,b);
% end
% toc
% mutualinfo(a/2,b/2)
% 
% mi_matlab(a,b)
% mi_matlab(a/2,b/2)
% 
% information(a,b)
% information(a/2,b/2)
% 
% mi like jlet does it:
% nr_buckets = 5;
% 
% tic
% for i=1:1000
%     mi_sen(a,b);
% end
% mi_sen(a,b)
% toc

tic
for i=1:1000
    mi_sen_fast(a,b);
end
mi_sen_fast(a,b)
toc