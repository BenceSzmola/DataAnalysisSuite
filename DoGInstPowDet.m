function [dets,detBorders,detParams,evComplexes] = DoGInstPowDet(data,inds2use,taxis,chan,fs,w1,w2,sdmult,minLen,refVal,refCh,refChData,showFigs,autoPilot)

% [dets,detBorders,detParams,evComplexes] = DoGInstPowDet(data,inds2use,taxis,chan,fs,w1,w2,sdmult,minLen,refVal,refCh,refChData,showFigs)

if size(data,1) > size(data,2)
    data = data';
end

% Checking whether refchan validation is requested 
% if isempty(refChData)
%     refVal = 0;
% else
%     refVal = 1;
% end

fs = round(fs,4);
w1 = round(w1,4);
w2 = round(w2,4);
minLen = round(minLen,4);

% Computing DoG
dogged = DoG(data,fs,w1,w2);
if refVal
    refDogged = DoG(refChData,fs,w1,w2);
else
    refDogged = [];
end

% Instant Power
instPowd = instPow(data,fs,w1,w2);
if refVal
    refInstPowd = instPow(refChData,fs,w1,w2);
    refInstPowdCut = refInstPowd;
else
    refInstPowd = [];
end

% dets = nan(size(data));
% detBorders = cell(min(size(data)),1);
detParams = cell(min(size(data)),1);
evComplexes = cell(min(size(data)),1);

if refVal
    if ~(ischar(inds2use) && strcmp(inds2use,'all'))
        if ~isempty(inds2use)
                refInstPowdCut = refInstPowd(inds2use);
        end
    end
%     refThr = median(refInstPowdCut) + std(refInstPowdCut);
%     [refDets,refDetMarks,aboveRefThr,belowRefThr] = refDetAlg(refInstPowd,refDogged,refThr,fs); 

    refQuietThr = median(refInstPowdCut) + std(refInstPowdCut);
    refQuietSegs = refInstPowdCut(refInstPowdCut < refQuietThr);
    refThr = median(refQuietSegs) + 2*std(refQuietSegs);
    
    [refAboveThrIvs, refIvLens] = computeAboveThrLengths(refInstPowd,refThr,'>',round(0.01*fs));
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
    aboveRefThr(refDets == 0) = refDogged(refDets == 0);
else
    refDets = [];
    refDetMarks = [];
    aboveRefThr = [];
end

quietThr = nan(size(data,1),1);
% quietThr = zeros(size(data));
quietSegs = cell(size(data,1),1);
qSegsInds = cell(size(data,1),1);
thr = nan(size(data,1),1);
extThr = nan(size(data,1),1);

for i = 1:size(data,1)
    
    if any(chan(i) == refCh)
        continue
    end
    
    % Determining background noise segments
    currInstPow = instPowd(i,:);
    if ~(ischar(inds2use) && strcmp(inds2use,'all'))
        if ~isempty(inds2use)
                currInstPow = currInstPow(inds2use);
        else
            continue
        end
    end
    
    quietThr(i) = median(currInstPow) + std(currInstPow);
    quietSegs{i} = currInstPow(currInstPow < quietThr(i));
    qSegsInds{i} = instPowd(i,:);
    qSegsInds{i}(instPowd(i,:) >= quietThr(i)) = nan;
%     quietThr(i,:) = movmean(currInstPow, round(0.1*fs)) + movstd(currInstPow, round(0.1*fs));
%     quietSegs{i} = currInstPow(currInstPow < quietThr(i,:));
%     qSegsInds{i} = currInstPow;
%     qSegsInds{i}(currInstPow >= quietThr(i,:)) = nan;

    thr(i) = median(quietSegs{i}) + sdmult*std(quietSegs{i});
    extThr(i) = median(quietSegs{i}) + std(quietSegs{i});
    
end

[dets,detBorders] = commDetAlg(taxis,chan,inds2use,data,instPowd,dogged,...
    refCh,refDogged,refDets,fs,thr,refVal,minLen,extThr,autoPilot);

for i = 1:min(size(data))
    
    if any(chan(i) == refCh)
        continue
    end
    
    % det stats
    [dets{i}, detBorders{i}, detParams{i},evComplexes{i}] = detParamMiner(1,dets{i},detBorders{i},fs,data(i,:),...
        instPowd(i,:),dogged(i,:),taxis);
    
    % plotting part mainly for bugfixing
    if showFigs
        xtraFig = figure('Name',['Chan#',num2str(chan(i))],'Visible','off');

        if refVal ~= 0
            sp1 = subplot(311);
            sp2 = subplot(312);
            sp3 = subplot(313);
            linkaxes([sp1,sp2,sp3],'x')
            
            plot(sp3,taxis,refDogged)
            hold(sp3,'on')
            plot(sp3,taxis,aboveRefThr,'-r')
            discInds = refDogged;
            discInds(inds2use) = nan;
            plot(sp3,taxis,discInds,'-m')
            hold(sp3,'off')

            xlabel(sp3,'Time [s]')
            ylabel(sp3,'Voltage [\muV]')
            title(sp3,'DoG of reference channel')
            legend(sp3,{'DoG','Above threshold','Discarded indices'})
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

        plot(sp2,taxis,instPowd(i,:))
        hold(sp2,'on')
        detPlot(sp2,dets{i},[],taxis,'stars','r',[])
        yline(sp2,thr(i),'g');
        yline(sp2,extThr(i),'m');
        yline(sp2,quietThr(i),'k');
        plot(sp2,taxis,qSegsInds{i},'-m')
        hold(sp2,'off')
        xlabel(sp2,'Time [s]')
        ylabel(sp2,'Power [\muV^2]')
        title(sp2,['Instantaneous Power of channel #',num2str(chan(i))])
        if ~isempty(dets{i})
            legendNames = {'Inst.Power','Detections','Detection threshold','Ext. threshold',...
            'Threshold for quiet intervals','Quiet intervals'};
        else
            legendNames = {'Inst.Power','Detection threshold','Ext. threshold',...
            'Threshold for quiet intervals','Quiet intervals'};
        end
        legend(sp2,legendNames)
        
        xtraFig.Visible = 'on';

    end
end

if any(ismember(chan, refCh))
    % egyelore refDets-t nem alakitottam at, ezert itt convertalom
    refDets = find(~isnan(refDetMarks));
    dets{ismember(chan, refCh)} = refDets;
end