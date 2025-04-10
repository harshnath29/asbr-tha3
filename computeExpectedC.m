function C_expected = computeExpectedC(calBody, calReadings)
    % Input:
    % calBody: struct with fields .d, .a, .c (NDx3, NAx3, NCx3 static coordinates)
    % calReadings: struct with cell arrays .D, .A, .C per frame (measured positions)
    %
    % Output:
    % C_expected: Nframes x NC x 3 matrix of expected C_i in EM tracker coordinates

    Nframes = length(calReadings.D);
    NC = size(calBody.c, 1);
    C_expected = zeros(Nframes, NC, 3);

    for k = 1:Nframes
        D_meas = calReadings.D{k};  % NDx3 measured
        d_true = calBody.d;         % NDx3 known

        [R_D, t_D] = pointSetRegistration(d_true, D_meas);  % d_j → D_j
        F_D = [R_D, t_D; 0 0 0 1];  % 4x4 homogeneous transform

        A_meas = calReadings.A{k};  % NAx3 measured
        a_true = calBody.a;         % NAx3 known

        [R_A, t_A] = pointSetRegistration(a_true, A_meas);  % a_j → A_j
        F_A = [R_A, t_A; 0 0 0 1];

        F = inv(F_D) * F_A;

        for i = 1:NC
            c_i = calBody.c(i, :).';      % 3x1 vector
            c_i_hom = [c_i; 1];           % 4x1 homogeneous
            C_i_expected_hom = F * c_i_hom;
            C_expected(k, i, :) = C_i_expected_hom(1:3);
        end
    end
end
