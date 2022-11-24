function [detPeaks,detBorders,detParams,evComplexes,s] = gmmAutoCorrDet(getSettMode,data,fs,tAxis,chans,refch,refData,refVal,showFigs,autoPilot)

switch getSettMode
    case 'gui'
        inpGUI = detAlgSettingGUI('gmmAutoCorrDet',fs);
        waitfor(inpGUI.mainFig)
    
    case 'def'
        inpGUI = detAlgSettingGUI('gmmAutoCorrDet',fs,'def');

    case 'prev'
        inpGUI = detAlgSettingGUI('gmmAutoCorrDet',fs,'prev');

end
s = inpGUI.convSett;
clear inpGUI
s.compNumSelMode  = s.compNumSelMode.list{s.compNumSelMode.sel};
s.envThrCrossMode = s.envThrCrossMode.list{s.envThrCrossMode.sel};
if nargin >= 9 && ~isempty(showFigs) && ~isnan(showFigs)
    s.debugPlots = showFigs;
end

if size(data,1) > size(data,2)
    data = data';
end

numChans = size(data,1);
dataLen  = size(data,2);

dogged = DoG(data,fs,s.goodBand(1),s.goodBand(2));
instE  = zeros(numChans,dataLen); 

detBorders = cell(numChans,1);
detPeaks   = cell(numChans,1);
peakVals   = cell(numChans,1);
peaks2val  = cell(numChans,1);

upEnvFeatInd  = 1;
lowEnvFeatInd = 2;

if s.debugPlots
    resFig = figure('Name','Results figure','WindowState','minimized');
end

for ch = 1:size(data,1)
    if ismember(chans(ch),refch)
        continue
    end

    if s.debugPlots
        slideFig = figure('Name','Current interval figure',...
                          'Units','normalized',...
                          'Position',[0.2, 0.3, 0.7, 0.5]);
    end

    %% computing features
%     dogged = DoG(data(ch,:),fs,s.goodBand(1),s.goodBand(2));
%     [upEnv,lowEnv] = envelope(dogged,s.envWinLen,'peak');
    [pks,locs] = findpeaks(dogged(ch,:),'MinPeakDistance',s.envWinLen);
    upEnv = makima(locs,pks,1:dataLen);
    [pks,locs] = findpeaks(-dogged(ch,:),'MinPeakDistance',s.envWinLen);
    lowEnv = makima(locs,pks,1:dataLen)*-1;
    
    iP = instPow(data(ch,:),fs,s.goodBand(1),s.goodBand(2));
    iPbad = instPow(data(ch,:),fs,s.badBand(1),s.badBand(2));
    
    [cfs,~,coi]       = cwt(data(ch,:),fs,'amor','FrequencyLimits',s.goodBand);
    edgeEffIv1        = 1:find(round(coi, 1) < s.goodBand(1), 1, 'first');
    edgeEffIv2        = find(round(coi, 1) < s.goodBand(2), 1, 'last'):size(data, 2);
    cfs(:,edgeEffIv1) = repmat(mean(cfs(:,[edgeEffIv1,edgeEffIv1(end) + 1:min(dataLen,edgeEffIv1(end) + round(.1*fs))]),2),1,length(edgeEffIv1));
    cfs(:,edgeEffIv2) = repmat(mean(cfs(:,[max(1,edgeEffIv2(1) - round(.1*fs)):edgeEffIv2(1) - 1,edgeEffIv2]),2),1,length(edgeEffIv2));
    cfs               = (cfs - mean(cfs,'all')) / std(cfs,0,'all');
    instE(ch,:)       = trapz(abs(cfs).^2);
    
    [cfs,~,coi]       = cwt(data(ch,:),fs,'amor','FrequencyLimits',s.badBand);
    edgeEffIv1        = 1:find(round(coi, 1) < s.badBand(1), 1, 'first');
    edgeEffIv2        = find(round(coi, 1) < s.badBand(2), 1, 'last'):size(data, 2);
    cfs(:,edgeEffIv1) = repmat(mean(cfs(:,[edgeEffIv1,edgeEffIv1(end) + 1:min(dataLen,edgeEffIv1(end) + round(.1*fs))]),2),1,length(edgeEffIv1));
    cfs(:,edgeEffIv2) = repmat(mean(cfs(:,[max(1,edgeEffIv2(1) - round(.1*fs)):edgeEffIv2(1) - 1,edgeEffIv2]),2),1,length(edgeEffIv2));
    cfs               = (cfs - mean(cfs,'all')) / std(cfs,0,'all');
    instEbad          = trapz(abs(cfs).^2);

    %% start sliding along data

