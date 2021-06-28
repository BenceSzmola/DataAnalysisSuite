function data_cl = ArtSupp(data,fs,meth,refchan)

%% Parameters

% fs = 20000;

%% Select algorithm

if nargin < 3
    list = {'wICA','classic ref subtract','Makarov wICA', 'my wICA','islam2014','ACAR/ANC'};
    [meth, tf] = listdlg('PromptString','Select cleaning algorithm!','ListString',list,'SelectionMode','single');
    if ~tf
        return
    end
end

%% Input data handling

if nargin == 0
    [filename,path] = uigetfile('*.rhd');
    oldpath = cd(path);
    data = read_Intan_RHD2000_file_szb(filename);
    data = data.amplifier_data;
    cd(oldpath)
    fs = 20000;
elseif nargin >= 2
    fs = round(fs,4);
end

if size(data,1)>size(data,2)
    data = data';
    disp('Input data was transposed')
end

t = linspace(0,length(data)/fs,length(data));

% % Independent Component Analysis
% 
% [icaEEG,A,W]=fastica(data); % Finding the ICs
% figure;
% PlotEEG(icaEEG,fs,[],[],'Independent components')
% 
% assignin('base','icaEEG',icaEEG)

%% Different methods
switch meth
    case 3
%% wICA style suppression (Makarov et al)

        % Independent Component Analysis 
        [icaEEG,A,W]=fastica(data); % Finding the ICs
        figure;
        PlotEEG(icaEEG,fs,[],[],'Independent components')
        
        assignin('base','icaEEG',icaEEG)
        nICs = 1:size(icaEEG,1); % Components to be processed, e.g. [1, 4:7]
        Kthr = 1.25;             % Tolerance for cleaning artifacts, try: 1, 1.15,...
        ArtefThreshold = 4;      % Threshold for detection of ICs with artefacts
                                 % Set lower values if you manually select ICs with 
                                 % artifacts. Otherwise increase
        verbose = 'on';          % print some intermediate results                         

        icaEEG2 = RemoveStrongArtifacts(icaEEG, nICs, Kthr, ArtefThreshold, fs, verbose); 

%         figure('color','w');
%         PlotEEG(icaEEG2, fs, [], [], 'wavelet filtered ICs');

        data_cl = A*icaEEG2;
%         figure
%         PlotEEG(data,fs,[],[],'Raw LFP')
%         figure('color','w');
%         PlotEEG(data_cl, fs, [], [], 'wICA cleaned LFP');

        figure('Name','Makarov wICA')
        j = 1;
        for i = 1:size(data,1)
            sp1 = subplot(size(data,1),2,j);
            j = j+1;
            plot(t,data(i,:))
            title(['Raw LFP - ch#',num2str(i)])
            xlabel('Time [s]')
            ylabel('Voltage [\muV]')
            axis tight
            sp2 = subplot(size(data,1),2,j);
            plot(t,data_cl(i,:))
            title(['Cleaned LFP - ch#',num2str(i)])
            xlabel('Time [s]')
            ylabel('Voltage [\muV]')
            axis tight
            linkaxes([sp1,sp2],'xy')
            j = j+1;
        end
        assignin('base','icaEEG2',icaEEG2)
        assignin('base','data_cl',data_cl)
        
    case 4
%% Own version of wICA
        
        % Independent Component Analysis 
        [icaEEG,A,W]=fastica(data); % Finding the ICs
        
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
        t_ext = linspace(0,length(data_cl)/fs,length(data_cl));

        figure('Name','Makarov wICA')
        j = 1;
        for i = 1:size(data,1)
            sp1 = subplot(size(data,1),2,j);
            j = j+1;
            plot(t,data(i,:))
            title(['Raw LFP - ch#',num2str(i)])
            xlabel('Time [s]')
            ylabel('Voltage [\muV]')
            axis tight
            sp2 = subplot(size(data,1),2,j);
            plot(t_ext,data_cl(i,:))
            title(['Cleaned LFP - ch#',num2str(i)])
            xlabel('Time [s]')
            ylabel('Voltage [\muV]')
            axis tight
            linkaxes([sp1,sp2],'xy')
            j = j+1;
        end
        
        assignin('base','icaEEG_cl',icaEEG_cl)
        assignin('base','data_cl',data_cl)
   
    case 5
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
        
    case 1
        %% Different kind of wICA
        
        lvl = 14;
        wname = 'db4';
        corrthr = 0.7;
        if nargin < 4
            refchan = inputdlg('# of reference channel');
            refchan = str2double(refchan{:});
        end
        
        mult = ceil(length(data)/2^lvl);
        data_pad = [data,zeros(size(data,1),mult*2^lvl-length(data))];
        
        corrupts = zeros(min(size(data)),lvl+1);
        
        % find the corrupted wavelet components based on correlation with
        % the reference
        [swa_ref,swd_ref] = swt(data_pad(refchan,:),lvl,wname);
        refMat = [swd_ref;swa_ref(end,:)];
        refIca = fastica(refMat);
        
        for i = 1:min(size(data))
            if i ~= refchan
                [swa,swd] = swt(data_pad(i,:),lvl,wname);
                for j = 1:(lvl+1)
                    if j <= lvl                        
                        rho = corrcoef(swd(j,:),swd_ref(j,:));
                        rho = rho(2);
                        if rho > corrthr
                            corrupts(i,j) = 1;
                        end
                        
