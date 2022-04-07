function [data_filt,f_fund] = periodicNoise(data,fs,fmax,f_fund,stopbandwidth)

% Detect and filter out periodic Noise (fundamental and harmonics)
% data_filt = periodicNoise(data,fs,fmax,f_fund,stopbandwidth)
% fs : sampling frequency
% fmax : manually set maximal frequency up to which the algorithm will filter
% f_fund : manually specify the fundamental frequency of the noise
% stopbandwidth :  how many Hz the filter should cut out around the noise
% input [] if you dont want to specify something

if nargin == 0
    prompt = {'Sampling frequency [Hz]:',...
        'Upper frequency limit for filtering (if left empty the algorithm will run until fs/2) [Hz]:',...
        'Fundamental frequency of the periodic noise (if not given, the algorithm will find it) [Hz]:',...
        'Stopband width [Hz]:'};
    title = 'Parameter input for periodic noise filter';
    definput = {'20000','1000','','5'};
    opts.Interpreter = 'tex';
    parameters = inputdlg(prompt,title,1,definput,opts);
    if isempty(parameters)
        return
    end
    fs = str2double(parameters{1});
    fmax = str2double(parameters{2});
    f_fund = str2double(parameters{3});
    stopbandwidth = str2double(parameters{4})/2;
end

if nargin == 2 % e.g. being called from DAS
    prompt = {'Upper frequency limit for filtering (if left empty the algorithm will run until fs/2) [Hz]:',...
        'Fundamental frequency of the periodic noise (if not given, the algorithm will find it) [Hz]:',...
        'Stopband width [Hz]:'};
    title = 'Parameter input for periodic noise filter';
    definput = {'1000','','5'};
    opts.Interpreter = 'tex';
    parameters = inputdlg(prompt,title,1,definput,opts);
    if isempty(parameters)
        return
    end
    fmax = str2double(parameters{1});
    f_fund = str2double(parameters{2});
    stopbandwidth = str2double(parameters{3})/2;
end

if nargin == 0 || isempty(data)
    [filename,path] = uigetfile('*.rhd');
    oldpath = cd(path);
    data = read_Intan_RHD2000_file_szb(filename);
    data = data.amplifier_data;
    cd(oldpath)
end

if size(data,1) > size(data,2)
    data = data';
end

if nargin > 0 && nargin < 2
    errordlg('Pls specifiy the sampling frequency!')
end

if isempty(f_fund) || isnan(f_fund)
    f_fund_given = false;
else
    f_fund_given = true;
end

if (nargin > 0 && nargin < 5)
    stopbandwidth = 5/2;
end

data_filt = data;
% assignin('base','data',data)
if ~f_fund_given
    [progRepFig,progBarPlot,progBarText,feedbackText] = progressReportWindow;
    f_fund = zeros(min(size(data)),1);
    for i = 1:min(size(data))
    
%         wb1 = waitbar(0,'Calculaing FFT...','Name','Finding the fundamental frequency');

        % Calculate FFT
        progBarPlot.Position = [0, 0, 0.3, 0.1]; 
        progBarText.String = ['Ch#',num2str(i),' - computing FFT...']; drawnow
        [faxis,psd] = freqspec(data(i,:),fs,0);
        
        % Cutting out low frequencies from PSD
        cutpsd = psd(find(faxis > 30,1):end);
        cutfaxis = faxis(find(faxis > 30,1):end);

        % Computing the running average and std
        cutpsd_runAvg = movmean(cutpsd,find(faxis > 10,1));
        cutpsd_runSd = movstd(cutpsd,find(faxis > 10,1));
        
        % simply detect the prominent peaks on the fft
        progBarPlot.Position = [0, 0, 0.6, 0.1]; 
        progBarText.String = ['Ch#',num2str(i),' - detecting peaks on FFT...']; drawnow
        [peaks,locs,~,proms] = findpeaks(cutpsd,'MinPeakDistance',find(faxis > 30,1));
        
        % check if findpeaks' detections are above the moving average+4*std
        lowPeaks = false(size(locs));
        for j = 1:length(peaks)
            if peaks(j) < (cutpsd_runAvg(locs(j)) + 4*cutpsd_runSd(locs(j)))
                lowPeaks(j) = true;
            end
        end
        if isempty(find(~lowPeaks, 1))
            close(wb1)
            warndlg(['The algorithm did not find any periodic noise! You can set the',...
                ' fundamental frequency manually if you want the filter to run anyway.'])
            data_filt = [];
            return
        end
        peaks = peaks(~lowPeaks);
        locs = locs(~lowPeaks);
        proms = proms(~lowPeaks);
        
        [~,maxPromInds] = sort(proms,'descend');
        maxLocs = locs(maxPromInds);
        
        progBarPlot.Position = [0, 0, 0.9, 0.1]; 
        progBarText.String = ['Ch#',num2str(i),' - checking possible frequencies...']; drawnow
        
        numproms = min([10,length(maxPromInds)]);
        putative_f_fund = zeros(1,numproms);
        for j = 1:numproms
            putative_f_fund(j) = cutfaxis(maxLocs(j));
        end
