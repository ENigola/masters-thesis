clear;
addpath('binPolyLib', 'decoders');

params1.L = 2;
params1.m = 2;
params1.t = 136;
params1.w = 147;
params1.name = 'm = 2';

params2.L = 2;
params2.m = 3;
params2.t = 85;
params2.w = 92;
params2.name = 'm = 3';

params3.L = 2;
params3.m = 4;
params3.t = 68;
params3.w = 75;
params3.name = 'm = 4';

params4.L = 1;

trialParams = [
    %params1;
    %params2;
    params3;
];    

% rTrials = [4001, 4507, 5003, 5501, 6007];
% rTrials = [1103, 1301, 1511, 1709, 1901];
rTrials = [809, 907, 1009, 1103, 1201];

nCodes = 5;
nMessagesPerCode = 20;

decodingFailures = zeros(length(trialParams), length(rTrials));
for paramsPos = 1:length(trialParams)
    params = trialParams(paramsPos);
    fprintf('Testing for params set %s\n', params.name);
    for rPos = 1:length(rTrials)
        r = rTrials(rPos);
        fprintf('r = %d\n', r);
        k = params.L * (params.m - 1) * r;        
        n = params.L * params.m * r;
        for i = 1:nCodes
            [H, Q] = generateTbConvQcMdpcCode(r, params.m, params.L, params.w);
            decoder = slidingWindowDecoder(H, params.m, params.L);
            for j = 1:nMessagesPerCode
                message = randi([0 1], 1, k);
                codeword = [message mod(message * Q, 2)];
                errorPos = randperm(n, params.t);
                withErrors = codeword;
                withErrors(errorPos) = 1 - withErrors(errorPos);
                decoded = decoder.decode(withErrors);
                if ~isequal(codeword, decoded)
                    fprintf('-');
                    decodingFailures(paramsPos, rPos) = decodingFailures(paramsPos, rPos) + 1;
                else
                    fprintf('+');
                end
            end
            fprintf('\n');
        end
    end
end

DFRs = decodingFailures ./ (nCodes * nMessagesPerCode);

figure;
title('DFR vs r');
xlabel('r');
ylabel('DFR');
set(gca, 'YScale', 'log');
hold on;
grid on;
for i = 1:length(trialParams)
    plot(rTrials, DFRs(i, :), '-o', 'DisplayName', trialParams(i).name);
end
legend show;


