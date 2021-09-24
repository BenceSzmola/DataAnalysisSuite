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
            return
        end
        steps = diff(aboveThr);
        steps = [0,steps];
        events = find(steps ~= 1);

    %     if ~isempty(quietThr)
    %         detDataModQ = detData;
    %         detDataModQ(detDataModQ < quietThr) = 0;
    %     end

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
    
    if refVal~=0
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
    
    minSepar = round(0.03*fs);
    for i = 1:size(rawData,1)
        if i == refch
            continue
        end
        
        [eventsPeak{i},eventsStartStop{i}] = mergeEvents(eventsPeak{i},eventsStartStop{i},minSepar);
    end
    
    dets = nan(size(rawData));
    for i = 1:size(rawData,1)
        if i == refch
            continue
        end
        
        dets(i,eventsPeak{i}) = 0;
    end
    detBorders = eventsStartStop;
    
%     allDets(eventsPeak) = 0;
%     allDetsStartStop = eventsStartStop;
%     validDets(eventsPeak(vEvents)) = 0;
%     validDetsStartStop = eventsStartStop(vEvents,:);

%     tempValidDetSS = validDetsStartStop;
%     merged = false(1,size(validDetsStartStop,1));
%     if size(validDetsStartStop,1) > 1
%         for i = 1:(size(validDetsStartStop,1)-1)
%             for j = i:(size(validDetsStartStop,1)-1)
%                 if (validDetsStartStop(j+1,1) - validDetsStartStop(j,2)) < minSepar
%                     tempValidDetSS(i,2) = validDetsStartStop(j+1,2);
%                     merged(j+1) = true;
%                 else
%                     break
%                 end
%             end
%         end
%     end

%     validDetsStartStop = tempValidDetSS(~merged,:);
%     temp = eventsPeak(vEvents);
%     validDets(temp(merged)) = nan;

%     if ~isempty(quietThr)
%         extEventsStartStop = validDetsStartStop;
%         for j = 1:size(validDetsStartStop,1)
%             if j == 1
%                 extEventsStartStop(j,1) = extBorders(1:validDetsStartStop(j,1),j,1);
%             else
%                 extEventsStartStop(j,1) = extBorders(validDetsStartStop(j-1,2):validDetsStartStop(j,1),j,1);
%             end
%             if j == size(validDetsStartStop,1)
%                 extEventsStartStop(j,2) = extBorders(validDetsStartStop(j,2):length(detDataModQ),j,2);
%             else
%                 extEventsStartStop(j,2) = extBorders(validDetsStartStop(j,2):validDetsStartStop(j+1,1),j,2);
%             end
%         end
%         validDetsStartStop = extEventsStartStop;
%     end
%     
%     function ind = extBorders(interV,j,startOrStop)
%         if startOrStop == 1
%             if quietThr > thr
%                 ind = find(detDataModQ(validDetsStartStop(j,1):validDetsStartStop(j,2)),1,'first');
%             else
%                 ind = find(~detDataModQ(interV),1,'last');
%             end
%         elseif startOrStop == 2
%             if quietThr > thr
%                 ind = find(detDataModQ(validDetsStartStop(j,1):validDetsStartStop(j,2)),1,'last');
%             else
%                 ind = find(~detDataModQ(interV),1,'first');
%             end
%         end
%                 
%         if isempty(ind)
%             if startOrStop == 1
%                 ind = validDetsStartStop(j,1);
%             elseif startOrStop == 2
%                 ind = validDetsStartStop(j,2);
%             end
%         else
%             if quietThr > thr
%                 ind = validDetsStartStop(j,1)+ind;
%             else
%                 ind = interV(1)+ind;
%             end
%         end
%         
%     end    
    

end

