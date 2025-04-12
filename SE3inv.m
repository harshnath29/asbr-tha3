function Tinv = SE3inv(T)
    R = T(1:3, 1:3);
    p = T(1:3, 4);

    Tinv = [R', -R' * p;
        0, 0, 0, 1];
end