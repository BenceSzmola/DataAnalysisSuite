function [dets,detBorders,detParams,evComplexes] = wavyDet(data,inds2use,taxis,chan,fs,minLen,sdmult,w1,w2,refVal,refCh,refChData,showFigs,autoPilot)

% [dets,detBorders,detParams,evComplexes] = wavyDet(data,inds2use,taxis,chan,fs,minLen,sdmult,w1,w2,refVal,refCh,refChData,showFigs)

%% Parameters
% srate = 20000;
if nargin ~= 0
    fs = round(fs,4);
    % mindist = 50;
    % runavgwindow = 0.25;
    % minlen = 0.02;
    minLen = round(minLen,4);
    % sdmult = 3;
    sdmult = round(sdmult,4);
    w1 = round(w1,4);
    w2 = round(w2,4);
    if size(data,1) > size(data,2)
        data = data';
    end
end

% Checking whether refchan validation is requested 
% if isempty(refChData)
%     refVal = 0;
% else
%     refVal = 1;
% end

detParams = cell(min(size(data)),1);
evComplexes = cell(min(size(data)),1);

dogged = DoG(data,fs,w1,w2);

% Finding above threshold segments on refchan
if refVal ~= 0
    
    refDogged = DoG(refChData,fs,w1,w2);
    [refCoeffs,~,~] = cwt(refChData,fs,'amor','FrequencyLimits',[w1 w2]);
    refInstE = trapz(abs(refCoeffs).^2);
    refInstEcut = refInstE;
    if ~(ischar(inds2use) && strcmp(inds2use,'all'))
        if ~isempty(inds2use)
                refInstEcut = refInstE(inds2use);
        end
    end
%     refThr = median(refInstEcut) + std(refInstEcut);
%     refThr = prctile(refInstE,80);

    refQuietThr = median(refInstEcut) + std(refInstEcut);
    refQuietSegs = refInstEcut(refInstEcut < refQuietThr);
    refThr = median(refQuietSegs) + sdmult*std(refQuietSegs);
    
%     [refDets,refDetMarks,aboveRefThr,belowRefThr] = refDetAlg(refInstE,[],refThr,fs);
    [refAboveThrIvs, refIvLens] = computeAboveThrLengths(refInstE,refThr,round(0.05*fs));
    if ~(ischar(inds2use) && strcmp(inds2use,'all'))
        if ~isempty(inds2use)
            ivs2del = false(length(refIvLens), 1);
            for iv = 1:length(refIvLens)
                currIvInds = refAboveThrIvs(iv,1):refAboveThrIvs(iv,2);
                intheClear = length(find(ismember(currIvInds, inds2use)));
                if (intheClear / refIvLens(iv)) < 0.75
                    ivs2del(iv) = true;
                end
            end
            refAboveThrIvs(ivs2del,:) = [];
            refIvLens(ivs2del) = [];
        end
    end
    refDets = nan(length(refChData), 1);
    for ivs = 1:length(refIvLens)
        refDets(refAboveThrIvs(ivs,1):refAboveThrIvs(ivs,2)) = 0;
    end
    aboveRefThr = nan(length(refChData), 1);
    aboveRefThr(refDets == 0) = refChData(refDets == 0);
else
    refDogged = [];
    refThr = [];
    refDets = [];
end

instE = zeros(size(data));
quietThr = nan(size(data,1),1);
quietSegs = cell(size(data,1),1);
qSegsInds = cell(size(data,1),1);
thr = nan(size(data,1),1);
extThr = nan(size(data,1),1);

for i = 1:size(data,1)
    if any(chan(i) == refCh)
        continue
    end
    
    %% Apply periodic filt
    % data = periodicNoise(data,srate,1000);

    %% CWT
    mb = msgbox('Computing wavelet transform...');

    [coeffs,~,coi] = cwt(data(i,:),fs,'amor','FrequencyLimits',[w1 w2]);
    edgeEffIntervalBegin = 1:find(round(coi, 1) < w1, 1, 'first');
    edgeEffIntervalEnd = find(round(coi, 1) < w2, 1, 'last'):size(data, 2);
    coeffs = abs(coeffs);

%     [coeffs_wideBand, f, coi] = cwt(data(i,:), fs, 'amor', 'FrequencyLimits', [1, min(fs/2, max(w2, 500))]);
%     coeffs_wideBand = abs(coeffs_wideBand);
%     edgeEffIntervalBegin = 1:find(round(coi, 1) < w1, 1, 'first');
%     edgeEffIntervalEnd = find(round(coi, 1) < w2, 1, 'last'):size(data, 2);
%     freqsOI = round(f,1) >= w1 & round(f,1) <= w2;
%     disp('these are the freqOI')
%     f(freqsOI)
%     coeffs = coeffs_wideBand(freqsOI,:);
%     coeffs_wideBand = coeffs_wideBand(~freqsOI,:);
    
