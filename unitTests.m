clear;
addpath('binPolyLib');

% Test binPolyEqual

assert(binPolyEqual(0, 0));
assert(binPolyEqual([1 0 1], [1 0 1]));
assert(binPolyEqual([1 1 0], [1 1 0 0 0 0 0 0 0]));
assert(binPolyEqual([1 0 1 1 0 0 0 0 0 0], [1 0 1 1]));
assert(~binPolyEqual(0, 1));
assert(~binPolyEqual(1, 0));
assert(~binPolyEqual([1 0 1], [1 0 1 0 0 0 0 1]));
assert(~binPolyEqual([0 0 1 0 0 0 1], [0 0 1 0]));

% Test binPolyAdd

assert(binPolyEqual(binPolyAdd(1, 1), 0));
assert(binPolyEqual(binPolyAdd(1, 0), 1));
assert(binPolyEqual(binPolyAdd([0 0 0], [0 1 0]), [0 1]));
assert(binPolyEqual(binPolyAdd([0 0 0], [0 0]), 0));
assert(binPolyEqual(binPolyAdd([1 0 1], [1 1 0]), [0 1 1]));
assert(binPolyEqual(binPolyAdd([1 1 1], [0 1 1]), [1 0 0]));
assert(binPolyEqual(binPolyAdd([0 1 0 1 1 0], [1 1 0 1 0]), [1 0 0 0 1 0]));
    
% Test binPolyMult

assert(isequal(binPolyMult([1 1 0 1], [1 0 1 1]), [1 1 1 1 1 1 1]));
assert(isequal(binPolyMult(0, [1 0 1]), [0 0 0]));
assert(isequal(binPolyMult([0 1 0], [0 1 0]), [0 0 1 0 0]));
assert(isequal(binPolyMult([0 1 0], [0 0]), [0 0 0 0]));
assert(isequal(binPolyMult([1 1 0 0 1 0 1 1], [1 0 1 1 0 0 1]), [1 1 1 0 0 0 1 1 1 0 0 0 1 1]));

% Test binPolyDiv

% try
%     binPolyDiv([0 1 1], [0 0]);
%     throw(MException('automatedTest:TestDivByZero', 'Division by zero did not fail'));
% catch ME
%     if ~strcmp(ME.identifier, 'binPolyDiv:divByZero')
%         rethrow(ME);
%     end
% end

a = [0 0 0 1 1 1 1 1 1 1];
b = [0 0 1 1 1 0 1];
[q, r] = binPolyDiv(a, b);
assert(isequal(q, [1 0 1 1]));
assert(isequal(r, [0 0 1 0 1 1]));

a = [0 1 0 1 0 0 0 1 1 0];
b = [0 1 0 1 1 1 1 0 0 0 1 0];
[q, r] = binPolyDiv(a, b);
assert(binPolyEqual(q, 0));
assert(binPolyEqual(r, [0 1 0 1 0 0 0 1 1 0]));

a = [0 1 1 0 0 0 1 1 1 0];
b = [1 1 1 1 1 1 0 0 0 0];
[q, r] = binPolyDiv(a, b);
assert(binPolyEqual(q, [1 0 0 1]));
assert(binPolyEqual(r, 1));

% Test binPolyGCD

a = [0 1 0 1 1 0 0 1];
b = [1 1 0 1 0 0 1];
[gcd, coefA, coefB] = binPolyGCD(a, b);
assert(binPolyEqual(gcd, [1 1]));
assert(binPolyEqual(coefA, [0 1 1 1]));
assert(binPolyEqual(coefB, [1 0 1 1 1]));
assert(binPolyEqual(gcd, binPolyAdd(binPolyMult(coefA, a), binPolyMult(coefB, b))));

a = [1 1 1 0 0 1 0 1 0 1];
b = [0 0 1 1 0 1 0 1 0 1 1 0 1 0 0];
[gcd, coefA, coefB] = binPolyGCD(a, b);
assert(binPolyEqual(gcd, 1));
assert(binPolyEqual(coefA, [1 1 1 0 1 1 1 1 1 1 1]));
assert(binPolyEqual(coefB, [1 1 1 1 0 1 1 1 0 0 0]));
assert(binPolyEqual(gcd, binPolyAdd(binPolyMult(coefA, a), binPolyMult(coefB, b))));

% Test createCirculant

assert(isequal(createCirculant(1), 1));
assert(isequal(createCirculant([1 2 3]), [1 2 3; 3 1 2; 2 3 1]));
assert(isequal(createCirculant([]), []));
assert(isequal(createCirculant([1 0 1]), [1 0 1; 1 1 0; 0 1 1]));

% Test generateQcMdpcCode

r = 313;
for n0 = 2:4
    w = n0 * 15;
    for i = 1:10
        [H, Q] = generateQcMdpcCode(r, w, n0);    
        G = [eye((n0-1)*r) Q];
        prod = mod(H * transpose(G), 2);
        assert(~any(prod, 'all'));
        assert(isequal(size(H), [r, n0*r]));
        assert(isequal(size(G), [(n0-1)*r, n0*r]));
        assert(length(find(H(randi([1 r]), :))) == w);
        assert(length(find(H(:, randi([1 2*r])))) == w / n0);
    end
end

% Test generateTbConvMdpcCode

r = 73;
for m = 2:5
    w = (m + 1) * 9;
    for L = 2:5
        [H, Q] = generateTbConvQcMdpcCode(r, m, L, w);    
        G = [eye(L*(m-1)*r) Q];
        prod = mod(G * transpose(H), 2);
        assert(~any(prod, 'all'));
        assert(isequal(size(H), [L * r, L * m * r]));
        assert(isequal(size(G), [L * (m - 1) * r, L * m * r]));
        assert(length(find(H(randi([1 L*r]), :))) == w);
    end
end

% Test indexNonZeroPos

H = [
    1 1 0 1 0 1
    0 1 1 1 1 0
    1 0 1 0 1 1
    ];

RExpected = [
    1 2 4 6
    2 3 4 5
    1 3 5 6
    ];

CExpected = [
    1 1 2 1 2 1
    3 2 3 2 3 3
    ];

[R, C] = indexNonZeroPos(H);
assert(isequal(RExpected, R));
assert(isequal(CExpected, C));

% Test RC2H

R = [
    1 2 4 6
    2 3 4 5
    1 3 5 6
    ];

C = [
    1 1 2 1 2 1
    3 2 3 2 3 3
    ];

HExpected = [
    1 1 0 1 0 1
    0 1 1 1 1 0
    1 0 1 0 1 1
    ];

H = RC2H(R, C);
assert(isequal(HExpected, H));

% Test writeMatToCsv

filename = 'writeMatToCsv_test.csv';
mat = [1, 2, 3; 1.234, 0, 54321; -2.3, 14, 1.234567];
writeMatToCsv(mat, filename);
matIn = readmatrix(filename);
assert(isequal(mat, matIn));
delete(filename);

% Testing finished
disp('Testing finished');