function [c] = decodeBlackGray(R, C, y, maxIter, ~)
% Performs Black-Gray bit-flipping decoding
% R, C - non-zero pos of H by row, column
% y - word to be decoded
% maxIter - max number of iterations
% c - decoded codeword if successful

% arbitrary params ATM
delta = 4; % decoding param
d = 32; % decoding param

c = y;
syndrome = mod(sum(c(R), 2), 2);
upcCounts = sum(syndrome(C));
for i = 1:maxIter
    if ~any(syndrome)
        break;
    end
    
    threshold = computeThreshold(max(upcCounts));
    
    black = find(upcCounts >= threshold);
    gray = find(upcCounts >= threshold - delta);
    gray = setdiff(gray, black);
    [c, syndrome, upcCounts] = flipBits(R, C, c, syndrome, upcCounts, black);
    
    blackFlipMask = upcCounts(black) >= d;    
    [c, syndrome, upcCounts] = flipBits(R, C, c, syndrome, upcCounts, black(blackFlipMask));
    
    grayFlipMask = upcCounts(gray) >= d;
    [c, syndrome, upcCounts] = flipBits(R, C, c, syndrome, upcCounts, gray(grayFlipMask));
end

end

function threshold = computeThreshold(maxUpcCount)
% Selects UPC count threshold for flipping
threshold = maxUpcCount; % simple rule for now
end
