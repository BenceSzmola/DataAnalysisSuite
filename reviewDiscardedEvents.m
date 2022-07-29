function events2Restore = reviewDiscardedEvents(taxis,fs,chan,data,refData,vEvents,eventsPeak,refValVictims)
    detInd = 0;
    chanInd = 1;
    
    events2Restore = cell(length(refValVictims),1);
    reviewFig = figure('Name','Review discarded events',...
        'NumberTitle','off','IntegerHandle','off',...
        'Units','normalized','Position',[0.3,0.3,0.33,0.33],...
        'KeyPressFcn',@ figKeyCB);
    
    reviewAx = subplot(2,1,1,'Parent',reviewFig);
    reviewAxRef = subplot(2,1,2,'Parent',reviewFig);
    title(reviewAx,'Use the arrows to change between events!')
    title(reviewAxRef,'Use space to mark event to be restored, and backspace to remove mark!')
    
    uiwait(reviewFig)
    
    function figKeyCB(h,kD)
        switch kD.Key
            case 'rightarrow'
                if detInd < length(refValVictims{chanInd})
                    detInd = detInd + 1;
                end
                
            case 'leftarrow'
                if detInd > 1
                    detInd = detInd - 1;
                end
                
            case 'uparrow'
                if chanInd < length(refValVictims)
                    chanInd = chanInd + 1;
                    detInd = 1;
                end
                
            case 'downarrow'
                if chanInd > 1
                    chanInd = chanInd - 1; 
                    detInd = 1;
                end
                
            case 'space'
                events2Restore{chanInd} = [events2Restore{chanInd}, detInd];
                
            case 'backspace'
                events2Restore{chanInd}(events2Restore{chanInd}==detInd) = [];
                
            case 'escape'
                close(h)
                return
                
        end
        
        % adjusted index (detInd works in refValVictims)
        ax = findobj(h,'Type','axes');
        if ~isempty(refValVictims{chanInd})
            adjInd = refValVictims{chanInd}(detInd);
        
            winInds = winMacher(adjInd,0.5);
            r = corrCalculator(adjInd);
            
            plot(ax(2),taxis(winInds),data(chanInd,winInds),'-r')
            hold(ax(2),'on')
            xline(ax(2),taxis(eventsPeak{chanInd}(adjInd)),'g','LineWidth',1);
            hold(ax(2),'off')
            if ~isempty(find(events2Restore{chanInd}==detInd,1))
                title(ax(2),['Discarded event - Ch#',num2str(chan(chanInd)),...
                    ' Event#',num2str(adjInd),' - marked for recovery'])
            else
                title(ax(2),['Discarded event - Ch#',num2str(chan(chanInd)),...
                    ' Event#',num2str(adjInd)])
            end
            xlabel(ax(2),'Time [s]')
            ylabel(ax(2),'Voltage [\muV]')

            plot(ax(1),taxis(winInds),refData(winInds))
            title(ax(1),['Reference channel - rho=',num2str(r(2))])
            xlabel(ax(1),'Time [s]')
            ylabel(ax(1),'Voltage [\muV]')
            
        else
            cla(ax(1))
            cla(ax(2))
            title(ax(1),['Ch#',num2str(chan(chanInd)),...
                ' - This channel is empty (or the refchannel)'])
            title(ax(2),['Ch#',num2str(chan(chanInd)),...
                ' - This channel is empty (or the refchannel)'])
        end
    end

    function winInds = winMacher(adjInd,winLen)
        winLen = round((winLen/2)*fs);
        
        if eventsPeak{chanInd}(adjInd)-winLen > 1
            winStart = eventsPeak{chanInd}(adjInd)-winLen;
        else
            winStart = 1;
        end
        if eventsPeak{chanInd}(adjInd)+winLen <= length(data)
            winEnd = eventsPeak{chanInd}(adjInd)+winLen;
        else
            winEnd = length(data);
        end
        
        winInds = winStart:winEnd;
    end

    function r = corrCalculator(adjInd)
        winInds = winMacher(adjInd,0.2);
        r = corrcoef(refData(winInds),data(chanInd,winInds));
    end
end