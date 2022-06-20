function [mergedPeaks,mergedBorders] = mergeEvents(eventsPeak,peakValues,detBorders,minSepar)

mergedBorders = detBorders;
merged = false(1,size(detBorders,1));

if size(detBorders,1) > 1
    for i = 1:(size(detBorders,1)-1)
        for j = i:(size(detBorders,1)-1)
            if ((detBorders(j+1,1) - detBorders(j,2)) < minSepar) && ((peakValues(j+1)/peakValues(j) < 0.8) || (peakValues(j+1)/peakValues(j) > (1/0.8)))
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