%         putative_f_fund
        howManyCanItDivide = 0;
        for j = 1:numproms
%             putative_f_fund(j)
            ratios = putative_f_fund/putative_f_fund(j);
            goodRatios = length(find(abs(round(ratios)-ratios) < 0.01));
            if goodRatios > howManyCanItDivide
                f_fund(i) = putative_f_fund(j);
                howManyCanItDivide = goodRatios;
            elseif goodRatios == howManyCanItDivide
                if f_fund(i) < putative_f_fund(j)
                    f_fund(i) = putative_f_fund(j);
                end
            end
        end
        
%         waitbar(.33,wb1,'Calculating autocorrelation...')
%         % Calculate autocorrelation
%         [autocorr,lag] = xcorr(cutpsd);
%         autocorr = autocorr(find(lag >= find(faxis > 20,1),1):end);
%         lag = lag(find(lag >= find(faxis > 20,1),1):end);
% 
%         % Peaks in autocorrelation, MaxPeakWidth should only allow through
%         % the nice narrow peaks we are looking for
%         [~,locs,~,proms] = findpeaks(autocorr,'MinPeakDistance',find(faxis>10,1),'MaxPeakWidth',10);
% 
%         % Sort prominences to find the prominent peaks
%         maxproms = sort(proms,'descend');
% %         % Maximal prominence is at 0 lag -> not needed
% %         maxproms = maxproms(2:end);
%         % Every peak is repeated because of negative and positive shifts
% %         maxproms = maxproms(1:2:end);
%         
% 
%         waitbar(.66,wb1,'Computing the fundamental frequency...')
%         % Find the maximal prominence with the lowest lag value (absolute value)
%         % => fundamental freq
% %         maxharmos = 0;
% %         for j = 1:length(maxproms)
% %                 freqs(j) = faxis(abs(lag(locs(find(proms==maxproms(j),1))))+1);
% %         end
% %         freqs = unique(freqs,'stable');
% %         
% %         f_fund = 0;
% %         for j = 1:10
% %             temp = mod(mod(freqs(1:10),freqs(j)),1);
% %             temp2 = length(find(temp<0.1));
% %             temp3 = length(find(abs(temp-1)<0.1));
% % %             fprintf(1,'%.2f Hz has %d harmonics\n',freqs(j),temp2+temp3)
% %             if temp2+temp3 > maxharmos
% %                 maxharmos = temp2+temp3;
% %                 f_fund = freqs(j);
% %             elseif temp2+temp3 == maxharmos
% %                 if freqs(j) < f_fund
% %                     f_fund = freqs(j);
% %                 end
% %             end
% %         end
% %         if ~isempty(find(abs(freqs-f_fund/2)<0.1))
% %             f_fund = freqs(find(abs(freqs-f_fund/2)<0.1));
% %         end
%         
% %         minloc = length(cutpsd);
% %         for j = 1:10
% %             if abs(lag(locs(find(proms==maxproms(j),1)))) < minloc
% %                 minloc = abs(lag(locs(find(proms==maxproms(j),1))));
% %             end
% %         f_fund = faxis(minloc+1);
% 
% %         dps = zeros(2,10);
%         runavg = movmean(autocorr,find(faxis>1,1));
% %         f_fund = 0;
%         numproms = min([10,length(maxproms)]);
%         dps = zeros(2,numproms);
%         
%         for j = 1:numproms
%             dps(1,j) = abs(lag(locs(find(proms==maxproms(j),1))));
%             dps(2,j) = autocorr(locs(find(proms==maxproms(j),1)))-runavg(locs(find(proms==maxproms(j),1)));
%         end
%         [~,inds1] = sort(dps(1,:));
%         faxis(dps(1,inds1)+1)
%         [~,inds2] = sort(dps(2,:),'descend');
%         sumOfInds = inds1+inds2;
%         [~,indsSum] = sort(sumOfInds);
%         
%         maxproms = maxproms(indsSum);
%         putative_f_fund = zeros(1,numproms);
%         for j = 1:numproms
%             putative_f_fund(j) = faxis(dps(1,j)+1);
%         end
%         putative_f_fund
%         howManyCanItDivide = 0;
%         for j = 1:numproms
%             putative_f_fund(j)
%             ratios = putative_f_fund/putative_f_fund(j)
%             goodRatios = length(find(abs(round(ratios)-ratios) < 0.01));
%             if goodRatios > howManyCanItDivide
%                 f_fund(i) = putative_f_fund(j);
%                 howManyCanItDivide = goodRatios;
%             end
%         end
% %         bestscore = 20;
% %         for j = 1:numproms
% %             if find(inds1==j)+find(inds2==j) < bestscore
% %                 f_fund(i) = faxis(dps(1,j)+1);
% %                 bestscore = find(inds1==j)+find(inds2==j);
% %             elseif find(inds1==j)+find(inds2==j) == bestscore
% %                 if faxis(dps(1,j)+1) < f_fund(i)
% %                     f_fund(i) = faxis(dps(1,j)+1);
% %                 end
% %             end
% %         end

