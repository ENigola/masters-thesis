function [c] = decodeWeightedBitFlip(R, C, y, maxIter)
% Performs simplified Weighted Bit-flipping decoding

w = size(C, 1);

c = y;
syndrome = mod(sum(c(R), 2), 2);
nucs = sum(syndrome(C));
for iter = 1:maxIter
    if ~any(syndrome)
        break
    end
    votes = sum(nucs(R) > w / 2, 2);
    minVotes1 = min(votes(syndrome == 1));
    minVotes0 = min(votes(syndrome == 0));
    rels = 2 * syndrome - 1;
    mask = (syndrome == 0) & (votes <= minVotes0 + 3);
    rels(mask) = rels(mask) * 3;
    mask = (syndrome == 1) & (votes <= minVotes1 + 3);
    rels(mask) = rels(mask) * 3;
    metric = sum(rels(C), 1);
    mm = max(metric);
    f = find(metric == mm);
    [~, J] = min(sum(votes(C(:, f))));
    [c, syndrome, nucs] = flipBits(R, C, c, syndrome, nucs, f(J));
end

end

