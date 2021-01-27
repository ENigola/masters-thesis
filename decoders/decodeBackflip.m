function [c] = decodeBackflip(R, C, y, maxIter)
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
    c(flipPos) = 1 - c(flipPos);
    
    % update time of death
    timeOfDeath(flipPos) = iter + timeToLive(upcCounts(flipPos) - threshold);
    
    % unflip
    unflipPos = find(timeOfDeath == iter);
    c(unflipPos) = 1 - c(unflipPos);
    
    % udpate syndrome and upcCounts
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
end

function threshold = computeThreshold(maxUpcCount)
% Selects UPC count threshold for flipping
threshold = maxUpcCount - 2; % simple rule for now
end

function ttl = timeToLive(delta)
% Selects time-to-live for flipped bit
ttl = (delta + 3) * 5; % arbitrary rule for now
end
