function adaptive_thresh(data)

srate = 20000;
dt = 1/srate;
step = 0.1;
win = step*2;
upthr = 4;
lowthr = 2.5;

if nargin == 0
    [filename,path] = uigetfile('*.rhd');
    oldpath = cd(path);
    data = read_Intan_RHD2000_file_cl(filename);
    cd(oldpath)
    data = data.amplifier_data(1,:);
end
tax = 0:dt:(length(data)*dt)-dt;

%%% Apply DoG (from BuzsakiLab)
GFw1       = makegausslpfir( 150, srate, 6 );
GFw2       = makegausslpfir( 250, srate, 6 );
lfpLow     = firfilt( data, GFw2 );      % lowpass filter
eegLo      = firfilt( lfpLow, GFw1 );   % highpass filter
lfpLow     = lfpLow - eegLo;            % difference of Gaussians

dogged = lfpLow;

% %%% Instantaneous power (from BuzsakiLab)
% ripWindow  = pi / mean( [w1 w2] );
% powerWin   = makegausslpfir( 1 / ripWindow, srate, 4 );
% 
% rip        = dogged(:,i);
% rip        = abs(rip);
% ripPower0  = firfilt( rip, powerWin );
% ripPower0  = max(ripPower0,[],2);
% 
% power(:,i) = ripPower0;

% % %  Z score the bandpass filtered signal
avg = mean(dogged);
sd = std(dogged);
z_dog = (dogged-avg)./sd;

% % % Calculate its envelope
envel = hilbert(z_dog);
envel = abs(envel);
assignin('base','env',envel)

% fig=figure;
% plot(dogged) 
% hold on
% plot(envel,'r')
% hold off

% % % Smoothing with Gaussian window
gw = gausswin(0.02*srate);
smoothie = conv(envel,gw,'same');
assignin('base','smoothie',smoothie)

% fig=figure;
% sp1=subplot(2,1,1);
% plot(envel) 
% sp2=subplot(2,1,2);
% plot(smoothie,'r')
% linkaxes([sp1,sp2],'x')

% % % Peak finding on smoothed signal
[piks,inds] = findpeaks(smoothie);
assignin('base','piks',piks)
assignin('base','inds',inds)

tps = tax(inds);

% % % sliding window histogram over peaks
% histo = zeros(length(0:200:max(smoothie)),length(1:step*srate:length(smoothie)));
% ii=1;
% for i = 1:step*srate:length(smoothie)
%     currinds = find(inds >= i & inds < (i+win*srate));
%     currbin = piks(currinds);
%     for j = 1:size(histo,1)
%         currbins2 = currbin(currbin >= (j-1)*200 & currbin < j*200);
%         histo(j,ii) = sum(currbins2);
%     end
%     ii = ii+1;
% end
% assignin('base','histo',histo)
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
assignin('base','histo',histo)
assignin('base','vbins',vbins)

% % % Sliding window mean
sliding_avg = zeros(1,length(smoothie));
detections = [];
for i = 1:step*srate:length(smoothie)
    try
        currstep = smoothie(i:(i+win*srate)-1);
    catch 
        currstep = smoothie(i:end);
    end
    curravg = mean(currstep);
    if i+win*srate-1 <= size(sliding_avg,2)
        sliding_avg(1,i:i+win*srate-1) = curravg;
    else
        sliding_avg(1,i:end) = curravg;
    end
    range = find(vbins >= sliding_avg(i)*lowthr & vbins <= sliding_avg(i)*upthr);
    if ~isempty(find(histo(range,i)))
        detections = [detections; i];
    end
end
assignin('base','sliding_avg',sliding_avg)
assignin('base','detections',detections)

% % % Histogram meg thresholdok abrazolasa
fig = figure;
imagesc(tax,vbins,histo)
set(gca,'YDir','normal')
colormap(hot)
colorbar
hold on
plot(tax,sliding_avg*upthr,'w')
hold on
plot(tax,sliding_avg*lowthr,'g')
hold on
detections = detections/srate;
for i = 1:length(detections)
    line([detections(i) detections(i)], [min(smoothie) max(smoothie)],'Color','cyan')
end