classdef DASeV < handle
    %% Initializing components
    properties (Access = private)
        mainFig
        
        %% menus
        optMenu
        ephysTypMenu
        highPassRawEphysMenu
        plotFullMenu
        
        %% tabs
        tabgrp
        loadTab
        viewerTab
        
        %% loadTab members
        selDirButt
        
        fileList
        
        fileInfoPanel
        fnameLabel
        fnameTxt
        commentsTxt
        ephysDetTypeLabel
        ephysDetTypeTxt
        ephysChanLabel
        ephysChanTxt
        ephysParamTable
        imagingDetTypeLabel
        imagingDetTypeTxt
        imagingRoiLabel
        imagingRoiTxt
        imagingParamTable
        
        loadDASSaveButt
        
        %% viewerTab members
        statPanel
        ephysDetParamsTable
        imagingDetParamsTable
        
        plotPanel
        fixWinSwitch
        ephysDetUpButt
        ephysDetDwnButt
        ephysChanUpButt
        ephysChanDwnButt
        ephysFixWinChanUpButt
        ephysFixWinChanDwnButt
        imagingDetUpButt
        imagingDetDwnButt
        imagingRoiUpButt
        imagingRoiDwnButt
        imagingFixWinRoiUpButt
        imagingFixWinRoiDwnButt
        
        
        % all the axes
        ax11
        ax21
        ax22
        ax31
        ax32
        ax33
        ax41
        ax42
        ax43
        ax44
        ax51
        ax52
        ax53
        ax54
        ax55
    end
    
    %% Initializing data stored in GUI
    properties (Access = private)
        %% general
        xLabel = 'Time [s]';
        loaded = [0,0,0]; % ephys-imaging-running (0-1)
        prevNumAx = 1;
        plotFull = 0;
        fixWin = 0;
        keyboardPressDtyp = 1;
        
        %% ephys stuff
        highPassRawEphys = 0;
        ephysRefCh = 0;
        ephysTypSelected = [1,0,0]; % raw-dog-instpow
        ephysData
        ephysDoGGed
        ephysInstPow
        ephysFs
        ephysTaxis
        ephysParams
        ephysDetParams
        ephysDets
        ephysDetBorders
        ephysYlabel
        ephysDetInfo
        ephysCurrDetNum = 1;
        ephysCurrDetRow = 1;
        ephysFixWinDetRow = 1;
        
        %% imaging
        imagingData
        imagingFs
        imagingTaxis
        imagingYlabel
        imagingDets
        imagingDetBorders
        imagingDetInfo
        imagingDetParams
        
        imagingCurrDetNum = 1;
        imagingCurrDetRow = 1;
        imagingFixWinDetRow = 1;
    end
    
    %% Constructor part
    methods (Access = public)
        %% Constructor function
        function gO = DASeV
            createComponents(gO)
%             allAx = findobj(gO.mainFig,'Type','axes');
%             for i = 1:length(allAx)
%                 allAx(i).Toolbar.Visible = 'on';
%             end
            if ~isempty(gO.fileList.String)
                fileListSel(gO)
            end
%             mainFigOpenFcn(guiobj)
            if nargout == 0
                clear gO
            end
        end
    end
    
    %% Helper functions
    methods (Access = private)
        %%
        function axVisSwitch(gO,numAx)
            zum = zoom(gO.mainFig);
            panobj = pan(gO.mainFig);
            switch numAx
                case 1
                    gO.ax11.Visible = 'on';
                    gO.ax21.Visible = 'off';
                    gO.ax22.Visible = 'off';
                    gO.ax31.Visible = 'off';
                    gO.ax32.Visible = 'off';
                    gO.ax33.Visible = 'off';
                    gO.ax41.Visible = 'off';
                    gO.ax42.Visible = 'off';
                    gO.ax43.Visible = 'off';
                    gO.ax44.Visible = 'off';
                    gO.ax51.Visible = 'off';
                    gO.ax52.Visible = 'off';
                    gO.ax53.Visible = 'off';
                    gO.ax54.Visible = 'off';
                    gO.ax55.Visible = 'off';
                case 2
                    gO.ax11.Visible = 'off';
                    gO.ax21.Visible = 'on';
                    gO.ax22.Visible = 'on';
                    gO.ax31.Visible = 'off';
                    gO.ax32.Visible = 'off';
                    gO.ax33.Visible = 'off';
                    gO.ax41.Visible = 'off';
                    gO.ax42.Visible = 'off';
                    gO.ax43.Visible = 'off';
                    gO.ax44.Visible = 'off';
                    gO.ax51.Visible = 'off';
                    gO.ax52.Visible = 'off';
                    gO.ax53.Visible = 'off';
                    gO.ax54.Visible = 'off';
                    gO.ax55.Visible = 'off';
                case 3
                    gO.ax11.Visible = 'off';
                    gO.ax21.Visible = 'off';
                    gO.ax22.Visible = 'off';
                    gO.ax31.Visible = 'on';
                    gO.ax32.Visible = 'on';
                    gO.ax33.Visible = 'on';
                    gO.ax41.Visible = 'off';
                    gO.ax42.Visible = 'off';
                    gO.ax43.Visible = 'off';
                    gO.ax44.Visible = 'off';
                    gO.ax51.Visible = 'off';
                    gO.ax52.Visible = 'off';
                    gO.ax53.Visible = 'off';
                    gO.ax54.Visible = 'off';
                    gO.ax55.Visible = 'off';
                case 4
                    gO.ax11.Visible = 'off';
                    gO.ax21.Visible = 'off';
                    gO.ax22.Visible = 'off';
                    gO.ax31.Visible = 'off';
                    gO.ax32.Visible = 'off';
                    gO.ax33.Visible = 'off';
                    gO.ax41.Visible = 'on';
                    gO.ax42.Visible = 'on';
                    gO.ax43.Visible = 'on';
                    gO.ax44.Visible = 'on';
                    gO.ax51.Visible = 'off';
                    gO.ax52.Visible = 'off';
                    gO.ax53.Visible = 'off';
                    gO.ax54.Visible = 'off';
                    gO.ax55.Visible = 'off';
                case 5
                    gO.ax11.Visible = 'off';
                    gO.ax21.Visible = 'off';
                    gO.ax22.Visible = 'off';
                    gO.ax31.Visible = 'off';
                    gO.ax32.Visible = 'off';
                    gO.ax33.Visible = 'off';
                    gO.ax41.Visible = 'off';
                    gO.ax42.Visible = 'off';
                    gO.ax43.Visible = 'off';
                    gO.ax44.Visible = 'off';
                    gO.ax51.Visible = 'on';
                    gO.ax52.Visible = 'on';
                    gO.ax53.Visible = 'on';
                    gO.ax54.Visible = 'on';
                    gO.ax55.Visible = 'on';
            end
            
            allAx = findobj(gO.mainFig,'Type','axes');
            actAx = findobj(allAx,'Visible','on');
            actAx = findobj(actAx,'Type','axes');
            inactAx = findobj(allAx,'Visible','off');
            inactAx = findobj(inactAx,'Type','axes');
            setAllowAxesZoom(zum,actAx,true)
            setAllowAxesZoom(zum,inactAx,false)
            setAllowAxesPan(panobj,actAx,true)
            setAllowAxesPan(panobj,inactAx,false)
            for i = 1:length(inactAx)
                cla(inactAx(i))
                
            end
            
            drawnow
        end
        
        %%
        function ephysPlot(gO,ax)
            currDetNum = gO.ephysCurrDetNum;
            currDetRow = gO.ephysCurrDetRow;
            
            currDetRows = 1:length(gO.ephysDetInfo);
            emptyChans = [];
            % Filtering out channels with no detections
            for j = 1:length(currDetRows)
                if isempty(find(~isnan(gO.ephysDets(currDetRows(j),:)),1))
                    emptyChans = [emptyChans, j];
                end
            end
            
            currDetRows(emptyChans) = [];
            currDetRow = currDetRows(currDetRow);
            
            numDets = length(find(~isnan(gO.ephysDets(currDetRow,:))));
            chan = gO.ephysDetInfo(currDetRow).Channel;
            
            currDetBorders = gO.ephysDetBorders{currDetRow};
            
            if numDets == 0
                return
            end
            
            if ~gO.plotFull
                gO.ephysDetUpButt.Enable = 'on';
                gO.ephysDetDwnButt.Enable = 'on';
                
                currDetParamsRows = gO.ephysDetParams{currDetRow};
                if ~isempty(currDetParamsRows)
                    currDetParams = currDetParamsRows(currDetNum);
                    assignin('base','currDetParams',currDetParams)
                    temp = [fieldnames([currDetParams]), squeeze(struct2cell([currDetParams]))];
                    gO.ephysDetParamsTable.Data = temp;
                    gO.ephysDetParamsTable.RowName = [];
                    gO.ephysDetParamsTable.ColumnName = {'Electrophysiology','Values'};
                end
                
