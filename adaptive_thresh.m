function csillag = adaptive_thresh(data,srate,step,minwidth,mindist,ratio)
%%
% srate = 20000;
srate = round(srate,4);
dt = 1/srate;
% step = 0.05;
step = round(step,4);
win = step*2;
upthr = 2.5;
lowthr = 1.5;%1.6;
% minwidth = 0.01;
minwidth = round(minwidth,4);
% mindist = 0.03;
midist = round(mindist,4);
% ratio = 0.99;


%%
if nargin == 0
    [filename,path] = uigetfile('*.rhd');
    oldpath = cd(path);
    data = read_Intan_RHD2000_file_cl(filename);
    cd(oldpath)
    goodch = input('Which is the leadchan?\n');
    refch = input('Which is the refchan?\n');
    if refch ~= 0
        data = data.amplifier_data(goodch,:)-data.amplifier_data(refch,:);
    else
        data = data.amplifier_data(goodch,:);
    end
end
tax = 0:dt:(length(data)*dt)-dt;


%% Apply DoG (from BuzsakiLab)
GFw1       = makegausslpfir( 150, srate, 6 );
GFw2       = makegausslpfir( 250, srate, 6 );
lfpLow     = firfilt( data, GFw2 );     % lowpass filter
eegLo      = firfilt( lfpLow, GFw1 );   % highpass filter
lfpLow     = lfpLow - eegLo;            % difference of Gaussians

dogged = lfpLow;

%% Wavelet filtering solution
% dogged = wavyfilt(data);

%% Instantaneous power (from BuzsakiLab)
% ripWindow  = pi / mean( [w1 w2] );
% powerWin   = makegausslpfir( 1 / ripWindow, srate, 4 );
% 
% rip        = dogged(:,i);
% rip        = abs(rip);
% ripPower0  = firfilt( rip, powerWin );
% ripPower0  = max(ripPower0,[],2);
% 
% power(:,i) = ripPower0;

%%  Z score the bandpass filtered signal
avg = mean(dogged);
sd = std(dogged);
z_dog = (dogged-avg)./sd;
% assignin('base','z_dog',z_dog)

%% Calculate its envelope
envel = hilbert(z_dog);
envel = abs(envel);
% assignin('base','env',envel)

% fig=figure;
% plot(dogged) 
% hold on
% plot(envel,'r')
% hold off

%% Smoothing with Gaussian window
gw = gausswin(0.02*srate);
smoothie = conv(envel,gw,'same');
% smoothie = imgaussfilt(envel,6);
% assignin('base','smoothie',smoothie)

% fig=figure;
% sp1=subplot(2,1,1);
% plot(envel) 
% sp2=subplot(2,1,2);
% plot(smoothie,'r')
% linkaxes([sp1,sp2],'x')

%% Peak finding on smoothed signal
[piks,inds] = findpeaks(smoothie);
% assignin('base','piks',piks)
% assignin('base','inds',inds)

tps = tax(inds);

%% sliding window histogram over peaks
vbins = linspace(min(smoothie),max(smoothie),100);
histo = zeros(length(vbins),length(smoothie));
for i = 1:step*srate:length(smoothie)
    currinds = find(inds >= i & inds < (i+win*srate));
    currbin = piks(currinds);
    for j = 1:size(histo,1)-1
        currbins2 = currbin(currbin >= vbins(j) & currbin <= vbins(j+1));
        if i+win*srate-1 <= size(histo,2)
            histo(j,i:i+win*srate-1) = length(currbins2);
        else
            histo(j,i:end) = length(currbins2);
        end
    end
end
% assignin('base','histo',histo)
% assignin('base','vbins',vbins)

