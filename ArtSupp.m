function ArtSupp(data)

%% Parameters

fs = 20000;

%% Select algorithm

list = {'wICA', 'my_wICA','islam2014'};
[idx tf] = listdlg('PromptString','Select cleaning algorithm!','ListString',list,'SelectionMode','single');
if ~tf
    return
end

%% Input data handling

if nargin == 0
    [filename,path] = uigetfile('*.rhd');
    oldpath = cd(path);
    data = read_Intan_RHD2000_file_cl(filename);
    data = data.amplifier_data;
    cd(oldpath)
end

% Independent Component Analysis

[icaEEG,A,W]=fastica(data); % Finding the ICs
figure;
PlotEEG(icaEEG,fs,[],[],'Independent components')

assignin('base','icaEEG',icaEEG)

%% CWT of ICs

% for i = 1:size(data,1)
%     figure
%     cwt(icaEEG(i,:),'amor',fs,'FrequencyLimit',[0 500])
%     title(['Cwt of IC #',num2str(i)])
% end

switch idx
%% wICA style suppression (Makarov et al)
    case 1

        nICs = 1:size(icaEEG,1); % Components to be processed, e.g. [1, 4:7]
        Kthr = 1.25;             % Tolerance for cleaning artifacts, try: 1, 1.15,...
        ArtefThreshold = 4;      % Threshold for detection of ICs with artefacts
                                 % Set lower values if you manually select ICs with 
                                 % artifacts. Otherwise increase
        verbose = 'on';          % print some intermediate results                         

        icaEEG2 = RemoveStrongArtifacts(icaEEG, nICs, Kthr, ArtefThreshold, fs, verbose); 

        figure('color','w');
        PlotEEG(icaEEG2, fs, [], [], 'wavelet filtered ICs');

        data_cl = A*icaEEG2;
        figure
        PlotEEG(data,fs,[],[],'Raw LFP')
        figure('color','w');
        PlotEEG(data_cl, fs, [], [], 'wICA cleaned LFP');

        assignin('base','icaEEG2',icaEEG2)
        assignin('base','data_cl',data_cl)
        
    case 2
%% Own version of wICA
        
        lvl = 10;
        wb = waitbar(0,'Cleaning ICs...');
        mult = ceil(length(icaEEG)/2^lvl);
        icaEEG_cl = zeros(size(icaEEG,1),mult*2^lvl);
        for i = 1:size(icaEEG,1)
            waitbar(i/size(icaEEG,1),wb,['Cleaning IC #',num2str(i)])
%             [coeffs,f,coi] = cwt(icaEEG(i,:),fs,'amor');
            data_pad = [icaEEG(i,:),zeros(1,mult*2^lvl-length(icaEEG(i,:)))];
            [swa,swd] = swt(data_pad,lvl,'haar');
            for j = 1:lvl
                temp = swd(j,:);
                alpha = median(abs(temp))/0.6745;
                thr = alpha*sqrt(2*log(length(data_pad)));
                temp(abs(temp)>thr) = 0;
                swd(j,:) = temp;
            end
            temp = swa(end,:);
            alpha = median(abs(temp))/0.6745;
            thr = alpha*sqrt(2*log(length(data_pad)));
            temp(abs(temp)>thr) = 0;
            swa(end,:) = temp;
            
            icaEEG_cl(i,:) = iswt(swa(end,:),swd,'haar');
%             thr = thselect(abs(coeffs),'rigrsure');
%             coeffs(abs(coeffs)<=thr) = 0;
%             coeffs(abs(coeffs)>thr) = coeffs(abs(coeffs)>thr) - thr^2./(coeffs(abs(coeffs)>thr));
            
%             icaEEG_cl(i,:) = icwt(coeffs,'amor');
        end
        close(wb)
        
        data_cl = A*icaEEG_cl;
        
        figure
        PlotEEG(icaEEG_cl,fs,[],[],'Cleaned ICs')
        figure
        PlotEEG(data,fs,[],[],'Raw LFP')
        figure
        PlotEEG(data_cl,fs,[],[],'Cleaned LFP')
        
        assignin('base','icaEEG_cl',icaEEG_cl)
        assignin('base','data_cl',data_cl)
   
    case 3
%% based on islam2014 - need to integrate the time index detection
        lvl = 10;
        chan = 1;
        wname = 'bior1.5';
        mult = ceil(length(data(chan,:))/2^lvl);
        data_pad = [data(chan,:),zeros(1,mult*2^lvl-length(data(chan,:)))];
        [swa,swd] = swt(data_pad,lvl,wname);
        art_inds = {};
%         figure
        for i = 1:lvl
            alpha = median(abs(swd(i,:)))/0.6745;
            thr = alpha*sqrt(2*log(length(data_pad)));
            thr_det(i) = thr;
            temp = swd(i,:);
%             temp(abs(temp)>thr) = temp(abs(temp)>thr) - (thr^2)./temp(abs(temp)>thr);
%             temp(abs(temp)>thr) = thr;
%             temp(abs(temp)<=thr) = 0;
            art_inds{i,1} = find(abs(temp)>thr);
            
