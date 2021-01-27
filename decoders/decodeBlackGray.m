function [c] = decodeBlackGray(R, C, y, maxIter)
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
for i = 1:maxIter
    if ~any(syndrome)
        break;
    end
    
    upcCounts = sum(syndrome(C));
    threshold = computeThreshold(max(upcCounts));
    
    black = find(upcCounts >= threshold);
    gray = find(upcCounts >= threshold - delta);
    gray = setdiff(gray, black);
    c(black) = 1 - c(black);
    syndrome = mod(sum(c(R), 2), 2);
    
    upcCounts = sum(syndrome(C));
    maskFlipPos = find(upcCounts(black) >= d);
    c(black(maskFlipPos)) = 1 - c(black(maskFlipPos));
    syndrome = mod(sum(c(R), 2), 2);
    
    upcCounts = sum(syndrome(C));
    maskFlipPos = find(upcCounts(gray) >= d);
    c(gray(maskFlipPos)) = 1 - c(gray(maskFlipPos));
    syndrome = mod(sum(c(R), 2), 2);
end

end

function threshold = computeThreshold(maxUpcCount)
% Selects UPC count threshold for flipping
threshold = maxUpcCount; % simple rule for now
end
