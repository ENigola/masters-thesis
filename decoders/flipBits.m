function [c, syndrome, upcCounts] = flipBits(R, C, c, syndrome, upcCounts, flipPos)
% Flips bits in word and updated syndrome and upcCounts accordingly
% R, C - non-zero pos of H by row, column
% c - word in which to flip
% syndrome - syndrome of c with respect to H
% upcCounts - unsatisfied parity check counts per bit (of word c)
% flipPos - positions in c to flip

c(flipPos) = 1 - c(flipPos);
for i = 1:length(flipPos) % for cFlipIdx = flipPos
    cFlipIdx = flipPos(i);
    syndrome(C(:, cFlipIdx)) = 1 - syndrome(C(:, cFlipIdx));
    for j = 1:length(C(:, cFlipIdx)) % for syndromeFlipIdx = transpose(C(:, cFlipIdx))
        syndromeFlipIdx = C(j, cFlipIdx);
        if syndrome(syndromeFlipIdx) == 0
            % parity check now satisified
            change = -1;
        else % syndrome(syndromeFlipIdx) == 1
            % new unsatisfied parity check
            change = +1;
        end
        upcCounts(R(syndromeFlipIdx, :)) = upcCounts(R(syndromeFlipIdx, :)) + change;
    end
end
end

