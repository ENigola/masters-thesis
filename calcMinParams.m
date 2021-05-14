function [t, w] = calcMinParams(secLevel, p, m, L, blockWeightOdd)
% Calculates t, w given target security level and other parameters
% secLevel - classical security level in bits
% p - circulant block size
% m - defined in construction
% L - tail-biting level
% blockWeightOdd
%   - if false, returns smallest w such that security level is reached
%   - if true, retruns smallest w such that w/(m+1) is odd integer
%     (or w/m is odd integer if L = 1)

assert(m >= 2);

R = (m - 1) / m;
if L == 1
    w = ceil((secLevel + log2(p)) / log2(1 / R));      
    t = ceil((secLevel + log2(sqrt(p))) / log2(1 / (1 - R)));
else
    w = ceil((secLevel + log2(p)) / log2((m + 1) / m));
    if (L == 2) && (m == 2)
        t = ceil((secLevel + log2(sqrt(p))) / log2(1 / (1 - R)));
    else
        t = ceil(((secLevel + log2(sqrt(p))) / log2(m + 1)) * ((L * m) / (m + 1)));
    end
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