%                 currDetBorders = gO.ephysDetBorders{currDetRow};
                if ~isempty(currDetBorders)
                    currDetBorders = currDetBorders(currDetNum,:);
                end
                
                detIdx = gO.ephysDets(currDetRow,:);
                detIdx = find(~isnan(detIdx));
                detIdx = detIdx(currDetNum);
                tDetInds = gO.ephysTaxis(detIdx);

                win = 0.5;
                win = round(win*gO.ephysFs,4);
                
                if ~isempty(currDetBorders)
                    winStart = currDetBorders(1)-win;
                    winEnd = currDetBorders(2)+win;
                    if (winStart > 0) & (winEnd <= length(gO.ephysTaxis))
                        winIdx = winStart:winEnd;
                        tWin = gO.ephysTaxis(winIdx);
                    elseif winStart <= 0
                        winIdx = 1:winEnd;
                        tWin = gO.ephysTaxis(winIdx);
                    elseif winEnd > length(gO.ephysTaxis)
                        winIdx = winStart:length(gO.ephysTaxis);
                        tWin = gO.ephysTaxis(winIdx);
                    end
                else
                    if (detIdx-win > 0) & (detIdx+win <= length(gO.ephysTaxis))
                        winIdx = detIdx-win:detIdx+win;
                        tWin = gO.ephysTaxis(winIdx);
                    elseif detIdx-win <= 0
                        winIdx = 1:detIdx+win;
                        tWin = gO.ephysTaxis(winIdx);
                    elseif detIdx+win > length(gO.ephysTaxis)
                        winIdx = detIdx-win:length(gO.ephysTaxis);
                        tWin = gO.ephysTaxis(winIdx);
                    end
                end
            
                if gO.fixWin == 1
                    chan = gO.ephysDetInfo(gO.ephysFixWinDetRow).Channel;
                    if chan == gO.ephysRefCh
                        axTitle = ['Channel #',num2str(chan), ' (Ref)'];
                    else
                        axTitle = ['Channel #',num2str(chan)];
                    end
                elseif gO.fixWin == 0
                    if chan == gO.ephysRefCh
                        axTitle = ['Channel #',num2str(chan), ' (Ref)',...
                            '      Detection #',...
                            num2str(currDetNum),'/',num2str(numDets)];
                    else
                        axTitle = ['Channel #',num2str(chan),'      Detection #',...
                            num2str(currDetNum),'/',num2str(numDets)];
                    end
                    
                end
            elseif gO.plotFull
                gO.ephysDetUpButt.Enable = 'off';
                gO.ephysDetDwnButt.Enable = 'off';
                gO.ephysCurrDetNum = 1;
                
                currDetParamsRows = gO.ephysDetParams{currDetRow};
                if ~isempty(currDetParamsRows)
                    currDetParamsAvg = mean(cell2mat(struct2cell(currDetParamsRows)),3);
                    temp = [fieldnames([currDetParamsRows(1)]),...
                        mat2cell(currDetParamsAvg,ones(1,length(currDetParamsAvg)))];
                    gO.ephysDetParamsTable.Data = temp;
                    gO.ephysDetParamsTable.RowName = [];
                    gO.ephysDetParamsTable.ColumnName = {'','Mean values'};
                end
                
                detInds = gO.ephysDets(currDetRow,:);
                detInds = find(~isnan(detInds));
                tDetInds = gO.ephysTaxis(detInds);
                
                winIdx = 1:length(gO.ephysTaxis);
                tWin = gO.ephysTaxis;
                                
                if chan == gO.ephysRefCh
                    axTitle = ['Channel #',num2str(chan),' (Ref)',...
                        '      #Detections = ',num2str(numDets)];
                else
                    axTitle = ['Channel #',num2str(chan),'      #Detections = ',...
                        num2str(numDets)];
                end
            end
                        
            data = [];
            axLims = [];
            yLabels = [];
            [b,a] = butter(2,5/(gO.ephysFs/2),'high');
            switch sum(gO.ephysTypSelected)
                case 1
                    if gO.ephysTypSelected(1)
                        if gO.highPassRawEphys == 1
                            temp = filtfilt(b,a,gO.ephysData(chan,:));
                            data = temp(winIdx);
%                             axLims = [tWin(1), tWin(end), min(temp), max(temp)];
                            axLims = [min(temp), max(temp)];
                        elseif gO.highPassRawEphys == 0
                            data = gO.ephysData(chan,winIdx);
