function spectroImageMaker(targetAx,taxis,fs,data,chans,freqLim,inds2use)

if nargin < 6 || isempty(freqLim)
    freqLim = [1, 500];
end

for ch = 1:size(data, 1)
    if (nargin < 5) || isempty(chans)
        currChan = ch;
    else
        currChan = chans(ch);
    end

    if isempty(targetAx)
        cwtFig = figure('Name',sprintf('Channel #%d CWT Spectrogram', currChan),...
            'NumberTitle', 'off',...
            'WindowState', 'maximized',...
            'SizeChangedFcn', @updateSpectroLabels);
        ax = axes(cwtFig);
    else
        ax = targetAx;
        cwtFig = targetAx.Parent;
        while ~strcmp(cwtFig.Type, 'figure')
            cwtFig = cwtFig.Parent;
        end
    end
    zoomObj = zoom(cwtFig);
    zoomObj.ActionPostCallback = @updateSpectroLabels;
    drawnow
    [cfs,f] = cwt(data(ch,:), 'amor', fs, 'FrequencyLimits', freqLim);
    if nargin >= 7 && ~isempty(inds2use)
        cfs(:,setxor(1:size(data, 2), inds2use)) = nan;
    end
    imagesc(ax,taxis,log2(f),abs(cfs))
    axis(ax, 'tight')
    ax.YDir = 'normal';
    ax.YTickLabel = num2str(2.^(ax.YTick'));
    title(sprintf('Ch#%d CWT',currChan))
    xlabel('Time [s]')
    ylabel('Frequency [Hz]')
%     c = colorbar;
%     c.Label.String = 'CWT coeff. magnitude';
    clear cfs f ax
    
end

    function updateSpectroLabels(h,~)
        if ~strcmp(h.Type, 'axes')
            sps = findobj(h,'Type','axes');
        else
            sps = h;
        end
        for sp = 1:length(sps)
            spKids = findobj(sps(sp).Children, 'Type', 'image');
            if isempty(spKids)
                continue
            end
            sps(sp).YTickLabel = cellfun(@(x) num2str(x),mat2cell(2.^(sps(sp).YTick'),...
                ones(1,length(sps(sp).YTick))),'UniformOutput',false);
        end
    end

end