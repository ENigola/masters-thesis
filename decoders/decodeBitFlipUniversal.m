function c = decodeBitFlipUniversal(H, y, maxIter)
% Performs basic bit-flipping decoding for any valid H
% H - parity-check matrix, no assumptions about its structure
% y - word to be decoded
% maxIter - max number of iterations
% c - decoded codeword if successful

c = y;
n = size(H, 2);
H_ = logical(H);
syndrome = mod(H * transpose(c), 2);
syndromeWeight = sum(syndrome);
upcCounts = zeros(1, n);
for i = 1:n
    upcCounts(i) = sum(syndrome(H_(:, i)));
end

for iter = 1:maxIter
    if syndromeWeight == 0
        break
    end
    
    threshold = max(upcCounts);
    flipPos = find(upcCounts >= threshold);
    [c, syndrome, upcCounts] = flipBitsUniversal(H, c, syndrome, upcCounts, flipPos);
    syndromeWeightNew = sum(syndrome);
    if syndromeWeightNew > syndromeWeight
        break
    else
        syndromeWeight = syndromeWeightNew;
    end
end

end

