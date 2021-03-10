function H = RC2H(R, C)
% Converts R, C representation to full H
% R, C - non-zero pos of H by row, column
% H - full parity-check matrix

r = size(R, 1);
n = size(C, 2);
H = zeros(r, n);
for i = 1:n
    H(C(:, i), i) = 1;
end
end

