function [D_frames, H_frames] = loadOptpivot(filename)
    fid = fopen(filename, 'r');
    if fid == -1
        error("Failed to open file: %s", filename);
    end

    header = fgetl(fid);
    parts = strsplit(strtrim(header), ',');
    ND = str2double(parts{1});
    NH = str2double(parts{2});
    Nframes = str2double(parts{3});

    D_frames = cell(Nframes, 1);
    H_frames = cell(Nframes, 1);

    for k = 1:Nframes
        D = zeros(ND, 3);
        for i = 1:ND
            line = fgetl(fid);
            D(i, :) = sscanf(line, '%f,%f,%f')';
        end
        H = zeros(NH, 3);
        for i = 1:NH
            line = fgetl(fid);
            H(i, :) = sscanf(line, '%f,%f,%f')';
        end
        D_frames{k} = D;
        H_frames{k} = H;
    end

    fclose(fid);
end


