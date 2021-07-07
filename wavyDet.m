function bips = wavyDet(data,srate,minlen,sdmult,w1,w2,refch)
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
    if size(data,1) > size(data,2)
        data = data';
    end
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

%% Input data handling

% Usage from commandline
if nargin == 0
    minlen = 0.01;
    sdmult = 3;
    w1 = 5;
    w2 = 40;
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

bips = nan(size(data));
% bips(:) = nan;
t = linspace(0,length(data)/srate,length(data));

% Finding above threshold segments on refchan
if refVal ~= 0
    refdets = nan(1,length(data));
    switch refVal
        case 1
            refData = data(refch,:);
        case 2
            refData = refch;
    end
    [refCoeffs,~,~] = cwt(refData,srate,'amor','FrequencyLimits',[w1 w2]);
    refInstE = trapz(abs(refCoeffs).^2);
    refThr = mean(refInstE) + sdmult*std(refInstE);
    refdets(refInstE > refThr) = 0;
    refdetsInds = find(refdets==0);
    for i = 1:length(refdetsInds)
        if i ~= length(refdetsInds)
            if (refdetsInds(i+1) - refdetsInds(i)) < 0.2*fs
                refdets(refdetsInds(i):refdetsInds(i+1)) = 0;
            end
        end
    end
end

for i = 1:min(size(data))
    if i == refch
        continue
    end
    %% Apply periodic filt
    % data = periodicNoise(data,srate,1000);

    %% Apply DoG (from BuzsakiLab)

%     GFw1       = makegausslpfir( 150, srate, 6 );
%     GFw2       = makegausslpfir( 250, srate, 6 );
%     lfpLow     = firfilt( data(i,:), GFw2 );      % lowpass filter
%     eegLo      = firfilt( lfpLow, GFw1 );   % highpass filter
%     lfpLow     = lfpLow - eegLo;            % difference of Gaussians
% 
%     dogged = lfpLow;

    %% Wavelet filtered solution

    % dogged = wavyfilt(data);
    % data = dogged;

    %% CWT

    

    mb = msgbox('Computing wavelet transform...');

    figure
    [coeffs,f,coi] = cwt(data(i,:),srate,'amor','FrequencyLimits',[w1 w2]);
    cwt(data(i,:),srate,'amor','FrequencyLimits',[w1 w2]); 
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
    assignin('base','instE',instE)
    thr = mean(instE) + sdmult*std(instE);
    % assignin('base','thr',thr)
    coeffs_det = instE;
    coeffs_det(coeffs_det<thr) = 0;
    coeffs_det(:,1:0.1*srate) = 0;
    coeffs_det(:,length(coeffs)-0.1*srate:end) = 0;
    % assignin('base','coeffs_det',coeffs_det)
    [~,dets] = find(coeffs_det);
    dets = unique(dets);
%     assignin('base','dets',dets)

    steps = diff(dets);
    events = find(steps~=1);
    events = events+1;
    vEvents = [];
    % bips = zeros(size(data));
    % bips(:) = nan;

    if (isempty(events)) && (length(dets) > minlen*srate)

        [~,maxIdx] = max(instE(dets));
        vEvents = maxIdx + dets(1);
        if (refVal == 0) | ((refVal ~= 0) & (isnan(refdets(vEvents))))
            bips(i,vEvents) = 0;
        end
    else
        events = [events, length(steps)];

        for j = 1:length(events)
            if j == 1
                len = events(j)-1;
                if len > minlen*srate
                    [~,maxIdx] = max(instE(1:dets(events(j))));
    %                 vEvents = [vEvents, 1];
                    if (refVal == 0) | ((refVal ~= 0) & (isnan(refdets(maxIdx))))
                        vEvents = [vEvents, maxIdx];
                    end
                end
            else
                len = events(j)-events(j-1);
                if len > minlen*srate
                    [~,maxIdx] = max(instE(dets(events(j-1):events(j))));
    %                 vEvents = [vEvents, events(i-1)];
                    if (refVal == 0) | ((refVal ~= 0) & (isnan(refdets(maxIdx+dets(events(j-1))))))
                        vEvents = [vEvents, maxIdx+dets(events(j-1))];
                    end
                end
            end
        end
        bips(i,vEvents) = 0;
    end

%     assignin('base','events',events)

    % for i = 1:length(events)
    %     if i == 1
    %         len = events(i)-1;
    %         if len > minlen*srate
    %             vEvents = [vEvents, 1];
    %         end
    %     else
    %         len = events(i)-events(i-1);
    %         if len > minlen*srate
    %             vEvents = [vEvents, events(i-1)];
    %         end
    %     end
    % end

%     assignin('base','vEvents',vEvents)

    % bips = zeros(1,length(t));
    % bips(:) = nan;
    % bips(dets(vEvents)) = 0;

%     assignin('base','bips',bips)
    % assignin('base','t',t)
    % assignin('base','doggy',dogged)
    %% Plotting
%     
%     figure
%     
%     ax1 = subplot(311);
%     plot(t,data(i,:))
%     hold on
%     plot(t,bips(i,:),'r*','MarkerSize',12)
%     axis tight
%     if min(size(data)) == 1
%         title('Detections based on CWT')
%     else
%         title(['Detections based on CWT - Ch#',num2str(i)])
%     end
%     xlabel('Time [s]')
%     ylabel('Voltage [\muV]')
%     
%     ax2 = subplot(312);
%     try
%         plot(t,instE)
%     catch
%         plot(t,colmean)
%     end
%     hold on
%     plot(t,ones(size(t))*thr)
%     xlabel('Time [s]')
%     ylabel('CWT coefficient magnitude')
%     axis tight
%     legend('Inst. Energy integral over all frequencies','threshold')
%     
%     ax3 = subplot(313);
%     if refVal ~= 0
%         plot(t,refInstE)
%         hold on
%         plot(t,refdets,'*r')
%     end
%     
%     linkaxes([ax1,ax2,ax3],'x')
%     xlim([0.1 t(end)-0.1])
end

if refVal == 1
    bips(refch,:) = refdets;
end