%     currInstE_wide  = trapz(coeffs_wideBand.^2, 1);
%     quietThr_wide = median(currInstE_wide) + std(currInstE_wide);
%     quietSegs_wide = currInstE_wide(currInstE_wide < quietThr_wide);
%     
%     thr_otherFreq = median(quietSegs_wide) + sdmult*std(quietSegs_wide);

    %% Z-score

    z_coeffs = (coeffs-mean(mean(coeffs)))/std(std(coeffs));
    % assignin('base','zizz',z_coeffs)
    delete(mb);

    %% Threshold calculation and detection

    % Instantaneous energy integral approach
    currInstE  = trapz(abs(coeffs).^2, 1);
    instE(i,:) = currInstE;
    % check whether only a subset of the indices should be used
    if ~(ischar(inds2use) && strcmp(inds2use,'all'))
        if ~isempty(inds2use)
%             inds2use(ismember(inds2use, edgeEffIntervalBegin)) = [];
%             inds2use(ismember(inds2use, edgeEffIntervalEnd)) = [];
%             currInstE = currInstE(inds2use);
        else
            continue
        end
    else
        inds2use = 1:size(data, 2);
%         inds2use(ismember(inds2use, edgeEffIntervalBegin)) = [];
%         inds2use(ismember(inds2use, edgeEffIntervalEnd)) = [];
%         currInstE = currInstE(inds2use);
    end
    
    inds2use(ismember(inds2use, edgeEffIntervalBegin)) = [];
    inds2use(ismember(inds2use, edgeEffIntervalEnd)) = [];
%     [ivs, ~] = computeAboveThrLengths(currInstE_wide, thr_otherFreq, round(0.1*fs));
%     for ivInd = 1:size(ivs, 1)
%         currIv = ivs(ivInd,1):ivs(ivInd,2);
%         inds2use(ismember(inds2use, currIv)) = [];
%     end
%     fprintf(1, 'len of inds2use before: %d\n', length(inds2use))
%     outsideDominantInds = find( (currInstE/length(find(freqsOI))) < (currInstE_wide/length(find(~freqsOI))) );
%     inds2use(ismember(inds2use, outsideDominantInds)) = [];
%     fprintf(1, 'len of inds2use after: %d\n', length(inds2use))
    currInstE = currInstE(inds2use);
    
%     thr = mean(instE) + sdmult*std(instE);
    quietThr(i) = median(currInstE) + std(currInstE);
%     quietThr(i) = prctile(currInstE,80);
    quietSegs{i} = currInstE(currInstE < quietThr(i));
    qSegsInds{i} = instE(i,:);
    qSegsInds{i}(instE(i,:) >= quietThr(i)) = nan;
    thr(i) = median(quietSegs{i}) + sdmult*std(quietSegs{i});
    extThr(i) = median(quietSegs{i}) + std(quietSegs{i});
    
end
    
[dets,detBorders] = commDetAlg(taxis,chan,inds2use,data,instE,dogged,refCh,refDogged,refDets,fs,...
    thr,refVal,minLen,extThr,autoPilot);

% check whether there is any power at the detected locations in other frequency ranges
% for i = 1:min(size(data))
%     if chan(i) == refCh
%         continue
%     end
%     
%     [cfs,f] = cwt(data(i,:),fs,'amor','FrequencyLimits',[1, min(1000, fs/2)]);
%     freqsOI = round(f,1) >= w1 & round(f,1) <= w2;
%     cfs = abs(cfs(~freqsOI,:));
%     
%     currInstE  = trapz(cfs.^2);
%     quietThr_otherFreq = median(currInstE) + std(currInstE);
%     quietSegs_otherFreq = currInstE(currInstE < quietThr_otherFreq);
%     
%     thr_otherFreq = median(quietSegs_otherFreq) + sdmult*std(quietSegs_otherFreq);
%     dets2del = false(size(dets{i}));
%     for j = 1:length(dets{i})
%         if any(currInstE(detBorders{i}(j,1):detBorders{i}(j,2)) > thr_otherFreq)
%             dets2del(j) = true;
%         end
%     end
%     dets{i}(dets2del) = [];
%     detBorders{i}(dets2del,:) = [];
% end

