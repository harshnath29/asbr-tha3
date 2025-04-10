function [tipPosition, dimplePosition] = emPivotCalibration(G_frames)
    N = length(G_frames);
    NG = size(G_frames{1}, 1);

    G0 = G_frames{1};
    g_j = G0 - mean(G0, 1);

    R_list = cell(N,1);
    t_list = zeros(N,3);

    for k = 1:N
        Gk = G_frames{k};
        [R, t] = pointSetRegistration(g_j, Gk);
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