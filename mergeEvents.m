function [mergedPeaks,mergedBorders] = mergeEvents(eventsPeak,detBorders,minSepar)

mergedBorders = detBorders;
merged = false(1,size(detBorders,1));

if size(detBorders,1) > 1
    for i = 1:(size(detBorders,1)-1)
        for j = i:(size(detBorders,1)-1)
            if (detBorders(j+1,1) - detBorders(j,2)) < minSepar
                mergedBorders(i,2) = detBorders(j+1,2);
                merged(j+1) = true;
            else
                break
            end
        end
    end
end

mergedBorders = mergedBorders(~merged,:);
mergedPeaks = eventsPeak(~merged);