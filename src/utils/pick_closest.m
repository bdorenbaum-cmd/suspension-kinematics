function sel = pick_closest(cands, ref)
d = vecnorm(cands - ref, 2, 2);
[~,i] = min(d);
sel = cands(i,:);
end