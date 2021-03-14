function [c] = decodeBlackGray(R, C, y, maxIter, tau, selectThreshold)
% Performs Black-Gray bit-flipping decoding
% tau - decoding param, difference between standard and gray set threshold
% selectThreshold - threshold selection function, takes syndrome weight as argument

d = size(C, 1);
maskThreshold = (d + 1) / 2 + 1;

c = y;
syndrome = mod(sum(c(R), 2), 2);
upcCounts = sum(syndrome(C));
for iter = 1:maxIter
    if ~any(syndrome)
        break;
    end
    
    threshold = selectThreshold(sum(syndrome));
    
    black = find(upcCounts >= threshold);
    gray = find((upcCounts >= threshold - tau) & (upcCounts < threshold));
    [c, syndrome, upcCounts] = flipBits(R, C, c, syndrome, upcCounts, black);
    
    blackFlipMask = upcCounts(black) >= maskThreshold;    
    [c, syndrome, upcCounts] = flipBits(R, C, c, syndrome, upcCounts, black(blackFlipMask));
    
    grayFlipMask = upcCounts(gray) >= maskThreshold;
    [c, syndrome, upcCounts] = flipBits(R, C, c, syndrome, upcCounts, gray(grayFlipMask));
end
end
