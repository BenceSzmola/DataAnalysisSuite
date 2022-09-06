function selIvs = graphicIntervalSel(tAxis,fs,data,chans,refchans)
%% preparation
delMode = false;
numChans = length(chans);
dataLen = length(tAxis);
stepSize_ms = 100;
stepSize = round((stepSize_ms/1000)*fs);
selIvs = zeros(0,2);
currInd = 1;

%% main code
ivSelFig = figure('Name', 'Graphical interval selection',...
    'NumberTitle', 'off',...
    'WindowState', 'maximized',...
    'MenuBar', 'none',...
    'KeyPressFcn', @figKeyCB,...
    'WindowButtonDownFcn', @axButtDwnCB,...
    'CloseRequestFcn', @figCloseReqCB);
delIvMenu = uimenu(ivSelFig, 'Text', 'Delete interval mode (Keyboard: Delete) - OFF',...
    'MenuSelectedFcn', @delIvMenuCB);
uicontrol(ivSelFig,...
    'Style', 'text',...
    'Units', 'normalized',...
    'Position', [0.01, 0.97, 0.075, 0.025],...
    'String', 'Keyboard step size [ms]:');
stepSizeEdit = uicontrol(ivSelFig,...
    'Style', 'edit',...
    'Units', 'normalized',...
    'Position', [0.085, 0.97, 0.05, 0.025],...
    'String', num2str(stepSize_ms),...
    'Callback', @stepSizeEditCB);
stepSizeSlider = uicontrol(ivSelFig,...
    'Style', 'slider',...
    'Units', 'normalized',...
    'Position', [0.01, 0.945, 0.135, 0.02],...
    'Min', 10,...
    'Max', 1000,...
    'Value', stepSize_ms,...
    'Callback', @stepSizeSliderCB);

selLines = gobjects(numChans, 1);
highLightLines = gobjects(numChans, 1);
subs = gobjects(numChans, 1);
subTtl = sgtitle(ivSelFig, 'Start selecting intervals! When you''re done just close the window!');
for i = 1:numChans
    subs(i) = subplot(numChans, 1, i);
    plot(tAxis, data(i,:))
    if ismember(chans(i), refchans)
        title(sprintf('Ch #%d (ref)', chans(i)))
    else
        title(sprintf('Ch #%d', chans(i)))
    end
    hold on
    selLines(i) = xline(tAxis(currInd), '-r', 'LineWidth', 1);
    highLightLines(i) = plot(tAxis, nan(dataLen, 1), '-r');
    hold off
end
set(findobj(subs, 'Type', 'line'), 'HitTest', 'off')
linkaxes(subs, 'x')

drawnow
waitfor(ivSelFig)

