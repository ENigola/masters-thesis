clear;
addpath('binPolyLib', 'decoders');

measureVsR = false; % r or t
plotLog = true; % log or linear

if measureVsR
    % BIKE Level 1 (BIKE_Spec.2020.05.01.1)
    w = 142;
    t = 134;
    tau = 3;
    selectThresholdBG = @(syndromeWeight) max(floor(0.0069722 * syndromeWeight + 13.530), 36);
    
    maxIter = 200;
    
    rTrials = ... 
        [8599, 8681, 8747, 8837, ...
        8933, 9013, 9127, 9203, ...
        9293, 9391, 9461, 9539, ...
        9643, 9739, 9817, 9901, ...
        10009, 10103];
    rTrials = 9001:200:9601;
else % measure vs t
    r = 4001;
    w = 70;
    tTrials = 60:2:100;
    
    NbIter = 5;
    tau = 3;
    selectThresholdBG = @(syndromeWeight) max(floor(0.0069722 * syndromeWeight + 13.530), 36);
    maxIter = 150;
end

selectThresholdWBF = @(maxMetric, minMetric, syndrome) maxMetric - (maxMetric - minMetric) * (0.55 - sum(syndrome) / length(syndrome));

settings.printProgress = false;
settings.nMaxCodes = 100;
settings.nMessagesPerCode = 100;
settings.minFailures = 100; % per variable value
settings.minTrials = 1000; % per variable value

% Signature: decode(R, C, y, t)

decBitFlip.decode = @(R, C, y, t) decodeBitFlip(R, C, y, maxIter);
decBitFlip.name = 'BitFlip';

decBackflip.decode = @(R, C, y, t) decodeBackflip(R, C, y, maxIter);
decBackflip.name = 'Backflip';

decBG.decode = @(R, C, y, t) decodeBlackGray(R, C, y, maxIter, tau, selectThresholdBG);
decBG.name = 'BG';

decBGF.decode = @(R, C, y, t) decodeBlackGrayFlip(R, C, y, 5, tau, selectThresholdBG);
decBGF.name = 'BGF';

decWBF.decode = @(R, C, y, t) decodeWeightedBitFlip(R, C, y, 7, selectThresholdWBF);
decWBF.name = 'WBF';

decHybrid.decode = @(R, C, y, t) decodeHybrid(R, C, y, 5, tau, selectThresholdBG, selectThresholdWBF);
decHybrid.name = 'Hybrid';

decBitFlipUniversal.decode = @(R, C, y, t) decodeBitFlipUniversal(RC2H(R, C), y, maxIter);
decBitFlipUniversal.name = 'BitFlip universal';


decoders = [
    decBitFlip;
    %decBackflip;
    %decBG;
    decBGF;
    decWBF;
    decHybrid;
    %decBitFlipUniversal;
];

if measureVsR
    DFRs = zeros(length(decoders), length(rTrials));
else
    DFRs = zeros(length(decoders), length(tTrials));
end

tic
for i = 1:length(decoders)
    fprintf('Testing %s\n', decoders(i).name); 
    %rng(1);
    if measureVsR 
        DFRs(i, :) = measureDFRvsR(decoders(i).decode, settings, rTrials, w, t);
    else
        DFRs(i, :) = measureDFRvsT(decoders(i).decode, settings, r, w, tTrials);
    end
end
toc
    
if measureVsR
    plotDFR(decoders, DFRs, rTrials, plotLog, 'r');
else
    plotDFR(decoders, DFRs, tTrials, plotLog, 't');
end

% save DFRs;

% SCRIPT END

function plotDFR(decoders, DFRs, xValues, logScale, xLabel)
    figure;
    title(sprintf('DFR vs %s', xLabel));
    xlabel(xLabel);
    ylabel('DFR');
    if logScale
        set(gca, 'YScale', 'log');
    end
    hold on;
    grid on;
    for i = 1:length(decoders)
        plot(xValues, DFRs(i, :), '-o', 'DisplayName', decoders(i).name);
    end
    legend show;
end

