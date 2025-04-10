function writeOutput1(C_expected, p_dimple_em, p_dimple_opt, filename)
    [Nframes, NC, ~] = size(C_expected);
    fid = fopen(filename, 'w');

    % Header
    fprintf(fid, '%d, %d, %s\n', NC, Nframes, extractAfter(filename, "HW3-PA1/HW3-PA1/"));

    % Dimple positions
    fprintf(fid, '%8.2f, %8.2f, %8.2f\n', p_dimple_em(1), p_dimple_em(2), p_dimple_em(3));
    fprintf(fid, '%8.2f, %8.2f, %8.2f\n', p_dimple_opt(1), p_dimple_opt(2), p_dimple_opt(3));

    % Expected C_i
    for f = 1:Nframes
        for i = 1:NC
            c = squeeze(C_expected(f, i, :));
            fprintf(fid, '%8.2f, %8.2f, %8.2f\n', c(1), c(2), c(3));
        end
    end

    fclose(fid);
end
