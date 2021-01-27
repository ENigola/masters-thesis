function [sum] = binPolyAdd(a, b)
% Adds two polys
lenA = length(a);
lenB = length(b);
if lenA >= lenB
    sum = a;
    sum(1:lenB) = mod(sum(1:lenB) + b, 2);
else
    sum = b;
    sum(1:lenA) = mod(sum(1:lenA) + a, 2);
end
end

