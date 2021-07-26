function dets = DoGInstPowDet(data,taxis,fs,w1,w2,sdmult,minLen,refch,showFigs)

assignin('base','taxis',taxis)

if size(data,1) > size(data,2)
    data = data';
end

% data = periodicNoise(data,fs,500);

%%%
valTyp = 2; % 1=time match based; 2=correlation based
corrThr = 0.6;
%%%

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
% instPowd = zeros(size(data));
% for i = 1:size(data,1)
%     ripWindow  = pi / mean( [w1 w2] );
%     powerWin   = makegausslpfir( 1 / ripWindow, fs, 4 );
% 
%     rip        = dogged(i,:);
%     rip        = abs(rip);
%     ripPower0  = firfilt( rip, powerWin );
%     ripPower0  = max(ripPower0,[],2);
% 
%     instPowd(i,:) = ripPower0;
% end
% 
% if refVal == 2
%     ripWindow  = pi / mean( [w1 w2] );
%     powerWin   = makegausslpfir( 1 / ripWindow, fs, 4 );
% 
%     rip        = refdogged;
%     rip        = abs(rip);
%     ripPower0  = firfilt( rip, powerWin );
%     ripPower0  = max(ripPower0,[],2);
% 
%     refInstPow = ripPower0;
% end

% Detection part
% if (refVal == 0) | (refVal == 2)
    dets = nan(size(data));
% elseif refVal == 1
%     dets = nan(size(data,1)-1,size(data,2));   
% end
refdets = nan(1,length(data));
refDetMarks = refdets;
refDetIVs = refdets;

if (refVal ~= 0)
%     if refVal == 2
%         thr = mean(refInstPow) + 3*std(refInstPow);
%         refdets(refInstPow>thr) = 0;
%     else
%         thr = mean(instPowd(refch,:)) + 3*std(instPowd(refch,:));
%         refdets(instPowd(refch,:)>thr) = 0;
%     end

    refThr = mean(refInstPowd) + 3*std(refInstPowd);
    refdets(refInstPowd>refThr) = 0;

    % join close-by events together
    refdetsInds = find(refdets==0);
    for i = 1:length(refdetsInds)
        if i ~= length(refdetsInds)
            if (refdetsInds(i+1) - refdetsInds(i)) < 0.2*fs
                refdets(refdetsInds(i):refdetsInds(i+1)) = 0;
            end
        end
    end
%     assignin('base','refdets',refdets)
    % reduce number of refdets by only keeping 1st and last index of an
    % event
    abThr = find(~isnan(refdets));
    aboveRefThr = nan(1,length(refDogged));
    belowRefThr = refDogged;
    
    if ~isempty(abThr)
        steps = diff(abThr);
        eventsS = [1,find(steps~=1)+1];
        eventsE = [find(steps~=1), length(steps)];
        refDetMarks(abThr(eventsS)) = 0;
        refDetMarks(abThr(eventsE)) = 0;
        for i = 1:length(eventsS)
            refDetIVs(abThr(eventsS(i)):abThr(eventsE(i))) = 0;
        end
%         notRefDetIVs = find(isnan(refDetIVs));
        refDetIVs = find(~isnan(refDetIVs));
%         aboveRefThr = nan(1,length(refdogged));
        aboveRefThr(refDetIVs) = refDogged(refDetIVs);
%         belowRefThr = refdogged;
        belowRefThr(refDetIVs) = nan;
%         if refVal == 2
%             aboveRefThr = nan(1,length(refdogged));
%             aboveRefThr(refDetIVs) = refdogged(refDetIVs);
%             belowRefThr = refdogged;
%             belowRefThr(refDetIVs) = nan;
%         else
%             aboveRefThr = nan(1,length(dogged));
%             aboveRefThr(refDetIVs) = dogged(refch,refDetIVs);
%             belowRefThr = dogged(refch,:);
%             belowRefThr(refDetIVs) = nan;
%         end
    else
        
    end
    
