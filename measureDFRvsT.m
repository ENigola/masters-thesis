function DFRs = measureDFRvsT(decoder, settings, r, w, tTrials)
% Measures DFR over t

n = 2 * r;   
decodingFailures = zeros(1, length(tTrials));
trialCounts = zeros(1, length(tTrials));
tRemainingPos = 1:length(tTrials);

for i = 1:settings.nMaxCodes
    if isempty(tRemainingPos)
        break; 
    end
    if settings.printProgress
        fprintf('Code %g\n', i);
    end
    [H, G] = generateRandomCode(r, w);
    [R, C] = indexNonZeroPos(H);
    for dummy = 1:settings.nMessagesPerCode
        msg = randi([0, 1], 1, r);
        codeword = mod(msg * G, 2);
        for tPos = tRemainingPos
            t = tTrials(tPos);
            errorPos = randperm(n, t);
            withErrors = codeword;
            withErrors(errorPos) = mod(withErrors(errorPos) + 1, 2);
            decoded = decoder(R, C, withErrors, t);
            trialCounts(tPos) = trialCounts(tPos) + 1;
            if ~isequal(decoded, codeword)
                decodingFailures(tPos) = decodingFailures(tPos) + 1;
            end
            if (decodingFailures(tPos) >= settings.minFailures) && (trialCounts(tPos) >= settings.minTrials)
                tRemainingPos(tRemainingPos == tPos) = [];
            end
        end
        if isempty(tRemainingPos)
            break;
        end
    end 
end

DFRs = decodingFailures ./ trialCounts;
end

