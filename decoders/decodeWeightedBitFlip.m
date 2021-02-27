function [c] = decodeWeightedBitFlip(R, C, y, maxIter)
% Performs simplified Weighted Bit-flipping decoding

w = size(C, 1);

c = y;
syndrome = mod(sum(c(R), 2), 2);
syndromeWeight = sum(syndrome);
nucs = sum(syndrome(C));
for iter = 1:maxIter
    if syndromeWeight == 0
        break
    end
    votes = sum(nucs(R) > w / 2, 2);
    minVotes0 = min(votes(syndrome == 0));    
    minVotes1 = min(votes(syndrome == 1));
    rels = 2 * syndrome - 1;
    mask = (syndrome == 0) & (votes <= minVotes0 + 3);
    rels(mask) = rels(mask) * 3;
    mask = (syndrome == 1) & (votes <= minVotes1 + 3);
    rels(mask) = rels(mask) * 3;
    metric = sum(rels(C), 1);
    maxMetric = max(metric);
    candidatePos = find(metric == maxMetric);
    [~, J] = min(sum(votes(C(:, candidatePos))));
    [c, syndrome, nucs] = flipBits(R, C, c, syndrome, nucs, candidatePos(J));
    syndromeWeightNew = sum(syndrome);
    if syndromeWeightNew > syndromeWeight
        break
    else
        syndromeWeight = syndromeWeightNew;
    end
end
end

