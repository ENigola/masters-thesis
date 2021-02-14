function [c] = decodeBackflip(R, C, y, maxIter, ~)
% Backflip decoding
% R, C - non-zero pos of H by row, column
% y - word to be decoded
% maxIter - max number of iterations
% c - decoded codeword if successful

c = y;
timeOfDeath = zeros(1, length(c));
syndrome = mod(sum(c(R), 2), 2);
upcCounts = sum(syndrome(C));
for iter = 1:maxIter
    if ~any(syndrome)
        break
    end
    
    threshold = computeThreshold(max(upcCounts));
    flipPos = find(upcCounts >= threshold);
    for flipIdx = flipPos
        if timeOfDeath(flipIdx) >= iter
            timeOfDeath(flipIdx) = 0;
        else
            timeOfDeath(flipIdx) = iter + timeToLive(upcCounts(flipIdx) - threshold);
        end
    end
    unflipPos = find(timeOfDeath == iter);
    flipPos = setxor(flipPos, unflipPos);
    
    [c, syndrome, upcCounts] = flipBits(R, C, c, syndrome, upcCounts, flipPos);
end
end

function threshold = computeThreshold(maxUpcCount)
% Selects UPC count threshold for flipping
threshold = maxUpcCount - 2; % simple rule for now
end

function ttl = timeToLive(delta)
% Selects time-to-live for flipped bit
ttl = (delta + 3) * 5; % arbitrary rule for now
end
