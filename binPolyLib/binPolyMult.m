function [product] = binPolyMult(x, y)
% Multiplies two polys x and y

% product = zeros(1, length(x) + length(y) - 1);
% yPos = find(y);
% for i = 1:length(x)
%     if x(i)
%         addPos = yPos + i - 1;
%         product(addPos) = product(addPos) + 1;
%     end
% end
% product = mod(product, 2);
product = mod(conv(x, y), 2);
end

