function bips = wavyDet(data,srate,minlen,sdmult,w1,w2)
%% Parameters
% srate = 20000;
if nargin ~= 0
    srate = round(srate,4);
    % mindist = 50;
    % runavgwindow = 0.25;
    % minlen = 0.02;
    minlen = round(minlen,4);
    % sdmult = 3;
    sdmult = round(sdmult,4);
    w1 = round(w1,4);
    w2 = round(w2,4);
end

%% Input data handling

if nargin == 0
    minlen = 0.02;
    sdmult = 3;
    w1 = 100;
    w2 = 250;
    srate = 20000;
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

%% Apply periodic filt
% data = periodicNoise(data,srate,1000);

%% Apply DoG (from BuzsakiLab)

% GFw1       = makegausslpfir( w1, srate, 6 );
% GFw2       = makegausslpfir( w2, srate, 6 );
% lfpLow     = firfilt( data, GFw2 );      % lowpass filter
% eegLo      = firfilt( lfpLow, GFw1 );   % highpass filter
% lfpLow     = lfpLow - eegLo;            % difference of Gaussians
% 
% dogged = lfpLow;

%% Wavelet filtered solution

% dogged = wavyfilt(data);
% data = dogged;

%% CWT

t = linspace(0,length(data)/srate,length(data));

mb = msgbox('Computing wavelet transform...');

figure
[coeffs,f,coi] = cwt(data,srate,'amor','FrequencyLimits',[w1 w2]);
cwt(data,srate,'amor','FrequencyLimits',[w1 w2]); 
coeffs = abs(coeffs);
% assignin('base','coeffs',coeffs)
% assignin('base','f',f)
% assignin('base','coi',coi)
%% Z-score

z_coeffs = (coeffs-mean(mean(coeffs)))/std(std(coeffs));
% assignin('base','zizz',z_coeffs)
delete(mb);

% figure('Name','Wavelet Transform','NumberTitle','off');
% 
% surface(t,f,z_coeffs);
% surface([min(t) max(t)],[min(f) max(f)],zeros(2,2),z_coeffs,...
%     'CDataMapping','scaled','FaceColor','texturemap','EdgeColor','None');
% colormap(parula(128));
% cb = colorbar;
% cb.Label.String = 'Z-Score';
% axis tight;
% % ylim([100 300]);
% title('Wavelet transform');
% ylabel('Frequency [Hz]');
% xlabel('Time [ms]');


%% Threshold calculation and detection

% % Standard mean+sd approach with running average
% colmean = mean(coeffs);
% colstd = std(coeffs);
% runavg = movmean(colmean,runavgwindow*srate);
% runstd = movstd(colstd,runavgwindow*srate);
% thr = runavg + sdmult*runstd;
% % thr = mean(mean(coeffs)) + sdmult*std(std(coeffs));
% assignin('base','thr',thr)
% coeffs_det = colmean;
% coeffs_det(coeffs_det<thr) = 0;
% coeffs_det(:,1:0.1*srate) = 0;
% coeffs_det(:,length(coeffs)-0.1*srate:end) = 0;
% assignin('base','coeffs_det',coeffs_det)
% [~,dets] = find(coeffs_det);
% dets = unique(dets);
% assignin('base','dets',dets)

% Instantaneous energy integral approach
% minlen = 0;
instE = trapz(abs(coeffs).^2);
thr = mean(instE) + sdmult*std(instE);
% assignin('base','thr',thr)
coeffs_det = instE;
coeffs_det(coeffs_det<thr) = 0;
coeffs_det(:,1:0.1*srate) = 0;
coeffs_det(:,length(coeffs)-0.1*srate:end) = 0;
% assignin('base','coeffs_det',coeffs_det)
[~,dets] = find(coeffs_det);
dets = unique(dets);
% assignin('base','dets',dets)

steps = diff(dets);
events = find(steps~=1);
events = events+1;
vEvents = [];

if (isempty(events)) && (length(dets) > minlen*srate)
    vEvents = dets(1);
else
    events = [events, length(steps)];
end

% assignin('base','events',events)

for i = 1:length(events)
    if i == 1
        len = events(i)-1;
        if len > minlen*srate
            vEvents = [vEvents, 1];
        end
    else
        len = events(i)-events(i-1);
        if len > minlen*srate
            vEvents = [vEvents, events(i-1)];
        end
    end
end
% assignin('base','vEvents',vEvents)

bips = zeros(1,length(t));
bips(:) = nan;
bips(dets(vEvents)) = 0;

% assignin('base','bips',bips)
% assignin('base','t',t)
% assignin('base','doggy',dogged)
%% Plotting
% 
% figure
% ax1 = subplot(2,1,1);
% plot(t,dogged)
% hold on
% plot(t,bips,'r*','MarkerSize',12)
% axis tight
% title('Detections based on CWT')
% xlabel('Time [s]')
% ylabel('Voltage [\muV]')
% ax2 = subplot(2,1,2);
% try
%     plot(t,instE)
% catch
%     plot(t,colmean)
% end
% hold on
% plot(t,ones(size(t))*thr)
% xlabel('Time [s]')
% ylabel('CWT coefficient magnitude')
% axis tight
% legend('Inst. Energy integral over all frequencies','threshold')
% linkaxes([ax1,ax2],'x')
% xlim([0.1 t(end)-0.1])
