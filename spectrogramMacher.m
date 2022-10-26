function spectrogramMacher(data,fs,freqLims,detBorders)

if any(freqLims > (fs/2))
    eD = errordlg('Frequency limits exceed Nyquist value!');
    pause(1)
    if ishandle(eD)
        close(eD)
    end
    return
end

if size(data,1) > size(data,2)
    data = data';
end

freqRange = freqLims(2)-freqLims(1);

taxis = linspace(-round(length(data)*1000/(2*fs),4),round(length(data)*1000/(2*fs),4),...
    length(data));

for i = 1:size(data,1)
    normData = data(i,:) + abs(min(data(i,:)));
    normData = normData / max(normData);
    [cfs,f] = cwt(data(i,:),'amor',fs,'FrequencyLimits',freqLims);
    cfs = abs(cfs);
    
    figure('Name', 'CWT Spectrogram', 'NumberTitle', 'off')
    surf(taxis,f,cfs,'EdgeColor','interp')
    view([0,90])
    hold on

    plot3(taxis, normData*(0.3*freqRange) + 0.6*freqRange, ones(size(taxis))*max(cfs(:)), '-r')
    
    if (nargin > 3) && ~isempty(detBorders)
        xline(taxis(detBorders(1)),'--w','LineWidth',1);
        xline(taxis(detBorders(2)),'--w','LineWidth',1);
    end
    
    hold off
    axis tight
    ylabel('Frequency [Hz]')
    xlabel('Time [ms]')
    cbar = colorbar;
    cbar.Label.String = 'CWT coefficient magnitude';
end