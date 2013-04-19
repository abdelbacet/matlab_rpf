function [ mi ] = mi_sen( a, b )
%mi_sen Computes mutual information based on sens approach
% only works if std(a) = std(b) = 1!!!!
% Assertion, that length(a) = length(b)
%   Detailed explanation goes here
    
    %% quantize (scale into right range, make integers & clamp) 
    % buckets go from 0 to nr_buckets - 1
    nr_buckets = 5;
    a_shift = (a+2)/4;  % [-2, 2] -> [0, 1]
    b_shift = (b+2)/4; 

    a_buckets = floor(nr_buckets*a_shift + 0.5);
    b_buckets = floor(nr_buckets*b_shift + 0.5);

    a_buckets = min(nr_buckets - 1, max(a_buckets, 0));
    b_buckets = min(nr_buckets - 1, max(b_buckets, 0));
    
    %% histograms
    nr_samples = length(a_buckets);
    hist_a = hist(a_buckets, 0:(nr_buckets-1));
    hist_b = hist(b_buckets, 0:(nr_buckets-1));
    hist_ab = hist(a_buckets*nr_buckets + b_buckets, (0:(nr_buckets^2-1))); % not sure if working as intended

    %% entropies
    probabilities_a = hist_a/nr_samples;
    probabilities_a(probabilities_a == 0) = []; % needed?
    entropy_a = sum(-probabilities_a/log2(probabilities_a));

    probabilities_b = hist_b/nr_samples;
    probabilities_b(probabilities_b == 0) = []; % needed?
    entropy_b = -sum(probabilities_b/log2(probabilities_b));

    probabilities_ab = hist_ab/nr_samples;
    probabilities_ab(probabilities_ab == 0) = []; % needed?
    entropy_ab = -sum(probabilities_ab/log2(probabilities_ab));

    %% mi (finally!)
    mi = (entropy_a + entropy_b - entropy_ab);
    % could be normalized using
    % mi = mi/entropy_ab
end

