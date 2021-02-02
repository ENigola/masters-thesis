clear;
addpath('binPolyLib', 'decoders');

nMaxCodes = 1000;
nMessagesPerCode = 200;
nRequiredFailures = 25;
insertedErrorCounts = 80:100;

decoders = {
    @decodeBitFlip;
    %@decodeBackflip;
    %@decodeBlackGray;
}; 

frameErrorRates = zeros(length(decoders), length(insertedErrorCounts));
for i = 1:length(decoders)
    frameErrorRates(i, :) = measureDecoderPerformance(decoders{i}, ...
        nMaxCodes, nMessagesPerCode, nRequiredFailures, insertedErrorCounts);
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
    semilogy(insertedErrorCounts, frameErrorRates(i, :), 'DisplayName', func2str(decoders{i}));
end
legend show;
