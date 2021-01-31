function [quotient, remainder] = binPolyDiv(dividend, divisor)
% Divides binary polynomials
% Uses polynomial long division

if ~any(divisor, 2)
    %throw(MException('binPolyDiv:divByZero', 'Division by zero polynomial'))
    fprintf('WARNING: Division by zero polynomial\n');
end
coder.varsize('remainder', [1 inf], [false true]);

divisorHigh = find(divisor, 1, 'last');
remainder = dividend;
remainderHigh = find(remainder, 1, 'last');
if isempty(divisorHigh) || isempty(remainderHigh) || divisorHigh(1) > remainderHigh(1)
    quotient = 0;
    return;
end
quotient = zeros(1, remainderHigh(1) - divisorHigh(1) + 1);
divisorPos = find(divisor);
while ~isempty(remainderHigh) && remainderHigh(1) >= divisorHigh(1)
    highDiff = remainderHigh(1) - divisorHigh(1);
    quotient(highDiff + 1) = 1;
    remainderFlipPos = divisorPos + highDiff;
    remainder(remainderFlipPos) = mod(remainder(remainderFlipPos) + 1, 2);
    remainderHigh = find(remainder, 1, 'last');
end
remainder = remainder(1:divisorHigh(1) - 1);
end

