clear;
addpath('binPolyLib', 'decoders');

printFailSucc = true;

secLevel = 32;

maxP = 2500;
p1.L = 1;
p1.m = 2;
[p1.t, p1.w] = calcMinParams(secLevel, maxP, p1.m, p1.L, true);
p1.pTrials = 801:100:1501;
p1.name = sprintf('L = %d, m = %d', p1.L, p1.m);

maxP = 2000;
p2.L = 1;
p2.m = 3;
[p2.t, p2.w] = calcMinParams(secLevel, maxP, p2.m, p2.L, true);
p2.pTrials = 601:100:1201;
p2.name = sprintf('L = %d, m = %d', p2.L, p2.m);

maxP = 2500;
p3.L = 2;
p3.m = 2;
[p3.t, p3.w] = calcMinParams(secLevel, maxP, p3.m, p3.L, true);
p3.pTrials = 801:100:1501;
p3.name = sprintf('L = %d, m = %d', p3.L, p3.m);

maxP = 2200;
p4.L = 3;
p4.m = 2;
[p4.t, p4.w] = calcMinParams(secLevel, maxP, p4.m, p4.L, true);
p4.pTrials = 601:100:1401;
p4.name = sprintf('L = %d, m = %d', p4.L, p4.m);

maxP = 2000;
p5.L = 2;
p5.m = 3;
[p5.t, p5.w] = calcMinParams(secLevel, maxP, p5.m, p5.L, true);
p5.pTrials = 501:100:1201;
p5.name = sprintf('L = %d, m = %d', p5.L, p5.m);

trialParams = [
    p1;
    p2;
    p3;
    p4;
    p5;
];    

nCodes = 10;
nMessagesPerCode = 50;

decodingFailures = cell(1, length(trialParams));
tic
for paramsPos = 1:length(trialParams)
    %rng(1);
    params = trialParams(paramsPos);
    fprintf('Testing for params set %s\n', params.name);
    paramsDF = zeros(1, length(params.pTrials));
    for pPos = 1:length(params.pTrials)
        p = params.pTrials(pPos);
        fprintf('p = %d\n', p);
        k = params.L * (params.m - 1) * p;        
        n = params.L * params.m * p;
        for i = 1:nCodes
            [H, Q] = generateTbConvQcMdpcCode(p, params.m, params.L, params.w);
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
                    paramsDF(pPos) = paramsDF(pPos) + 1;
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
toc

dfrIntercept = 0.1;
figure;
title('DFR vs p');
xlabel('p');
ylabel('DFR');
set(gca, 'YScale', 'log');
hold on;
grid on;
pMin = 100000;
pMax = 0;
for i = 1:length(trialParams)
    params = trialParams(i);
    DFRs = decodingFailures{i} ./ (nCodes * nMessagesPerCode);
    plot(params.pTrials, DFRs, '-o', 'DisplayName', params.name);
    pMin = min(pMin, min(params.pTrials));
    pMax = max(pMax, max(params.pTrials));
end
%plot([pMin pMax], [dfrIntercept dfrIntercept], '--r', 'DisplayName', sprintf('DFR = %s', dfrIntercept));
legend show;


