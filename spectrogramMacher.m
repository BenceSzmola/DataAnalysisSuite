function spectrogramMacher(data,fs,w1,w2)

if size(data,1) > size(data,2)
    data = data';
end

if (w1 > 1000) | (w2 > 1000)
    errordlg('Unexpected frequency cutoff values!')
    return
end

dogged = DoG(data,fs,w1,w2);
taxis = linspace(-round(length(data)*1000/(2*fs),4),round(length(data)*1000/(2*fs),4),...
    length(data));

for i = 1:size(data,1)
    normdog = dogged+abs(min(dogged(i,:)));
    normdog = normdog/max(normdog);
    [cfs,f] = cwt(dogged(i,:),'amor',fs,'FrequencyLimits',[1,1000]);
    
    figure('Name',['CWT Spectrogram'])
%     surface('XData',taxis,'YData',f,'CData',abs(cfs),...
%         'ZData',zeros(size(cfs)),'EdgeColor','none','CDataMapping','scaled')
    surf(taxis,f,abs(cfs),'EdgeColor','interp')
    view([0,90])
    hold on
%     plot(taxis,normdog*300+600,'-r')
    plot3(taxis,normdog*300+600,ones(size(taxis))*max(abs(cfs(:))),'-r')
    hold off
    axis tight
    ylabel('Frequency [Hz]')
    xlabel('Time [ms]')
    cbar = colorbar;
    cbar.Label.String = 'CWT coefficient magnitude';
end