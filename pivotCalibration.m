function [tipPosition, dimplePosition] = pivotCalibration(markerFrames)
    % Input:
    % markerFrames: A cell array where each element is an Nx3 matrix
    %               containing the positions of N EM markers for one frame.
    % Output:
    % tipPosition: 3x1 vector representing the position of the tool tip (pivot point).
    % dimplePosition: 3x1 vector representing the position of the dimple.

    numFrames = length(markerFrames);
    midpoints = zeros(numFrames, 3);
    translatedMarkers = cell(numFrames, 1);

    for k = 1:numFrames
        midpoints(k, :) = mean(markerFrames{k}, 1);
        translatedMarkers{k} = markerFrames{k} - midpoints(k, :);
    end

    A = zeros(3 * numFrames, 3);
    b = zeros(3 * numFrames, 1);

    for k = 1:numFrames
        A(3*k-2:3*k, :) = eye(3);
        b(3*k-2:3*k) = midpoints(k, :)'; % Midpoint contribution
    end

    tipPosition = A \ b;
    dimplePosition = mean(midpoints, 1)' + tipPosition;

end
