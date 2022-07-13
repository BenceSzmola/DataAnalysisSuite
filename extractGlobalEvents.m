function [globalEvents] = extractGlobalEvents(dets,tol,runOnSaves)
% [globalEvents] = extractGlobalEvents(dets,tol,fromSaves)

if (nargin >= 3) && runOnSaves
    [saveFnames, path] = uigetfile('DASsave*.mat', 'MultiSelect', 'on');
    if ~iscell(saveFnames)
        saveFnames = {saveFnames};
    end
    
    numSaves = length(saveFnames);
    
    for saveNum = 1:numSaves
        load([path,saveFnames{saveNum}], 'ephysSaveData', 'imagingSaveData')

        if ~isempty(ephysSaveData)
            if ~isempty(ephysSaveData.Dets)
                globalEvents = extraction(ephysSaveData.Dets, round(0.05*ephysSaveData.Fs));
                ephysSaveData.GlobalDets = globalEvents;
                save([path,saveFnames{saveNum}], '-append', 'ephysSaveData')
            end
        end
        
        if ~isempty(imagingSaveData)
            if ~isempty(imagingSaveData.Dets)
                globalEvents = extraction(imagingSaveData.Dets, round(0.05*imagingSaveData.Fs));
                imagingSaveData.GlobalDets = globalEvents;
                save([path,saveFnames{saveNum}], '-append', 'imagingSaveData')
            end
        end

    end
else
    globalEvents = extraction(dets,tol);
end


    function globalEvents = extraction(dets,tol)
        numChans = length(dets);

        % check which detection indexes are within tolerance to one another
        [c, ~, ic] = uniquetol(vertcat(dets{:}), tol, 'DataScale', 1);
        % tag the indices which only occur once (we are interested in events that appear on at least 2 channels)
        icUniq = unique(ic);
        tooUniq = false(length(icUniq), 1);
        for i = 1:length(icUniq)
            if length(find(ic == icUniq(i))) < 2
                tooUniq(i) = true;
            end
        end

        % group the indices according to channels
        numDets = cellfun(@length, dets);
        icByChan = mat2cell(ic, numDets);

        % create the output matrix (rows are the global events, columns represent the channels, values show which
        % detection on the given channel)
        globalEvents = nan(length(c), numChans);
        for ch = 1:numChans
            currIc = icByChan{ch};
            for i = 1:length(currIc)
                if tooUniq(currIc(i))
                    continue
                end
                globalEvents(currIc(i),ch) = i;
            end
        end
        globalEvents = globalEvents(any(globalEvents, 2),:);
    end

if nargout == 0
    clear globalEvents
end

end