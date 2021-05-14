classdef slidingWindowDecoder < handle
    % Object-oriented version of sliding window decoder
    % - optimized for decoding over the same code multiple times
    % - trades memory for execution speed
    
    properties (SetAccess = private)
        m
        L
        r
        windowBlockCount
        windows
        RWindows
        CWindows
    end
    
    methods
        function obj = slidingWindowDecoder(H, m, L)
            obj.m = m;
            obj.L = L;
            obj.r = size(H, 1) / L;
            if L == 1
                obj.windowBlockCount = m;
            else
                obj.windowBlockCount = m + 1;
            end
            obj.createWindows;
            obj.createHWindows(H);
        end
        
        function createWindows(obj)
            obj.windows = zeros(obj.L, (obj.windowBlockCount)*obj.r);
            windowBlocks = zeros(1, obj.windowBlockCount);
            for i = 1:obj.L
                windowMainStart = mod((i-1)*(obj.m-1), obj.L*(obj.m-1)) + 1;
                windowMainEnd = mod(windowMainStart + obj.windowBlockCount - 2, obj.L*(obj.m-1));

                if windowMainStart < windowMainEnd
                    windowBlocks(1:obj.windowBlockCount-1) = windowMainStart:windowMainEnd;
                else
                    windowBlocks(1:obj.windowBlockCount-1) = [1:windowMainEnd windowMainStart:obj.L*(obj.m-1)];
                end
                
                windowBlocks(obj.windowBlockCount) = obj.L * (obj.m - 1) + i;
                
                for j = 1:length(windowBlocks)
                    blockPos = windowBlocks(j);
                    obj.windows(i, 1+(j-1)*obj.r : j*obj.r) = 1 + (blockPos - 1) * obj.r : blockPos * obj.r;
                end 
            end
        end
        
        function createHWindows(obj, H)
            rowWeight = sum(H(1, :));
            columnWeight = sum(H(1 : obj.r, 1));
            obj.RWindows = zeros(obj.r, rowWeight, obj.L);
            obj.CWindows = zeros(columnWeight, obj.windowBlockCount*obj.r, obj.L);
            for i = 1:obj.L
                HWindow = H(1+(i-1)*obj.r : i*obj.r, obj.windows(i, :));
                [obj.RWindows(:, :, i), obj.CWindows(:, :, i)] = indexNonZeroPos(HWindow);
            end
        end
        
        function c = decode(obj, y)
            maxWindowIter = 300;
            c = y;
            for i = 1:obj.L + 1
                windowIndex = mod(i - 1, obj.L) + 1;
                window = obj.windows(windowIndex, :);
                yWindow = c(window);
                c(window) = decodeBitFlip(obj.RWindows(:, :, windowIndex), obj.CWindows(:, :, windowIndex), yWindow, maxWindowIter);
            end
        end
    end
end

