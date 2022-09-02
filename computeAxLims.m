function axLims = computeAxLims(fullData, yLimMode, tAxis, winInds)

    axLims = nan(size(fullData, 1), 2);
    switch yLimMode
        case 'global'
            dataLen = length(tAxis);
            winInds = 1:dataLen;

        case 'window'
            dataLen = length(winInds);

    end
        
    axLims(:,1) = min(fullData(:,winInds), [], 2);
    axLims(:,1) = axLims(:,1) - 0.1*abs(axLims(:,1));
    axLims(:,2) = max(fullData(:,winInds), [], 2);
    axLims(:,2) = axLims(:,2) + 0.1*abs(axLims(:,2));

end