%                             axLims = [tWin(1), tWin(end),...
                            axLims = [min(gO.ephysData(chan,:)), max(gO.ephysData(chan,:))];
                        end
                        yLabels = string(gO.ephysYlabel);
                    elseif gO.ephysTypSelected(2)
                        data = gO.ephysDoGGed(chan,winIdx);
%                         axLims = [tWin(1), tWin(end),...
                        axLims = [min(gO.ephysDoGGed(chan,:)), max(gO.ephysDoGGed(chan,:))];
                        yLabels = string(gO.ephysYlabel);
                    elseif gO.ephysTypSelected(3)
                        data = gO.ephysInstPow(chan,winIdx);
%                         axLims = [tWin(1), tWin(end),...
                        axLims = [min(gO.ephysInstPow(chan,:)), max(gO.ephysInstPow(chan,:))];
                        temp = find(gO.ephysYlabel=='[');
                        yLabels = string(['Power ',gO.ephysYlabel(temp:end-1),...
                                '^2]']);
                    end
                case 2
                    if gO.ephysTypSelected(1)
                        if gO.highPassRawEphys == 1
                            tempfull = filtfilt(b,a,gO.ephysData(chan,:));
                            temp = tempfull(winIdx);
%                             axLims = [axLims; tWin(1), tWin(end),...
                            axLims = [axLims; min(tempfull), max(tempfull)];
                        elseif gO.highPassRawEphys == 0
                            temp = gO.ephysData(chan,winIdx);
%                             axLims = [axLims; tWin(1), tWin(end),...
                            axLims = [axLims; min(gO.ephysData(chan,:)), max(gO.ephysData(chan,:))];
                        end
                        data = [data; temp];
                        yLabels = [string(yLabels); string(gO.ephysYlabel)];
                    end
                    if gO.ephysTypSelected(2)
                        data = [data; gO.ephysDoGGed(chan,winIdx)];
%                         axLims = [axLims; tWin(1), tWin(end),...
                        axLims = [axLims; min(gO.ephysDoGGed(chan,:)), max(gO.ephysDoGGed(chan,:))];
                        yLabels = [string(yLabels); string(gO.ephysYlabel)];
                    end
                    if gO.ephysTypSelected(3)
                        data = [data; gO.ephysInstPow(chan,winIdx)];
%                         axLims = [axLims; tWin(1), tWin(end),...
                        axLims = [axLims; min(gO.ephysInstPow(chan,:)), max(gO.ephysInstPow(chan,:))];
                        temp = find(gO.ephysYlabel=='[');
                        yLabels = [string(yLabels); string(['Power ',gO.ephysYlabel(temp:end-1),...
                                '^2]'])];
                    end
                case 3
                    if gO.highPassRawEphys == 1
                        tempfull = filtfilt(b,a,gO.ephysData(chan,:));
                        temp = tempfull(winIdx);
%                         axLims = [tWin(1), tWin(end),...
                        axLims = [min(tempfull), max(tempfull)];
                    elseif gO.highPassRawEphys == 0
                        temp = gO.ephysData(chan,winIdx);
%                         axLims = [tWin(1), tWin(end),...
                        axLims = [min(gO.ephysData(chan,:)), max(gO.ephysData(chan,:))];
                    end
                    data = [temp;...
                        gO.ephysDoGGed(chan,winIdx);...
                        gO.ephysInstPow(chan,winIdx)];
                    axLims = [axLims;... %axLims(1:2), ...
                        min(gO.ephysDoGGed(chan,:)), max(gO.ephysDoGGed(chan,:));
                        min(gO.ephysInstPow(chan,:)), max(gO.ephysInstPow(chan,:))];
                    temp = find(gO.ephysYlabel=='[');
                    yLabels = [string(gO.ephysYlabel); string(gO.ephysYlabel);...
                        string(['Power ',gO.ephysYlabel(temp:end-1),...
                                '^2]'])];
            end
            
            for i = 1:min(size(data))
                plot(ax(i),tWin,data(i,:))
                hold(ax(i),'on')
%                 if chan == gO.ephysDetInfo(1).Params.RefCh
%                     for j = 1:2:length(tDetInds)
%                         plot(ax(i),tWin(tDetInds(j):tDetInds(j+1)),data(i,tDetInds(j):tDetInds(j+1)),'-r')
%                     end
%                 else
                    for j = 1:length(tDetInds)
                        xline(ax(i),tDetInds(j),'Color','r','LineWidth',1);
                        if ~isempty(currDetBorders)
                            xline(ax(i),gO.ephysTaxis(currDetBorders(j,1)),'Color','g','LineWidth',1);
                            xline(ax(i),gO.ephysTaxis(currDetBorders(j,2)),'Color','g','LineWidth',1);
                        end
                    end
%                 end
                hold(ax(i),'off')
                xlabel(ax(i),gO.xLabel)
                ylabel(ax(i),yLabels(i,:))
%                 axis(ax(i),axLims(i,:))
                axis(ax(i),'tight')
                ylim(ax(i),axLims(i,:))
                title(ax(i),axTitle)
                
%                 z = zoom(gO.mainFig);
%                 setAllowAxesZoom(z,ax(i),1)
%                 getAxesZoomConstraint(z,ax(i))
            end
            
        end
        
        %%
        function imagingPlot(gO,ax)
            currDetNum = gO.imagingCurrDetNum;
            currDetRow = gO.imagingCurrDetRow;
            
            currDetRows = 1:length(gO.imagingDetInfo);
            emptyChans = [];
            % Filtering out channels with no detections
            for j = 1:length(currDetRows)
                if isempty(find(~isnan(gO.imagingDets(currDetRows(j),:)),1))
                    emptyChans = [emptyChans, j];
                end
            end
            currDetRows(emptyChans) = [];
            currDetRow = currDetRows(currDetRow);
            
            numDets = length(find(~isnan(gO.imagingDets(currDetRow,:))));
            chan = gO.imagingDetInfo(currDetRow).Roi;
            
            currDetBorders = gO.imagingDetBorders{currDetRow};
            
            if numDets == 0
                return
            end
            
            if ~gO.plotFull
                gO.imagingDetUpButt.Enable = 'on';
                gO.imagingDetDwnButt.Enable = 'on';
                
                currDetParamsRows = gO.imagingDetParams{currDetRow};
                if ~isempty(currDetParamsRows)
                    currDetParams = currDetParamsRows(currDetNum);
                    assignin('base','currDetParams',currDetParams)
                    temp = [fieldnames([currDetParams]), squeeze(struct2cell([currDetParams]))];
                    gO.imagingDetParamsTable.Data = temp;
                    gO.imagingDetParamsTable.RowName = [];
                    gO.imagingDetParamsTable.ColumnName = {'Imaging','Values'};
                end
                
                detIdx = gO.imagingDets(currDetRow,:);
                detIdx = find(~isnan(detIdx));
                detIdx = detIdx(currDetNum);
                tDetInds = gO.imagingTaxis(detIdx);

                win = 0.5;
                win = round(win*gO.imagingFs,0);
                
                
                if ~isempty(currDetBorders)
                    currDetBorders = currDetBorders(currDetNum,:);
                    
                    winStart = currDetBorders(1)-win;
                    winEnd = currDetBorders(2)+win;
                    if (winStart > 0) & (winEnd <= length(gO.imagingTaxis))
                        winIdx = winStart:winEnd;
                        tWin = gO.imagingTaxis(winIdx);
                    elseif winStart <= 0
                        winIdx = 1:winEnd;
                        tWin = gO.imagingTaxis(winIdx);
                    elseif winEnd > length(gO.imagingTaxis)
                        winIdx = winStart:length(gO.imagingTaxis);
                        tWin = gO.imagingTaxis(winIdx);
                    end
                else
                    if (detIdx-win > 0) & (detIdx+win <= length(gO.imagingTaxis))
                            winIdx = detIdx-win:detIdx+win;
                            tWin = gO.imagingTaxis(winIdx);
                        elseif detIdx-win <= 0
                            winIdx = 1:detIdx+win;
                            tWin = gO.imagingTaxis(winIdx);
                        elseif detIdx+win > length(gO.imagingTaxis)
                            winIdx = detIdx-win:length(gO.imagingTaxis);
                            tWin = gO.imagingTaxis(winIdx);
                    end
                end
%                 axTitle = ['ROI #',num2str(chan),'      Detection #',...
%                                 num2str(currDetNum),'/',num2str(numDets)];
                
                if gO.fixWin == 1
                    chan = gO.imagingDetInfo(gO.imagingFixWinDetRow).Roi;
                    axTitle = ['ROI #',num2str(chan)];
                elseif gO.fixWin == 0
                    axTitle = ['ROI #',num2str(chan),'      Detection #',...
                        num2str(currDetNum),'/',num2str(numDets)];
                end
                
            elseif gO.plotFull
                gO.imagingDetUpButt.Enable = 'off';
                gO.imagingDetDwnButt.Enable = 'off';
                gO.imagingCurrDetNum = 1;
                
                currDetParamsRows = gO.imagingDetParams{currDetRow};
                if ~isempty(currDetParamsRows)
                    currDetParamsAvg = mean(cell2mat(struct2cell(currDetParamsRows)),3);
                    temp = [fieldnames([currDetParamsRows(1)]),...
                        mat2cell(currDetParamsAvg,ones(1,length(currDetParamsAvg)))];
                    gO.imagingDetParamsTable.Data = temp;
                    gO.imagingDetParamsTable.RowName = [];
                    gO.imagingDetParamsTable.ColumnName = {'','Mean values'};
                end
                
                detInds = gO.imagingDets(currDetRow,:);
                detInds = find(~isnan(detInds));
                tDetInds = gO.imagingTaxis(detInds);
                
                winIdx = 1:length(gO.imagingTaxis);
                tWin = gO.imagingTaxis;
                
                axTitle = ['ROI #',num2str(chan),'      #Detections = ',...
                    num2str(numDets)];
            end
            
            data = gO.imagingData(chan,winIdx);
            axLims = [min(gO.imagingData(chan,:)), max(gO.imagingData(chan,:))];
            yLabels = string(gO.imagingYlabel);
            
            for i = 1:min(size(data))
                plot(ax(i),tWin,data(i,:))
                hold(ax(i),'on')
                for j = 1:length(tDetInds)
                    xline(ax(i),tDetInds(j),'Color','r','LineWidth',1);
                    if ~isempty(currDetBorders)
                        xline(ax(i),gO.imagingTaxis(currDetBorders(j,1)),'Color','g','LineWidth',1);
                        xline(ax(i),gO.imagingTaxis(currDetBorders(j,2)),'Color','g','LineWidth',1);
                    end
                end
                hold(ax(i),'off')
                xlabel(ax(i),gO.xLabel)
                ylabel(ax(i),yLabels(i,:))
%                 axis(ax(i),axLims(i,:))
                axis(ax(i),'tight')
                ylim(ax(i),axLims(i,:))
                title(ax(i),axTitle)
            end
        end
        
        %% 
        function smartplot(gO)
            axVisSwitch(gO,sum(gO.loaded)+(sum(gO.ephysTypSelected)-1))
            %%%
%             axVisSwitch(gO,5)
%             gO.loaded = [1,1,2];
            %%%
            switch sum(gO.loaded)
                case 1
                    if gO.loaded(1)
                        switch sum(gO.ephysTypSelected)
                            case 1
                                ax = [gO.ax11];
                            case 2
                                ax = [gO.ax21, gO.ax22];
                            case 3
                                ax = [gO.ax31, gO.ax32, gO.ax33];
                        end
                        linkaxes(ax,'x')
                        ephysPlot(gO,ax)
                    elseif gO.loaded(2)
                        ax = [gO.ax11];
                        linkaxes(ax,'x')
                        imagingPlot(gO,ax)
                    elseif gO.loaded(3)
                        
                    end
                case 2
                    ephysAxCount = 0;
                    if gO.loaded(1)
                        switch sum(gO.ephysTypSelected)
                            case 1
                                ax = [gO.ax21];
                                ephysAxCount = 1;
                            case 2
                                ax = [gO.ax31, gO.ax32];
                                ephysAxCount = 2;
                            case 3
                                ax = [gO.ax41, gO.ax42, gO.ax43];
                                ephysAxCount = 3;
                        end
                        linkaxes(ax,'x')
                        ephysPlot(gO,ax)
                    end
                    if gO.loaded(2)
                        switch ephysAxCount
                            case 0
                                ax = [gO.ax21];
                            case 1
                                ax = [gO.ax22];
                            case 2
                                ax = [gO.ax33];
                            case 3
                                ax = [gO.ax44];
                        end
                        linkaxes(ax,'x')
                        imagingPlot(gO,ax)
                    end
                case 3
                    ephysAxCount = 0;
                    if gO.loaded(1)
                        switch sum(gO.ephysTypSelected)
                            case 1
                                ephysAxCount = 1;
                                ax = [gO.ax31];
                            case 2
                                ephysAxCount = 2;
                                ax = [gO.ax41, gO.ax42];
                            case 3
                                ephysAxCount = 3;
                                ax = [gO.ax51, gO.ax52, gO.ax53];
                        end
                        linkaxes(ax,'x')
                        ephysPlot(gO,ax)
                    end
                    if gO.loaded(2)
                        switch ephysAxCount
                            case 0
                                ax = [gO.ax31];
                            case 1
                                ax = [gO.ax32];
                            case 2
                                ax = [gO.ax43];
                            case 3
                                ax = [gO.ax54];
                        end
                        linkaxes(ax,'x')
                        imagingPlot(gO,ax)
                    end
            end
        end
    end
    
    %% Callback functions
    methods (Access = private)
        
        %%
        function ephysTypMenuSel(gO,~,~)
            [idx,tf] = listdlg('ListString',{'Raw','DoG','InstPow'},...
                'PromptString','Select data type(s) to show detections on!');
            if ~tf
                return
            end
            
            gO.ephysTypSelected(:) = 0;
            gO.ephysTypSelected(idx) = 1;
            
            smartplot(gO)
        end
        
        %%
        function highPassRawEphysMenuSel(gO,~,~)
            if strcmp(gO.highPassRawEphysMenu.Checked,'off')
                gO.highPassRawEphys = 1;
                gO.highPassRawEphysMenu.Checked = 'on';
            else
                gO.highPassRawEphys = 0;
                gO.highPassRawEphysMenu.Checked = 'off';
            end
            smartplot(gO)
        end
        
        %%
        function plotFullMenuSel(gO,~,~)
            if gO.plotFull == 1
                gO.plotFull = 0;
            elseif gO.plotFull == 0
                gO.plotFull = 1;
                gO.fixWinSwitch.Value = 0;
                fixWinSwitchPress(gO)
            end
            smartplot(gO)
        end
        
        %%
        function tabChanged(gO,~,e)
            if (e.NewValue == gO.tabgrp.Children(2)) & isempty(find(gO.loaded,1))
                gO.tabgrp.SelectedTab = e.OldValue;
                drawnow
                warndlg('No file loaded!')
            end
        end
        
        %%
        function selDirButtPress(gO,~,~)
            newdir = uigetdir;
            if newdir == 0
                return
            end
            cd(newdir)
            newdir = [newdir,'\*DASsave*.mat'];
            newlist = dir(newdir);
            if isempty(newdir)
                warndlg('Selected directory does not include any save files!')
                return
            end
            newlist = {newlist.name};
            gO.fileList.String = newlist;
        end
        
        %%
        function loadSaveButtPress(gO,~,~)
            val = gO.fileList.Value;
            if ~isempty(gO.fileList.String)
                fname = gO.fileList.String{val};
            else
                warndlg('No file selected!')
                return
            end
            
            gO.ephysCurrDetNum = 1;
            gO.ephysCurrDetRow = 1;
            
            testload = matfile(fname);

            gO.loaded(1) = 0;
            gO.ephysDetUpButt.Enable = 'off';
            gO.ephysDetDwnButt.Enable = 'off';
            gO.ephysChanUpButt.Enable = 'off';
            gO.ephysChanDwnButt.Enable = 'off';

            if (~isempty(find(strcmp(fieldnames(testload),'ephysSaveData'),1)))...
                    & (~isempty(find(strcmp(fieldnames(testload),'ephysSaveInfo'),1)))
                load(fname,'ephysSaveData','ephysSaveInfo')

                if ~isempty(ephysSaveData) & ~isempty(ephysSaveInfo)
                    gO.ephysData = ephysSaveData.RawData;
                    gO.ephysFs = ephysSaveData.Fs;
                    gO.ephysTaxis = ephysSaveData.TAxis;
                    gO.ephysYlabel = ephysSaveData.YLabel;
                    gO.ephysDets = ephysSaveData.Dets;
                    try
                        gO.ephysDetBorders = ephysSaveData.DetBorders;
                    catch
                        gO.ephysDetBorders = cell(min(size(gO.ephysData)),1);
                    end
                    try 
                        gO.ephysDetParams = ephysSaveData.DetParams;
                    catch
                        gO.ephysDetParams = cell(min(size(gO.ephysData)),1);
                    end
                    gO.ephysDetInfo = ephysSaveInfo;
                    if ~strcmp(gO.ephysDetInfo(1).DetType,'Adapt')
                        if gO.ephysDetInfo(1).Params.RefCh ~= 0
                            gO.ephysRefCh = gO.ephysDetInfo(1).Params.RefCh;
                        end
                    end

                    gO.ephysDetUpButt.Enable = 'on';
                    gO.ephysDetDwnButt.Enable = 'on';
                    gO.ephysChanUpButt.Enable = 'on';
                    gO.ephysChanDwnButt.Enable = 'on';

                    gO.loaded(1) = 1;

                    gO.ephysDoGGed = DoG(gO.ephysData,gO.ephysFs,150,250);
                    gO.ephysInstPow = instPow(gO.ephysData,gO.ephysFs,150,250);
                    
                    axButtPress(gO,1,0,0)

                    
                end
            end
            
            gO.loaded(2) = 0;
            gO.imagingDetUpButt.Enable = 'off';
            gO.imagingDetDwnButt.Enable = 'off';
            gO.imagingRoiUpButt.Enable = 'off';
            gO.imagingRoiDwnButt.Enable = 'off';            

            if (~isempty(find(strcmp(fieldnames(testload),'imagingSaveData'),1)))...
                    & (~isempty(find(strcmp(fieldnames(testload),'imagingSaveInfo'),1)))
                load(fname,'imagingSaveData','imagingSaveInfo')
                
                if ~isempty(imagingSaveData) & ~isempty(imagingSaveInfo)
                    gO.imagingData = imagingSaveData.RawData;
                    gO.imagingFs = imagingSaveData.Fs;
                    gO.imagingTaxis = imagingSaveData.TAxis;
                    gO.imagingYlabel = imagingSaveData.YLabel;
                    gO.imagingDets = imagingSaveData.Dets;
                    try
                        gO.imagingDetBorders = imagingSaveData.DetBorders;
                    catch
                        gO.imagingDetBorders = cell(min(size(gO.imagingData)),1);
                    end
                    try
                        gO.imagingDetParams = imagingSaveData.DetParams;
                    catch
                        gO.imagingDetParams = cell(min(size(gO.imagingData)),1);
                    end
                    gO.imagingDetInfo = imagingSaveInfo;

                    gO.imagingDetUpButt.Enable = 'on';
                    gO.imagingDetDwnButt.Enable = 'on';
                    gO.imagingRoiUpButt.Enable = 'on';
                    gO.imagingRoiDwnButt.Enable = 'on';
                    
                    gO.loaded(2) = 1;
                    axButtPress(gO,2,0,0)
                end
            end
            
            
            if ~isempty(find(gO.loaded, 1))
                gO.tabgrp.SelectedTab = gO.tabgrp.Children(2);

%                 smartplot(gO)
            end
        end
        
        %%
        function fileListSel(gO,~,~)
            val = gO.fileList.Value;
            if ~isempty(gO.fileList.String)
                fname = gO.fileList.String{val};
            else
                warndlg('No DAS save files in current directory!')
                return
            end
            
            testload = matfile(fname);
            
            if ~isempty(find(strcmp(fieldnames(testload),'comments'),1))
                load(fname,'comments')
                gO.commentsTxt.String = comments;
            end
            
            gO.fnameTxt.String = fname;
            
            if ~isempty(find(strcmp(fieldnames(testload),'ephysSaveInfo'),1))
                load(fname,'ephysSaveInfo')
                if ~isempty(ephysSaveInfo)
%                     gO.fnameTxt.String = fname;
                    gO.ephysDetTypeTxt.String = ephysSaveInfo.DetType;
                    gO.ephysChanTxt.String = num2str([ephysSaveInfo.Channel]);
                    gO.ephysParamTable.Data = squeeze(struct2cell(ephysSaveInfo(1).Params))';
                    gO.ephysParamTable.ColumnName = fieldnames(ephysSaveInfo(1).Params);
                else
                    gO.ephysDetTypeTxt.String = '';
                    gO.ephysChanTxt.String = '';
                    gO.ephysParamTable.Data = [];
                    gO.ephysParamTable.ColumnName = '';
                end
            else
                gO.ephysDetTypeTxt.String = '';
                gO.ephysChanTxt.String = '';
                gO.ephysParamTable.Data = [];
                gO.ephysParamTable.ColumnName = '';
            end
            
            if ~isempty(find(strcmp(fieldnames(testload),'imagingSaveInfo'),1))
                load(fname,'imagingSaveInfo')
                if ~isempty(imagingSaveInfo)
                    gO.imagingDetTypeTxt.String = imagingSaveInfo.DetType;
                    gO.imagingRoiTxt.String = num2str([imagingSaveInfo.Roi]);
                    gO.imagingParamTable.Data = squeeze(struct2cell(imagingSaveInfo(1).Params))';
                    gO.imagingParamTable.ColumnName = fieldnames(imagingSaveInfo(1).Params);
                else
                    gO.imagingDetTypeTxt.String = '';
                    gO.imagingRoiTxt.String = '';
                    gO.imagingParamTable.Data = [];
                    gO.imagingParamTable.ColumnName = '';
                end
            else
                gO.imagingDetTypeTxt.String = '';
                gO.imagingRoiTxt.String = '';
                gO.imagingParamTable.Data = [];
                gO.imagingParamTable.ColumnName = '';
            end
        end
        
        %%
        function axButtPress(gO,dTyp,detUpDwn,chanUpDwn)
            switch dTyp
                case 1
                    currDetRows = 1:length(gO.ephysDetInfo);
%                     currChans = [gO.ephysDetInfo.Channel];
                    
                    currDetNum = gO.ephysCurrDetNum;
                    currDetRow = gO.ephysCurrDetRow;
                    detMat = gO.ephysDets;
                case 2
                    currDetRows = 1:length(gO.imagingDetInfo);
%                     currChans = [gO.imagingDetInfo.Roi];
                    
                    currDetNum = gO.imagingCurrDetNum;
                    currDetRow = gO.imagingCurrDetRow;
                    detMat = gO.imagingDets;
                case 3
                    
            end
            
            emptyChans = [];
            % Filtering out channels with no detections
            for j = 1:length(currDetRows)
                if isempty(find(~isnan(detMat(currDetRows(j),:)),1))
                    emptyChans = [emptyChans, j];
                end
            end
%             currChans(emptyChans) = [];
            currDetRows(emptyChans) = [];
            
            if chanUpDwn ~= 0
                currDetNum = 1;
            end

            if (chanUpDwn == 0) & (detUpDwn == 0)
                currDetNum = 1;
                currDetRow = 1;
            end
            
            if gO.plotFull == 0
                switch detUpDwn
                    case 1
                        temp = currDetRows(currDetRow);
                        if currDetNum < length(find(~isnan(detMat(temp,:))))
                            currDetNum = currDetNum + 1;
                        end
                    case -1
                        if currDetNum > 1
                            currDetNum = currDetNum - 1;
                        end
                end
            end
                
            switch chanUpDwn
                case 1
                    if currDetRow < length(currDetRows)
                        currDetRow = currDetRow + 1;
                    end
                case -1
                    if currDetRow > 1
                        currDetRow = currDetRow -1;
                    end
            end
            
            switch dTyp
                case 1
                    gO.ephysCurrDetNum = currDetNum;
                    gO.ephysCurrDetRow = currDetRow;
                    gO.ephysFixWinDetRow = currDetRow;
                case 2
                    gO.imagingCurrDetNum = currDetNum;
                    gO.imagingCurrDetRow = currDetRow;
                    gO.imagingFixWinDetRow = currDetRow;
                case 3
                    
            end

            smartplot(gO)
        end
        
        %%
        function axButtPressFixWin(gO,dTyp,chanUpDwn)
            switch dTyp
                case 1
                    currDetRows = 1:length(gO.ephysDetInfo);
                    
                    fixWinCurrDetRow = gO.ephysFixWinDetRow;
                case 2
                    currDetRows = 1:length(gO.imagingDetInfo);
                    
                    fixWinCurrDetRow = gO.imagingFixWinDetRow;
                case 3
                    
            end
            
            switch chanUpDwn
                case 1
                    if fixWinCurrDetRow < length(currDetRows)
                        fixWinCurrDetRow = fixWinCurrDetRow + 1;
                    end
                case -1
                    if fixWinCurrDetRow > 1
                        fixWinCurrDetRow = fixWinCurrDetRow -1;
                    end
            end
            
            switch dTyp
                case 1
                    gO.ephysFixWinDetRow = fixWinCurrDetRow;
                case 2
                    gO.imagingFixWinDetRow = fixWinCurrDetRow;
                case 3
                    
            end

            smartplot(gO)
            
        end
        
        %%
        function fixWinSwitchPress(gO,~,~)
            gO.fixWin = gO.fixWinSwitch.Value;
            
            switch gO.fixWin
                case 0
                    if gO.loaded(1)
                        gO.ephysDetUpButt.Enable = 'on';
                        gO.ephysDetUpButt.Visible = 'on';
                        gO.ephysDetDwnButt.Enable = 'on';
                        gO.ephysDetDwnButt.Visible = 'on';
                        gO.ephysChanUpButt.Enable = 'on';
                        gO.ephysChanUpButt.Visible = 'on';
                        gO.ephysChanDwnButt.Enable = 'on';
                        gO.ephysChanDwnButt.Visible = 'on';

                        gO.ephysFixWinChanUpButt.Enable = 'off';
                        gO.ephysFixWinChanUpButt.Visible = 'off';
                        gO.ephysFixWinChanDwnButt.Enable = 'off';
                        gO.ephysFixWinChanDwnButt.Visible = 'off';
                    end
                    
                    if gO.loaded(2)
                        gO.imagingDetUpButt.Enable = 'on';
                        gO.imagingDetUpButt.Visible = 'on';
                        gO.imagingDetDwnButt.Enable = 'on';
                        gO.imagingDetDwnButt.Visible = 'on';
                        gO.imagingRoiUpButt.Enable = 'on';
                        gO.imagingRoiUpButt.Visible = 'on';
                        gO.imagingRoiDwnButt.Enable = 'on';
                        gO.imagingRoiDwnButt.Visible = 'on';

                        gO.imagingFixWinRoiUpButt.Enable = 'off';
                        gO.imagingFixWinRoiUpButt.Visible = 'off';
                        gO.imagingFixWinRoiDwnButt.Enable = 'off';
                        gO.imagingFixWinRoiDwnButt.Visible = 'off';
                    end
                case 1
                    gO.plotFull = 0;
                    
                    if gO.loaded(1)
                        gO.ephysDetUpButt.Enable = 'off';
                        gO.ephysDetUpButt.Visible = 'off';
                        gO.ephysDetDwnButt.Enable = 'off';
                        gO.ephysDetDwnButt.Visible = 'off';
                        gO.ephysChanUpButt.Enable = 'off';
                        gO.ephysChanUpButt.Visible = 'off';
                        gO.ephysChanDwnButt.Enable = 'off';
                        gO.ephysChanDwnButt.Visible = 'off';

                        gO.ephysFixWinChanUpButt.Enable = 'on';
                        gO.ephysFixWinChanUpButt.Visible = 'on';
                        gO.ephysFixWinChanDwnButt.Enable = 'on';
                        gO.ephysFixWinChanDwnButt.Visible = 'on';
                    end
                    
                    if gO.loaded(2)
                        gO.imagingDetUpButt.Enable = 'off';
                        gO.imagingDetUpButt.Visible = 'off';
                        gO.imagingDetDwnButt.Enable = 'off';
                        gO.imagingDetDwnButt.Visible = 'off';
                        gO.imagingRoiUpButt.Enable = 'off';
                        gO.imagingRoiUpButt.Visible = 'off';
                        gO.imagingRoiDwnButt.Enable = 'off';
                        gO.imagingRoiDwnButt.Visible = 'off';

                        gO.imagingFixWinRoiUpButt.Enable = 'on';
                        gO.imagingFixWinRoiUpButt.Visible = 'on';
                        gO.imagingFixWinRoiDwnButt.Enable = 'on';
                        gO.imagingFixWinRoiDwnButt.Visible = 'on';
                    end
            end
            
            smartplot(gO)
            
        end
        
        %%
        function keyboardPressFcn(gO,~,kD)
            if gO.tabgrp.SelectedTab == gO.tabgrp.Children(2)
                if strcmp(kD.Key,'d') & (sum(gO.loaded) > 1)
                    switch gO.keyboardPressDtyp
                        case 1
                            gO.keyboardPressDtyp = 2;
                        case 2
                            gO.keyboardPressDtyp = 1;
    %                     case 3

                    end
                else

                    detChanUpDwn = [0,0];
                    switch kD.Key
                        case 'rightarrow'
                            detChanUpDwn = [1,0];
                        case 'leftarrow'
                            detChanUpDwn = [-1,0];
                        case 'uparrow'
                            detChanUpDwn = [0,1];
                        case 'downarrow'
                            detChanUpDwn = [0,-1];
                    end

                    if gO.fixWin == 1
                        axButtPressFixWin(gO,gO.keyboardPressDtyp,detChanUpDwn(2))
                    else
                        axButtPress(gO,gO.keyboardPressDtyp,detChanUpDwn(1),detChanUpDwn(2))
                    end
                end
            end
        end
    end
    
    %% gui component initialization and construction
    methods (Access = private)
        function createComponents(gO)
            %% Create figure
            gO.mainFig = figure('Units','normalized',...
                'Position',[0.1, 0.1, 0.8, 0.7],...
                'NumberTitle','off',...
                'Name','DAS Event Viewer',...
                'IntegerHandle','off',...
                'HandleVisibility','Callback',...
                'MenuBar','none',...
                'KeyPressFcn',@ gO.keyboardPressFcn);
            
            %% Menus
            gO.optMenu = uimenu(gO.mainFig,...
                'Text','Options');
            gO.ephysTypMenu = uimenu(gO.optMenu,...
                'Text','Ephys data type selection',...
                'MenuSelectedFcn',@ gO.ephysTypMenuSel);
            gO.highPassRawEphysMenu = uimenu(gO.optMenu,...
                'Text','Apply high pass filter to displayed raw ephys data',...
                'Checked','off',...
                'MenuSelectedFcn',@ gO.highPassRawEphysMenuSel);
            gO.plotFullMenu = uimenu(gO.optMenu,...
                'Text','Plot full data / Plot individual detections',...
                'MenuSelectedFcn',@ gO.plotFullMenuSel);
            
            %% Tabgroup
            gO.tabgrp = uitabgroup(gO.mainFig,...
                'Units','normalized',...
                'Position',[0,0,1,1],...
                'SelectionChangedFcn', @ gO.tabChanged);
            gO.loadTab = uitab(gO.tabgrp,...
                'Title','Load save');
            gO.viewerTab = uitab(gO.tabgrp,...
                'Title','Event viewer');
            
            %% loadTab members
            gO.selDirButt = uicontrol(gO.loadTab,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.01, 0.85, 0.1, 0.05],...
                'String','Change directory',...
                'Callback',@ gO.selDirButtPress);
            
            gO.loadDASSaveButt = uicontrol(gO.loadTab,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.01, 0.65, 0.1, 0.05],...
                'String','Load selected save',...
                'Callback',@ gO.loadSaveButtPress);
            
            initFileList = dir('*DASsave*.mat');
            initFileList(find(strcmp({initFileList.name},'DAS_LOG.mat'))) = [];
            initFileList = {initFileList.name};
            gO.fileList = uicontrol(gO.loadTab,...
                'Style','listbox',...
                'Units','normalized',...
                'Position',[0.12,0.1,0.3,0.9],...
                'String',initFileList,...
                'Callback',@ gO.fileListSel);
            
            gO.fileInfoPanel = uipanel(gO.loadTab,...
                'Position',[0.44,0.1,0.55,0.9]);
            gO.fnameLabel = uicontrol(gO.fileInfoPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.01, 0.89, 0.45, 0.1],...
                'String','File name:');
            gO.fnameTxt = uicontrol(gO.fileInfoPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.54, 0.89, 0.45, 0.1]);
            gO.commentsTxt = uicontrol(gO.fileInfoPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.01, 0.785, 0.9, 0.1]);                
            
            gO.ephysDetTypeLabel = uicontrol(gO.fileInfoPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.01, 0.68, 0.2, 0.1],...
                'String','Ephys detection type:');
            gO.ephysDetTypeTxt = uicontrol(gO.fileInfoPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.215, 0.68, 0.1, 0.1]);
            gO.ephysChanLabel = uicontrol(gO.fileInfoPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.01, 0.575, 0.2, 0.1],...
                'String','Ephys channel(s) #:');
            gO.ephysChanTxt = uicontrol(gO.fileInfoPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.215, 0.575, 0.1, 0.1]);
            gO.ephysParamTable = uitable(gO.fileInfoPanel,...
                'Units','normalized',...
                'Position',[0.01, 0.37, 0.45, 0.2],...
                'RowName','');
            
            gO.imagingDetTypeLabel = uicontrol(gO.fileInfoPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.5, 0.68, 0.2, 0.1],...
                'String','Imaging detection type:');
            gO.imagingDetTypeTxt = uicontrol(gO.fileInfoPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.705, 0.68, 0.1, 0.1]);
            gO.imagingRoiLabel = uicontrol(gO.fileInfoPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.5, 0.575, 0.2, 0.1],...
                'String','Imaging ROI(s) #:');
            gO.imagingRoiTxt = uicontrol(gO.fileInfoPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.705, 0.575, 0.1, 0.1]);
            gO.imagingParamTable = uitable(gO.fileInfoPanel,...
                'Units','normalized',...
                'Position',[0.5, 0.37, 0.45, 0.2],...
                'RowName','');
           
            
            %% viewerTab members
            gO.statPanel = uipanel(gO.viewerTab,...
                'Position',[0, 0, 0.3, 1],...
                'Title','Event parameters');
            gO.ephysDetParamsTable = uitable(gO.statPanel,...
                'Units','normalized',...
                'Position',[0.01, 0.7, 0.98, 0.3],...
                'ColumnWidth',{200,150});
            gO.imagingDetParamsTable = uitable(gO.statPanel,...
                'Units','normalized',...
                'Position',[0.01, 0.35, 0.98, 0.3],...
                'ColumnWidth',{200,150});
            
            gO.plotPanel = uipanel(gO.viewerTab,...
                'Position',[0.3, 0, 0.7, 1]);
            gO.fixWinSwitch = uicontrol(gO.plotPanel,...
                'Style','checkbox',...
                'Units','normalized',...
                'Position',[0.95, 0.965, 0.05, 0.05],...
                'String','FixWin',...
                'Callback',@ gO.fixWinSwitchPress);
            gO.ephysDetUpButt = uicontrol(gO.plotPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.965, 0.9, 0.035, 0.05],...
                'String','<HTML>Det&uarr',...
                'Callback',@(h,e) gO.axButtPress(1,1,0));
            gO.ephysDetDwnButt = uicontrol(gO.plotPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.965, 0.85, 0.035, 0.05],...
                'String','<HTML>Det&darr',...
                'Callback',@(h,e) gO.axButtPress(1,-1,0));
            gO.ephysChanUpButt = uicontrol(gO.plotPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.965, 0.8, 0.035, 0.05],...
                'String','<HTML>Chan&uarr',...
                'Callback',@(h,e) gO.axButtPress(1,0,1));
            gO.ephysChanDwnButt = uicontrol(gO.plotPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.965, 0.75, 0.035, 0.05],...
                'String','<HTML>Chan&darr',...
                'Callback',@(h,e) gO.axButtPress(1,0,-1));
            gO.ephysFixWinChanUpButt = uicontrol(gO.plotPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.965, 0.8, 0.035, 0.05],...
                'String','<HTML>Chan&uarr',...
                'Callback',@(h,e) gO.axButtPressFixWin(1,1),...
                'Visible','off',...
                'Enable','off');
            gO.ephysFixWinChanDwnButt = uicontrol(gO.plotPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.965, 0.75, 0.035, 0.05],...
                'String','<HTML>Chan&darr',...
                'Callback',@(h,e) gO.axButtPressFixWin(1,-1),...
                'Visible','off',...
                'Enable','off');
            
            gO.imagingDetUpButt = uicontrol(gO.plotPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.965, 0.7, 0.035, 0.05],...
                'String','<HTML>Det&uarr',...
                'Callback',@(h,e) gO.axButtPress(2,1,0));
            gO.imagingDetDwnButt = uicontrol(gO.plotPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.965, 0.65, 0.035, 0.05],...
                'String','<HTML>Det&darr',...
                'Callback',@(h,e) gO.axButtPress(2,-1,0));
            gO.imagingRoiUpButt = uicontrol(gO.plotPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.965, 0.6, 0.035, 0.05],...
                'String','<HTML>ROI&uarr',...
                'Callback',@(h,e) gO.axButtPress(2,0,1));
            gO.imagingRoiDwnButt = uicontrol(gO.plotPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.965, 0.55, 0.035, 0.05],...
                'String','<HTML>ROI&darr',...
                'Callback',@(h,e) gO.axButtPress(2,0,-1));

            gO.ax11 = axes(gO.plotPanel,'Position',[0.1, 0.2, 0.85, 0.6],...
                'Visible','off');
            gO.ax11.Toolbar.Visible = 'on';
            gO.ax21 = axes(gO.plotPanel,'Position',[0.1, 0.55, 0.85, 0.4],...
                'Visible','off');
            gO.ax21.Toolbar.Visible = 'on';
            gO.ax22 = axes(gO.plotPanel,'Position',[0.1, 0.06, 0.85, 0.4],...
                'Visible','off');
            gO.ax22.Toolbar.Visible = 'on';
