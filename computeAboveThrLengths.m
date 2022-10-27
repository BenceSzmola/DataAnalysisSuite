function [intervals, lens] = computeAboveThrLengths(data,thr,thrMode,minLen,maxLen,multFeatMode)
% [intervals, lens] = computeAboveThrLengths(data,thr,thrMode,minLen,maxLen,multFeatMode)
% This function expects one channel at a time.
% But it can take various features from one channel, then it will check
%   when both features satisfy their respective thresholds.
% Threshold input (thr) can either be a single value or a list of values with length equal to data input.

if size(data,1) > size(data,2)
    data = data';
end

if all(ismember(size(data),size(thr)))
    if size(thr,1) > size(thr,2)
        thr = thr';
    end
elseif size(data,1) ~= size(thr,1)
    thr = thr';
elseif ~ismember(size(data,1),size(thr))
    errordlg('Threshold input should be of compatible size with data input!')
    intervals = [];
    lens = [];
    return
end

if (nargin < 3) || isempty(thrMode)
    thrMode = ">";
elseif ~isstring(thrMode)
    thrMode = string(thrMode);
end

if size(data,1) ~= length(thrMode)
    thrMode = repmat(thrMode(1),1,size(data,1));
end

if (nargin < 6 ) || isempty(multFeatMode)
    multFeatMode = "&";
end

% selectedInds = true(1,size(data,2));
for i = 1:size(data,1)
    switch thrMode(i)
        case ">"
            selectedInds_temp = data(i,:) > thr(i,:);
        case "<"
            selectedInds_temp = data(i,:) < thr(i,:);
        case "=="
            selectedInds_temp = data(i,:) == thr(i,:);
    end

    if i == 1
        selectedInds = selectedInds_temp;
    else

        switch multFeatMode
            case "&"
                selectedInds = selectedInds & selectedInds_temp;
            case "|"
                selectedInds = selectedInds | selectedInds_temp;
            case "xor"
                selectedInds = xor(selectedInds,selectedInds_temp);
            case "only1st"
                selectedInds = selectedInds & ~selectedInds_temp;
        end

    end
end
selectedInds = find(selectedInds);

if isempty(selectedInds)
    intervals = [];
    lens = [];

    return
end
indDiffs = diff(selectedInds);
startInds = find([0,indDiffs] ~= 1);
endInds = find([indDiffs, length(selectedInds)] ~= 1);
lens = (endInds - startInds) + 1;

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
