clear;
addpath('binPolyLib', 'decoders');

r = 4801; % block width/height
w = 45; % row and column weight of each block

nCodes = 5;
nMessagesPerCode = 3;
insertedErrorCounts = 90:2:120; % t
maxIter = 100; % per decoding attempt

n = 2 * r;
% rngSeed = 1;
% rng(rngSeed);

decoders = {
    @decodeBitFlip;
    @decodeBitFlipNew;
    %@decodeBackflip;
    %@decodeBlackGray;
};    

frameErrors = zeros(length(decoders), length(insertedErrorCounts));
for i = 1:nCodes
    fprintf('Code %d \n', i);
    [H, G] = generateRandomCode(r, w);
    [R, C] = indexNonZeroPos(H);
    for j = 1:nMessagesPerCode
        msg = randi([0, 1], 1, r);
        codeword = mod(msg * G, 2); 
        for k = 1:length(insertedErrorCounts)
            t = insertedErrorCounts(k);
            errorPos = randperm(n, t);
            codewordWithErrors = codeword;
            codewordWithErrors(errorPos) = mod(codewordWithErrors(errorPos) + 1, 2);
            for m = 1:length(decoders)
                decoder = decoders{m};
                decoded = decoder(R, C, codewordWithErrors, maxIter);
                if any(mod(sum(decoded(R), 2), 2))
                    % decoding failure
                    frameErrors(m, k) = frameErrors(m, k) + 1;
                elseif ~isequal(decoded, codeword)
                    % decoded to incorrect codeword
                    disp('Decoded to wrong codeword');
                else
                    % correctly decoded
                end 
            end
        end
    end
end
frameErrorRates = frameErrors / (nCodes * nMessagesPerCode);

% Plot results
figure;
hold on;
xlabel('t');
ylabel('FER');
grid on
title('Frame error rates');
for i = 1:length(decoders)
    plot(insertedErrorCounts, frameErrorRates(i, :), 'DisplayName', func2str(decoders{i}));
end
legend show;

