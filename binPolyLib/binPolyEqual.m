function [areEqual] = binPolyEqual(a, b)
% Checks if the arrays a and b represent the same polynomial
% TODO: simplify/optimize
lenA = length(a);
lenB = length(b);
lenMax = max(lenA, lenB);
lenMin = min(lenA, lenB);
areEqual = false;
for i = 1:lenMax
    if i <= lenMin
        if a(i) ~= b(i)
            return;
        end
    elseif i <= lenA
        if a(i) ~= 0
            return;
        end
    elseif b(i) ~= 0
        return;
    end              
end
areEqual = true;
end

