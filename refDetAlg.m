function [refDets,refDetMarks,aboveRefThr,belowRefThr] = refDetAlg(refDetData,refShowData,refThr,fs)

refDets = nan(1,length(refDetData));
refDetMarks = refDets;
refDetIVs = refDets;

% refThr = mean(refDetData) + 3*std(refDetData);
refDets(refDetData>refThr) = 0;

% join close-by events together
refdetsInds = find(refDets==0);
for i = 1:length(refdetsInds)
    if i ~= length(refdetsInds)
        if (refdetsInds(i+1) - refdetsInds(i)) < 0.2*fs
            refDets(refdetsInds(i):refdetsInds(i+1)) = 0;
        end
    end
end

% reduce number of refdets by only keeping 1st and last index of an
% event
abThr = find(~isnan(refDets));
if ~isempty(refShowData)
    aboveRefThr = nan(1,length(refShowData));
    belowRefThr = refShowData;
else
    aboveRefThr = nan(1,length(refDetData));
    belowRefThr = refDetData;
end

if ~isempty(abThr)
    steps = diff(abThr);
    eventsS = [1,find(steps~=1)+1];
    eventsE = [find(steps~=1), length(steps)];
    refDetMarks(abThr(eventsS)) = 0;
    refDetMarks(abThr(eventsE)) = 0;
    for i = 1:length(eventsS)
        refDetIVs(abThr(eventsS(i)):abThr(eventsE(i))) = 0;
    end
    refDetIVs = find(~isnan(refDetIVs));
    
    if ~isempty(refShowData)
        aboveRefThr(refDetIVs) = refShowData(refDetIVs);
        belowRefThr(refDetIVs) = nan;
    else
        aboveRefThr(refDetIVs) = refDetData(refDetIVs);
        belowRefThr(refDetIVs) = nan;
    end
    
end