for i = 1:min(size(data))
    if any(chan(i) == refCh)
        continue
    end
    
    [dets{i}, detBorders{i}, detParams{i},evComplexes{i}] = detParamMiner(1,dets{i},detBorders{i},fs,data(i,:),...
        instE(i,:),dogged(i,:),taxis);
    
%     evs2del = false(1,length(detParams{i}));
%     for j = 1:length(detParams{i})
%         if (detParams{i}(j).Frequency < (w1 * 0.85)) || (detParams{i}(j).Frequency > (w2 * 1.15))
%             evs2del(j) = true;
%         end
%     end
%     detParams{i}(evs2del) = [];
%     dets{i}(evs2del) = [];
%     detBorders{i}(evs2del,:) = [];
%     for j = 1:length(evs2del)
%         if evs2del(j)
%             detInComplex = cellfun(@(x) ismember(j,x), evComplexes{i});
%             if ~any(detInComplex)
%                 continue
%             end
%             complex2check = evComplexes{i}{detInComplex};
%             if (length(complex2check) == 2) || ((find(complex2check == j) ~= 1) && (find(complex2check == j) ~= length(complex2check)))
%                 evComplexes{i}(detInComplex) = [];
%             else
%                 complex2check(complex2check == j) = [];
%                 evComplexes{i}{detInComplex} = complex2check;
%             end
%             
%         end
%     end

    %% Plotting
    if showFigs
        xtraFig = figure('Name',['Chan#',num2str(chan(i))],'Visible','off');

        if refVal ~= 0
            sp1 = subplot(411);
            sp2 = subplot(412);
            sp3 = subplot(413);
            sp4 = subplot(414);
            linkaxes([sp1,sp2,sp3,sp4],'x')
            
            plot(sp3,taxis,refDogged)
            hold(sp3,'on')
            discInds = refDogged;
            discInds(inds2use) = nan;
            plot(sp3,taxis,discInds,'-m')
            hold(sp3,'off')
            legend(sp3, {'DoG of reference','Discarded indices'})
            xlabel(sp3,'Time [s]')
            ylabel(sp3,'Voltage [\muV]')
            title(sp3,'DoG of reference channel')
            
            plot(sp4,taxis,refInstE)
            hold(sp4,'on')
            plot(sp4,taxis,aboveRefThr,'-r')
            yline(sp4,refThr,'Color','g','LineWidth',1);
            hold(sp4,'off')
            xlabel(sp4,'Time [s]')
            ylabel(sp4,'CWT coefficient magnitude')
            title(sp4,'Instant energy of reference channel')
            legend(sp4,{'Inst.E.','Above threshold','Ref thr'})
        else
            sp1 = subplot(211);
            sp2 = subplot(212);
            linkaxes([sp1,sp2],'x')
        end
        
        plot(sp1,taxis,dogged(i,:))
        hold(sp1,'on')
%         plot(sp1,taxis,dets(i,:),'*r','MarkerSize',10)
        detPlot(sp1,dets{i},[],taxis,'stars','r',[])
        hold(sp1,'off')
        xlabel(sp1,'Time [s]')
        ylabel(sp1,'Voltage [\muV]')
        title(sp1,['DoG of channel #',num2str(chan(i))])

        plot(sp2,taxis,instE(i,:))
        hold(sp2,'on')
%         plot(sp2,taxis,dets(i,:),'*r','MarkerSize',10)
        detPlot(sp2,dets{i},[],taxis,'stars','r',[])
        yline(sp2,thr(i),'Color','g');
        yline(sp2,extThr(i),'Color','m');
        yline(sp2,quietThr(i),'Color','k');
        plot(sp2,taxis,qSegsInds{i},'-m')
        if ~isempty(dets{i})
            legendNames = {'Inst. Energy integral','Detections','Detection threshold','Ext. threshold',...
                'Quiet threshold','Quiet segments'};
        else
            legendNames = {'Inst. Energy integral','Detection threshold','Ext. threshold',...
                'Quiet threshold','Quiet segments'};
        end
        legend(sp2,legendNames)
        hold(sp2,'off')
        xlabel(sp2,'Time [s]')
        ylabel(sp2,'CWT coefficient magnitude')
        title(sp2,'Instantaneous energy based on CWT')

        xtraFig.Visible = 'on';
        
    end
end

% if any(ismember(chan, refCh))
%     % egyelore refDets-t nem alakitottam at, ezert itt convertalom
%     refDets = find(~isnan(refDetMarks));
%     dets{ismember(chan, refCh)} = refDets;
% end