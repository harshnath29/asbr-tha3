function G_frames = loadEmpivot(filename)
    fid = fopen(filename, 'r');
    if fid == -1
        error("Failed to open file: %s", filename);
    end

    header = fgetl(fid);
    parts = strsplit(strtrim(header), ',');
    NG = str2double(parts{1});
    Nframes = str2double(parts{2});

    G_frames = cell(Nframes, 1);
    for k = 1:Nframes
        G = zeros(NG, 3);
        for i = 1:NG
            line = strtrim(fgetl(fid));
            if isempty(line)
                error("Unexpected empty line reading frame %d marker %d", k, i);
            end
            G(i, :) = sscanf(line, '%f,%f,%f')';
        end
        G_frames{k} = G;
    end

    fclose(fid);
end