%                         tf = figure;
%                         subplot(211)
%                         plot(swd(j,:))
%                         title('sig')
%                         subplot(212)
%                         plot(swd_ref(j,:))
%                         title(['ref, corr=',num2str(rho)])
%                         waitforbuttonpress
%                         close(tf)
                        
                    elseif j == lvl+1
                        rho = corrcoef(swa(lvl,:),swa_ref(lvl,:));
                        rho = rho(2);
                        if rho > corrthr
                            corrupts(i,lvl+1) = 1;
                        end
                    end
                end
            end
        end
        assignin('base','corrupts',corrupts)
        
        data_cl = zeros(size(data_pad));        
        for i = 1:size(corrupts,1)
            temp = find(corrupts(i,:));
            assignin('base','cortemp',temp)
            if isempty(temp)
                continue
            end
            [swa,swd] = swt(data_pad(i,:),lvl,wname);
            if ~isempty(find(temp==lvl+1))
                tempMat = [swd(temp(1:end-1),:);swa(end,:)];
            else
                tempMat = swd(temp,:);
            end
            assignin('base','tempMat',tempMat)
            [icaSwt,A,W] = fastica(tempMat);
            icfig = figure;
            for j = 1:length(temp)
                sp1 = subplot(311);
                plot(icaSwt(j,:))
                title(['IC #',num2str(j),' - channel #',num2str(i)])
                sp2 = subplot(312);
                plot(data(i,:))
                title(['Raw LFP - channel #',num2str(i)])
                sp3 = subplot(313);
                plot(data(refchan,:))
                title('Raw LFP - reference channel')
                linkaxes([sp1,sp2,sp3],'x')
                decision = questdlg('Keep IC?');
                if strcmp(decision,'No')
%                     icaSwt(j,:) = 0;
                    A(j,:) = 0;
                end
            end
            close(icfig)
            tempMat_cl = A*icaSwt;
            assignin('base','tempMat_cl',tempMat_cl)
            if ~isempty(find(temp==lvl+1))
                swd(temp(1:end-1),:) = tempMat_cl(1:end-1,:);
                swa(end,:) = tempMat_cl(end,:);
            else
                swd(temp,:) = tempMat_cl;
            end
            data_cl(i,:) = iswt(swa(end,:),swd,wname);
        end
        data_cl = data_cl(:,1:length(data));
        data_cl(refchan,:) = data(refchan,:);
%         assignin('base','data_cl',data_cl)
        
        figure('Name','wICA')
        j = 1;
        for i = 1:size(data,1)
            if i ~= refchan
                sp1 = subplot(size(data,1)-1,2,j);
                j = j+1;
                plot(t,data(i,:))
                title(['Raw LFP - ch#',num2str(i)])
                xlabel('Time [s]')
                ylabel('Voltage [\muV]')
                axis tight
                sp2 = subplot(size(data,1)-1,2,j);
                plot(t,data_cl(i,:))
                title(['Cleaned LFP - ch#',num2str(i)])
                xlabel('Time [s]')
                ylabel('Voltage [\muV]')
                axis tight
                linkaxes([sp1,sp2],'xy')
                j = j+1;
            end
        end
        
    case 6
        %% ACAR (Xinyu et al 2017) / ANC using refchan
        L = 1000; % length of filter tap
        u = 0.1; % step size to ensure stability
%         car = sum(data,1)/size(data,1);
        if nargin < 4
            refchan = inputdlg('# of reference channel');
            refchan = str2double(refchan{:});
        end
        ref = data(refchan,:);
%         pow = rms(ref)^2;
        pow = var(ref);
        sigchans = 1:size(data,1);
        sigchans(sigchans==refchan) = [];
        data_sig = data(sigchans,:);
        % trying removing mean
        data_sig = data_sig-mean(data_sig,2);
        data_cl = zeros(size(data));
        
