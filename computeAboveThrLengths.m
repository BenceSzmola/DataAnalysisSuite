function [intervals, lens] = computeAboveThrLengths(data,thr)

aboveThrInds = find(data > thr);
if isempty(aboveThrInds) || isempty(aboveThrInds)
    intervals = [];
    lens = [];

    return
end
indDiffs = diff(aboveThrInds);
startInds = find([0,indDiffs] ~= 1);
endInds = find([indDiffs, length(aboveThrInds)] ~= 1);
lens = 1 + (endInds-startInds);

intervals(:,1) = aboveThrInds(startInds);
intervals(:,2) = aboveThrInds(endInds);