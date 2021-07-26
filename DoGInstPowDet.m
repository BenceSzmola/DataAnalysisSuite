function [dets,detBorders,detStats] = DoGInstPowDet(data,taxis,fs,w1,w2,sdmult,minLen,refch,showFigs)

if size(data,1) > size(data,2)
    data = data';
end

% data = periodicNoise(data,fs,500);

% Checking whether refchan validation is requested 
% 0 => not reqeusted; nonzero number => number of refchan; 
% dataseries => refchan itself
if refch == 0
    refVal = 0;
elseif isnumber(refch) && (refch~=0)
    refVal = 1;
else % Only one data channel is given + the refchannel in a separate array
    refVal = 2;
end

fs = round(fs,4);
w1 = round(w1,4);
w2 = round(w2,4);
minLen = round(minLen,4);

% Computing DoG
dogged = DoG(data,fs,w1,w2);
if refVal == 2
    refDogged = DoG(refch,fs,w1,w2);
elseif refVal == 1
    refDogged = dogged(refch,:);
end

% Instant Power
instPowd = instPow(data,fs,w1,w2);
if refVal == 2
    refInstPowd = instPow(refch,fs,w1,w2);
elseif refVal == 1
    refInstPowd = instPowd(refch,:);
end

dets = nan(size(data));
detBorders = cell(min(size(data)),1);
detStats = cell(min(size(data)),1);

if (refVal ~= 0)
    refThr = mean(refInstPowd) + 3*std(refInstPowd);
    [refDets,refDetMarks,aboveRefThr,belowRefThr] = refDetAlg(refInstPowd,refDogged,refThr,fs); 
    
end

for i = 1:size(data,1)

    if i == refch
        continue
    end
    
    % Determining background noise segments
    currInstPow = instPowd(i,:);
    quietthr = mean(currInstPow) + std(currInstPow);
    quietSegs = currInstPow(currInstPow < quietthr);
    qSegsInds = currInstPow;
    qSegsInds(currInstPow>=quietthr) = nan;
    
    thr = mean(quietSegs) + sdmult*std(quietSegs);
    
    [validDets,validDetBorders] = commDetAlg(data(i,:),instPowd(i,:),dogged(i,:),...
        refch,refDogged,refDets,fs,thr,refVal,minLen);
    dets(i,:) = validDets;
    detBorders{i} = validDetBorders;
    
    % det stats
    detStats{i} = detStatMiner(dets(i,:),detBorders{i},fs,data(i,:),instPowd(i,:),dogged(i,:));
    
    % plotting part mainly for bugfixing
    if showFigs
        xtraFig = figure('Name',['Chan#',num2str(i)],'Visible','off');

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
        title(sp1,['DoG of channel #',num2str(i)])

        plot(sp2,taxis,instPowd(i,:))
        hold(sp2,'on')
        plot(sp2,taxis,dets(i,:),'*r','MarkerSize',10)
        plot(sp2,taxis,thr*ones(1,length(taxis)),'-g')
        plot(sp2,taxis,quietthr*ones(1,length(taxis)),'-k')
        plot(sp2,taxis,qSegsInds,'-m')
        hold(sp2,'off')
        xlabel(sp2,'Time [s]')
        ylabel(sp2,'Power [\muV^2]')
        title(sp2,['Instantaneous Power of channel #',num2str(i)])
        legend(sp2,{'Inst.Power','Detections','Detection threshold',...
            'Threshold for quiet intervals','Quiet intervals'})
        
        xtraFig.Visible = 'on';

    end
end

if refVal == 1
    dets(refch,:) = refDetMarks;
    
end

