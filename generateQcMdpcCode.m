function [H, G] = generateQcMdpcCode(r, w)
% Generates random QC-MDPC code with n0 = 2
% r - width and height of blocks
% w - full row weight
% H - parity check matrix (r x 2r)
% G - generator matrix (r x 2r)

maxTries = 100;
% Create polynomial x^r - 1
modPoly = zeros(1, r + 1);
modPoly(1) = 1; 
modPoly(r + 1) = 1;

wBlock = w / 2;
assert(rem(wBlock, 2) == 1);

rows = zeros(2, r);
rowInvs = zeros(2, r);
for i = [1 2]
    tries = 0;
    coprimeGenerated = false;
    while ~coprimeGenerated
        if tries >= maxTries
            %throw(MException('generateRandomCode:limitReaced', ...
            %    strcat("Could not generate valid row in ", int2str(maxTries), ' tries')));
            fprintf(['WARNING: Valid row not generated in ' int2str(maxTries) ' tries']);
        end
        rows(i, :) = 0;
        rows(i, randperm(r, wBlock)) = 1;
        [gcd, ~, rowInv] = binPolyGCD(modPoly, rows(i, :));
        coprimeGenerated = isequal(find(gcd, 1, 'last'), 1);
        if coprimeGenerated
            rowInvs(i, 1:length(rowInv)) = rowInv;
        end
        tries = tries + 1;
    end
end
H = [createCirculant(rows(1, :)) createCirculant(rows(2, :))];
q = binPolyMult(rows(1, :), rowInvs(2, :));
[~, q] = binPolyDiv(q, modPoly);
assert(length(q) == r);
Q = transpose(createCirculant(q));
G = [eye(r) Q];
end

