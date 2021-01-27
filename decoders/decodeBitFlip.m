function [c] = decodeBitFlip(R, C, y, maxIter)
% Performs basic bit-flipping decoding
% R, C - non-zero pos of H by row, column
% y - word to be decoded
% maxIter - max number of iterations
% c - decoded codeword if successful

c = y;
syndrome = mod(sum(c(R), 2), 2);
for iter = 1:maxIter
    if ~any(syndrome)
        break
    end
    
    upcCounts = sum(syndrome(C));
    threshold = computeThreshold(max(upcCounts));
    flipPos = find(upcCounts >= threshold);
    c(flipPos) = mod(c(flipPos) + 1, 2);
    for flipIdx = flipPos
        syndrome(C(:, flipIdx)) = mod(syndrome(C(:, flipIdx)) + 1, 2);
    end
end
end

function threshold = computeThreshold(maxUpcCount)
% Selects UPC count threshold for flipping
threshold = maxUpcCount; % simple rule for now
end
