clear;
addpath('binPolyLib', 'decoders');

r = 4801;
wBlock = 31;
m = 2;
L = 2;
tTrials = 160:2:190;

n = L * m * r;
k = L * (m - 1) * r;
w = (m + 1) * wBlock;

nCodes = 10;
nMessagesPerCode = 10;

decodingFailures = zeros(1, length(tTrials));
for i = 1:nCodes
    fprintf('Testing code %d\n', i);
    [H, Q] = generateTbConvQcMdpcCode(r, m, L, w);
    decoder = slidingWindowDecoder(H, m, L);
    for j = 1:nMessagesPerCode
        message = randi([0 1], 1, k);
        codeword = [message mod(message * Q, 2)];
        for tPos = 1:length(tTrials)
            t = tTrials(tPos);
            errorPos = randperm(n, t);
            withErrors = codeword;
            withErrors(errorPos) = 1 - withErrors(errorPos);
            decoded = decoder.decode(withErrors);
            if ~isequal(codeword, decoded)
                fprintf('-');
                decodingFailures(tPos) = decodingFailures(tPos) + 1;
            else
                fprintf('+');
            end
        end
        fprintf('\n');
    end
end

DFRs = decodingFailures ./ (nCodes * nMessagesPerCode);

figure;
title('DFR vs t');
xlabel('t');
ylabel('DFR');
set(gca, 'YScale', 'log');
hold on;
grid on;
plot(tTrials, DFRs, '-o', 'DisplayName', 'SWD');
legend show;