%             align([gO.ax21,gO.ax22],'Distribute','Distribute')
%             linkaxes([gO.ax21,gO.ax22],'x')
            gO.ax31 = axes(gO.plotPanel,'Position',[0.1, 0.71, 0.85, 0.25],...
                'Visible','off');
            gO.ax31.Toolbar.Visible = 'on';
            gO.ax32 = axes(gO.plotPanel,'Position',[0.1, 0.38, 0.85, 0.25],...
                'Visible','off');
            gO.ax32.Toolbar.Visible = 'on';
            gO.ax33 = axes(gO.plotPanel,'Position',[0.1, 0.05, 0.85, 0.25],...
                'Visible','off');
            gO.ax33.Toolbar.Visible = 'on';
%             align([gO.ax31,gO.ax32,gO.ax33],'Distribute','Distribute')
%             linkaxes([gO.ax31,gO.ax32,gO.ax33],'x')
            gO.ax41 = axes(gO.plotPanel,'Position',[0.2, 0.8, 0.7, 0.175],...
                'Visible','off');
            gO.ax41.Toolbar.Visible = 'on';
            gO.ax42 = axes(gO.plotPanel,'Position',[0.2, 0.55, 0.7, 0.175],...
                'Visible','off');
            gO.ax42.Toolbar.Visible = 'on';
            gO.ax43 = axes(gO.plotPanel,'Position',[0.2, 0.3, 0.7, 0.175],...
                'Visible','off');
            gO.ax43.Toolbar.Visible = 'on';
            gO.ax44 = axes(gO.plotPanel,'Position',[0.2, 0.05, 0.7, 0.175],...
                'Visible','off');
            gO.ax44.Toolbar.Visible = 'on';