%% helper functions
    function figKeyCB(~,e)
        switch e.Key
            case 'leftarrow'
                currInd = max(1, currInd - stepSize);
                
            case 'rightarrow'
                currInd = min(dataLen, currInd + stepSize);
                
            case 'uparrow'
                stepSize = min(round(fs*stepSizeSlider.Max/1000), stepSize + round(fs*10/1000));
                stepSizeEdit.String = num2str(round(1000*stepSize/fs));
                stepSizeSlider.Value = round(1000*stepSize/fs);
                
            case 'downarrow'
                stepSize = max(round(fs*stepSizeSlider.Min/1000), stepSize - round(fs*10/1000));
                stepSizeEdit.String = num2str(round(1000*stepSize/fs));
                stepSizeSlider.Value = round(1000*stepSize/fs);
                
            case 'end'
                currInd = dataLen;
                
            case 'home'
                currInd = 1;
                
            case 'escape'
                if ~isempty(selIvs) && isnan(selIvs(end,2))
                    delete(findobj(ivSelFig, 'Type', 'ConstantLine', '-and', 'Value', tAxis(selIvs(end,1)), '-and', 'LineStyle', '--'))
                    selIvs(end,:) = [];
                    subTtl.String = 'Deleted the open interval!';
                end
                
            case 'delete'
                delIvMenuCB
                
            case 'return'
                if ~delMode
                    if isempty(selIvs)
                        selIvs = [currInd, nan];
                    elseif isnan(selIvs(end,2))
                        selIvs(end,2) = currInd;
                        if selIvs(end,1) > selIvs(end,2)
                            selIvs(end,:) = fliplr(selIvs(end,:));
                        end
                    else
                        selIvs(end+1,:) = [currInd, nan];
                    end
                    drawIvBord(currInd,isnan(selIvs(end,2)))
                else
                    delIvs(currInd)
                end
                
        end
        if ~strcmp(e.Key, 'return')
            updateSelLines
        end
    end

    function axButtDwnCB(h,~)
        currPointMat = h.CurrentObject.CurrentPoint;
        [~,currInd] = min(abs(tAxis - currPointMat(1)));
        if ~delMode
            updateSelLines
        else
            delIvs(currInd)
        end
    end

    function updateSelLines
        set(selLines, 'Value', tAxis(currInd))
        set(selLines, 'HitTest', 'off')
    end

    function drawIvBord(xInd,ivStart)
        for axInd = 1:numChans
            xline(subs(axInd), tAxis(xInd), '--k', 'LineWidth', 1);
            if ivStart
                subTtl.String = 'Select end of interval!';
            else
                subTtl.String = sprintf('Interval selected! (#intervals = %d)', size(selIvs, 1));
                currIv = selIvs(end,1):selIvs(end,2);
                highLightLines(axInd).YData(currIv) = data(axInd,currIv);
            end
        end
    end

    function delIvs(inpInd)
        rows2del = find((inpInd >= selIvs(:,1)) & (inpInd <= selIvs(:,2)));
        for row = 1:length(rows2del)
            delete(findobj(ivSelFig, 'Type', 'ConstantLine', '-and', 'Value', tAxis(selIvs(rows2del(row),1)), '-and', 'LineStyle', '--'))
            delete(findobj(ivSelFig, 'Type', 'ConstantLine', '-and', 'Value', tAxis(selIvs(rows2del(row),2)), '-and', 'LineStyle', '--'))
            
            for row2 = 1:numChans
                highLightLines(row2).YData(selIvs(rows2del(row),1):selIvs(rows2del(row),2)) = nan;
            end
        end
        selIvs(rows2del,:) = [];
        
        if isempty(selIvs)
            delMode = false;
            delIvMenu.Text = 'Delete interval mode (Keyboard: Delete) - OFF';
            subTtl.String = 'All intervals deleted!';
        end
    end

    function delIvMenuCB(~,~)
        if isempty(selIvs)
            eD = errordlg('No intervals yet!');
            pause(1)
            if ishandle(eD)
                close(eD)
            end
        elseif isnan(selIvs(end,2))
            return
        else
            delMode = ~delMode;
            if delMode
                delIvMenu.Text = 'Delete interval mode (Keyboard: Delete) - ON';
                subTtl.String = 'Delete mode active (Click into interval or press return to delete)';
            else
                delIvMenu.Text = 'Delete interval mode (Keyboard: Delete) - OFF';
                subTtl.String = 'Exited delete mode';
            end
        end
    end

    function stepSizeEditCB(~,~)
        newVal = str2double(stepSizeEdit.String);
        if newVal < stepSizeSlider.Min
            newVal = stepSizeSlider.Min;
            stepSizeEdit.String = num2str(newVal);
        elseif newVal > stepSizeSlider.Max
            newVal = stepSizeSlider.Max;
            stepSizeEdit.String = num2str(newVal);
        end
        stepSizeSlider.Value = newVal;
        stepSize = round((newVal/1000)*fs);
    end

    function stepSizeSliderCB(~,~)
        stepSizeEdit.String = num2str(stepSizeSlider.Value);
        stepSize = round((stepSizeSlider.Value/1000)*fs);
    end

    function figCloseReqCB(h,~)
        if isempty(selIvs) || isnan(selIvs(end,2))
            if isempty(selIvs)
                quest = 'No intervals selected, close anyway?';
            elseif isnan(selIvs(end,2))
                quest = 'The last interval isn''t closed. Close window anyway (last interval will be discarded)?';
            end
            choice = questdlg(quest, 'Close window');
            if ~strcmp(choice, 'Yes')
                return
            else
                if ~isempty(selIvs)
                    selIvs(end,:) = [];
                end
                delete(h)
            end
        else
            delete(h)
        end
    end

end