classdef bitFlipDecoder < handle
    % Object-oriented version of basic bit-flip decoder
    
    properties (Access = private)
        R
        C
        syndrome
        upcCounts
        c
    end
    
    methods (Static)
        function threshold = computeThreshold(maxUpcCount)
            % Selects UPC count threshold for flipping
            threshold = maxUpcCount; % simple rule for now
        end         
    end
    
    methods
        function obj = bitFlipDecoder(R, C)
            obj.R = R;
            obj.C = C;
        end
        
        function codeword = decode(obj, y, maxIter)
            obj.c = y; 
            obj.syndrome = mod(sum(obj.c(obj.R), 2), 2);
            obj.upcCounts = sum(obj.syndrome(obj.C));
            for iter = 1:maxIter
                if ~any(obj.syndrome)
                    break
                end

                threshold = bitFlipDecoder.computeThreshold(max(obj.upcCounts));
                flipIndices = find(obj.upcCounts >= threshold);
                obj.flipBits(flipIndices);
            end
            codeword = obj.c;
        end
        
        function flipBits(obj, flipIndices)
            % updates c, syndrome and upcCounts accodring to the flipPos
            obj.c(flipIndices) = 1 - obj.c(flipIndices);
            for i = 1:length(flipIndices) % for cFlipIdx = flipPos
                cFlipIdx = flipIndices(i);
                obj.syndrome(obj.C(:, cFlipIdx)) = 1 - obj.syndrome(obj.C(:, cFlipIdx));
                for j = 1:length(obj.C(:, cFlipIdx)) % for syndromeFlipIdx = transpose(obj.C(:, cFlipIdx))
                    syndromeFlipIdx = obj.C(j, cFlipIdx);
                    if obj.syndrome(syndromeFlipIdx) == 0
                        % parity check now satisified
                        change = -1;
                    else % obj.syndrome(syndromeFlipIdx) == 1
                        % new unsatisfied parity check
                        change = +1;
                    end
                    obj.upcCounts(obj.R(syndromeFlipIdx, :)) = obj.upcCounts(obj.R(syndromeFlipIdx, :)) + change;
                end
            end
        end
        
    end
end

