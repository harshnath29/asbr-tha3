function calReadings = loadCalReadings(filename)
    % Load calibration readings file robustly
    % Output: struct with fields D, A, C (each is cell array of Nframes)

    fid = fopen(filename, 'r');
    if fid == -1
        error("Failed to open file: %s", filename);
    end

    header = fgetl(fid);
    parts = strsplit(strtrim(header), ',');
    ND = str2double(parts{1});
    NA = str2double(parts{2});
    NC = str2double(parts{3});
    Nframes = str2double(parts{4});

    numMarkersPerFrame = ND + NA + NC;
    totalLines = numMarkersPerFrame * Nframes;

    data = zeros(totalLines, 3);
    count = 0;

    while count < totalLines && ~feof(fid)
        line = strtrim(fgetl(fid));
        if isempty(line) || all(isspace(line))
            continue;
        end
        count = count + 1;
        data(count, :) = sscanf(line, '%f,%f,%f')';
    end

    fclose(fid);

    if count ~= totalLines
        error("Expected %d lines, got %d in %s", totalLines, count, filename);
    end

    calReadings.D = cell(Nframes, 1);
    calReadings.A = cell(Nframes, 1);
    calReadings.C = cell(Nframes, 1);

    for k = 1:Nframes
        baseIdx = (k - 1) * numMarkersPerFrame;
        calReadings.D{k} = data(baseIdx + (1:ND), :);
        calReadings.A{k} = data(baseIdx + (ND+1:ND+NA), :);
        calReadings.C{k} = data(baseIdx + (ND+NA+1:ND+NA+NC), :);
    end
end
