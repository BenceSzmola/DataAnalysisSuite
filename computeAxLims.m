function axLims = computeAxLims(fullData, yLimMode, tAxis, winInds)

    if isnumeric(yLimMode)
        axLims = yLimMode;
    else
        axLims = nan(size(fullData, 1), 2);
        
        if strcmp('global', yLimMode)
            dataLen = length(tAxis);
            winInds = 1:dataLen;
        end
        
        axLims(:,1) = min(fullData(:,winInds), [], 2);
        axLims(:,1) = axLims(:,1) - 0.1*abs(axLims(:,1));
        axLims(:,2) = max(fullData(:,winInds), [], 2);
        axLims(:,2) = axLims(:,2) + 0.1*abs(axLims(:,2));
    end
    
end