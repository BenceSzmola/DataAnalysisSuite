function [dets,detBorders,detParams] = DoGInstPowDet(data,taxis,chan,fs,w1,w2,sdmult,minLen,refCh,refChData,showFigs)

if size(data,1) > size(data,2)
    data = data';
end

% Checking whether refchan validation is requested 
if isempty(refChData)
    refVal = 0;
else
    refVal = 1;
end

fs = round(fs,4);
w1 = round(w1,4);
w2 = round(w2,4);
minLen = round(minLen,4);

% Computing DoG
dogged = DoG(data,fs,w1,w2);
if refVal == 1
    refDogged = DoG(refChData,fs,w1,w2);
else
    refDogged = [];
end

% Instant Power
instPowd = instPow(data,fs,w1,w2);
if refVal == 1
    refInstPowd = instPow(refChData,fs,w1,w2);
else
    refInstPowd = [];
end

% dets = nan(size(data));
% detBorders = cell(min(size(data)),1);
detParams = cell(min(size(data)),1);

if refVal == 1
    refThr = mean(refInstPowd) + 3*std(refInstPowd);
    [refDets,refDetMarks,aboveRefThr,belowRefThr] = refDetAlg(refInstPowd,refDogged,refThr,fs); 
else
    refDets = [];
    refDetMarks = [];
    aboveRefThr = [];
    belowRefThr = [];
end

quietThr = nan(size(data,1),1);
quietSegs = cell(size(data,1),1);
qSegsInds = cell(size(data,1),1);
thr = nan(size(data,1),1);
extThr = nan(size(data,1),1);

for i = 1:size(data,1)
    
    if chan(i) == refCh
        continue
    end
    
    % Determining background noise segments
    currInstPow = instPowd(i,:);

    quietThr(i) = mean(currInstPow) + std(currInstPow);
    quietSegs{i} = currInstPow(currInstPow < quietThr(i));
    qSegsInds{i} = currInstPow;
    qSegsInds{i}(currInstPow>=quietThr(i)) = nan;

    thr(i) = mean(quietSegs{i}) + sdmult*std(quietSegs{i});
    extThr(i) = mean(quietSegs{i}) + std(quietSegs{i});
    
end

[dets,detBorders] = commDetAlg(taxis,chan,data,instPowd,dogged,...
    refCh,refDogged,refDets,fs,thr,refVal,minLen,extThr);

for i = 1:min(size(data))
    
    if chan(i) == refCh
        continue
    end
    
    % det stats
    detParams{i} = detParamMiner(1,dets{i},detBorders{i},fs,data(i,:),instPowd(i,:),dogged(i,:));
    
    % plotting part mainly for bugfixing
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
            hold(sp3,'off')

            xlabel(sp3,'Time [s]')
            ylabel(sp3,'Voltage [\muV]')
            title(sp3,'DoG of reference channel')
            legend(sp3,{'DoG','Above threshold'})
        else
            sp1 = subplot(211);
            sp2 = subplot(212);
            linkaxes([sp1,sp2],'x')
        end
        
        plot(sp1,taxis,dogged(i,:))
        hold(sp1,'on')
        plot(sp1,taxis,dets(i,:),'*r','MarkerSize',10)
        hold(sp1,'off')
        xlabel(sp1,'Time [s]')
        ylabel(sp1,'Voltage [\muV]')
        title(sp1,['DoG of channel #',num2str(chan(i))])

        plot(sp2,taxis,instPowd(i,:))
        hold(sp2,'on')
        plot(sp2,taxis,dets(i,:),'*r','MarkerSize',10)
        plot(sp2,taxis,thr(i)*ones(1,length(taxis)),'-g')
        plot(sp2,taxis,quietThr(i)*ones(1,length(taxis)),'-k')
        plot(sp2,taxis,qSegsInds{i},'-m')
        hold(sp2,'off')
        xlabel(sp2,'Time [s]')
        ylabel(sp2,'Power [\muV^2]')
        title(sp2,['Instantaneous Power of channel #',num2str(chan(i))])
        legend(sp2,{'Inst.Power','Detections','Detection threshold',...
            'Threshold for quiet intervals','Quiet intervals'})
        
        xtraFig.Visible = 'on';

    end
end

% if ~isempty(find(chan==refCh, 1))
%     dets(find(chan==refCh),:) = refDetMarks;
%     
% end

