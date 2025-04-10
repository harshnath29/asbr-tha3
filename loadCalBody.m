function calBody = loadCalBody(filename)
    % Load calibration body file with known structure
    % Output: calBody struct with fields .d (NDx3), .a (NAx3), .c (NCx3)

    fid = fopen(filename, 'r');
    if fid == -1
        error("Failed to open file: %s", filename);
    end

    header = fgetl(fid);
    if isempty(header)
        error("Header line is empty in file: %s", filename);
    end

    headerParts = strsplit(strtrim(header), ',');
    ND = str2double(headerParts{1});
    NA = str2double(headerParts{2});
    NC = str2double(headerParts{3});

    totalLines = ND + NA + NC;
    data = zeros(totalLines, 3);

    lineCount = 0;
    while lineCount < totalLines && ~feof(fid)
        line = fgetl(fid);
        if isempty(line) || all(isspace(line))
            continue; % skip empty lines
        end
        lineCount = lineCount + 1;
        data(lineCount, :) = sscanf(line, '%f,%f,%f')';
    end

    fclose(fid);

    if lineCount ~= totalLines
        error("Mismatch in expected number of lines vs actual in: %s", filename);
    end

    calBody.d = data(1:ND, :);                       % EM base markers
    calBody.a = data(ND+1:ND+NA, :);                 % optical markers on calibration object
    calBody.c = data(ND+NA+1:ND+NA+NC, :);           % EM markers on calibration object
end
