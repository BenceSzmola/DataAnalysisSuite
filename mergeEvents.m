function [mergedPeaks,mergedBorders] = mergeEvents(eventsPeak,peakValues,detBorders,minSepar)

mergedBorders = detBorders;
merged = false(1,size(detBorders,1));

if size(detBorders,1) > 1
%     for i = 1:(size(detBorders,1)-1)
%         for j = i:(size(detBorders,1)-1)
%             if ((detBorders(j+1,1) - detBorders(j,2)) < minSepar) %&& ((peakValues(j+1)/peakValues(j) < 0.8) || (peakValues(j+1)/peakValues(j) > (1/0.8)))
%                 mergedBorders(i,2) = detBorders(j+1,2);
%                 merged(j+1) = true;
%                 
%                 if peakValues(j+1) > peakValues(j)
%                     eventsPeak(j) = eventsPeak(j+1);
%                 end
%             else
%                 break
%             end
%         end
%     end

    detNum = 1;
    while detNum < size(detBorders, 1)
        detNumInside = detNum;
        while (detNumInside < size(detBorders, 1)) && (detBorders(detNumInside + 1,1) - detBorders(detNumInside,2)) < minSepar
            mergedBorders(detNum,2) = detBorders(detNumInside + 1,2);
            merged(detNumInside + 1) = true;
            
            if peakValues(detNumInside + 1) > peakValues(detNumInside)
                peakValues(detNumInside) = peakValues(detNumInside + 1);
                eventsPeak(detNum) = eventsPeak(detNumInside + 1);
            end
            
            detNumInside = detNumInside + 1;
        end
        if detNumInside > detNum
            detNum = detNumInside;
        else
            detNum = detNum + 1;
        end
    end
    
end

mergedBorders = mergedBorders(~merged,:);
mergedPeaks = eventsPeak(~merged);