end

for i = 1:size(data,1)
%     %%%
%     vEvCount = 0;
%     %%%
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
    
%     thr = mean(instPow(i,:)) + sdmult*std(instPow(i,:));
%     currInstPow = instPow(i,:);

    temp = instPowd(i,:);
    
    temp(temp < thr) = 0;
    [~,aboveThr] = find(temp);
    aboveThr = unique(aboveThr);
    steps = diff(aboveThr);
    events = find(steps ~= 1);
    events = events + 1;
    fprintf(1,'chan#%d, first # of events = %d\n',i,length(events))
    vEvents = [];
    
    if (isempty(events)) && (length(aboveThr) > minLen*fs)

        [~,maxIdx] = max(currInstPow(aboveThr));
        newEv = maxIdx + aboveThr(1);
        
        if refVal~=0
            winSize = 0.1*fs;

            if newEv-winSize < 1
                winInds = 1:newEv+winSize;
%                 refWin = refdets(1:newEv+winSize);
%                 refWin = refdogged(1:newEv+win);
%                 chanWin = dogged(i,1:newEv+win);
            elseif newEv+winSize > length(refdets)
                winInds = newEv-winSize:length(taxis);
%                 refWin = refdets(newEv-winSize:end);
%                 refWin = refdogged(newEv-win:end);
%                 chanWin = dogged(i,newEv-win:end);
            else
                winInds = newEv-winSize:newEv+winSize;
%                 refWin = refdets(newEv-winSize:newEv+winSize);
%                 refWin = refdogged(newEv-win:newEv+win);
%                 chanWin = dogged(i,newEv-win:newEv+win);
            end
            
            if valTyp == 1
                refWin = refdets(winInds);
                condit = ((refch~=0) & (isempty(find(refWin==0,1)))) | (refch==0);
            elseif valTyp == 2
                refWin = refDogged(winInds);
                chanWin = dogged(i,winInds);
                
                r = corrcoef(refWin,chanWin);
                condit = ((refch~=0) & (abs(r(2))<corrThr)) | (refch==0);
            end
            
%             condit = ((refch~=0) & (isempty(find(refWin==0,1)))) | (refch==0);
%             r = corrcoef(refWin,chanWin);
            
%             figure;
%             subplot(211)
%             plot(chanWin)
%             title(['Chan',num2str(i),'   potential event 1'])
%             subplot(212)
%             plot(refWin)
%             title(['Refchan window, corr = ',num2str(r(2))])
%             waitforbuttonpress
            
%             condit = ((refch~=0) & (abs(r(2))<corrThr)) | (refch==0);
            if condit
                vEvents = [vEvents, newEv];
            end
        else
            vEvents = [vEvents, newEv];
        end
        
%         % validating against refch
%         if ((refch~=0) & (refdets(vEvents)~=0)) | (refch==0)       
        dets(i,vEvents) = 0;
%         end
        
    else
        events = [events, length(steps)];
%         figure
        for j = 1:length(events)
            if j == 1
                len = events(j)-1;
                if len > minLen*fs
                    [~,maxIdx] = max(currInstPow(1:aboveThr(events(j))));
                    newEv = maxIdx;
%                     if ((refch~=0) & (refdets(maxIdx)~=0)) | (refch==0)
%                         vEvents = [vEvents, maxIdx];
%                     end
                else
                    newEv = [];
                end
            else
                len = events(j)-events(j-1);
                if len > minLen*fs
                    [~,maxIdx] = max(currInstPow(aboveThr(events(j-1):events(j))));
                    newEv = maxIdx+aboveThr(events(j-1));
%                     if ((refch~=0) & (refdets(maxIdx+aboveThr(events(j-1)))~=0)) | (refch==0)
%                         vEvents = [vEvents, maxIdx+aboveThr(events(j-1))];
%                     end
                else
                    newEv = [];
                end
                
            end
            
            if ~isempty(newEv) & (refVal~=0)
                winSize = 0.1*fs;
                
