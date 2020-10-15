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
        figure
        for i = 1:lvl
            alpha = median(abs(swd(i,:)))/0.6745;
            thr = alpha*sqrt(2*log(length(data_pad)));
            tres(i) = thr;
            temp = swd(i,:);
%             temp(abs(temp)>thr) = temp(abs(temp)>thr) - (thr^2)./temp(abs(temp)>thr);
%             temp(abs(temp)>thr) = thr;
            temp(abs(temp)>thr) = 0;
            art_inds{i,1} = find(temp(abs(temp)>thr));
            
            subplot(2,1,1)
            plot(swd(i,:))
            title(['lvl',num2str(i),' detail'])
            hold on
            line([1 length(temp)],[thr thr])
            hold on
            line([1 length(temp)],[-thr -thr])
            hold off
            subplot(2,1,2)
            plot(temp)
            title(['lvl',num2str(i),' detail thresholded'])
            hold on
            line([1 length(temp)],[thr thr])
            hold on
            line([1 length(temp)],[-thr -thr])
            hold off
            swd_thr(i,:) = temp;
            
            waitforbuttonpress
        end
        alpha = median(abs(swa(10,:)))/0.6745;
        thr = alpha*sqrt(2*log(length(data_pad)));
        swa_thr = swa(10,:);
%         swa_thr(abs(swa_thr)>thr) = swa_thr(abs(swa_thr)>thr) - (thr^2)./swa_thr(abs(swa_thr)>thr);
        swa_thr(abs(swa_thr)>thr) = 0;
        art_inds{1,2} = find(swa_thr(abs(swa_thr)>thr));
        assignin('base','swd',swd)
        assignin('base','swd_thr',swd_thr)
        assignin('base','tres',tres)
        
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