function dets = DoGInstPowDet(data,fs,w1,w2,sdmult,minLen,refch)

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
end

% Instant Power
instPow = zeros(size(data));
for i = 1:size(data,1)
    ripWindow  = pi / mean( [w1 w2] );
    powerWin   = makegausslpfir( 1 / ripWindow, fs, 4 );

    rip        = dogged(i,:);
    rip        = abs(rip);
    ripPower0  = firfilt( rip, powerWin );
    ripPower0  = max(ripPower0,[],2);

    instPow(i,:) = ripPower0;
end

if refVal == 2
    ripWindow  = pi / mean( [w1 w2] );
    powerWin   = makegausslpfir( 1 / ripWindow, fs, 4 );

    rip        = refdogged;
    rip        = abs(rip);
    ripPower0  = firfilt( rip, powerWin );
    ripPower0  = max(ripPower0,[],2);

    refInstPow = ripPower0;
end

% Detection part
% if (refVal == 0) | (refVal == 2)
    dets = nan(size(data));
% elseif refVal == 1
%     dets = nan(size(data,1)-1,size(data,2));   
% end
refdets = nan(1,length(data));

if (refch ~= 0)
    if refVal == 2
        thr = mean(refInstPow) + sdmult*std(refInstPow);
        refdets(refInstPow>thr) = 0;
    else
        thr = mean(instPow(refch,:)) + sdmult*std(instPow(refch,:));
        refdets(instPow(refch,:)>thr) = 0;
    end
    refdetsInds = find(refdets==0);
    for i = 1:length(refdetsInds)
        if i ~= length(refdetsInds)
            if (refdetsInds(i+1) - refdetsInds(i)) < 0.2*fs
                refdets(refdetsInds(i):refdetsInds(i+1)) = 0;
            end
        end
    end
end

for i = 1:size(data,1)
    if i == refch
        continue
    end
    
    % Determining background noise segments
    currInstPow = instPow(i,:);
    quietthr = mean(currInstPow) + std(currInstPow);
    quietSegs = currInstPow(currInstPow < quietthr);
    qSegsInds = currInstPow;
    qSegsInds(currInstPow>=quietthr) = nan;
    
    
    thr = mean(quietSegs) + sdmult*std(quietSegs);
    
%     thr = mean(instPow(i,:)) + sdmult*std(instPow(i,:));
%     currInstPow = instPow(i,:);
    temp = instPow(i,:);
    
    temp(temp < thr) = 0;
    [~,aboveThr] = find(temp);
    aboveThr = unique(aboveThr);
    steps = diff(aboveThr);
    events = find(steps ~= 1);
    events = events + 1;
    vEvents = [];
    
    if (isempty(events)) && (length(aboveThr) > minLen*fs)

        [~,maxIdx] = max(currInstPow(aboveThr));
        vEvents = maxIdx + aboveThr(1);
        
        % validating against refch
        if ((refch~=0) & (refdets(vEvents)~=0)) | (refch==0)       
            dets(i,vEvents) = 0;
        end
        
    else
        events = [events, length(steps)];

        for j = 1:length(events)
            if j == 1
                len = events(j)-1;
                if len > minLen*fs
                    [~,maxIdx] = max(currInstPow(1:aboveThr(events(j))));
                    if ((refch~=0) & (refdets(maxIdx)~=0)) | (refch==0)
                        vEvents = [vEvents, maxIdx];
                    end
                end
            else
                len = events(j)-events(j-1);
                if len > minLen*fs
                    [~,maxIdx] = max(currInstPow(aboveThr(events(j-1):events(j))));
                    if ((refch~=0) & (refdets(maxIdx+aboveThr(events(j-1)))~=0)) | (refch==0)
                        vEvents = [vEvents, maxIdx+aboveThr(events(j-1))];
                    end
                end
            end
        end
        dets(i,vEvents) = 0;
    end
    
    % plotting part mainly for bugfixing
    t=linspace(0,length(data)/fs,length(data));
    figure('Name',['Chan#',num2str(i)])
    sp1=subplot(311);
    plot(t,dogged(i,:))
    hold on
    plot(t,dets(i,:),'*r')
    sp2=subplot(312);
    plot(t,instPow(i,:))
    hold on
    plot(t,dets(i,:),'*r')
    hold on
    plot(t,thr*ones(1,length(t)),'-g')
    hold on
    plot(t,quietthr*ones(1,length(t)),'-k')
    hold on
    plot(t,qSegsInds,'-y')
    sp3=subplot(313);
    if refVal ==1
        plot(t,dogged(refch,:))
        hold on 
        plot(t,refdets,'*r')
    elseif refVal == 2
        plot(t,refdogged)
        hold on
        plot(t,refdets,'*r')
    end
    linkaxes([sp1,sp2,sp3],'x')
end

if refVal == 1
    dets(refch,:) = refdets;
end