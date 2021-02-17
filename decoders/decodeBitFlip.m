function [c] = decodeBitFlip(R, C, y, maxIter)
% Performs basic bit-flipping decoding
% R, C - non-zero pos of H by row, column
% y - word to be decoded
% maxIter - max number of iterations
% c - decoded codeword if successful

c = y;
syndrome = mod(sum(c(R), 2), 2);
upcCounts = sum(syndrome(C));
for iter = 1:maxIter
    if ~any(syndrome)
        break
    end
    
    threshold = max(upcCounts);
    flipPos = find(upcCounts >= threshold);
    [c, syndrome, upcCounts] = flipBits(R, C, c, syndrome, upcCounts, flipPos);
end
end
