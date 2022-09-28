function [intervals, lens] = computeAboveThrLengths(data,thr,thrMode,minLen,maxLen)
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

if (nargin < 3) || isempty(thrMode)
    thrMode = '>';
end

switch thrMode
    case '>'
        selectedInds = find(data > thr);
    case '<'
        selectedInds = find(data < thr);
    case '=='
        selectedInds = find(data == thr);
end

if isempty(selectedInds)
    intervals = [];
    lens = [];

    return
end
indDiffs = diff(selectedInds);
startInds = find([0,indDiffs] ~= 1);
endInds = find([indDiffs, length(selectedInds)] ~= 1);
lens = 1 + (endInds-startInds);

intervals(:,1) = selectedInds(startInds);
intervals(:,2) = selectedInds(endInds);

if (nargin >= 4) && ~isempty(minLen) && ~isnan(minLen)
    intervals(lens < minLen,:) = [];
    lens(lens < minLen) = [];
end

if (nargin >= 5) && ~isempty(maxLen) && ~isnan(maxLen)
    intervals(lens > maxLen,:) = [];
    lens(lens > maxLen) = [];
end