%     niceIvs = zeros(0,2);
%     mehIvs  = zeros(0,2);
%     badIvs  = zeros(0,2);
    evInds = zeros(1,dataLen);
    startOffset = 0;
    for startInd = 1:s.winLen:dataLen
        startInd     = min(dataLen,startInd + startOffset);
        if startInd >= (dataLen - 1)
            continue
        end
        currInds     = startInd:min(dataLen, startInd + s.winLen - 1);
        if (dataLen - currInds(end)) < s.winLen/2
            startOffset = startOffset + (dataLen - currInds(end));
            currInds = startInd:dataLen;
        end
        
        currTaxis    = tAxis(currInds);
        currDoG      = dogged(ch,currInds);
        currUpEnv    = upEnv(currInds);
        currLowEnv   = lowEnv(currInds);
        currIp       = iP(currInds);
        currIpBad    = iPbad(currInds);
        currInstE    = instE(ch,currInds);
        currInstEbad = instEbad(currInds);

        % check to ensure a signal isnt cut in half by the windowing
        upEnvThr  = median(currUpEnv) + std(currUpEnv);
        lowEnvThr = median(currLowEnv) - std(currLowEnv);
        iPThr     = median(currIp) + std(currIp);
        instEThr  = median(currInstE) + std(currInstE);
        win2test  = max(1,length(currInds) - round(.05*fs)):length(currInds);
        cond      = ( (length(find(currUpEnv(win2test) > upEnvThr)) / length(win2test)) > .5 ) ||...
                    ( (length(find(currLowEnv(win2test) < lowEnvThr)) / length(win2test)) > .5 ) ||...
                    ( (length(find(currIp(win2test) > iPThr)) / length(win2test)) > .5 ) ||...
                    ( (length(find(currInstE(win2test) > instEThr)) / length(win2test)) > .5 );
        if cond
            fprintf('Stretching current window!\n')
            startOffset = startOffset + round(.1*fs);
            currInds     = startInd:min(dataLen, startInd + startOffset + s.winLen - 1);

            currTaxis    = tAxis(currInds);
            currDoG      = dogged(ch,currInds);
            currUpEnv    = upEnv(currInds);
            currLowEnv   = lowEnv(currInds);
            currIp       = iP(currInds);
            currIpBad    = iPbad(currInds);
            currInstE    = instE(ch,currInds);
            currInstEbad = instEbad(currInds);
        end
        
        data2fit = [currUpEnv',currLowEnv',currIp',currIpBad',currInstE',currInstEbad'];
        [chosenGMM,clustInds,lowClust,gofVals,dropPercent] = runGMM(data2fit,s);

        if s.debugPlots
            figure(slideFig)
        
            sp1 = subplot(4,1,1,'Parent',slideFig);
            for k = 1:chosenGMM.NumComponents
                segments = nan(size(currDoG));
                segments(clustInds==k) = currDoG(clustInds==k);
                plot(sp1,currTaxis,segments,'DisplayName',num2str(k))
                hold(sp1,'on')
            end
            legend(sp1)
            hold(sp1,'off')
            title(sp1,'DoG of current segment')
    
            sp2 = subplot(4,1,2,'Parent',slideFig);
            for k = 1:chosenGMM.NumComponents
                segments = nan(size(currInstE));
                segments(clustInds==k) = currInstE(clustInds==k);
                plot(sp2,currTaxis,segments,'DisplayName',num2str(k))
                hold(sp2,'on')
            end
            legend(sp2)
            hold(sp2,'off')
            title(sp2,'CWT InstE (good freqs) of current segment')
    
            sp3 = subplot(4,1,3,'Parent',slideFig);
            for k = 1:chosenGMM.NumComponents
                segments = nan(size(currInstEbad));
                segments(clustInds==k) = currInstEbad(clustInds==k);
                plot(sp3,currTaxis,segments,'DisplayName',num2str(k))
                hold(sp3,'on')
            end
            legend(sp3)
            hold(sp3,'off')
            title(sp3,'CWT InstE (bad freqs) of current segment')
        
            sp4 = subplot(4,1,4,'Parent',slideFig);
            plot(sp4,gofVals,'o-')
            title(sp4,sprintf('Best component num: %d, best drop=%.4f',chosenGMM.NumComponents,dropPercent))

            waitforbuttonpress
        end

        if chosenGMM.NumComponents  > 1

            goodClusters = find(1:chosenGMM.NumComponents ~= lowClust);
    
            upThr       = chosenGMM.mu(lowClust,upEnvFeatInd) + s.envThrSdMult*sqrt(chosenGMM.Sigma(upEnvFeatInd,upEnvFeatInd,lowClust));
            lowThr      = chosenGMM.mu(lowClust,lowEnvFeatInd) - s.envThrSdMult*sqrt(chosenGMM.Sigma(lowEnvFeatInd,lowEnvFeatInd,lowClust));
    
            for k = goodClusters

