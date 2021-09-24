function [validDets,validDetsStartStop] = commDetAlg(rawData,detData,corrData,...
        refch,refCorrData,refDets,fs,thr,refVal,minLen,quietThr)

    %%%
    if isempty(corrData) | isempty(refCorrData)
        valTyp = 1;
    else
        valTyp = 2; % 1=time match based; 2=correlation based
        corrThr = 0.6;
    end

    if nargin < 11
        quietThr = [];
    end
    
    % Creating a container to store events which were discarded by the
    % refchan validation mechanic
    if refVal ~= 0
        refValVictims = [];
    end

    minSepar = round(0.03*fs);
    minLen = round(minLen*fs);
    %%%

    allDets = nan(size(rawData));
    validDets = nan(size(rawData));
    validDetsStartStop = [];

    detDataMod = detData;
    detDataMod(detDataMod < thr) = 0;
    [~,aboveThr] = find(detDataMod);
    aboveThr = unique(aboveThr);
    if isempty(aboveThr)
        return
    end
    steps = diff(aboveThr);
    steps = [0,steps];
    events = find(steps ~= 1);

    if ~isempty(quietThr)
        detDataModQ = detData;
        detDataModQ(detDataModQ < quietThr) = 0;
    end

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
            elseif ~condit & vEvents(j)
                vEvents(j) = false;
                refValVictims = [refValVictims, j];
            end

        end
    end
    
    allDets(eventsPeak) = 0;
    allDetsStartStop = eventsStartStop;
    validDets(eventsPeak(vEvents)) = 0;
    validDetsStartStop = eventsStartStop(vEvents,:);

    tempValidDetSS = validDetsStartStop;
    merged = false(1,size(validDetsStartStop,1));
    if size(validDetsStartStop,1) > 1
        for i = 1:(size(validDetsStartStop,1)-1)
            for j = i:(size(validDetsStartStop,1)-1)
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

    if ~isempty(quietThr)
        extEventsStartStop = validDetsStartStop;
        for j = 1:size(validDetsStartStop,1)
            if j == 1
                extEventsStartStop(j,1) = extBorders(1:validDetsStartStop(j,1),j,1);
            else
                extEventsStartStop(j,1) = extBorders(validDetsStartStop(j-1,2):validDetsStartStop(j,1),j,1);
            end
            if j == size(validDetsStartStop,1)
                extEventsStartStop(j,2) = extBorders(validDetsStartStop(j,2):length(detDataModQ),j,2);
            else
                extEventsStartStop(j,2) = extBorders(validDetsStartStop(j,2):validDetsStartStop(j+1,1),j,2);
            end
        end
        validDetsStartStop = extEventsStartStop;
    end
    
    function ind = extBorders(interV,j,startOrStop)
        if startOrStop == 1
            if quietThr > thr
                ind = find(detDataModQ(validDetsStartStop(j,1):validDetsStartStop(j,2)),1,'first');
            else
                ind = find(~detDataModQ(interV),1,'last');
            end
        elseif startOrStop == 2
            if quietThr > thr
                ind = find(detDataModQ(validDetsStartStop(j,1):validDetsStartStop(j,2)),1,'last');
            else
                ind = find(~detDataModQ(interV),1,'first');
            end
        end
                
        if isempty(ind)
            if startOrStop == 1
                ind = validDetsStartStop(j,1);
            elseif startOrStop == 2
                ind = validDetsStartStop(j,2);
            end
        else
            if quietThr > thr
                ind = validDetsStartStop(j,1)+ind;
            else
                ind = interV(1)+ind;
            end
        end
        
    end    
    

end

