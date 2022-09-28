function [dets,detBorders] = commDetAlg(taxis,chan,inds2use,rawData,detData,corrData,...
        refch,refCorrData,refDets,fs,thr,refVal,eventMinLen,extThr,autoPilot)

% [dets,detBorders] = commDetAlg(taxis,chan,inds2use,rawData,detData,corrData,refch,refCorrData,refDets,fs,thr,refVal,minLen,extThr)

    corrThr = 0.5;

    if nargin < 14
        extThr = [];
    end

    
    aboveThrMinLen = round(0.01 * fs);
    eventMinLen = round(eventMinLen * fs);

    if size(rawData,1) > size(rawData,2)
        rawData = rawData';
    end
    if size(detData,1) > size(detData,2)
        detData = detData';
    end
    if size(corrData,1) > size(corrData,2)
        corrData = corrData';
    end

    %% Creating a container to store events which were discarded by the refchan validation mechanic
    if refVal ~= 0
        refValVictims = cell(size(rawData,1),1);
    end
    
    %%
    eventsStartStop = cell(size(rawData,1),1);
    eventsPeak = cell(size(rawData,1),1);
    peakValues = cell(size(rawData,1),1);
    vEvents = cell(size(rawData,1),1);
    
    %%
    for ch = 1:size(rawData,1)
        if any(chan(ch) == refch)
            continue
        end

        [eventsStartStop{ch}, evLens] = computeAboveThrLengths(detData(ch,:),thr(ch),'>',aboveThrMinLen);
%         eventsStartStop{ch}(evLens < aboveThrMinLen,:) = [];
%         evLens(evLens < aboveThrMinLen) = [];
        numEvs = length(evLens);
        
        if ~(ischar(inds2use) && strcmp(inds2use,'all'))
            if ~isempty(inds2use)
                evs2del = false(numEvs, 1);
                for ev = 1:numEvs
                    currEvInds = eventsStartStop{ch}(ev,1):eventsStartStop{ch}(ev,2);
                    intheClear = length(find(ismember(currEvInds, inds2use)));
                    if (intheClear / evLens(ev)) < 0.75
                        evs2del(ev) = true;
                    end
                end
                eventsStartStop{ch}(evs2del,:) = [];
                evLens(evs2del) = [];
                numEvs = length(evLens);
            else
                continue
            end
        end
        
        eventsPeak{ch} = nan(numEvs, 1);
        peakValues{ch} = nan(numEvs, 1);
        vEvents{ch} = true(numEvs, 1);
        for ev = 1:numEvs
            [peakValues{ch}(ev), maxIdx] = max(detData(ch,eventsStartStop{ch}(ev,1):eventsStartStop{ch}(ev,2)));
            eventsPeak{ch}(ev) = maxIdx + eventsStartStop{ch}(ev,1) - 1;
            
            if refVal ~= 0     
                % up for debate what window should be used here
                winInds = eventsStartStop{ch}(ev,1):eventsStartStop{ch}(ev,2);

                if refVal == 1
                    refWin = refDets(winInds);
                    condit = isempty(find(refWin == 0, 1));
                elseif refVal == 2
                    refWin = refCorrData(winInds);
                    chanWin = corrData(ch,winInds);
                    
                    r = corrcoef(refWin,chanWin);
                    condit = abs(r(2)) < corrThr;
                end
                
                if ~condit
                    vEvents{ch}(ev) = false;
                    refValVictims{ch} = [refValVictims{ch}; ev];
                end
            end
        end
        
    end
    
    %%
    if ~autoPilot && (refVal~=0) && (~isempty(vertcat(refValVictims{:})))
        quest = sprintf('Do you want to review the %d discarded events (from all channels)',...
            length(vertcat(refValVictims{:})));
        questTitle = 'Review of discarded events';
        answer = questdlg(quest,questTitle);
        if strcmp(answer,'Yes')
            reviewData = corrData;
            
%             events2Restore = reviewDiscardedEvents(taxis,fs,chan,reviewData,refCorrData,vEvents,eventsPeak,refValVictims);
            events2Restore = WIPreviewDiscardedEvents(taxis,fs,chan,reviewData,refCorrData,eventsPeak,refValVictims);
            for ch = 1:length(events2Restore)
                for j = 1:length(events2Restore{ch})
                    vEvents{ch}(refValVictims{ch}(events2Restore{ch}(j))) = true;
                end
            end
        end
    end
    
    %%
    for ch = 1:size(rawData,1)
        if any(chan(ch) == refch)
            continue
        end
        
        eventsStartStop{ch} = eventsStartStop{ch}(vEvents{ch},:);
        eventsPeak{ch} = eventsPeak{ch}(vEvents{ch});
        peakValues{ch} = peakValues{ch}(vEvents{ch});
    end
    
    %%
    if ~isempty(extThr)
        
        for ch = 1:size(rawData,1)
            if any(chan(ch) == refch)
                continue
            end
            
            detDataModQ = detData(ch,:);
            detDataModQ(detDataModQ < extThr(ch)) = 0;
            eventsStartStop{ch} = extendEvents(eventsStartStop{ch},detDataModQ,thr(ch),extThr(ch));
        end
        
    end
    
    %%
    minSepar = round(eventMinLen / 2);
    for ch = 1:size(rawData,1)
        if any(chan(ch) == refch)
            continue
        end
        
        [eventsPeak{ch},eventsStartStop{ch}] = mergeEvents(eventsPeak{ch},peakValues{ch},eventsStartStop{ch},minSepar);
    end
    
    %%
    for ch = 1:size(rawData, 1)
        tooShort = false(length(eventsPeak{ch}),1);
        for ev = 1:length(eventsPeak{ch})
            if (eventsStartStop{ch}(ev,2) - eventsStartStop{ch}(ev,1)) < eventMinLen
                tooShort(ev) = true;
            end
        end
        eventsPeak{ch}(tooShort) = [];
        eventsStartStop{ch}(tooShort,:) = [];
    end
    
    %%
    dets = eventsPeak;
    if any(ismember(chan, refch))
        dets{ismember(chan, refch)} = [];
    end
    detBorders = eventsStartStop;   

end

