function [c] = decodeBlackGrayFlip(R, C, y, maxIter, t)
% Performs Black-Gray-Flip decoding
% R, C - non-zero pos of H by row, column
% y - word to be decoded
% maxIter - max number of iterations
% t - inserted error count
% c - decoded codeword if successful

c = y;
c = decodeBlackGray(R, C, c, 1, t);
c = decodeBitFlip(R, C, c, maxIter - 1, t);
end
