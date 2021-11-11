function [dets,detBorders] = commDetAlg(taxis,rawData,detData,corrData,...
        refch,refCorrData,refDets,fs,thr,refVal,minLen,extThr)

    %%%
    if isempty(corrData) | isempty(refCorrData)
        valTyp = 1;
    else
        valTyp = 2; % 1=time match based; 2=correlation based
        corrThr = 0.6;
    end

    if nargin < 12
        extThr = [];
    end
    
%     minSepar = round(0.03*fs);
    minLen = round(minLen*fs);
    %%%

%     allDets = nan(size(rawData));
%     validDets = nan(size(rawData));
%     validDetsStartStop = [];

    if size(rawData,1) > size(rawData,2)
        rawData = rawData';
    end
    if size(detData,1) > size(detData,2)
        detData = detData';
    end
    if size(corrData,1) > size(corrData,2)
        corrData = corrData';
    end

    % Creating a container to store events which were discarded by the
    % refchan validation mechanic
    if refVal ~= 0
        refValVictims = cell(size(rawData,1));
    end
    
    eventsStartStop = cell(size(rawData,1),1);
    eventsPeak = cell(size(rawData,1),1);
    vEvents = cell(size(rawData,1),1);
    
    for i = 1:min(size(rawData))
        if i == refch
            continue
        end
        
        detDataMod = detData(i,:);
        detDataMod(detDataMod < thr(i)) = 0;
        [~,aboveThr] = find(detDataMod);
        aboveThr = unique(aboveThr);
        if isempty(aboveThr)
            continue
        end
        steps = diff(aboveThr);
        steps = [0,steps];
        events = find(steps ~= 1);

        eventsStartStop{i} = nan(length(events),2);
        eventsPeak{i} = nan(length(events),1);
        vEvents{i} = false(length(events),1);
        aboveMinLen = false(length(events),1);
        
        for j = 1:length(events)
            eventsStartStop{i}(j,1) = aboveThr(events(j));
            if j == length(events)
                eventsStartStop{i}(j,2) = aboveThr(end);
            else
                eventsStartStop{i}(j,2) = aboveThr(events(j+1)-1);
            end

            if (eventsStartStop{i}(j,2)-eventsStartStop{i}(j,1)) > minLen
                aboveMinLen(j) = true;
            end

            [~,maxIdx] = max(detData(i,eventsStartStop{i}(j,1):eventsStartStop{i}(j,2)));
            eventsPeak{i}(j) = maxIdx + eventsStartStop{i}(j,1) - 1;
            
            if refVal~=0
                winSize = 0.1*fs;

                if eventsPeak{i}(j)-winSize < 1
                    winInds = 1:eventsPeak{i}(j)+winSize;
                elseif eventsPeak{i}(j)+winSize > length(rawData)
                    winInds = eventsPeak{i}(j)-winSize:length(rawData);
                else
                    winInds = eventsPeak{i}(j)-winSize:eventsPeak{i}(j)+winSize;
                end

                if valTyp == 1
                    refWin = refDets(winInds);
                    condit = ((refch~=0) & (isempty(find(refWin==0,1)))) | (refch==0);
                elseif valTyp == 2
                    refWin = refCorrData(winInds);
                    chanWin = corrData(i,winInds);

                    r = corrcoef(refWin,chanWin);
                    condit = ((refch~=0) & (abs(r(2))<corrThr)) | (refch==0);
                end

                if condit & aboveMinLen(j)
                    vEvents{i}(j) = true;
                elseif ~condit & aboveMinLen(j)
                    vEvents{i}(j) = false;
                    refValVictims{i} = [refValVictims{i}, j];
                end
            else
                vEvents{i} = aboveMinLen;
            end
        end
        
    end
    
%     assignin('base','evSS1',eventsStartStop)
%     assignin('base','evP1',eventsPeak)
    
    if (refVal~=0) && (~isempty([refValVictims{:}]))
        quest = sprintf('Do you want to review the %d discarded events (from all channels)',...
            length([refValVictims{:}]));
        title = 'Review of discarded events';
        answer = questdlg(quest,title);
        if strcmp(answer,'Yes')
            if valTyp == 1
                reviewData = detData;
            elseif valTyp == 2
                reviewData = corrData;
            end
            events2Restore = reviewDiscardedEvents(taxis,fs,reviewData,refCorrData,vEvents,eventsPeak,refValVictims);
%             assignin('base','vEventsBefore',vEvents)
            for i = 1:length(events2Restore)
                for j = 1:length(events2Restore{i})
                    vEvents{i}(refValVictims{i}(events2Restore{i}(j))) = true;
                end
            end
%             assignin('base','vEventsAfter',vEvents)
        end
    end
    
    for i = 1:size(rawData,1)
        if i == refch
            continue
        end
        
        eventsStartStop{i} = eventsStartStop{i}(vEvents{i},:);
        eventsPeak{i} = eventsPeak{i}(vEvents{i});
    end
        
%     assignin('base','evSS2',eventsStartStop)
%     assignin('base','evP2',eventsPeak)
    
    if ~isempty(extThr)
        
        for i = 1:size(rawData,1)
            if i == refch
                continue
            end
            
            detDataModQ = detData(i,:);
            detDataModQ(detDataModQ < extThr(i)) = 0;
            eventsStartStop{i} = extendEvents(eventsStartStop{i},detDataModQ,thr(i),extThr(i));
        end
        
    end
    
%     assignin('base','evSS3',eventsStartStop)
%     assignin('base','evP3',eventsPeak)
%     
    minSepar = round(0.03*fs);
    for i = 1:size(rawData,1)
        if i == refch
            continue
        end
        
        [eventsPeak{i},eventsStartStop{i}] = mergeEvents(eventsPeak{i},eventsStartStop{i},minSepar);
    end
    
%     assignin('base','evSS4',eventsStartStop)
%     assignin('base','evP4',eventsPeak)
    
    dets = nan(size(rawData));
    for i = 1:size(rawData,1)
        if i == refch
            continue
        end
        
        dets(i,eventsPeak{i}) = 0;
    end
    detBorders = eventsStartStop;   

end

