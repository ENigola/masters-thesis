clear;
addpath('binPolyLib', 'decoders');

printFailSucc = false;

secLevel = 40;

maxR = 2500;
p1.L = 2;
p1.m = 2;
[p1.t, p1.w] = calcMinParams(secLevel, maxR, p1.m, p1.L, true);
p1.rTrials = 801:80:1601;
p1.name = sprintf('L = %d, m = %d', p1.L, p1.m);

maxR = 2000;
p2.L = 2;
p2.m = 3;
[p2.t, p2.w] = calcMinParams(secLevel, maxR, p2.m, p2.L, true);
p2.rTrials = 501:50:1001;
p2.name = sprintf('L = %d, m = %d', p2.L, p2.m);

maxR = 1500;
p3.L = 2;
p3.m = 4;
[p3.t, p3.w] = calcMinParams(secLevel, maxR, p3.m, p3.L, true);
p3.rTrials = 351:55:901;
p3.name = sprintf('L = %d, m = %d', p3.L, p3.m);

maxR = 1500;
p4.L = 2;
p4.m = 5;
[p4.t, p4.w] = calcMinParams(secLevel, maxR, p4.m, p4.L, true);
p4.rTrials = 301:45:751;
p4.name = sprintf('L = %d, m = %d', p4.L, p4.m);


trialParams = [
    p1;
    p2;
    p3;
    p4;
];    

nCodes = 30;
nMessagesPerCode = 50;

decodingFailures = cell(1, length(trialParams));
for paramsPos = 1:length(trialParams)
    %rng(1);
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

dfrIntercept = 0.1;
figure;
title('DFR vs r');
xlabel('r');
ylabel('DFR');
set(gca, 'YScale', 'log');
hold on;
grid on;
rMin = 100000;
rMax = 0;
for i = 1:length(trialParams)
    params = trialParams(i);
    DFRs = decodingFailures{i} ./ (nCodes * nMessagesPerCode);
    plot(params.rTrials, DFRs, '-o', 'DisplayName', params.name);
    rMin = min(rMin, min(params.rTrials));
    rMax = max(rMax, max(params.rTrials));
end
plot([rMin rMax], [dfrIntercept dfrIntercept], '--r', 'DisplayName', sprintf('DFR = %s', dfrIntercept));
legend show;