%             subplot(2,1,1)
%             plot(swd(i,:))
%             title(['lvl',num2str(i),' detail'])
%             hold on
%             line([1 length(temp)],[thr thr])
%             hold on
%             line([1 length(temp)],[-thr -thr])
%             hold off
%             subplot(2,1,2)
%             plot(temp)
%             title(['lvl',num2str(i),' detail thresholded'])
%             hold on
%             line([1 length(temp)],[thr thr])
%             hold on
%             line([1 length(temp)],[-thr -thr])
%             hold off
%             swd_thr(i,:) = temp;
%             
%             waitforbuttonpress
        end
        alpha = median(abs(swa(10,:)))/0.6745;
        thr_apr = alpha*sqrt(2*log(length(data_pad)));
        swa_thr = swa(10,:);
%         swa_thr(abs(swa_thr)>thr) = swa_thr(abs(swa_thr)>thr) - (thr^2)./swa_thr(abs(swa_thr)>thr);
%         swa_thr(abs(swa_thr)>thr) = 0;
        art_inds{1,2} = find(abs(swa_thr)>thr_apr);
        assignin('base','swd',swd)
%         assignin('base','swd_thr',swd_thr)
        assignin('base','tres',thr_det)
        assignin('base','artinds',art_inds)
        
        % Filtering
        spikeband = DoG(data(chan,:),fs,300,5000);
        badband = DoG(data(chan,:),fs,150,400);
%         [bh,ah] = butter(4,5000/(fs/2),'high');
%         high = filter(bh,ah,data(chan,:));
        high = DoG(data(chan,:),fs,5000,10000);
        thr_sp = (median(abs(spikeband))/0.6745)*sqrt(2*log(length(data(chan,:))));
        thr_bb = (median(abs(badband))/0.6745)*sqrt(2*log(length(data(chan,:))));
        thr_high = (median(abs(high))/0.6745)*sqrt(2*log(length(data(chan,:))));
        figure
        subplot(311)
        plot(spikeband)
        title('spike')
        subplot(312)
        plot(badband)
        title('badband')
        subplot(313)
        plot(high)
        title('highpass')
        
        inds = find(~cellfun('isempty', art_inds));
%         for i = 1:length(inds)
%             for j = 1:length(art_inds{i})
%                 if art_inds{i}(j) <= length(data(chan,:))
%                     idx = art_inds{i}(j);
%                     if (abs(badband(idx)) < thr_bb) || (abs(high(idx)) < thr_high)
%                         if (abs(spikeband(idx)) > thr_sp)
%                             % not an artifact index
%                             art_inds{i}(j) = nan;
%                         else
%                             % is an artifact index
%                         end
%                     else
%                         % is an artifact
%                     end
%                 end
%             end
%         end
%         assignin('base','artinds2',art_inds)
        
        % Thresholding coefficients
        swd_thr = swd;
        swa_thr = swa(end,:);
        for i = 1:length(inds)
            for j = 1:length(art_inds{i})
                idx = art_inds{i}(j);
                if ~isnan(idx)
                    if i~=length(inds)
%                         swd_thr(i,idx) = swd(i,idx) - (thr_det(i)^2)./swd(i,idx);
                        swd_thr(i,idx) = thr_det(i);
                    else
%                         swa_thr(idx) = swa_thr(idx) - (thr_apr^2)./swa_thr(idx);
                        swa_thr(idx) = thr_apr;
                    end
                end
            end
        end
        assignin('base','swd_thr',swd_thr)
        assignin('base','swa_thr',swa_thr)
        
        figure
        for i = 1:10
            subplot(2,1,1)
            plot(swd(i,:))
            title(['lvl',num2str(i),' detail'])
            hold on
            line([1 length(swd(i,:))],[thr_det(i) thr_det(i)])
            hold on
            line([1 length(swd(i,:))],[-thr_det(i) -thr_det(i)])
            hold off
            subplot(2,1,2)
            plot(swd_thr(i,:))
            title(['lvl',num2str(i),' detail thresholded'])
            hold on
            line([1 length(swd(i,:))],[thr_det(i) thr_det(i)])
            hold on
            line([1 length(swd(i,:))],[-thr_det(i) -thr_det(i)])
            hold off

            waitforbuttonpress
        end
        
        data_cl = iswt(swa_thr,swd_thr,wname);
        figure
        ax1=subplot(211);
        plot(data_pad)
        title('original lfp')
        ax2=subplot(212);
        plot(data_cl)
        title('reconstructed lfp')
        linkaxes([ax1,ax2],'x')
end

%% Apply DoG (from BuzsakiLab)

wb = waitbar(0,'Calculating DoG');

waitbar(1/2,wb,'Calculating DoG from original LFP')
dogged = DoG(data,fs,4,12);

waitbar(2/2,wb,'Calculating DoG from cleaned LFP')
dogged_cl = DoG(data_cl,fs,4,12);
close(wb)

figure;
PlotEEG(dogged,fs,[],[],'DoG from uncleaned')
figure;
PlotEEG(dogged_cl,fs,[],[],'DoG from cleaned')

% figure
% ax1 = subplot(211);
% plot(dogged(chan,:))
% title('Uncleaned DoG')
% ax2 = subplot(212);
% plot(dogged_cl)
% title('Cleaned DoG')
% linkaxes([ax1,ax2],'x')

assignin('base','dogged',dogged)
assignin('base','dogged_cl',dogged_cl)