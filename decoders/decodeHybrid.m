function [c] = decodeHybrid(R, C, y, maxIter, t)
% Performs 2 rounds of WBF decoding and rest as BGF decoding
% R, C - non-zero pos of H by row, column
% y - word to be decoded
% maxIter - max number of iterations
% t - inserted error count
% c - decoded codeword if successful

c = y;
c = decodeWeightedBitFlip(R, C, c, 2, t);
c = decodeBlackGrayFlip(R, C, c, maxIter - 2, t);
end
