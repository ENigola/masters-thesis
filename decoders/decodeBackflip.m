function [c] = decodeBackflip(R, C, y, maxIter)
% Backflip decoding
% R, C - non-zero pos of H by row, column
% y - word to be decoded
% maxIter - max number of iterations
% c - decoded codeword if successful

c = y;
timeOfDeath = zeros(1, length(c));
syndrome = mod(sum(c(R), 2), 2);
for iter = 1:maxIter
    if ~any(syndrome)
        break
    end
    
    % unflip
    unflipPos = find(timeOfDeath == iter);
    c(unflipPos) = 1 - c(unflipPos);
    
    upcCounts = sum(syndrome(C));
    threshold = computeThreshold(max(upcCounts));
    flipPos = find(upcCounts >= threshold);
    c(flipPos) = 1 - c(flipPos);
    for flipIdx = flipPos
        syndrome(C(:, flipIdx)) = mod(syndrome(C(:, flipIdx)) + 1, 2);
        timeOfDeath(flipIdx) = iter + timeToLive(upcCounts(flipIdx), threshold);
    end
end
end

function threshold = computeThreshold(maxUpcCount)
% Selects UPC count threshold for flipping
threshold = maxUpcCount - 2; % simple rule for now
end

function ttl = timeToLive(upcCount, threshold)
% Selects time-to-live for flipped bit
ttl = (upcCount - threshold + 3) * 5; % arbitrary rule for now
end
