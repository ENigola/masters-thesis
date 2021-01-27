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

try
    binPolyDiv([0 1 1], [0 0]);
    throw(MException('automatedTest:TestDivByZero', 'Division by zero did not fail'));
catch ME
    if ~strcmp(ME.identifier, 'binPolyDiv:divByZero')
        rethrow(ME);
    end
end

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

% Test generateRandomCode

r = 1001;
w = 25;
for i = 1:10
    [H, G] = generateRandomCode(r, w);    
    prod = H * transpose(G);
    prod = mod(prod, 2);
    assert(~any(prod, 'all'));
    assert(isequal(size(H), [r 2*r]));
    assert(isequal(size(G), [r 2*r]));
    assert(length(find(H(randi([1 r]), :))), 2 * w);
    assert(length(find(H(:, randi([1 2*r])))), w);
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

% Testing finished
disp('Testing finished');