%         wbank = zeros(length(sigchans),L);
%         for i = 1:length(sigchans)
%             w = zeros(1,L);
%             for j = L:length(data_sig)
%                 n_est = ref(j-L+1:j).*w;
%                 s_est = data_sig(i,j-L+1:j)-n_est;
%                 w = w+2*u*s_est.*ref(j-L+1:j)/(L*pow);
%             end
%             if mean(w) < 0
%                 w = -1*w;
%             end
%             wbank(i,:) = w;
%             data_cl(sigchans(i),:) = filter(w,1,data_sig(i,:));
%             ma = movmean(data_cl(sigchans(i),:),L/2);
%             data_cl(sigchans(i),:) = data_cl(sigchans(i),:)/L;
%         end
%         data_cl(refchan,:) = ref;
%         assignin('base','data_cl',data_cl)        
%         assignin('base','wbank',wbank)
        
        for i = 1:length(sigchans)
            w = ones(1,L);
%             w = 0;
            for j = L:length(data_sig)
                n_est = ref(j-L+1:j).*w;
%                 display(size(n_est))
                s_est = data_sig(i,j-L+1:j)-n_est;
%                 display(size(s_est))
                data_cl(sigchans(i),j-L+1:j) = s_est;
                w = w+2*u*s_est*ref(j-L+1:j)'/(L*pow);
%                 display(size(w))
%                 display('break')
            end
%             data_cl(sigchans(i),:) = data_sig(i,:)-ref*w;
%             display(w)
        end
        data_cl(refchan,:) = ref;
%         assignin('base','data_cl',data_cl)  
        
        figure('Name','Adaptive filter')
        j = 1;
        for i = 1:size(data,1)
            sp1 = subplot(size(data,1),2,j);
            j = j+1;
            plot(t,data(i,:))
            title(['Raw LFP - ch#',num2str(i)])
            xlabel('Time [s]')
            ylabel('Voltage [\muV]')
            axis tight
            sp2 = subplot(size(data,1),2,j);
            plot(t,data_cl(i,:))
            title(['Cleaned LFP - ch#',num2str(i)])
            xlabel('Time [s]')
            ylabel('Voltage [\muV]')
            axis tight
            linkaxes([sp1,sp2],'xy')
%             ylim([-2000 2000])
            j = j+1;
        end
        
%         figure
%         dogi=DoG(data_cl,20000,150,250);
%         dogclassic = DoG(data-data(5,:),20000,150,250);
%         dognoncl = DoG(data,20000,150,250);
%         sp1=subplot(411);
%         plot(dogi(1,:))
%         title('DoG after prototype denoise')
%         sp2=subplot(412);
%         plot(dognoncl(1,:))
%         title('DoG from raw')
%         sp3=subplot(413);
%         plot(dogclassic(1,:))
%         title('DoG with classic subtraction')
%         sp4=subplot(414);
%         plot(dognoncl(5,:))
%         title('DoG of refchan')
%         linkaxes([sp1,sp2,sp3,sp4],'x')
        
    case 2
        %% classic refchan subtraction
        if nargin < 4
            refchan = inputdlg('# of reference channel');
            refchan = str2double(refchan{:});
        end
        ref = data(refchan,:);
        sigchans = 1:size(data,1);
        sigchans(sigchans==refchan) = [];

        data_cl = data;
        data_cl(sigchans,:) = data_cl(sigchans,:) - ref;
%         assignin('base','data_cl',data_cl)
        
        figure('Name','Classic subtraction')
        j = 1;
        for i = 1:size(data,1)
            sp1 = subplot(size(data,1),2,j);
            j = j+1;
            plot(t,data(i,:))
            title(['Raw LFP - ch#',num2str(i)])
            xlabel('Time [s]')
            ylabel('Voltage [\muV]')
            axis tight
            sp2 = subplot(size(data,1),2,j);
            plot(t,data_cl(i,:))
            title(['Cleaned LFP - ch#',num2str(i)])
            xlabel('Time [s]')
            ylabel('Voltage [\muV]')
            axis tight
            linkaxes([sp1,sp2],'xy')
            j = j+1;
        end
        
end

