function [c] = decodeBlackGrayFlip(R, C, y, maxIter, tau, selectThreshold)
% Performs Black-Gray-Flip decoding

c = y;
c = decodeBlackGray(R, C, c, 1, tau, selectThreshold);
c = decodeBitFlip(R, C, c, maxIter - 1);
end
