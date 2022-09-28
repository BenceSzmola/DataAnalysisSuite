function [intervals, widths] = fullWaveWidth(data, peakInds, thr)
% [intervals, widths] = fullWaveWidth(data, peakInds, thr)
% Input one data channel at a time!
    
    if all(size(data) > 1)
        eD = errordlg('This function takes one channel at a time!');
        pause(1)
        if ishandle(eD)
            close(eD)
        end
        intervals = [];
        widths = [];
        return
    end

    intervals = nan(length(peakInds), 2);
    widths = nan(length(peakInds), 1);
    for p = 1:length(peakInds)
        pInd = peakInds(p);
        if ismember(pInd, [1, length(data)])
            continue
        end
%         pVal = data(pInd);
        
%         leftCross = find(data(1:max(1, pInd - 1)) > pVal, 1, 'last');
%         if isempty(leftCross)
%             leftCross = 1;
%         end
%         [~, leftMin] = min(data(leftCross:pInd));
%         leftMin = leftMin + leftCross - 1;
%         
%         rightCross = find(data(min(length(data), pInd + 1):end) > pVal, 1, 'first') + min(length(data), pInd + 1) - 1;
%         if isempty(rightCross)
%             rightCross = length(data);
%         end
%         [~, rightMin] = min(data(pInd:rightCross));
%         rightMin = rightMin + pInd - 1;
% 
%         widths(p) = rightMin - leftMin;
%         intervals(p,:) = [leftMin, rightMin];
        
        diffSign = sign(diff(data));
        
        leftBot = find(diffSign(1:pInd - 1) == -1, 1, 'last');
        rightBot = find(diffSign(pInd + 1:end) == 1, 1, 'first') + pInd - 1;
        
        if (nargin > 2) && ~isempty(thr) && ~isnan(thr)
            [aboveThrIvs, ~] = computeAboveThrLengths(data, thr, '>');
            aboveThrIvs = aboveThrIvs((aboveThrIvs(:,1) < pInd) & (aboveThrIvs(:,2) > pInd),:);
            [~, leftBotThr] = min(abs(pInd - aboveThrIvs(:,1)));
            leftBotThr = aboveThrIvs(leftBotThr,1);
            [~, rightBotThr] = min(abs(aboveThrIvs(:,2) - pInd));
            rightBotThr = aboveThrIvs(rightBotThr,2);
            
            leftBot = min(leftBot, leftBotThr);
            rightBot = max(rightBot, rightBotThr);
        end
        
        if ~isempty(leftBot) && ~isempty(rightBot)
            widths(p) = rightBot - leftBot;
            intervals(p,:) = [leftBot, rightBot];
        end
    end
    intervals(isnan(widths),:) = [];
    widths(isnan(widths)) = [];
end