%% Sliding window mean
sliding_avg = zeros(1,length(smoothie));
sliding_sd = zeros(1,length(smoothie));
detections = [];
for i = 1:step*srate:length(smoothie)
    try
        currstep = smoothie(i:(i+win*srate)-1);
    catch 
        currstep = smoothie(i:end);
    end
    curravg = mean(currstep);
    currsd = std(currstep);
    if i+win*srate-1 <= size(sliding_avg,2)
        sliding_avg(1,i:i+win*srate-1) = curravg;
        sliding_sd(1,i:i+win*srate-1) = currsd;
    else
        sliding_avg(1,i:end) = curravg;
        sliding_sd(1,i:end) = currsd;
    end
    currupthr = sliding_avg(i)+sliding_sd(i)*upthr;
    currlowthr = sliding_avg(i)+sliding_sd(i)*lowthr;
    range = find(vbins >= currlowthr & vbins <= currupthr);
    if ~isempty(find(histo(range,i)))
        detections = [detections; i];
    end
end
% assignin('base','sliding_avg',sliding_avg)
% assignin('base','detections',detections)

%% Histogram meg thresholdok abrazolasa
figure;
imagesc(tax,vbins,histo)
set(gca,'YDir','normal')
colormap(hot)
colorbar
title('Histogram from Hilbert envelope peaks')
xlabel('Time [s]')
ylabel('Voltage [\muV]')
% hold on
% plot(tax,sliding_avg*upthr,'w')
hold on
hist_low = plot(tax,sliding_avg*lowthr,'g');
hold off

figure
sp1=subplot(2,1,1);
% plot(tax,sliding_avg*upthr)
% hold on
lowline = plot(tax,sliding_avg*lowthr);
hold on
plot(tax,smoothie)
title('Hilbert envelope smoothed by Gaussian filter')
xlabel('Time [s]')
ylabel('Voltage [\muV]')
legend('Threshold','Hilbert envelope')
sp2=subplot(2,1,2);
plot(tax,z_dog)
title('DoG filtered LFP')
xlabel('Time [s]')
ylabel('Voltage [\muV]')
linkaxes([sp1,sp2],'x')

%% Detection based on num of peaks
biggs = 0;
for i = 1:length(sliding_avg)
    range = find(vbins <= sliding_avg(i)*lowthr);
    biggs = biggs + sum(histo(range,i));
end
while (biggs/sum(sum(histo))) < ratio
    biggs = 0;
    lowthr = lowthr + 0.01;
    for i = 1:length(sliding_avg)
        range = find(vbins <= sliding_avg(i)*lowthr);
        biggs = biggs + sum(histo(range,i));
    end
    fprintf(1,'ratio: %1.4f, thresh multiplier: %1.2f\n',(biggs/sum(sum(histo))),lowthr)
end
lowline.YData = sliding_avg*lowthr;
hist_low.YData = sliding_avg*lowthr;
drawnow

detettione = [];
for i = 2:length(smoothie)-1
    if (smoothie(i) > sliding_avg(i)*lowthr) && (smoothie(i) > smoothie(i-1)) && (smoothie(i) > smoothie(i+1))
        detettione = [detettione; i];
    end
end
for i = 1:length(detettione)
    %search lower intersection
    j = 1;
    while smoothie(detettione(i)-j) > sliding_avg(detettione(i)-j)*lowthr
        j = j+1;
    end
    lowend = detettione(i)-j;
    %search upper intersection
    j = 1;
    while smoothie(detettione(i)+j) > sliding_avg(detettione(i)+j)*lowthr
        j = j+1;
    end
    highend = detettione(i)+j;
    if (highend-lowend) < minwidth*srate
        detettione(i) = 0;
    end
end
detettione(detettione==0) = [];

for i = 1:length(detettione)-1
    if (detettione(i+1)-detettione(i)) < mindist*srate
        detettione(i) = 0;
    end
end
detettione(detettione==0) = [];

% assignin('base','detettione',detettione)

%% Show detecitons on dog
csillag = zeros(1,length(smoothie));
csillag(:) = nan;
csillag(detettione) = 0;
% figure
% plot(tax,z_dog)
% hold on
hold(sp2,'on')
plot(tax,csillag,'r*','MarkerSize',12)
legend('DoG','Detections')
axis tight
hold off