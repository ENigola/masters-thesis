function [c] = decodeSlidingWindow(H, y, m, L)
% Sliding window decoding
% TODO

% TODO: uses old construction, update to new

maxWindowIter = 150;
m = 2;
W = m + 1;
r = size(H, 1) / L;

c = y;
window = zeros(1, W * r);
for i = 1:L
    windowStart = mod(1 + (i - 1) * m, m * L);
    windowEnd = mod(windowStart + W - 1, m * L);
    
    if windowStart < windowEnd
        windowBlocks = windowStart:windowEnd;
    else
        windowBlocks = [1:windowEnd windowStart:m*L];
    end
    
    for j = 1:length(windowBlocks)
        blockPos = windowBlocks(j);
        window(1+(j-1)*r : j*r) = 1 + (blockPos - 1) * r : blockPos * r;
    end
    
    windowH = H(1+(i-1)*r : i*r, window);   
    [windowR, windowC] = indexNonZeroPos(windowH);
    windowY = c(window);
    
    windowDecoded = decodeBitFlip(windowR, windowC, windowY, maxWindowIter);
    c(window) = windowDecoded;
end

end

