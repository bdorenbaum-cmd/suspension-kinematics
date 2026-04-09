function assert_non_empty(A, msg)
if isempty(A) || any(isnan(A(:)))
    error('%s', msg);
end
end