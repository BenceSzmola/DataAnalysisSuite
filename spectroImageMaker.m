function spectroImageMaker(taxis,fs,data,chans,freqLim,inds2use)

if nargin < 5 || isempty(freqLim)
    freqLim = [1, 500];
end

for ch = 1:size(data, 1)
    if (nargin < 4) || isempty(chans)
        currChan = ch;
    else
        currChan = chans(ch);
    end

    cwtFig = figure('Name',sprintf('Channel #%d CWT Spectrogram', currChan),...
        'NumberTitle', 'off',...
        'WindowState', 'maximized',...
        'SizeChangedFcn', @updateSpectroLabels);
    zoomObj = zoom(cwtFig);
    zoomObj.ActionPostCallback = @updateSpectroLabels;
    drawnow
    [cfs,f] = cwt(data(ch,:), 'amor', fs, 'FrequencyLimits', freqLim);
    if nargin >= 6 && ~isempty(inds2use)
        cfs(:,setxor(1:size(data, 2), inds2use)) = nan;
    end
    imagesc(taxis,log2(f),abs(cfs))
    axis tight
    ax = gca;
    ax.YDir = 'normal';
    ax.YTickLabel = num2str(2.^(ax.YTick'));
    title(sprintf('Ch#%d CWT',currChan))
    xlabel('Time [s]')
    ylabel('Frequency [Hz]')
    c = colorbar;
    c.Label.String = 'CWT coeff. magnitude';
    clear cfs f ax
end

    function updateSpectroLabels(h,~)
        if ~strcmp(h.Type, 'axes')
            sps = findobj(h,'Type','axes');
        else
            sps = h;
        end
        for sp = 1:length(sps)
            sps(sp).YTickLabel = cellfun(@(x) num2str(x),mat2cell(2.^(sps(sp).YTick'),...
                ones(1,length(sps(sp).YTick))),'UniformOutput',false);
        end
    end

end