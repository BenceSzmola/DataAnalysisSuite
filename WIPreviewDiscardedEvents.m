function events2Restore = WIPreviewDiscardedEvents(taxis,fs,chan,data,compMode,compData,eventsPeak,refValVictims)
    globVictInd = 0;
    colInd = 1;
    
    events2Restore = cell(length(refValVictims),1);
    
    victimsPeakInds = refValVictims;
    for ch = 1:length(refValVictims)
        for vic = 1:length(refValVictims{ch})
            victimsPeakInds{ch}(vic) = eventsPeak{ch}(refValVictims{ch}(vic));
        end
    end
    
    globVicts = extractGlobalEvents(victimsPeakInds,round(0.01*fs),true);
    
    reviewFig = figure('Name','Review discarded events',...
        'NumberTitle','off','IntegerHandle','off',...
        'Units','normalized','Position',[0.3,0.3,0.33,0.33],...
        'KeyPressFcn',@ figKeyCB,...
        'WindowStyle', 'modal',...
        'WindowState', 'maximized');
    
    reviewAx = subplot(2,1,1,'Parent',reviewFig);
    reviewAxRef = subplot(2,1,2,'Parent',reviewFig);
    title(reviewAx,'Use the arrows to change between events!')
    title(reviewAxRef,'Use space to mark event to be restored, and backspace to remove mark!')
    hold(reviewAx, 'on')
    revLine = plot(reviewAx,0,0,'-r');
    revGreenLine = xline(reviewAx,0,'g','LineWidth',1);
    hold(reviewAx, 'off')
    refLine = plot(reviewAxRef,0,0,'-b');
    linkaxes([reviewAx,reviewAxRef],'xy')
    uiwait(reviewFig)
    
    function figKeyCB(h,kD)
        
        switch kD.Key
            case 'rightarrow'
                if globVictInd < size(globVicts, 1)
                    globVictInd = globVictInd + 1;
                    colInd = 1;
                end
                
            case 'leftarrow'
                if globVictInd > 1
                    globVictInd = globVictInd - 1;
                    colInd = 1;
                end
                
            case 'uparrow'
                if colInd < length(find(~isnan(globVicts(globVictInd,:))))
                    colInd = colInd + 1;
                end
                
            case 'downarrow'
                if colInd > 1
                    colInd = colInd - 1; 
                end
                
            case 'space'
                if globVictInd == 0
                    return
                end
                events2Restore{colInd2chanInd} = [events2Restore{colInd2chanInd}, globVictInd2detInd];
                doOnOtherChans('rescue')
                
                
            case 'backspace'
                if globVictInd == 0
                    return
                end
                events2Restore{colInd2chanInd}(events2Restore{colInd2chanInd}==globVictInd2detInd) = [];
                doOnOtherChans('doom')
                
            case 'escape'
                close(h)
                return
                
        end
        
        if globVictInd == 0
            return
        end
        
        chInd = colInd2chanInd;
        detInd = globVictInd2detInd;
        
        % adjusted index (globVictInd works in refValVictims)
        ax = findobj(h,'Type','axes');
        
        adjInd = refValVictims{chInd}(detInd);
        
        
        winInds = winMacher(0.5);
        if strcmp(compMode,'ref')
            r = corrCalculator;
            compData2plot = compData(winInds);
        elseif strcmp(compMode,'raw')
            compData2plot = compData(chInd,winInds);
        end

        revLine.XData = taxis(winInds);
        revLine.YData = data(chInd,winInds);
        revGreenLine.Value = taxis(victimsPeakInds{chInd}(detInd));
        if ~isempty(find(events2Restore{chInd} == detInd, 1))
            title(ax(2),['Discarded event - Ch#',num2str(chan(chInd)),...
                ' Event#',num2str(adjInd),' - marked for recovery'])
        else
            title(ax(2),['Discarded event - Ch#',num2str(chan(chInd)),...
                ' Event#',num2str(adjInd)])
        end
        xlabel(ax(2),'Time [s]')
        ylabel(ax(2),'Voltage [\muV]')

        refLine.XData = taxis(winInds);
        refLine.YData = compData2plot;
        if strcmp(compMode,'ref')
            title(ax(1),['Reference channel - rho=',num2str(r(2))])
        elseif strcmp(compMode,'raw')
            title(ax(1),['Wideband data - Ch#',num2str(chan(chInd))])
        end
        xlabel(ax(1),'Time [s]')
        ylabel(ax(1),'Voltage [\muV]')

        lowerLim = min(min(compData2plot), min(data(chInd,winInds)));
        upperLim = max(max(compData2plot), max(data(chInd,winInds)));
        yrange = upperLim - lowerLim;
        lowerLim = lowerLim - 0.1*yrange;
        upperLim = upperLim + 0.1*yrange;
        xlim(ax(1), [taxis(winInds(1)), taxis(winInds(end))])
        ylim(ax(1), [lowerLim, upperLim])
        
    end

    function winInds = winMacher(winLen)
        winLen = round((winLen/2)*fs);
        
        currInd = victimsPeakInds{colInd2chanInd}(globVictInd2detInd);
        winStart = max(1, currInd - winLen);
        winEnd = min(length(data), currInd + winLen);
        winInds = winStart:winEnd;
    end

    function doOnOtherChans(mode)
        for ch1 = 1:length(refValVictims)
            
            matches = abs(victimsPeakInds{colInd2chanInd}(globVictInd2detInd) - victimsPeakInds{ch1}) < round(0.01*fs);
            switch mode
                case 'rescue'
                    events2Restore{ch1} = unique([events2Restore{ch1}, find(matches)]);
                    
                case 'doom'
                    events2Restore{ch1}(ismember(events2Restore{ch1}, find(matches))) = [];
                    
            end
        end
        
    end

    function r = corrCalculator
        winInds = winMacher(0.2);
        r = corrcoef(compData(winInds),data(colInd2chanInd,winInds));
    end
    
    function chanInd = colInd2chanInd
        chanInd = find(~isnan(globVicts(globVictInd,:)));
        chanInd = chanInd(colInd);
    end

    function detInd = globVictInd2detInd
        detInd = globVicts(globVictInd,colInd2chanInd);
    end

end