%                 [niceIvsTemp,mehIvsTemp,badIvsTemp] = clustIvFilter(fs,currInds,chosenGMM,lowClust,clustInds,k,upThr,lowThr,currDoG,currUpEnv,currLowEnv,currIp,currInstE,currInstEbad,s);
                evInds = clustIvFilter(fs,evInds,currInds,chosenGMM,lowClust,clustInds,k,currTaxis,currDoG,currUpEnv,currLowEnv,currIp,currInstE,currInstEbad,s);
%                 niceIvs = [niceIvs; niceIvsTemp];
%                 mehIvs  = [mehIvs; mehIvsTemp];
%                 badIvs  = [badIvs; badIvsTemp];
            end

        end
    end

    if s.debugPlots
        delete(slideFig)
    end

    niceIvs = computeAboveThrLengths(evInds,1,'==');
    mehIvs  = computeAboveThrLengths(evInds,2,'==');
%     badIvs  = computeAboveThrLengths(evInds,3,'==');

    mergedIvs    = [niceIvs; mehIvs];
    mergedPeaks  = zeros(size(mergedIvs,1),1);
    peakVals{ch} = zeros(length(mergedPeaks),1);
    for iv = 1:size(mergedIvs,1)
        [peakVals{ch}(iv),maxInd] = max(dogged(ch,mergedIvs(iv,1):mergedIvs(iv,2)));
        mergedPeaks(iv) = maxInd + mergedIvs(iv,1) - 1;
    end
    
    if ~isempty(mergedIvs)
        upExtThr = chosenGMM.mu(lowClust,upEnvFeatInd) + sqrt(chosenGMM.Sigma(upEnvFeatInd,upEnvFeatInd,lowClust));
        detDataModQ = upEnv;
        detDataModQ(detDataModQ < upExtThr) = 0;
        upIvs = extendEvents(mergedIvs,detDataModQ,upThr,upExtThr);
    
        lowExtThr = chosenGMM.mu(lowClust,lowEnvFeatInd) + sqrt(chosenGMM.Sigma(lowEnvFeatInd,lowEnvFeatInd,lowClust));
        detDataModQ = lowEnv;
        detDataModQ(detDataModQ < lowExtThr) = 0;
        lowIvs = extendEvents(mergedIvs,detDataModQ,lowThr,lowExtThr);
    
        mergedIvs(:,1) = min([upIvs(:,1),lowIvs(:,1)],[],2);
        mergedIvs(:,2) = max([upIvs(:,2),lowIvs(:,2)],[],2);
    end

    detBorders{ch} = mergedIvs;
    detPeaks{ch}   = mergedPeaks;
    peaks2val{ch}  = ((size(niceIvs,1) + 1):length(mergedPeaks))';

    if s.debugPlots
        sp = subplot(numChans,1,ch,'Parent',resFig);
        plot(sp,tAxis,dogged(ch,:))
        hold(sp,'on')
        y = [min(dogged(ch,:)),min(dogged(ch,:)),max(dogged(ch,:)),max(dogged(ch,:))];
    %     for iv = 1:size(badIvs,1)
    %         x = [badIvs(iv,1),badIvs(iv,2),badIvs(iv,2),badIvs(iv,1)];
    %         patch(sp,tAxis(x),y,'k','FaceAlpha',.25,'EdgeColor','k')
    %     end
        for iv = 1:size(mehIvs,1)
            x = [mehIvs(iv,1),mehIvs(iv,2),mehIvs(iv,2),mehIvs(iv,1)];
            patch(sp,tAxis(x),y,'m','FaceAlpha',.25,'EdgeColor','m')
        end
        for iv = 1:size(niceIvs,1)
            x = [niceIvs(iv,1),niceIvs(iv,2),niceIvs(iv,2),niceIvs(iv,1)];
            patch(sp,tAxis(x),y,'r','FaceAlpha',.25,'EdgeColor','r')
        end
        hold(sp,'off')
        title(sp,sprintf('Channel #%d',chans(ch)))
    end
