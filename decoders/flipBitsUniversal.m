function [c, syndrome, upcCounts] = flipBitsUniversal(H, c, syndrome, upcCounts, flipPos)
% Flips bits in word and updated syndrome and upcCounts accordingly
% H - parity-check matrix
% c - word in which to flip
% syndrome - syndrome of c with respect to H
% upcCounts - unsatisfied parity check counts per bit (of word c)
% flipPos - positions in c to flip

c(flipPos) = 1 - c(flipPos);
for cFlipIdx = flipPos
    syndromeFlipPos = find(H(:, cFlipIdx));
    syndrome(syndromeFlipPos) = 1 - syndrome(syndromeFlipPos);
    for syndromeFlipIdx = transpose(syndromeFlipPos)
        if syndrome(syndromeFlipIdx) == 0
            % parity check now satisified
            change = -1;
        else % syndrome(syndromeFlipIdx) == 1
            % new unsatisfied parity check
            change = +1;
        end
        upcChangePos = find(H(syndromeFlipIdx, :));
        upcCounts(upcChangePos) = upcCounts(upcChangePos) + change;
    end
end
end

