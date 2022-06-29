function [dets,detBorders,detParams,evComplexes] = wavyDet(data,inds2use,taxis,chan,fs,minLen,sdmult,w1,w2,refCh,refChData,showFigs)
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
if isempty(refChData)
    refVal = 0;
else
    refVal = 1;
end

detParams = cell(min(size(data)),1);
evComplexes = cell(min(size(data)),1);

dogged = DoG(data,fs,w1,w2);

% Finding above threshold segments on refchan
if refVal ~= 0
    
    refDogged = DoG(refChData,fs,w1,w2);
    [refCoeffs,~,~] = cwt(refChData,fs,'amor','FrequencyLimits',[w1 w2]);
    refInstE = trapz(abs(refCoeffs).^2);
    if ~(ischar(inds2use) && strcmp(inds2use,'all'))
        if ~isempty(inds2use)
                refInstE = refInstE(inds2use);
        end
    end
%     refThr = median(refInstE) + std(refInstE);
    refThr = prctile(refInstE,80);
    
    [refDets,refDetMarks,aboveRefThr,belowRefThr] = refDetAlg(refInstE,[],refThr,fs);
else
    refDogged = [];
    refInstE = [];
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
    if chan(i) == refCh
        continue
    end
    
    %% Apply periodic filt
    % data = periodicNoise(data,srate,1000);

    %% CWT
    mb = msgbox('Computing wavelet transform...');

    [coeffs,~,~] = cwt(data(i,:),fs,'amor','FrequencyLimits',[w1 w2]);
    coeffs = abs(coeffs);

    %% Z-score

    z_coeffs = (coeffs-mean(mean(coeffs)))/std(std(coeffs));
    % assignin('base','zizz',z_coeffs)
    delete(mb);

    %% Threshold calculation and detection

    % Instantaneous energy integral approach
    currInstE  = trapz(abs(coeffs).^2);
    instE(i,:) = currInstE;
    % check whether only a subset of the indices should be used
    if ~(ischar(inds2use) && strcmp(inds2use,'all'))
        if ~isempty(inds2use)
                currInstE = currInstE(inds2use);
        else
            continue
        end
    end
%     thr = mean(instE) + sdmult*std(instE);
%     quietThr(i) = median(currInstE) + std(currInstE);
    quietThr(i) = prctile(currInstE,80);
    quietSegs{i} = currInstE(currInstE < quietThr(i));
    qSegsInds{i} = instE(i,:);
    qSegsInds{i}(instE(i,:) >= quietThr(i)) = nan;
    
    thr(i) = median(quietSegs{i}) + sdmult*std(quietSegs{i});
    extThr(i) = median(quietSegs{i}) + std(quietSegs{i});
    
end
    
[dets,detBorders] = commDetAlg(taxis,chan,inds2use,data,instE,dogged,refCh,refDogged,refDets,fs,...
    thr,refVal,minLen,extThr);

% % check whether there is any power at the detected locations in other frequency ranges
% for i = 1:min(size(data))
%     if chan(i) == refCh
%         continue
%     end
%     
%     [cfs,f] = cwt(data(i,:),fs,'amor','FrequencyLimits',[1 1000]);
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
    if chan(i) == refCh
        continue
    end
    
    [detParams{i},evComplexes{i}] = detParamMiner(1,dets{i},detBorders{i},fs,data(i,:),instE(i,:),dogged(i,:),taxis);
    evs2del = false(1,length(detParams{i}));
    for j = 1:length(detParams{i})
        if (detParams{i}(j).Frequency < w1) || (detParams{i}(j).Frequency > w2)
            evs2del(j) = true;
        end
    end
    detParams{i}(evs2del) = [];
    dets{i}(evs2del) = [];
    detBorders{i}(evs2del,:) = [];
    for j = 1:length(evs2del)
        if evs2del(j)
            detInComplex = cellfun(@(x) ismember(j,x), evComplexes{i});
            if ~any(detInComplex)
                continue
            end
            complex2check = evComplexes{i}{detInComplex};
            if (length(complex2check) == 2) || ((find(complex2check == j) ~= 1) && (find(complex2check == j) ~= length(complex2check)))
                evComplexes{i}(detInComplex) = [];
            else
                complex2check(complex2check == j) = [];
                evComplexes{i}{detInComplex} = complex2check;
            end
            
        end
    end

    %% Plotting
    if showFigs
        xtraFig = figure('Name',['Chan#',num2str(chan(i))],'Visible','off');

        if refVal ~= 0
            sp1 = subplot(311);
            sp2 = subplot(312);
            sp3 = subplot(313);
            linkaxes([sp1,sp2,sp3],'x')
            
            plot(sp3,taxis,belowRefThr)
            hold(sp3,'on')
            plot(sp3,taxis,aboveRefThr,'-r')
            yline(sp3,refThr,'Color','g','LineWidth',1);
            hold(sp3,'off')

            xlabel(sp3,'Time [s]')
            ylabel(sp3,'CWT coefficient magnitude')
            title(sp3,'Instant energy of reference channel')
            legend(sp3,{'Inst.E.','Above threshold'})
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
        yline(sp2,quietThr(i),'Color','k');
        plot(sp2,taxis,qSegsInds{i},'-m')
        if ~isempty(dets{i})
            legendNames = {'Inst. Energy integral','Detections','Detection threshold',...
                'Quiet threshold','Quiet segments'};
        else
            legendNames = {'Inst. Energy integral','Detection threshold',...
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

if ~isempty(find(chan==refCh, 1))
    % egyelore refDets-t nem alakitottam at, ezert itt convertalom
    refDets = find(~isnan(refDetMarks));
    dets{chan==refCh} = refDets;
end