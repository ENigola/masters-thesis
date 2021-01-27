function [R, C] = indexNonZeroPos(H)
% Indexes non-zero positions of matrix (creates Tanner graph representation)
% Assumes matrix has constant row and column weight
% H - matrix to collect information from
% R - indexes by row (R-height = H-height, each row is a check node)
% C - indexes by column (C-width = H-width, each column is a variable node)

R = zeros(size(H, 1), sum(H(1, :)));
C = zeros(sum(H(:, 1)), size(H, 2));
% TODO: remove duplicate information finding
for i = 1:size(H, 1) % iterate rows
    R(i, :) = find(H(i, :));
end
for i = 1:size(H, 2) % iterate columns
    C(:, i) = find(H(:, i));
end
end

