function [gcd, coefA, coefB] = binPolyGCD(a, b)
% Calculates GCD poly of polys a and b
% uses extended Euclid's algorithm
% gcd - GCD poly
% coefA - poly Bezout coefficient of a
% coefB - poly Bezout coefficient of b
% coefA * a + coefB * b = gcd
r1 = a;
r2 = b;
s1 = 1;
s2 = 0;
t1 = 0;
t2 = 1;
while any(r2)
    [q, r3] = binPolyDiv(r1, r2);
    s3 = mod(binPolyAdd(binPolyMult(q, s2), s1), 2);
    t3 = mod(binPolyAdd(binPolyMult(q, t2), t1), 2);
    % shift values
    r1 = r2;
    r2 = r3;
    s1 = s2;
    s2 = s3;
    t1 = t2;
    t2 = t3;
end
gcd = r1;
coefA = s1;
coefB = t1;
end

