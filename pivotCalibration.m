function [tipPosition, dimplePosition] = pivotCalibration(markerFrames)
    % Input:
    % markerFrames: Cell array of EM marker positions (Nx3 matrices) per frame
    % Output:
    % tipPosition: 3x1 vector (tip position in probe coordinates)
    % dimplePosition: 3x1 vector (dimple position in tracker coordinates)

    numFrames = length(markerFrames);
    midpoints = zeros(numFrames, 3);
    R = cell(numFrames, 1);

    refFrame = markerFrames{1};
    refMidpoint = mean(refFrame, 1);
    centeredRef = refFrame - refMidpoint;

    for k = 1:numFrames
        midpoints(k, :) = mean(markerFrames{k}, 1);
        centeredMoving = markerFrames{k} - midpoints(k, :);

        [R_k, ~] = pointSetRegistration(centeredMoving, centeredRef);
        R{k} = R_k;
    end

    A = zeros(3 * numFrames, 3);
    b = zeros(3 * numFrames, 1);

    for k = 1:numFrames
        A(3*k-2:3*k, :) = R{k}; % Incorporate rotation matrix
        b(3*k-2:3*k) = midpoints(k, :)';
    end

    tipPosition = A \ b;
    dimplePosition = mean(midpoints, 1)' + tipPosition;
end