%             align([gO.ax41,gO.ax42,gO.ax43,gO.ax44],'Center','Top')
%             linkaxes([gO.ax41,gO.ax42,gO.ax43,gO.ax44],'x')
            gO.ax51 = axes(gO.plotPanel,'Position',[0.25, 0.85, 0.6, 0.135],...
                'Visible','off');
            gO.ax51.Toolbar.Visible = 'on';
            gO.ax52 = axes(gO.plotPanel,'Position',[0.25, 0.65, 0.6, 0.135],...
                'Visible','off');
            gO.ax52.Toolbar.Visible = 'on';
            gO.ax53 = axes(gO.plotPanel,'Position',[0.25, 0.45, 0.6, 0.135],...
                'Visible','off');
            gO.ax53.Toolbar.Visible = 'on';
            gO.ax54 = axes(gO.plotPanel,'Position',[0.25, 0.25, 0.6, 0.135],...
                'Visible','off');
            gO.ax54.Toolbar.Visible = 'on';
            gO.ax55 = axes(gO.plotPanel,'Position',[0.25, 0.05, 0.6, 0.135],...
                'Visible','off');
            gO.ax55.Toolbar.Visible = 'on';
%             align([gO.ax51,gO.ax52,gO.ax53,gO.ax54,gO.ax55],'Distribute','Distribute')
%             linkaxes([gO.ax51,gO.ax52,gO.ax53,gO.ax54,gO.ax55],'x')
        end
    end
end