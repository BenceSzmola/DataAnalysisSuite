function baselineInds = getBaselineInds(data, method, winSize)
% baselineInds = getBaselineInds(data, method, winSize)
% Returns indices of the input data which are assumed to be part of the baseline activity
% Data should be single channel!
% Available methods:
%   -'EnvelopeProminence' (call with name or 1): 
    
    switch method
        case {1, 'EnvelopeProminence'}
            [data,~] = envelope(data, winSize, 'peak');
            
            thresh = median(data);
            [~, locs] = findpeaks(data, 'MinPeakProminence', thresh);
            [intervals, lens] = fullWaveWidth(data, locs, thresh);
            baselineInds = 1:length(data);
            if ~isempty(lens)
                for iv = 1:length(lens)
                    baselineInds(intervals(iv,1):intervals(iv,2)) = nan;
                end
                baselineInds(isnan(baselineInds)) = [];
            end
    end

end