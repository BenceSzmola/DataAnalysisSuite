function data_filt = periodicNoise(data,fs,fmax,f_fund,stopbandwidth)

% Detect and filter out periodic Noise (fundamental and harmonics)
% data_filt = periodicNoise(data,fs,fmax,f_fund,stopbandwidth)
% fs : sampling frequency
% fmax : manually set maximal frequency up to which the algorithm will filter
% f_fund : manually specify the fundamental frequency of the noise
% stopbandwidth : +- how many Hz the filter should cut out around the noise
% input [] if you dont want to specify something

if nargin == 0
    prompt = {'Sampling frequency [Hz]:',...
        'Upper frequency limit for filtering (if left empty the algorithm will run until fs/2) [Hz]:',...
        'Fundamental frequency of the periodic noise (if not given, the algorithm will find it) [Hz]:',...
        '\pm how many Hz should be filtered around the noise [Hz]:'};
    title = 'Parameter input for periodic noise filter';
    definput = {'20000','500','','0.5'};
    opts.Interpreter = 'tex';
    parameters = inputdlg(prompt,title,1,definput,opts);
    if isempty(parameters)
        return
    end
    fs = str2double(parameters{1});
    fmax = str2double(parameters{2});
    f_fund = str2double(parameters{3});
    stopbandwidth = str2double(parameters{4});
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

if (nargin > 0 && nargin < 4) || isempty(f_fund) || isnan(f_fund)
    f_fund_given = false;
else
    f_fund_given = true;
end

if (nargin > 0 && nargin < 5)
    stopbandwidth = 0.5;
end

data_filt = data;
for i = 1:min(size(data))
    if ~f_fund_given
        wb1 = waitbar(0,'Calculaing FFT...','Name','Finding the fundamental frequency');
        % Calculate FFT
        [faxis,psd] = freqspec(data(i,:),fs,0);

        % Cutting out low frequencies from PSD
        cutpsd = psd(find(faxis>20,1):end);

        waitbar(.33,wb1,'Calculating autocorrelation...')
        % Calculate autocorrelation
        [autocorr,lag] = xcorr(cutpsd);

        % Peaks in autocorrelation
        [~,locs,~,proms] = findpeaks(autocorr,'MinPeakDistance',find(faxis>10,1),'Threshold',10);

        % Sort prominences to find the prominent peaks
        maxproms = sort(proms,'descend');
        % Maximal prominence is at 0 lag -> not needed
        maxproms = maxproms(2:end);
        maxproms = maxproms(1:2:end);

        waitbar(.66,wb1,'Computing the fundamental frequency...')
        % Find the maximal prominence with the lowest lag value (absolute value)
        % => fundamental freq
%         maxharmos = 0;
%         for j = 1:length(maxproms)
%                 freqs(j) = faxis(abs(lag(locs(find(proms==maxproms(j),1))))+1);
%         end
%         freqs = unique(freqs,'stable');
%         
%         f_fund = 0;
%         for j = 1:10
%             temp = mod(mod(freqs(1:10),freqs(j)),1);
%             temp2 = length(find(temp<0.1));
%             temp3 = length(find(abs(temp-1)<0.1));
% %             fprintf(1,'%.2f Hz has %d harmonics\n',freqs(j),temp2+temp3)
%             if temp2+temp3 > maxharmos
%                 maxharmos = temp2+temp3;
%                 f_fund = freqs(j);
%             elseif temp2+temp3 == maxharmos
%                 if freqs(j) < f_fund
%                     f_fund = freqs(j);
%                 end
%             end
%         end
%         if ~isempty(find(abs(freqs-f_fund/2)<0.1))
%             f_fund = freqs(find(abs(freqs-f_fund/2)<0.1));
%         end
        
%         minloc = length(cutpsd);
%         for j = 1:10
%             if abs(lag(locs(find(proms==maxproms(j),1)))) < minloc
%                 minloc = abs(lag(locs(find(proms==maxproms(j),1))));
%             end
%         f_fund = faxis(minloc+1);

        dps = zeros(2,10);
        runavg = movmean(autocorr,find(faxis>1,1));
        f_fund = 0;
        for j = 1:10
            dps(1,j) = abs(lag(locs(find(proms==maxproms(j),1))));
            dps(2,j) = autocorr(locs(find(proms==maxproms(j),1)))-runavg(locs(find(proms==maxproms(j),1)));
        end
        [~,inds1] = sort(dps(1,:));
        [~,inds2] = sort(dps(2,:),'descend');
        bestscore = 20;
        for j = 1:10
            if find(inds1==j)+find(inds2==j) < bestscore
                f_fund = faxis(dps(1,j)+1);
                bestscore = find(inds1==j)+find(inds2==j);
            elseif find(inds1==j)+find(inds2==j) == bestscore
                if faxis(dps(1,j)+1) < f_fund
                    f_fund = faxis(dps(1,j)+1);
                end
            end
        end
        waitbar(1,wb1,'Finished')
        close(wb1)
        fprintf(1,'The fundamental frequency of the periodic noise in channel %d is: %f Hz\n',i,f_fund)
    end
    
    % fmax is the frequency up to which the algorithm will run
    if (nargin > 0 && nargin < 3) || isempty(fmax) || isnan(fmax)
        fmax = ((fs/2)-f_fund);
    end

    % Use series of bandstop filters to eliminate the periodic noise
    f = 0;
    wb2 = waitbar(0,'Initializing filtering...','Name','Filtering the data');
    while f < fmax
        f = f+f_fund;
        waitbar(f/fmax,wb2,['Filtering at ',num2str(f),' Hz'])
        [b,a] = butter(2,[f-stopbandwidth, f+stopbandwidth]/(fs/2),'stop');
        data_filt(i,:) = filtfilt(b,a,data_filt(i,:));
%         freqz(b,a)
%         [data_filt(i,:),d] = bandstop(data(i,:),[f-1,f+1],fs);
%         freqz(d)
%         waitforbuttonpress
    end
    close(wb2)
end

plotfft = questdlg('Plot before&after FFTs?','FFT plots');
if strcmp(plotfft,'Yes')
    freqspec(data,fs,1,0,fmax)
    freqspec(data_filt,fs,1,0,fmax)
end

if nargout == 0
    clear data_filt
end