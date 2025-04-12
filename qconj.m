function [qi] = qconj(q)
    qi = q;
    qi(2:4) = -q(2:4);
end