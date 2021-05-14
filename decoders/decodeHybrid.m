function [c] = decodeHybrid(R, C, y, maxIter, tau, selectThresholdBG, selectThresholdWBF)
% Performs 2 rounds of WBF decoding and rest as BGF decoding

c = y;
c = decodeWeightedBitFlip(R, C, c, 2, selectThresholdWBF);
c = decodeBlackGrayFlip(R, C, c, maxIter - 2, tau, selectThresholdBG);
end
