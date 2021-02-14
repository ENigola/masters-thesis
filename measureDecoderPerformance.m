function frameErrorRates = measureDecoderPerformance(decoder, nMaxCodes, nMessagesPerCode, nRequiredFailures, nMinTrials, insertedErrorCounts)
% Tests the success rate of the decoder decoders
% decoder - the decoder to test, must have arguments (R, C, y, maxIter)
% nMaxCodes - max number of codes to test for
% nMessagesPerCode - number of messages to run tests for per code
% nRequiredFailures - min number of decoding failures required per error count
% nMinTrials - min number of trials required per error count
% insertedErrorCounts - array of error counts to test decoding for

r = 4801; % block width/height
w = 45; % row and column weight of each block
maxIter = 100; % per decoding attempt

n = 2 * r;   

frameErrors = zeros(1, length(insertedErrorCounts));
trialCounts = zeros(1, length(insertedErrorCounts));
remainingErrorCountsPos = 1:length(insertedErrorCounts);

for i = 1:nMaxCodes
    if isempty(remainingErrorCountsPos)
        break; 
    end
    fprintf('Code %g\n', i);
    [H, G] = generateRandomCode(r, w);
    [R, C] = indexNonZeroPos(H);
    for j = 1:nMessagesPerCode
        msg = randi([0, 1], 1, r);
        codeword = mod(msg * G, 2);
        for errorCountPos = remainingErrorCountsPos
            errorCount = insertedErrorCounts(errorCountPos);
            errorPos = randperm(n, errorCount);
            codewordWithErrors = codeword;
            codewordWithErrors(errorPos) = mod(codewordWithErrors(errorPos) + 1, 2);
            decoded = decoder(R, C, codewordWithErrors, maxIter, errorCount);
            trialCounts(errorCountPos) = trialCounts(errorCountPos) + 1;
            if ~isequal(decoded, codeword)
                frameErrors(errorCountPos) = frameErrors(errorCountPos) + 1;
            end
            if (frameErrors(errorCountPos) >= nRequiredFailures) && (trialCounts(errorCountPos) >= nMinTrials)
                remainingErrorCountsPos(remainingErrorCountsPos == errorCountPos) = [];
            end
        end
        if isempty(remainingErrorCountsPos)
            break;
        end
    end 
end

frameErrorRates = frameErrors ./ trialCounts;
end

