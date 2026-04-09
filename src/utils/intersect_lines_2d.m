function [ix, iz] = intersect_lines_2d(a1, a2, b1, b2)

    da = a2 - a1;
    db = b2 - b1;

    denom = da(1)*db(2) - da(2)*db(1);
    if abs(denom) < 1e-12
        error('Side-view lines nearly parallel');
    end

    t = ((b1(1)-a1(1))*db(2) - (b1(2)-a1(2))*db(1)) / denom;
    p = a1 + t*da;

    ix = p(1);
    iz = p(2);
end