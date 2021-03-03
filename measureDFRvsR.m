function DFRs = measureDFRvsR(decoder, settings, rTrials, w, t)
% Measure DFR over r

decodingFailures = zeros(1, length(rTrials));
trialCounts = zeros(1, length(rTrials));

for i = 1:length(rTrials)
    r = rTrials(i);
    if settings.printProgress
        fprintf('Testing r = %d\n', r);
    end
    n = 2 * r;
    requiredReached = false;
    for dummy = 1:settings.nMaxCodes
        [H, G] = generateQcMdpcCode(r, w);
        Q = G(:, r+1:2*r);
        [R, C] = indexNonZeroPos(H);
        for dummy2 = 1:settings.nMessagesPerCode
            msg = randi([0 1], 1, r);
            codeword = [msg, mod(msg * Q, 2)];
            errorPos = randperm(n, t);
            withErrors = codeword;
            withErrors(errorPos) = 1 - withErrors(errorPos);
            decoded = decoder(R, C, withErrors, t);
            trialCounts(i) = trialCounts(i) + 1;
            if ~isequal(decoded, codeword)
                decodingFailures(i) = decodingFailures(i) + 1;
            end
            if (decodingFailures(i) >= settings.minFailures) && (trialCounts(i) >= settings.minTrials)
               requiredReached = true; 
               break
            end
        end
        if requiredReached
            break
        end
    end
end

DFRs = decodingFailures ./ trialCounts;
end

