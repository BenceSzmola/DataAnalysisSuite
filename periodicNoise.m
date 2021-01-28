function data_filt = periodicNoise(data,fs)

% Detect and filter out periodic Noise (fundamental and harmonics)

if size(data,1) > size(data,2)
    data = data';
end
data_filt = zeros(size(data));
for i = 1:min(size(data))
    % Calculate FFT
    [faxis,psd] = freqspec(data,fs,0);

    % Cutting out low frequencies from PSD
    cutpsd = psd(find(faxis>20,1):end);

    % Calculate autocorrelation
    [autocorr,lag] = xcorr(cutpsd);

    % Peaks in autocorrelation
    [~,locs,~,proms] = findpeaks(autocorr,'MinPeakDistance',find(faxis>20,1));

    % Sort prominences to find the prominent peaks
    maxproms = sort(proms,'descend');
    % Maximal prominence is at 0 lag -> not needed
    maxproms = maxproms(2:end);

    % Find the maximal prominence with the lowest lag value (absolute value)
    % => fundamental freq
    minloc = length(cutpsd);
    for j = 1:10
        if abs(lag(locs(find(proms==maxproms(j),1)))) < minloc
            minloc = abs(lag(locs(find(proms==maxproms(j),1))));
        end
    end
    f_fund = faxis(minloc+1);
    fprintf(1,'The fundamental frequency of the periodic noise in channel %d is: %f Hz\n',i,f_fund)

    % Use series of bandstop filters to eliminate the periodic noise
    f = 0;
    while f < ((fs/2)-f_fund)
        f = f+f_fund;
        [b,a] = butter(2,[f-1 f+1]/(fs/2),'stop');
        data_filt(i,:) = filtfilt(b,a,data(i,:));
        freqz(b,a)
%         [data_filt(i,:),d] = bandstop(data(i,:),[f-1,f+1],fs);
%         freqz(d)
        waitforbuttonpress
    end
end

assignin('base','data_filt',data_filt)

freqspec(data,fs,1)
freqspec(data_filt,fs,1)