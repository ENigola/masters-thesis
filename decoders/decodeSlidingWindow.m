function [c] = decodeSlidingWindow(H, y, m, L)
% Sliding window decoding
% H - parity-check matrix of the tail-biting code
% y - word to be decoded
% m - number of block in the parent QC-MDPC code (n/(n-k))
% L - tailbiting level

maxWindowIter = 150;
r = size(H, 1) / L;

c = y;
window = zeros(1, (m + 1) * r);
windowBlocks = zeros(1, m + 1);
for i = 1:L
    windowMainStart = mod((i-1)*(m-1), L*(m-1)) + 1;
    windowMainEnd = mod(windowMainStart + m - 1, L*(m-1));
    
    if windowMainStart < windowMainEnd
        windowBlocks(1:m) = windowMainStart:windowMainEnd;
    else
        windowBlocks(1:m) = [1:windowMainEnd windowMainStart:L*(m-1)];
    end
    
    windowBlocks(m + 1) = L * (m - 1) + i;
    
    for j = 1:length(windowBlocks)
        blockPos = windowBlocks(j);
        window(1+(j-1)*r : j*r) = 1 + (blockPos - 1) * r : blockPos * r;
    end
    
    windowH = H(1+(i-1)*r : i*r, window);   
    [windowR, windowC] = indexNonZeroPos(windowH);
    windowY = c(window);
    
    c(window) = decodeBitFlip(windowR, windowC, windowY, maxWindowIter);
end

end

