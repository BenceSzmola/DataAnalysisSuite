function wavyDet(data)
%% Parameters

srate = 20000;
mindist = 50;
sdmult = 3;

%% Input data handling

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

%% Apply DoG (from BuzsakiLab)

GFw1       = makegausslpfir( 150, srate, 6 );
GFw2       = makegausslpfir( 250, srate, 6 );
lfpLow     = firfilt( data, GFw2 );      % lowpass filter
eegLo      = firfilt( lfpLow, GFw1 );   % highpass filter
lfpLow     = lfpLow - eegLo;            % difference of Gaussians

dogged = lfpLow;

%% Wavelet filtered solution

% dogged = wavyfilt(data);
% data = dogged;

%% CWT

t = linspace(0,length(data)/srate,length(data))*1000;

mb = msgbox('Computing wavelet transform...');

figure
[coeffs,f,coi] = cwt(data,srate,'FrequencyLimits',[150 250]);
cwt(data,srate,'amor','FrequencyLimits',[150 250]); 
coeffs = abs(coeffs);
assignin('base','coeffs',coeffs)
assignin('base','f',f)
assignin('base','coi',coi)
%% Z-score

z_coeffs = (coeffs-mean(mean(coeffs)))/std(std(coeffs));
assignin('base','zizz',z_coeffs)
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

colmax = max(coeffs);
colavg = mean(colmax);
colsd = std(colmax);
thr = colavg + sdmult*colsd;
assignin('base','thr',thr)
coeffs_det = coeffs;
coeffs_det(coeffs_det<thr) = 0;
coeffs_det(:,1:0.1*srate) = 0;
coeffs_det(:,length(coeffs)-0.1*srate:end) = 0;
assignin('base','coeffs_det',coeffs_det)
[~,dets] = find(coeffs_det);
dets = unique(dets);
for i = 1:length(dets)-1
    if (dets(i+1)-dets(i)) < 0.05*srate
        dets(i) = 0;
    end
end
dets(dets==0) = [];
bips = zeros(length(t),1);
bips(:) = nan;
bips(dets) = 0;

assignin('base','t',t)
assignin('base','doggy',dogged)
%% Plotting

figure
plot(t,dogged)
hold on
plot(t,bips,'r*','MarkerSize',12)
axis tight
title('Detections based on CWT')
xlabel('Time [ms]')