function [quotient, remainder] = binPolyDiv(dividend, divisor)
% Divides binary polynomials
% Uses polynomial long division

if ~any(divisor)
    %throw(MException('binPolyDiv:divByZero', 'Division by zero polynomial'))
    fprintf('WARNING: Division by zero polynomial\n');
end

divisorHigh = find(divisor, 1, 'last');
remainder = dividend;
remainderHigh = find(remainder, 1, 'last');
if isempty(divisorHigh) || isempty(remainderHigh) || divisorHigh > remainderHigh
    quotient = 0;
    return;
end
quotient = zeros(1, remainderHigh - divisorHigh + 1);
divisorPos = find(divisor);
while ~isempty(remainderHigh) && remainderHigh >= divisorHigh
    highDiff = remainderHigh - divisorHigh;
    quotient(highDiff + 1) = 1;
    remainderFlipPos = divisorPos + highDiff;
    remainder(remainderFlipPos) = mod(remainder(remainderFlipPos) + 1, 2);
    remainderHigh = find(remainder, 1, 'last');
end
remainder = remainder(1:divisorHigh - 1);
end

