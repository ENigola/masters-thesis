function [c] = decodeBitFlip(R, C, y, maxIter)
% Performs basic bit-flipping decoding
% R, C - non-zero pos of H by row, column
% y - word to be decoded
% maxIter - max number of iterations
% c - decoded codeword if successful

c = y;
syndrome = mod(sum(c(R), 2), 2);
syndromeWeight = sum(syndrome);
upcCounts = sum(syndrome(C), 1);
for iter = 1:maxIter
    if syndromeWeight == 0
        break
    end
    
    threshold = max(upcCounts);
    flipPos = find(upcCounts >= threshold);
    [c, syndrome, upcCounts] = flipBits(R, C, c, syndrome, upcCounts, flipPos);
    syndromeWeightNew = sum(syndrome);
    if syndromeWeightNew > syndromeWeight
        break
    else
        syndromeWeight = syndromeWeightNew;
    end
end
end
