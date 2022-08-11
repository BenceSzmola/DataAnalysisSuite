function [intervals, lens] = computeAboveThrLengths(data,thr,minLen,maxLen)
% [intervals, lens] = computeAboveThrLengths(data,thr,minLen,maxLen)
% This function expects one channel at a time.
% Threshold input (thr) can either be a single value or a list of values with length equal to data input.

if all(size(data) > 1)
    eD = errordlg('This function takes one channel at a time!');
    pause(1)
    if ishandle(eD)
        close(eD)
    end
    intervals = [];
    lens = [];
    return
end

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

if (nargin >= 3) && ~isempty(minLen) && ~isnan(minLen)
    intervals(lens < minLen,:) = [];
    lens(lens < minLen) = [];
end

if (nargin >= 4) && ~isempty(maxLen) && ~isnan(maxLen)
    intervals(lens > maxLen,:) = [];
    lens(lens > maxLen) = [];
end
