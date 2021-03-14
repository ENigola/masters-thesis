function [H, Q] = generateQcMdpcCode(r, w, n0)
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

wBlock = w / n0;
assert(rem(wBlock, 2) == 1);

rows = zeros(n0, r);
rowInvs = zeros(n0, r);
for i = 1:n0
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

H = zeros(r, n0*r);
for i = 1:n0
    H(:, 1+(i-1)*r : i*r) = createCirculant(rows(i, :));
end

Q = zeros((n0-1)*r, r);
for i = 1:n0-1
    rowQ = binPolyMult(rowInvs(n0, :), rows(i, :));
    [~, rowQ] = binPolyDiv(rowQ, modPoly);
    Q(1+(i-1)*r : i*r, :) = transpose(createCirculant(rowQ));
end
end

