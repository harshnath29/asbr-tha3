function [tipPosition, dimplePosition] = opticalPivotCalibration(D_frames, H_frames, d_true)
    N = length(D_frames);
    NH = size(H_frames{1}, 1);

    H0 = H_frames{1};
    h_j = H0 - mean(H0, 1);

    R_list = cell(N,1);
    t_list = zeros(N,3);

    for k = 1:N
        [R_D, t_D] = pointSetRegistration(d_true, D_frames{k});
        FD = [R_D, t_D; 0 0 0 1];
        FD_inv = inv(FD);

        Hk = H_frames{k};
        Hk_em = (FD_inv * [Hk, ones(NH,1)]')';
        Hk_em = Hk_em(:, 1:3);

        [R, t] = pointSetRegistration(h_j, Hk_em);
        R_list{k} = R;
        t_list(k, :) = t';
    end

    A = zeros(3 * N, 6);
    b = zeros(3 * N, 1);

    for k = 1:N
        A_k = [eye(3), -R_list{k}];
        A(3*k-2:3*k, :) = A_k;
        b(3*k-2:3*k) = t_list(k, :)';
    end

    x = A \ b;
    dimplePosition = x(1:3);
    tipPosition = x(4:6);
end