end
if s.debugPlots
    linkaxes(findobj(resFig,'Type','axes'),'x')
    resFig.WindowState = 'maximized';
end

if ~autoPilot && ~isempty(vertcat(peaks2val{:}))
    mehEvs2keep = WIPreviewDiscardedEvents(tAxis,fs,chans,dogged,'raw',data,detPeaks,peaks2val,'Dubious events');
    for ch = 1:numChans
        if ismember(chans(ch),refch)
            continue
        end
        evs2keep = peaks2val{ch}(mehEvs2keep{ch});
        peaks2del = peaks2val{ch}(~ismember(peaks2val{ch},evs2keep));
        detPeaks{ch}(peaks2del) = [];
        peakVals{ch}(peaks2del) = [];
        detBorders{ch}(peaks2del,:) = [];
    end
end

for ch = 1:numChans
    [detPeaks{ch},sortIdx] = sort(detPeaks{ch});
    peakVals{ch} = peakVals{ch}(sortIdx);
    detBorders{ch} = detBorders{ch}(sortIdx,:);
end

if refVal
    refDog = DoG(refData,fs,s.goodBand(1),s.goodBand(2));
    refValVictims2Del = cell(numChans,1);
    refValVictimsEval = cell(numChans,1);
    refValWinHalfLen = round(.025*fs);
    for ch = 1:numChans
        if ismember(chans(ch),refch)
            continue
        end
        for iv = 1:length(detPeaks{ch})
            winInds = max(1, detPeaks{ch}(iv) - refValWinHalfLen):min(dataLen, detPeaks{ch}(iv) + refValWinHalfLen);
            if std(refDog(winInds)) / std(dogged(ch,winInds)) > .5
                r = corrcoef(dogged(ch,winInds),refDog(winInds));
                if abs(r(2)) > .9
                    refValVictims2Del{ch} = [refValVictims2Del{ch}; iv];
                elseif abs(r(2)) > .6
                    refValVictimsEval{ch} = [refValVictimsEval{ch}; iv];
                end
            end
        end
    end

    if ~isempty(vertcat(refValVictims2Del{:}))
        for ch = 1:numChans
            if ismember(chans(ch),refch)
                continue
            end

            peaks2del = refValVictims2Del{ch};
            detPeaks{ch}(peaks2del) = [];
            peakVals{ch}(peaks2del) = [];
            detBorders{ch}(peaks2del,:) = [];

            if ~isempty(refValVictimsEval{ch})
                for ind = 1:length(refValVictimsEval{ch})
                    decrBy = sum(refValVictimsEval{ch}(ind) > peaks2del);
                    refValVictimsEval{ch}(ind) = refValVictimsEval{ch}(ind) - decrBy;
                end
            end
        end
    end

    if ~isempty(vertcat(refValVictimsEval{:}))
        if ~autoPilot
            evs2Restore = WIPreviewDiscardedEvents(tAxis,fs,chans,dogged,'ref',refDog,detPeaks,refValVictimsEval,'Reference validation');
            for ch = 1:numChans
                if ismember(chans(ch),refch)
                    continue
                end
                evs2keep = refValVictimsEval{ch}(evs2Restore{ch});
                peaks2del = refValVictimsEval{ch}(~ismember(refValVictimsEval{ch},evs2keep));
                detPeaks{ch}(peaks2del) = [];
                peakVals{ch}(peaks2del) = [];
                detBorders{ch}(peaks2del,:) = [];
            end
        else
            for ch = 1:numChans
                if ismember(chans(ch),refch)
                    continue
                end
                peaks2del = refValVictimsEval{ch};
                detPeaks{ch}(peaks2del) = [];
                peakVals{ch}(peaks2del) = [];
                detBorders{ch}(peaks2del,:) = [];
            end
        end
    end
end

for ch = 1:numChans
    if ismember(chans(ch),refch)
        continue
    end
    
    [detPeaks{ch},detBorders{ch}] = mergeEvents(detPeaks{ch},peakVals{ch},detBorders{ch},s.clustGapFillLen);
end

detParams   = cell(numChans,1);
evComplexes = cell(numChans,1);
for ch = 1:numChans
    if ismember(chans(ch),refch)
        continue
    end
    
    [detPeaks{ch}, detBorders{ch}, detParams{ch},evComplexes{ch}] = detParamMiner(1,detPeaks{ch},detBorders{ch},fs,data(ch,:),...
        instE(ch,:),dogged(ch,:),tAxis);
end

end