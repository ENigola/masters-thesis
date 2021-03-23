function [t, w] = calcMinParams(secLevel, r, m, L, blockWeightOdd)
% Calculates t, w given target security level and other parameters
% secLevel - classical security level in bits
% blockWeightOdd
%   - if false, returns smallest w such that security level is reached
%   - if true, retruns smallest w such that w/(m+1) is odd integer
%     (or w/m is odd integer if L = 1)

R = (m - 1) / m;
t = ceil((secLevel + log2(sqrt(L * r))) / log2(1 / (1 - R)));
if L == 1
    w = ceil((secLevel + log2(r)) / log2(1 / R));
else
    w = ceil((secLevel + log2(r)) / log2(2 - R));
end

if blockWeightOdd
    if L == 1
        blockCount = m;
    else
        blockCount = m + 1;
    end
    wBlock = ceil(w / blockCount);
    if mod(wBlock, 2) == 0
        wBlock = wBlock + 1;
    end
    w = wBlock * blockCount;
end
end

