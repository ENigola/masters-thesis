function [H, G] = generateTbConvQcMdpcCode(r, w, L)
% Generates random TB Conv QC-MDPC code
% r - block width and height
% w - full row weight
% m - n/r
% L - tail-biting level

assert(L > 1);
m = 2; % doesn't work for other value ATM

cCount = m + 1;

wBlock = w / cCount;
assert(rem(wBlock, 2) == 1);

maxTries = 100;

% Create polynomial x^r - 1
modPoly = zeros(1, r + 1);
modPoly(1) = 1; 
modPoly(r + 1) = 1;

rows = zeros(cCount, r);
for i = 1:cCount
    tries = 0;
    coprimeGenerated = false;
    while ~coprimeGenerated
        if tries >= maxTries
            throw(MException('generateRandomCode:limitReaced', ...
                strcat("Could not generate valid row in ", int2str(maxTries), ' tries')));
        end
        rows(i, :) = 0;
        rows(i, randperm(r, wBlock)) = 1;
        [gcd, ~, ~] = binPolyGCD(modPoly, rows(i, :));
        coprimeGenerated = isequal(find(gcd, 1, 'last'), 1);
        tries = tries + 1;
    end
end

Cs = zeros(r, r, cCount);
for i = 1:cCount
    Cs(:, :, i) = createCirculant(rows(i, :));
end

% ---

H0 = reshape(Cs(:, :, 1:m), r, m*r);
H1 = [Cs(:, :, m + 1) zeros(r, (m - 1) * r)];

G0 = zeros((m - 1) * r, m * r);
for i = 1 : m - 1
    G0(1+(i-1)*r : i*r, 1+i*r : (i+1)*r) = transpose(Cs(:, :, m + 1));
end

G1 = zeros((m - 1) * r, m * r);
for i = 1 : m - 1
    G1(1+(i-1)*r : i*r, 1+(i-1)*r : i*r) = transpose(Cs(:, :, i + 1));
    G1(1+(i-1)*r : i*r, 1+i*r : (i+1)*r) = transpose(Cs(:, :, i));
end

% ---

H = zeros(L * r, L * m * r);
HRow = [H0 H1 zeros(r, (L - 2) * m * r)];
for i = 1:L
    H(1+(i-1)*r : i*r, :) = circshift(HRow, [0, (i-1)*m*r]);
end

% TODO: doesn't work for m > 2
G = zeros(L * (m - 1) * r, L * m * r);
GRow = [G0 G1 zeros((m - 1) * r, (L - 2) * m * r)];
for i = 1:L
    G(1+(i-1)*(m-1)*r : i*(m-1)*r, :) = circshift(GRow, [0, (i-1)*m*r]);
end

