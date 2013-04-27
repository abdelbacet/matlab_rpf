function [a, b, W_r_c] = compute_feature_weights_jleth(iter_step, N, debug_pixel)
%Jleth's approach to compute feature weights
%   Weights are not computed per color channel, but overall. This
%   is supposed to reduce decoloring of the image.
    
    %% mutual Dependancies of k'th attribute vs ALL color channels
    m_D_rk_c = zeros([1, size(N.random_pars, 1)]);
    m_D_pk_c = zeros([1, size(N.pos, 1)]);
    m_D_fk_c = zeros([1, size(N.features, 1)]);
    for channel = 1:3
        channel_info = N.color(channel,:);
        for k = 1:size(N.random_pars, 1)
            rk = N.random_pars(k, :);
            m_D_rk_c(k) = m_D_rk_c(k) + mutualinfo(channel_info, rk);
        end
        
        for k = 1:size(N.pos, 1)
            pk = N.pos(k, :);
            m_D_pk_c(k) = m_D_pk_c(k) + mutualinfo(channel_info, pk);
        end
        
        for k = 1:size(N.features, 1)
            fk = N.features(k, :);
            m_D_fk_c(k) = m_D_fk_c(k) + mutualinfo(channel_info, fk);
        end
    end
    
    %% mutual Dependency of k'th feature vs l'th attribute
    m_D_fk_rl = zeros([size(N.features, 1), size(N.random_pars, 1)]);
    m_D_fk_pl = zeros([size(N.features, 1), size(N.pos, 1)]);
    m_D_fk_cl = zeros([size(N.features, 1), size(N.color, 1)]);
    for k = 1:size(N.features, 1)
        feature_info = N.features(k,:);
        for l = 1:size(N.random_pars, 1)
            rl = N.random_pars(l, :);
            m_D_fk_rl(k, l) = mutualinfo(feature_info, rl);
        end
        
        for l = 1:size(N.pos, 1)
            pl = N.pos(l, :);
            m_D_fk_pl(k, l) = mutualinfo(feature_info, pl);
        end
        
        for l = 1:size(N.color, 1)
            % average of color channels
            m_D_fk_cl(k, l) = m_D_fk_c(k)/size(N.color, 1);
        end
    end

    %% Aggregate values
    D_r_c = sum(m_D_rk_c); % color vs random
    D_p_c = sum(m_D_pk_c); % color vs position
    D_f_c = sum(m_D_fk_c); % color vs features
    D_a_c = D_r_c + D_p_c + D_f_c; % color vs all features
    
    % How much do random pars tell about color? In [0,1]
    % added 1e-10 to prevent nan
    W_r_c = D_r_c/(D_r_c + D_p_c + 1e-10);
    
    t = iter_step - 1;
    % alpha of tech report
    a = max(1 - ( 1 + 0.1*t)*W_r_c, 0);
    % in paper:
    %a = 1 - W_r_c;

    
    %% Compute beta by summing up over results
    % could be written matlab style
        
    b = zeros([size(N.features, 1), 1]);
    for k = 1:size(N.features, 1)
        D_fk_r = sum(m_D_fk_rl(k, :)); % kth feature vs random
        D_fk_p = sum(m_D_fk_pl(k, :)); % kth feature vs position
        D_fk_c = sum(m_D_fk_cl(k, :)); % kth feature vs color
        % How much do random pars tell about feature?
        W_fk_r = D_fk_r/(D_fk_r + D_fk_p + 1e-10);
        W_fk_c = D_fk_c/(D_a_c + 1e-10);
        % Tech report:
        b(k) = W_fk_c * max(1 - (1 + 0.1*t)*W_fk_r, 0);
        % in paper:
        %b(k) = W_fk_c * (1 - W_fk_r);
    end
    
    %% For comparing with jleth:
%     if (debug_pixel)
%         fprintf('pos = (%d, %d) \n', N.pos_unnormed(1,1), N.pos_unnormed(2,1));
%         fprintf('D_r_c = %.2f (%.2f, %.2f, %.2f) \n', D_r_c/D_a_c*100, m_D_rk_c./D_a_c*100);
%         fprintf('D_p_c = %.2f (%.2f, %.2f) \n', D_p_c/D_a_c*100, m_D_pk_c./D_a_c*100);
%         fprintf('D_f_c = %.2f (%.2f, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f) \n', D_f_c/D_a_c*100, m_D_fk_c./D_a_c*100);
%         fprintf('W_r_c = %f \n', W_r_c);
%          
%         fprintf('alpha = %f \n', a);
%         fprintf('beta = %f \n', b);
%  
%         
%         fprintf('MI Color position = %.4f \n', D_p_c);
%         fprintf('MI Color random = %.4f \n', D_r_c);
%         fprintf('MI Color features = %.4f \n', sum(sum(m_D_fk_cl)));
%     end
end