%                 vEvCount = vEvCount +1;
%                 %%% testing interchannel correlation
%                 fprintf(1,'Channel#%d, event#%d, (%2.2f sec)\n',i,vEvCount,newEv/fs)
%                 corrcoef(instPowd(:,newEv-win:newEv+win)')
%                 %%%
                
                if newEv-winSize < 1
                    winInds = 1:newEv+winSize;
%                     refWin = refdets(1:newEv+winSize);
%                     refWin = refdogged(1:newEv+win);
%                     chanWin = dogged(i,1:newEv+win);
                elseif newEv+winSize > length(refdets)
                    winInds = newEv-winSize:length(taxis);
%                     refWin = refdets(newEv-winSize:end);
%                     refWin = refdogged(newEv-win:end);
%                     chanWin = dogged(i,newEv-win:end);
                else
                    winInds = newEv-winSize:newEv+winSize;
%                     refWin = refdets(newEv-winSize:newEv+winSize);
%                     refWin = refdogged(newEv-win:newEv+win);
%                     chanWin = dogged(i,newEv-win:newEv+win);
                end
                
                if valTyp == 1
                    refWin = refdets(winInds);
                    condit = ((refch~=0) & (isempty(find(refWin==0,1)))) | (refch==0);
                elseif valTyp == 2
                    refWin = refDogged(winInds);
                    chanWin = dogged(i,winInds);

                    r = corrcoef(refWin,chanWin);
                    condit = ((refch~=0) & (abs(r(2))<corrThr)) | (refch==0);
                end
                
%                 subplot(211)
%                 plot(chanWin)
%                 title(['Chan',num2str(i),'   PotentialEvent ',...
%                     num2str(j)])
%                 subplot(212)
%                 plot(refWin)
%                 title(['Refchan window, corr = ',num2str(r(2))])
%                 waitforbuttonpress

                if condit
                    vEvents = [vEvents, newEv];
                end
            else
                vEvents = [vEvents, newEv];
            end
            
        end
        dets(i,vEvents) = 0;
    end
    
    % plotting part mainly for bugfixing
%     t=linspace(0,length(data)/fs,length(data));
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
        
%         sp1=subplot(311);
        plot(sp1,taxis,dogged(i,:))
        hold(sp1,'on')
        plot(sp1,taxis,dets(i,:),'*r','MarkerSize',10)
        hold(sp1,'off')
        xlabel(sp1,'Time [s]')
        ylabel(sp1,'Voltage [\muV]')
        title(sp1,['DoG of channel #',num2str(i)])

%         sp2=subplot(312);
        plot(sp2,taxis,instPowd(i,:))
        hold(sp2,'on')
        plot(sp2,taxis,dets(i,:),'*r','MarkerSize',10)
%         hold on
        plot(sp2,taxis,thr*ones(1,length(taxis)),'-g')
%         hold on
        plot(sp2,taxis,quietthr*ones(1,length(taxis)),'-k')
%         hold on
        plot(sp2,taxis,qSegsInds,'-m')
        hold(sp2,'off')
        xlabel(sp2,'Time [s]')
        ylabel(sp2,'Power [\muV^2]')
        title(sp2,['Instantaneous Power of channel #',num2str(i)])
        legend(sp2,{'Inst.Power','Detections','Detection threshold',...
            'Threshold for quiet intervals','Quiet intervals'})
        
        xtraFig.Visible = 'on';
%         sp3=subplot(313);
%         plot(taxis,belowRefThr)
%         hold on
%         plot(taxis,aboveRefThr,'-r')
%         hold off
% 
%         xlabel('Time [s]')
%         ylabel('Voltage [\muV]')
%         title('DoG of reference channel')
%         legend({'DoG','Above threshold','Threshold'})
%         linkaxes([sp1,sp2,sp3],'x')
    end
end

if refVal == 1
    dets(refch,:) = refDetMarks;
end

assignin('base','dets',dets)