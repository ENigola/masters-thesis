function [c] = decodeWeightedBitFlip(R, C, y, maxIter, selectThreshold)
% Performs simplified Weighted Bit-flipping decoding

d = size(C, 1);
c = y;
syndrome = mod(sum(c(R), 2), 2);
nucs = sum(syndrome(C));
for iter = 1:maxIter
    if ~any(syndrome)
        break
    end
    votes = sum(nucs(R) > d / 2, 2);
    minVotes0 = min(votes(syndrome == 0));    
    minVotes1 = min(votes(syndrome == 1));
    rels = 2 * syndrome - 1;
    mask = (syndrome == 0) & (votes <= minVotes0 + 3);
    rels(mask) = rels(mask) * 3;
    mask = (syndrome == 1) & (votes <= minVotes1 + 3);
    rels(mask) = rels(mask) * 3;
    metric = sum(rels(C), 1);

    % Original method
%     maxMetric = max(metric);
%     candidatePos = find(metric == maxMetric);
%     [~, J] = min(sum(votes(C(:, candidatePos))));
%     [c, syndrome, nucs] = flipBits(R, C, c, syndrome, nucs, candidatePos(J));
    
    threshold = selectThreshold(max(metric), min(metric), syndrome);
    flipPos = find(metric >= threshold);
    [c, syndrome, nucs] = flipBits(R, C, c, syndrome, nucs, flipPos);
end
end

