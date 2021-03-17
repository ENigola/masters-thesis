clear;
addpath('binPolyLib', 'decoders');

printFailSucc = false;

secLevel = 80;

maxR = 4000;
p1.L = 2;
p1.m = 2;
[p1.t, p1.w] = calcMinParams(secLevel, maxR, p1.m, p1.L, true);
p1.rTrials = 2001:50:3001;
p1.name = 'L = 2, m = 2';

maxR = 6000;
p2.L = 1;
p2.m = 2;
[p2.t, p2.w] = calcMinParams(secLevel, maxR, p2.m, p2.L, true);
p2.rTrials = 3601:60:4801;
p2.name = 'L = 1, m = 2';

maxR = 5000;
p3.L = 1;
p3.m = 3;
[p3.t, p3.w] = calcMinParams(secLevel, maxR, p3.m, p3.L, true);
p3.rTrials = 2501:50:3501;
p3.name = 'L = 1, m = 3';

maxR = 4000;
p4.L = 1;
p4.m = 4;
[p4.t, p4.w] = calcMinParams(secLevel, maxR, p4.m, p4.L, true);
p4.rTrials = 2001:50:3001;
p4.name = 'L = 1, m = 4';

trialParams = [
    p1;
    p2;
    p3;
    p4;
];    

nCodes = 10;
nMessagesPerCode = 50;

decodingFailures = cell(1, length(trialParams));
for paramsPos = 1:length(trialParams)
    params = trialParams(paramsPos);
    fprintf('Testing for params set %s\n', params.name);
    paramsDF = zeros(1, length(params.rTrials));
    for rPos = 1:length(params.rTrials)
        r = params.rTrials(rPos);
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
                    if printFailSucc
                        fprintf('-');
                    end
                    paramsDF(rPos) = paramsDF(rPos) + 1;
                else
                    if printFailSucc
                        fprintf('+');
                    end
                end
            end
            if printFailSucc
                fprintf('\n');
            end
        end
    end
    decodingFailures{paramsPos} = paramsDF;
end

figure;
title('DFR vs r');
xlabel('r');
ylabel('DFR');
set(gca, 'YScale', 'log');
hold on;
grid on;
for i = 1:length(trialParams)
    params = trialParams(i);
    DFRs = decodingFailures{i} ./ (nCodes * nMessagesPerCode);
    plot(params.rTrials, DFRs, '-o', 'DisplayName', params.name);
end
legend show;