%         waitbar(1,wb1,'Finished')
%         close(wb1)

        progBarPlot.Position = [0, 0, 1, 0.1]; 
        progBarText.String = ['Ch#',num2str(i),' - found the fundamental frequency!...'];
        feedbackText_old = feedbackText.String;
        feedbackText.String = [feedbackText_old; strcat("Ch#",num2str(i)," fund freq = ",num2str(f_fund(i))," Hz")]; drawnow
        fprintf(1,'The fundamental frequency of the periodic noise in channel %d is: %f Hz\n',i,f_fund(i))
    end
    if length(unique(round(f_fund/2)*2)) > 1
        modeVal = mode(round(f_fund/2)*2);
        [uniqVals,~,ic] = unique(round(f_fund/2)*2);
        f_fund = mean(f_fund(ic == find(uniqVals == modeVal,1)));
    else
        f_fund = mean(f_fund);
    end
    
    fprintf(1,'The final result for the fundamental frequency of the periodic noise in the whole recording is: %f Hz\n',f_fund)
    
    progBarPlot.Position = [0, 0, 1, 0.1]; 
    progBarText.String = ['Done with all channels!'];
    feedbackText_old = feedbackText.String;
    feedbackText.String = [feedbackText_old; strcat("Overall fund freq = ",num2str(f_fund)," Hz")]; drawnow
%     delete(progRepFig)
end
    
% fmax is the frequency up to which the algorithm will run
if isempty(fmax) || isnan(fmax)
    fmax = ((fs/2)-f_fund-1);
elseif fmax > ((fs/2)-f_fund-1)
    fmax = ((fs/2)-f_fund-1);
end

for i = 1:min(size(data))
    % Use series of bandstop filters to eliminate the periodic noise
    f = f_fund;
    wb2 = waitbar(0,'Initializing filtering...','Name','Filtering the data');
    while f < fmax
        waitbar(f/fmax,wb2,['Filtering at ',num2str(f),' Hz'])
        [b,a] = butter(2,[f-stopbandwidth, f+stopbandwidth]/(fs/2),'stop');
        data_filt(i,:) = filtfilt(b,a,data_filt(i,:));
        f = f+f_fund;
%         freqz(b,a)
%         [data_filt(i,:),d] = bandstop(data(i,:),[f-1,f+1],fs);
%         freqz(d)
%         waitforbuttonpress
    end
    close(wb2)
end

plotfft = questdlg('Plot before&after FFTs?','FFT plots');
if strcmp(plotfft,'Yes')
    [faxis,psd] = freqspec(data,fs,1,0,fmax,'before');
    [faxis_cl,psd_cl] = freqspec(data_filt,fs,1,0,fmax,'after');
end

% assignin('base','faxis',faxis)
% assignin('base','faxiscl',faxis_cl)
% assignin('base','psd',psd)
% assignin('base','psdcl',psd_cl)

if nargout == 0
    clear data_filt
end

    function [progRepFig,progBarPlot,progBarText,feedbackText] = progressReportWindow
        progRepFig = figure('Visible','off',...
            'Units','normalized',...
            'Position',[0.2, 0.2, 0.3, 0.5],...
            'NumberTitle','off',...
            'Name','Periodic Noise Filter - Progress',...
            'MenuBar','none',...
            'IntegerHandle','off',...
            'HandleVisibility','Callback');
        
        progBarHandle = axes(progRepFig,...
            'Units', 'normalized',...
            'Position', [0.1, 0.8, 0.8, 0.1]);
        axis(progBarHandle, 'off')
        hold(progBarHandle, 'on')
        xlim(progBarHandle, [0, 1])
        ylim(progBarHandle, [0, 0.1])
        progBarPlot = rectangle(progBarHandle,...
            'Position', [0, 0, 0.1, 0.1],...
            'FaceColor', [0 0 1]);
        
        progBarText = uicontrol(progRepFig,...
            'Style', 'text',...
            'Units', 'normalized',...
            'Position', [0.4, 0.65, 0.2, 0.1],...
            'String', 'Initializing...');
        
        feedbackText = uicontrol(progRepFig,...
            'Style', 'text',...
            'Units', 'normalized',...
            'Position', [0.1, 0.1, 0.8, 0.45]);
        
        progRepFig.Visible = 'on';
    end


end