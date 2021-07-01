function dets = DoGInstPowDet(data,fs,w1,w2,sdmult,minLen)

if size(data,1) > size(data,2)
    data = data';
end

fs = round(fs,4);
w1 = round(w1,4);
w2 = round(w2,4);
minLen = round(minLen,4);

% Computing DoG
dogged = DoG(data,fs,w1,w2);

% Instant Power
for i = 1:size(data,1)
    ripWindow  = pi / mean( [w1 w2] );
    powerWin   = makegausslpfir( 1 / ripWindow, fs, 4 );

    rip        = dogged(i,:);
    rip        = abs(rip);
    ripPower0  = firfilt( rip, powerWin );
    ripPower0  = max(ripPower0,[],2);

    instPow(i,:) = ripPower0;
end

% Detection part
dets = nan(size(data));
for i = 1:size(data,1)
    thr = mean(instPow(i,:)) + sdmult*std(instPow(i,:));
    currInstPow = instPow(i,:);
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
        dets(i,vEvents) = 0;
    else
        events = [events, length(steps)];

        for j = 1:length(events)
            if j == 1
                len = events(j)-1;
                if len > minLen*fs
                    [~,maxIdx] = max(currInstPow(1:aboveThr(events(j))));
                    vEvents = [vEvents, maxIdx];
                end
            else
                len = events(j)-events(j-1);
                if len > minLen*fs
                    [~,maxIdx] = max(currInstPow(aboveThr(events(j-1):events(j))));
                    vEvents = [vEvents, maxIdx+aboveThr(events(j-1))];
                end
            end
        end
        dets(i,vEvents) = 0;
    end
end