%% Performance evaluation
% 
% answer = questdlg('Lauch performance evaluation?','Performance evaluation');
% if strcmp(answer,'Yes')
%     refchan = inputdlg('# of reference channel or 0 if you want to run on all');
%     refchan = str2double(refchan{:});
%     ref = data(refchan,:);
%     sigchans = 1:size(data,1);
%     sigchans(sigchans==refchan) = [];
%     
%     tempfig = figure;
%     spcell = cell(1,size(data,1));
%     for i = 1:size(data,1)
%         sp = subplot(size(data,1),1,i);
%         spcell{i} = sp;
%         plot(t,data(i,:))
%         title(['Original LFP, channel#',num2str(i)])
%     end
%     linkaxes([spcell{1},spcell{2},spcell{3},spcell{4},spcell{5}],'x')
%     noiseregion = inputdlg('Noise_begin noise_end (in [s])');
%     cleanregion = inputdlg('Clean_begin clean_end (in [s])');
%     close(tempfig)
%     assignin('base','noiseregion',noiseregion)
%     assignin('base','cleanregion',cleanregion)
%     
%     noise_borders = sscanf(noiseregion{:},'%f %f');
%     clean_borders = sscanf(cleanregion{:},'%f %f');
%     
%     if abs(diff(noise_borders)) == abs(diff(clean_borders))
%         mysnr_raw = sum(sum(data(sigchans,clean_borders(1)*fs:clean_borders(2)*fs).^2,2))/...
%             sum(sum(data(sigchans,noise_borders(1)*fs:noise_borders(2)*fs).^2,2));
%         mysnr_raw_dB = 10*log10(mysnr_raw);
%         
%         mysnr_cl = sum(sum(data_cl(sigchans,clean_borders(1)*fs:clean_borders(2)*fs).^2,2))/...
%         sum(sum(data_cl(sigchans,noise_borders(1)*fs:noise_borders(2)*fs).^2,2));
%         mysnr_cl_dB = 10*log10(mysnr_cl);
%         
% %         mysnr_raw = var(data(sigchans,clean_borders(1)*fs:clean_borders(2)*fs))/...
% %             var(data(sigchans,noise_borders(1)*fs:noise_borders(2)*fs));
% %         mysnr_raw_dB = 10*log10(mysnr_raw);
% %         mysnr_cl = var(data_cl(sigchans,clean_borders(1)*fs:clean_borders(2)*fs))/...
% %             var(data_cl(sigchans,noise_borders(1)*fs:noise_borders(2)*fs));
% %         mysnr_cl_dB = 10*log10(mysnr_cl);
%     else
%         fprintf(1,'Specified segments have different lengths -> normalizing\n')
%         mysnr_raw1 = sum(sum(data(sigchans,clean_borders(1)*fs:clean_borders(2)*fs).^2,2))/...
%             (abs(diff(clean_borders))*fs*length(sigchans));
%         mysnr_raw2 = sum(sum(data(sigchans,noise_borders(1)*fs:noise_borders(2)*fs).^2,2))/...
%             (abs(diff(noise_borders))*fs*length(sigchans));
%         mysnr_raw = mysnr_raw1/mysnr_raw2;
%         
%         mysnr_raw_dB = 10*log10(mysnr_raw);
%         
%         mysnr_cl1 = sum(sum(data_cl(sigchans,clean_borders(1)*fs:clean_borders(2)*fs).^2,2))/...
%             (abs(diff(clean_borders))*fs*length(sigchans));
%         mysnr_cl2 = sum(sum(data_cl(sigchans,noise_borders(1)*fs:noise_borders(2)*fs).^2,2))/...
%             (abs(diff(noise_borders))*fs*length(sigchans));
%         mysnr_cl = mysnr_cl1/mysnr_cl2;
%         
%         mysnr_cl_dB = 10*log10(mysnr_cl);
%     end
%     
%     fprintf(1,'Raw SNR = %f\ncleaned SNR = %f\n',mysnr_raw,mysnr_cl)
%     fprintf(1,'In dB: %f dB; %f dB\n',mysnr_raw_dB,mysnr_cl_dB)
%     fprintf(1,'deltaSNR = %f [dB]\n',mysnr_cl_dB-mysnr_raw_dB)
% end

%% Shared visualizer part (might or might not keep)
% %% Apply DoG (from BuzsakiLab)
% 
% wb = waitbar(0,'Calculating DoG');
% 
% waitbar(1/2,wb,'Calculating DoG from original LFP')
% dogged = DoG(data,fs,4,12);
% 
% waitbar(2/2,wb,'Calculating DoG from cleaned LFP')
% dogged_cl = DoG(data_cl,fs,4,12);
% close(wb)
% 
% t = linspace(0,length(data)/fs,length(data));
% t_pad = linspace(0,length(data_pad)/fs,length(data_pad));
% 
% figure
% j = 1;
% for i = 1:size(data,1)
%     subplot(size(data,1),2,j)
%     j = j+1;
%     plot(t,data(i,:))
%     title(['Original - ch#',num2str(i)])
%     subplot(size(data,1),2,j)
%     plot(t_pad,data_cl(i,:))
%     title(['Cleaned - ch#',num2str(i)])
%     j = j+1;
% end
% 
% figure
% PlotEEG(dogged,fs,[],[],'DoG from uncleaned')
% figure;
% PlotEEG(dogged_cl,fs,[],[],'DoG from cleaned')
% 
% % figure
% % ax1 = subplot(211);
% % plot(dogged(chan,:))
% % title('Uncleaned DoG')
% % ax2 = subplot(212);
% % plot(dogged_cl)
% % title('Cleaned DoG')
% % linkaxes([ax1,ax2],'x')
% 
% assignin('base','dogged',dogged)
% assignin('base','dogged_cl',dogged_cl)