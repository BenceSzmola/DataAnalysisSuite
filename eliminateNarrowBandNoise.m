function [dataCl,fmax,qFact] = eliminateNarrowBandNoise(data,fs,fmax,qFact,plotFFTs,chans)

if size(data,1) > size(data,2)
    data = data';
end
dataCl = data;

numChans = size(data,1);

if nargin < 3 || isempty(fmax) || isnan(fmax)
    fmax = min(1000, floor(fs/2));
end

if nargin < 4 || isempty(qFact) || isnan(qFact)
    qFact = 100;
end

if nargin < 5 || isempty(plotFFTs) || isnan(plotFFTs)
    plotFFTs =  false;
end

if nargin < 6 || isempty(chans) || any(isnan(chans))
    chans = 1:size(data,1);
end

if plotFFTs
    faxisOG = zeros(size(data));
    psdOG   = zeros(size(data));
    faxisCl = zeros(size(data));
    psdCl   = zeros(size(data));
end

foundPeaks = false;

for ch = 1:numChans
    [faxis,psd] = freqspec(data(ch,:),fs,0,0,fmax);

    faxisStep   = faxis(2) - faxis(1);
    upsampMult = ceil(faxisStep/0.005);
    interpFaxis = linspace(faxis(1),faxis(end),length(faxis)*upsampMult);
    temp = spline(faxis,psd,interpFaxis);

    psd = temp;
    faxis = interpFaxis;
    faxisStep   = faxis(2) - faxis(1);
    
    if plotFFTs
        faxisOG(ch,1:length(faxis)) = faxis;
        psdOG(ch,1:length(psd)) = psd;
    end

    runMed = movmedian(psd,round(20/faxisStep));
    runSD  = movstd(psd,round(20/faxisStep));

%     figure;
%     plot(faxis,psd)
%     hold on
%     plot(faxis,runMed + 4*runSD, '--')
%     hold off
%     title(num2str(ch))

    ivs2check = computeAboveThrLengths(psd, runMed + 4*runSD, '>', round(.05/faxisStep));
%     faxis(ivs2check)
    if ~isempty(ivs2check)
        foundPeaks = true;
    end
    for iv = 1:size(ivs2check,1)
        if faxis(ivs2check(iv,1)) < 30
            continue
        end
        [~,maxInd]   = max(psd(ivs2check(iv,1):ivs2check(iv,2)));
        f2filt = faxis(ivs2check(iv,1) + maxInd - 1);

        wo = f2filt/(fs/2);
        bw = wo/qFact;
        [b,a] = iirnotch(wo,bw,1);
        dataCl(ch,:) = filtfilt(b,a,dataCl(ch,:));
    end

    if plotFFTs
        [faxis,psd] = freqspec(dataCl(ch,:),fs,0,0,fmax);
        faxisCl(ch,1:length(faxis)) = faxis;
        psdCl(ch,1:length(psd)) = psd;
    end

end

if ~foundPeaks
    dataCl = [];
    eD = errordlg('No anomalous peaks found!');
    pause(1)
    if ishandle(eD)
        close(eD)
    end
    return
end

if plotFFTs
    faxisOG = faxisOG(:,any(faxisOG));
    psdOG   = psdOG(:,any(psdOG));
    faxisCl = faxisCl(:,any(faxisCl));
    psdCl   = psdCl(:,any(psdCl));

    
    for ch = 1:size(data, 1)
        figure('NumberTitle', 'off', 'Name', ['FFT before & after - Ch #',num2str(chans(ch))]);
        subplot(211)
        plot(faxisOG(ch,:), psdOG(ch,:))
        title(sprintf('Ch #%d - FFT before',chans(ch)))
        
        subplot(212)
        plot(faxisCl(ch,:), psdCl(ch,:))
        title(sprintf('Ch #%d - FFT after',chans(ch)))
        
        linkaxes(findobj(gcf, 'Type', 'axes'), 'xy')
    end

end