function [R, t] = pointSetRegistration(movingPoints, fixedPoints)
    % Input:
    % movingPoints: Nx3 matrix of points in the moving set
    % fixedPoints: Nx3 matrix of corresponding points in the fixed set
    % Output:
    % R: 3x3 rotation matrix
    % t: 3x1 translation vector

    centroidMoving = mean(movingPoints, 1);
    centroidFixed = mean(fixedPoints, 1);

    centeredMoving = movingPoints - centroidMoving;
    centeredFixed = fixedPoints - centroidFixed;

    H = centeredMoving' * centeredFixed;
    [U, ~, V] = svd(H);
    R = V * U';
    
    % Ensure that the R matrix is valid (det(R) = 1)
    if det(R) < 0
        V(:, end) = -V(:, end);
        R = V * U';
    end

    t = centroidFixed' - R * centroidMoving';

end
