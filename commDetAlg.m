function [validDets,validDetsStartStop] = commDetAlg(rawData,detData,corrData,...
    refch,refCorrData,refDets,fs,thr,refVal,minLen)

%%%
if isempty(corrData) | isempty(refCorrData)
    valTyp = 1;
else
    valTyp = 2; % 1=time match based; 2=correlation based
    corrThr = 0.6;
end

minSepar = round(0.1*fs);
minLen = round(minLen*fs);
%%%

allDets = nan(size(rawData));
validDets = nan(size(rawData));
validDetsStartStop = [];

detData(detData < thr) = 0;
[~,aboveThr] = find(detData);
aboveThr = unique(aboveThr);
if isempty(aboveThr)
    return
end
steps = diff(aboveThr);
steps = [0,steps];
events = find(steps ~= 1);

eventsStartStop = nan(length(events),2);
eventsPeak = nan(length(events),1);
vEvents = false(length(events),1);

for j = 1:length(events)
    eventsStartStop(j,1) = aboveThr(events(j));
    if j == length(events)
        eventsStartStop(j,2) = aboveThr(end);
    else
        eventsStartStop(j,2) = aboveThr(events(j+1)-1);
    end

    if (eventsStartStop(j,2)-eventsStartStop(j,1)) > minLen
        vEvents(j) = true;
    end

    [~,maxIdx] = max(detData(eventsStartStop(j,1):eventsStartStop(j,2)));
    eventsPeak(j) = maxIdx + eventsStartStop(j,1) - 1;

    if refVal~=0
        winSize = 0.1*fs;

        if eventsPeak(j)-winSize < 1
            winInds = 1:eventsPeak(j)+winSize;
        elseif eventsPeak(j)+winSize > length(rawData)
            winInds = eventsPeak(j)-winSize:length(rawData);
        else
            winInds = eventsPeak(j)-winSize:eventsPeak(j)+winSize;
        end

        if valTyp == 1
            refWin = refDets(winInds);
            condit = ((refch~=0) & (isempty(find(refWin==0,1)))) | (refch==0);
        elseif valTyp == 2
            refWin = refCorrData(winInds);
            chanWin = corrData(winInds);

            r = corrcoef(refWin,chanWin);
            condit = ((refch~=0) & (abs(r(2))<corrThr)) | (refch==0);
        end

        if condit & vEvents(j)
            vEvents(j) = true;
        else
            vEvents(j) = false;
        end

    end
end

allDets(eventsPeak) = 0;
allDetsStartStop = eventsStartStop;
validDets(eventsPeak(vEvents)) = 0;
validDetsStartStop = eventsStartStop(vEvents,:);

tempValidDetSS = validDetsStartStop;
merged = false(1,length(validDetsStartStop));
if min(size(validDetsStartStop)) > 1
    for i = 1:(length(validDetsStartStop)-1)
        for j = i:(length(validDetsStartStop)-1)
            if (validDetsStartStop(j+1,1) - validDetsStartStop(j,2)) < minSepar
                tempValidDetSS(i,2) = validDetsStartStop(j+1,2);
                merged(j+1) = true;
            else
                break
            end
        end
    end
end

validDetsStartStop = tempValidDetSS(~merged,:);
temp = eventsPeak(vEvents);
validDets(temp(merged)) = nan;
