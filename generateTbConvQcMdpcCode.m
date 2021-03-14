function [H, Q] = generateTbConvQcMdpcCode(r, m, L, w)
% Generates random TB Conv QC-MDPC code
%  equivalent to normal QC-MDPC code generation if L = 1
% r - block width and height
% m - n/r
% L - tail-biting level
% w - full row weight
% Q - as in G = [I Q]

if L == 1
    blockCount = m;
else
    blockCount = m + 1;
end
wBlock = w / blockCount;
assert(rem(wBlock, 2) == 1);
maxRowGenTries = 10;

% Create polynomial x^r - 1
modPoly = zeros(1, r + 1);
modPoly(1) = 1; 
modPoly(r + 1) = 1;

rows = zeros(blockCount, r);
rowInvs = zeros(blockCount, r);
for i = 1:blockCount
    tries = 0;
    coprimeGenerated = false;
    while ~coprimeGenerated
        tries = tries + 1;
        if tries == maxRowGenTries + 1
            warning('Row generation has taken more than %d tries.', maxRowGenTries);
        end
        rows(i, :) = 0;
        rows(i, randperm(r, wBlock)) = 1;
        [gcd, ~, rowInv] = binPolyGCD(modPoly, rows(i, :));
        coprimeGenerated = isequal(find(gcd, 1, 'last'), 1);
    end
    rowInvs(i, 1:length(rowInv)) = rowInv;
end

Cs = zeros(r, r, blockCount);
for i = 1:blockCount
    Cs(:, :, i) = createCirculant(rows(i, :));
end

% H = [A B]
% A = L quasi-cyclic shifts of [C1 C2 ... Cm-1 Cm+1 0 ... 0] by (m-1)*r
% B = L quasi-cyclic shifts of [Cm 0 ... 0] by r
H = zeros(L*r, L*m*r);
% HStartRow = [C1 C2 ... Cm-1 Cm+1 0 ... 0]
if L == 1
    HStartRow =  reshape(Cs(:, :, 1:m-1), r, (m-1)*r);
else
    HStartRow = [reshape(Cs(:, :, 1:m-1), r, (m-1)*r), Cs(:, :, m+1), zeros(r, (L*m-L-m)*r)]; 
end
for i = 1:L
    H(1+(i-1)*r : i*r, 1 : L*(m-1)*r) = circshift(HStartRow, [0, (i-1)*(m-1)*r]);
    H(1+(i-1)*r : i*r, (L*(m-1)+i-1)*r+1 : (L*(m-1)+i)*r) = Cs(:, :, m);
end
   
% G = [I Q]
% Q = L quasi-cyclic shifts of column
%   [Cm^-1 * C1, Cm^-1 * C2, ..., Cm^-1 * Cm-1, Cm^-1 * Cm+1, 0, ..., 0]
%   by (m-1)*r
Q = zeros(L*(m-1)*r, L*r);
QColumn = zeros(L*(m-1)*r, r);
for i = 1:m-1
    [~, poly] = binPolyDiv(binPolyMult(rowInvs(m, :), rows(i, :)), modPoly);
    QColumn(1+(i-1)*r : i*r, :) = transpose(createCirculant(poly));
end
if L ~= 1
    [~, poly] = binPolyDiv(binPolyMult(rowInvs(m, :), rows(m+1, :)), modPoly);
    QColumn(1+(m-1)*r : m*r, :) = transpose(createCirculant(poly));
end
for i = 1:L
    Q(:, 1+(i-1)*r : i*r) = circshift(QColumn, [(i-1)*(m-1)*r, 0]);
end

end