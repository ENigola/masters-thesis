function threshold = selectThreshold(S, t, w, d, n, r)
% TODO, work in progress
% Current version taken from BIKE specification
% S - current syndrome weight
% t - estimate of current number of remaining errors
% w - H row weight
% d - H column weight
% n - H width (code length)
% r - H height (syndrome length)

X = calcX(t, w, n, r);
piZero = calcPiZero(S, X, t, d, w, n);
piOne = calcPiOne(S, X, t, d);
threshold = calcT(piZero, piOne, n, t, d);
end

% function t = estimateT(tOriginal, S, w, n, r)
%     possibleTs = 1:tOriginal;
%     sEstimates = zeros(1, length(possibleTs));
%     for i = 1:length(possibleTs)
%         possibleT = possibleTs(i);
%         for l = 1:2:min(possibleT, w)
%             sEstimates(i) = sEstimates(i) + calcRho(w, l, n, possibleT);
%         end
%     end
%     sEstimates = r * sEstimates;
%     diffs = abs(sEstimates - S);
%     [~, closestIdx] = min(diffs);
%     t = possibleTs(closestIdx);
% end

function X = calcX(t, w, n, r)
    X = 0;
    for l = 1:2:min(t, w)
       X = X + (l - 1) * r * calcRho(w, l, n, t);
    end
%     sumOne = 0;
%     sumTwo = 0;
%     for l = 1:2:min(t, w)
%         rho = calcRho(w, l, n, t);
%         sumOne = sumOne + (l - 1) * rho;
%         sumTwo = sumTwo + rho;
%     end
%     X = S * sumOne / sumTwo;
end

function rho = calcRho(w, l, n, t)
    warning('off','MATLAB:nchoosek:LargeCoefficient');
    rho = nchoosek(w, l) * (nchoosek(n - w, t - l) / nchoosek(n, t));
    warning('on');
end

function piZero = calcPiZero(S, X, t, d, w, n)
    piZero = ((w * S) - X) / ((n - t) * d);
    % piZero = ((w - 1) * S - X) / ((n - t) * d);
end

function piOne = calcPiOne(S, X, t, d)
    piOne = (S + X) / (t * d);
end

function T = calcT(piZero, piOne, n, t, d)
    if piOne > 1
        T = calcT_alt(piZero, piOne, n, t, d);
        return;
    end
    x1 = log((n - t) / t);
    x2 = d * log((1 - piZero) / (1 - piOne));
    x3 = log(piOne / piZero);
    x4 = log((1 - piZero) / (1 - piOne));
    x5 = (x1 + x2) / (x3 + x4);
    T = ceil(x5);
end

function T = calcT_alt(piZero, piOne, n, t, d)
    for T = 1:d
        zeroSide = (n - t) * nchoosek(d, T) * (piZero ^ T) * ((1 - piZero) ^ (d - T));
        if piOne < 1
            oneSide = t * nchoosek(d, T) * (piOne ^ T) * ((1 - piOne) ^ (d - T));
        else
            oneSide = 1;
        end
        if zeroSide <= oneSide
            break;
        end
    end
end


