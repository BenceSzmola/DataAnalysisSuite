function dets = DoGInstPowDet(data,taxis,fs,w1,w2,sdmult,minLen,refch,showFigs)

if size(data,1) > size(data,2)
    data = data';
end

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
    refdogged = DoG(refch,fs,w1,w2);
elseif refVal == 1
    refdogged = dogged(refch,:);
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

    thr = mean(refInstPowd) + 3*std(refInstPowd);
    refdets(refInstPowd>thr) = 0;

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
        aboveRefThr = nan(1,length(refdogged));
        aboveRefThr(refDetIVs) = refdogged(refDetIVs);
        belowRefThr = refdogged;
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
    vEvents = [];
    
    if (isempty(events)) && (length(aboveThr) > minLen*fs)

        [~,maxIdx] = max(currInstPow(aboveThr));
        newEv = maxIdx + aboveThr(1);
        
        if refVal~=0
            win = 0.1*fs;

            if newEv-win < 1
%                 refWin = refdets(1:newEv+win);
                refWin = refdogged(1:newEv+win);
                chanWin = dogged(i,1:newEv+win);
            elseif newEv+win > length(refdets)
%                 refWin = refdets(newEv-win:end);
                refWin = refdogged(newEv-win:end);
                chanWin = dogged(i,newEv-win:end);
            else
%                 refWin = refdets(newEv-win:newEv+win);
                refWin = refdogged(newEv-win:newEv+win);
                chanWin = dogged(i,newEv-win:newEv+win);
            end
%             condit = ((refch~=0) & (isempty(find(refWin==0,1)))) | (refch==0);
            r = corrcoef(refWin,chanWin);
            
%             figure;
%             subplot(211)
%             plot(chanWin)
%             title(['Chan',num2str(i),'   potential event 1'])
%             subplot(212)
%             plot(refWin)
%             title(['Refchan window, corr = ',num2str(r(2))])
%             waitforbuttonpress
            
            condit = ((refch~=0) & (abs(r(2))<0.6)) | (refch==0);
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
                win = 0.1*fs;
                
%                 vEvCount = vEvCount +1;
%                 %%% testing interchannel correlation
%                 fprintf(1,'Channel#%d, event#%d, (%2.2f sec)\n',i,vEvCount,newEv/fs)
%                 corrcoef(instPowd(:,newEv-win:newEv+win)')
%                 %%%
                
%                 if newEv-win < 1
%                     refWin = refdets(1:newEv+win);
%                 elseif newEv+win > length(refdets)
%                     refWin = refdets(newEv-win:end);
%                 else
%                     refWin = refdets(newEv-win:newEv+win);
%                 end
%                 condit = ((refch~=0) & (isempty(find(refWin==0,1)))) | (refch==0);
                if newEv-win < 1
    %                 refWin = refdets(1:newEv+win);
                    refWin = refdogged(1:newEv+win);
                    chanWin = dogged(i,1:newEv+win);
                elseif newEv+win > length(refdets)
    %                 refWin = refdets(newEv-win:end);
                    refWin = refdogged(newEv-win:end);
                    chanWin = dogged(i,newEv-win:end);
                else
    %                 refWin = refdets(newEv-win:newEv+win);
                    refWin = refdogged(newEv-win:newEv+win);
                    chanWin = dogged(i,newEv-win:newEv+win);
                end
                r = corrcoef(refWin,chanWin);
                
%                 subplot(211)
%                 plot(chanWin)
%                 title(['Chan',num2str(i),'   PotentialEvent ',...
%                     num2str(j)])
%                 subplot(212)
%                 plot(refWin)
%                 title(['Refchan window, corr = ',num2str(r(2))])
%                 waitforbuttonpress
                
                condit = ((refch~=0) & (abs(r(2))<0.6)) | (refch==0);
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
        figure('Name',['Chan#',num2str(i)])

        sp1=subplot(311);
        plot(taxis,dogged(i,:))
        hold on
        plot(taxis,dets(i,:),'*r')
        xlabel('Time [s]')
        ylabel('Voltage [\muV]')
        title(['DoG of channel #',num2str(i)])

        sp2=subplot(312);
        plot(taxis,instPowd(i,:))
        hold on
        plot(taxis,dets(i,:),'*r')
        hold on
        plot(taxis,thr*ones(1,length(taxis)),'-g')
        hold on
        plot(taxis,quietthr*ones(1,length(taxis)),'-k')
        hold on
        plot(taxis,qSegsInds,'-m')
        xlabel('Time [s]')
        ylabel('Power [\muV^2]')
        title(['Instantaneous Power of channel #',num2str(i)])
        legend({'Inst.Power','Detections','Detection threshold',...
            'Threshold for quiet intervals','Quiet intervals'})

        sp3=subplot(313);
        plot(taxis,belowRefThr)
        hold on
        plot(taxis,aboveRefThr,'-r')
        hold off
%         if refVal ==1
%             plot(taxis,belowRefThr)
%             hold on 
% %             plot(taxis,refDetMarks,'*r')
%             plot(taxis,aboveRefThr,'-r')
%         elseif refVal == 2
%             temp = refdogged;
%             temp(refDetIVs) = nan;
%             plot(taxis,temp)
%             hold on
% %             plot(taxis,refDetMarks,'*r')
%             temp = nan(1,length(data));
%             temp(refDetIVs) = refdogged(refDetIVs);
%             plot(taxis,temp,'-r')
%         end
        xlabel('Time [s]')
        ylabel('Voltage [\muV]')
        title('DoG of reference channel')
        legend({'DoG','Above threshold'})
        linkaxes([sp1,sp2,sp3],'x')
    end
end

if refVal == 1
    dets(refch,:) = refDetMarks;
end