function [ mi ] = mi_sen_fast( a, b )
%mi_sen Computes mutual information based on sens approach
% only works if std(a) = std(b) = 1
% Assertion, that length(a) = length(b)
    
    %% quantize (scale into right range, make integers & clamp) 
    % buckets go from 0 to nr_buckets - 1
    nr_buckets = 5;
    a_shift = (a+2)/4;  % [-2, 2] -> [0, 1]
    b_shift = (b+2)/4; 

    a_buckets = floor((nr_buckets - 1)*a_shift + 0.5);
    b_buckets = floor((nr_buckets - 1)*b_shift + 0.5);

    a_buckets = min(nr_buckets - 1, max(a_buckets, 0));
    b_buckets = min(nr_buckets - 1, max(b_buckets, 0));
    
    %% histograms
   
    entropy_a = entropy(a_buckets);
    entropy_b = entropy(b_buckets);
    entropy_ab = entropy(a_buckets*nr_buckets + b_buckets); % not sure if working as intended

    %% mi (finally!)
    mi = (entropy_a + entropy_b - entropy_ab);
    % could be normalized using
    % mi = mi/entropy_ab
end

function e = entropy(bucketized_list)
    bucketized_list = sort(bucketized_list);
    k = find([1, diff(bucketized_list)]);
    H=zeros(size(k));
    H(bucketized_list(k) + 1) = diff([k, length(bucketized_list) + 1]);
    p = H/length(bucketized_list);
    p(p == 0) = [];
    e = -sum(p.*log(p))/log(2);
end