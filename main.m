clear;
addpath('binPolyLib', 'decoders');

nMaxCodes = 10;
nMessagesPerCode = 100;
nRequiredFailures = 10;
nMinTrials = 100;
insertedErrorCounts = 90:100;

decoders = {
    @decodeBitFlip;
    %@decodeBitFlipNew;
    %@decodeBackflip;
    %@decodeBackflipNew;
    %@decodeBlackGray;
    @decodeBlackGrayFlip;
    @decodeWeightedBitFlip;
    @decodeHybrid;
}; 

frameErrorRates = zeros(length(decoders), length(insertedErrorCounts));
for i = 1:length(decoders)
    fprintf('Testing %s\n', func2str(decoders{i}));
    rng(1);
    frameErrorRates(i, :) = measureDecoderPerformance(decoders{i}, ...
        nMaxCodes, nMessagesPerCode, nRequiredFailures, nMinTrials, insertedErrorCounts);
end

% Plot results
figure;
title('Frame error rates');
xlabel('t');
ylabel('FER');
set(gca, 'YScale', 'log');
hold on;
grid on;
for i = 1:length(decoders)
    plot(insertedErrorCounts, frameErrorRates(i, :), '-o', 'DisplayName', func2str(decoders{i}));
end
legend show;
