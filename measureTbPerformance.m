clear;
addpath('binPolyLib', 'decoders');

rng(1);

r = 2399;
w = 93;
tTrials = 90:2:100;
L = 2;

nCodes = 2;
nMessagesPerCode = 2;

n = 4 * r;
k = 2 * r;
decodingFailures = zeros(1, length(tTrials));
for i = 1:nCodes
    fprintf('Testing code %d\n', i);
    [H, G] = generateTbConvQcMdpcCode(r, w, L);
    for j = 1:nMessagesPerCode
        message = randi([0 1], 1, k);
        codeword = mod(message * G, 2);
        assert(~any(mod(H * transpose(codeword), 2), 'all'));
        for tPos = 1:length(tTrials)
            t = tTrials(tPos);
            errorPos = randperm(n, t);
            withErrors = codeword;
            withErrors(errorPos) = 1 - withErrors(errorPos);
            decoded = decodeSlidingWindow(H, withErrors, L); 
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
%set(gca, 'YScale', 'log');
hold on;
grid on;
plot(tTrials, DFRs, '-o', 'DisplayName', 'SWD');
legend show;


