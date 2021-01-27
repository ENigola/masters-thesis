function [circulant] = createCirculant(topRow)
% Creates a circulant matrix from the given top row
len = length(topRow);
circulant = zeros(len);
for i = 1:len
    circulant(i, i:len) = topRow(1 : len - i + 1);
    circulant(i, 1:i-1) = topRow(len - i + 2: len);
end

