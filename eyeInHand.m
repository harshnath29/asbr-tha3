function [R, p] = eyeInHand(qrobots, trobots, qcameras, tcameras)
    % first finding R
    M = zeros(4 * (length(qrobots) - 1), 4);
    RA = zeros(3 * (length(qrobots) - 1), 3);
    for i = 1:length(qrobots)-1
        qA = qmul(qconj(qrobots(i, :)), qrobots(i+1, :));
        RA(1 + (i-1) * 3: i * 3, :) = q2rot(qA) - eye(3, 3);
        qB = qmul(qconj(qcameras(i, :)), qcameras(i+1, :));

        st = 1 + (i - 1) * 4;
        en = st + 3;
        M(st:en, :) = makeMi(qA, qB);
    end
    [~, ~, Vt] = svd(M);
    qx = Vt(:, 4);
    qx = qx / norm(qx);
    R = q2rot(qx);

    % using R to find p
    b = zeros(3 * (length(qrobots) - 1), 1);
    for i = 1:length(qrobots)-1
        Ta1 = makeSE3(q2rot(qrobots(i, :)), trobots(i, :)');
        Ta2 = makeSE3(q2rot(qrobots(i+1, :)), trobots(i+1, :)');
        Ta = SE3inv(Ta1) * Ta2;
        pa = Ta(1:3, 4);
        Tb1 = makeSE3(q2rot(qcameras(i, :)), tcameras(i, :)');
        Tb2 = makeSE3(q2rot(qcameras(i+1, :)), tcameras(i+1, :)');
        Tb = SE3inv(Tb1) * Tb2;
        pb = Tb(1:3, 4);
        b(1 + (i-1) * 3: i * 3, :) = R * pb - pa;
    end
    p = RA\b;
end

function [Mi] = makeMi(qa, qb)
    sa = qa(1);
    va = qa(2:4);
    sb = qb(1);
    vb = qb(2:4);

    Mi = [(sa - sb), -(va - vb);
        (va - vb)', (sa-sb) * eye(3, 3) + skew3(va + vb)];
end