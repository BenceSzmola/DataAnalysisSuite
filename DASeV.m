classdef DASeV < handle
    %% Initializing components
    properties (Access = private)
        mainFig
        
        %% menus
        optMenu
        ephysTypMenu
        imagingTypMenu
        runTypMenu
        highPassRawEphysMenu
        plotFullMenu
        showEventSpectroMenu
        
        %% tabs
        tabgrp
        loadTab
        viewerTab
        eventDbTab
        
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
        ephysDetSettingsTable
        imagingDetTypeLabel
        imagingDetTypeTxt
        imagingRoiLabel
        imagingRoiTxt
        imagingDetSettingsTable
        
        simultIndicator
        simultSettingTable
        
        runIndicator
        
        loadDASSaveButt
        
        %% viewerTab members
        statPanel
        ephysDetParamsTable
        imagingDetParamsTable
        
        save2DbPanel
        save2DbEphysCheckBox
        save2DbImagingCheckBox
        save2DbSimultCheckBox
        save2DbRunningChechBox
        save2DbButton
        
        plotPanel
        fixWinSwitch
        simultModeSwitch
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
        selDir = cd;
        path2loadedSave
        xLabel = 'Time [s]';
        loaded = [0,0,0]; % ephys-imaging-running (0-1)
        prevNumAx = 1;
        plotFull = 0;
        fixWin = 0;
        simultMode = 0;
        keyboardPressDtyp = 1;
        save2DbEphysSelection = cell(1,1);
        save2DbImagingSelection = cell(1,1);
%         save2DbSimultEphysSelection
%         save2DbSimultImagingSelection
        save2DbSimultSelection = [0,0,0,0];
        
        %% ephys stuff
        highPassRawEphys = 0;
        ephysRefCh = 0;
        ephysTypSelected = [1,0,0]; % raw-dog-instpow
        ephysData
        ephysDoGGed
        ephysInstPow
        ephysFs
        ephysTaxis
        ephysDetSettings
        ephysDetParams
        ephysDets
        ephysDetBorders
        ephysYlabel
        ephysDetInfo
        ephysCurrDetNum = 1;
        ephysCurrDetRow = 1;
        ephysFixWinDetRow = 1;
        
        %% imaging
        imagingTypSelected = [1,0];         % Raw-Gauss
        imagingData
        imagingSmoothed
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
        
        %% running
        runDataTypSelected = [1,0,0];       % Velocity-AbsPos-RelPos
        runFs = 200;
        runTaxis
        runAbsPos
        runRelPos
        runLap
        runLicks
        runVeloc
        
        %% simult
        simultDets
        simultDetInfo
        
        simultEphysCurrDetNum = 1;
        simultEphysCurrDetRow = 1;
        simultEphysFixWinDetRow = 1;
        
        simultImagingCurrDetNum = 1;
        simultImagingCurrDetRow = 1;
        simultImagingFixWinDetRow = 1;
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
        function [numDets,numChans,chanNum,chanOgNum,detNum,detIdx,detBorders,detParams] = extractDetStruct(gO,dTyp)
            
            switch gO.simultMode
                case 0
                    switch dTyp
                        case 1
                            currChan = gO.ephysCurrDetRow;
                            currDet = gO.ephysCurrDetNum;
                            
                            allChans = 1:size(gO.ephysData,1);
                            dets = gO.ephysDets;
                            detInfo = gO.ephysDetInfo;
                            detBorders = gO.ephysDetBorders;
                            detParams = gO.ephysDetParams;
                        case 2
                            currChan = gO.imagingCurrDetRow;
                            currDet = gO.imagingCurrDetNum;
                            
                            allChans = 1:size(gO.imagingData,1);
                            dets = gO.imagingDets;
                            detInfo = gO.imagingDetInfo;
                            detBorders = gO.imagingDetBorders;
                            detParams = gO.imagingDetParams;
                    end
                    
                    currDetRows = 1:length(detInfo);

                    emptyRows = [];
                    for i = 1:length(currDetRows)
                        if isempty(find(~isnan(dets(i,:)),1))
                            emptyRows = [emptyRows; i];
                        end
                    end
                    allChans(emptyRows) = [];
                    dets(emptyRows,:) = [];
                    currDetRows(emptyRows) = [];
                    detInfo(emptyRows) = [];
                    if ~isempty(detBorders)
                        detBorders(emptyRows) = [];
                    end
                    if ~isempty(detParams)
                        detParams(emptyRows) = [];
                    end

                    numDets = length(find(~isnan(dets(currChan,:))));
                    numChans = length(currDetRows);
                    
                    if nargout == 2
                        return
                    end
                    
                    if dTyp == 1
                        chanOgNum = detInfo(currChan).Channel;
                    elseif dTyp == 2
                        chanOgNum = detInfo(currChan).Roi;
                    end
                    
                    chanNum = allChans(currChan);
                    detNum = currDet;
                    
                    if nargout == 5
                        return
                    end
                    
                    detIdx = find(~isnan(dets(currChan,:)));
                    if ~gO.plotFull 
                        detIdx = detIdx(currDet);
                    end
                    
                    if ~isempty(detBorders{currChan})
                        if ~gO.plotFull
                            detBorders = detBorders{currChan}(currDet,:);
                        elseif gO.plotFull
                            detBorders = detBorders{currChan};
                        end
                    else
                        detBorders = [];
                    end
                    
                    if ~isempty(detParams{currChan})
                        if ~gO.plotFull
                            detParams = detParams{currChan}(currDet);
                        elseif gO.plotFull
                            detParams = detParams{currChan};
                        end
                    else
                        detParams = [];
                    end
                    
                case 1
                    detStruct = gO.simultDets;
                    
                    detInfo = gO.simultDetInfo;
                    emptyRows = [];
                    currDetRowsRel = [];
                    for i = 1:length(detStruct)
                        if isempty(find([detStruct(i).DetInds{:}],1))
                            emptyRows = [emptyRows; i];
                        else
                            currDetRowsRel = [currDetRowsRel; i];
                        end
                    end
                    detStruct(emptyRows) = [];

                    numEphysChans = length(detStruct);
                    currEphysChan = gO.simultEphysCurrDetRow;
                    [r,~] = find([detStruct(currEphysChan).DetInds{:}]);
                    r = unique(r);
                    
                    switch dTyp
                        case 1
                            numDets = length(r);
                            numChans = numEphysChans;
                            
                            if nargout == 2
                                return
                            end
                            
                            currChan = gO.simultEphysCurrDetRow;
                            currDet = gO.simultEphysCurrDetNum;
                            
                            detMat = gO.ephysDets;
                            detMat(emptyRows,:) = [];
%                             assignin('base','detMat',detMat)
                            
                            detMat = detMat(currChan,:);
                            
                            detIdx = find(~isnan(detMat));
                            detNum = r(currDet);
                            if ~gO.plotFull
                                detIdx = detIdx(detNum);
                            end
                            
                            nonSimDetInfo = gO.ephysDetInfo;
                            nonSimDetInfo = nonSimDetInfo(currDetRowsRel(currChan));
%                             nonSimDetInfo = nonSimDetInfo(currChan);
                            chanOgNum = nonSimDetInfo.Channel;
                            
                            chanNum = currDetRowsRel(currChan);
                            
                            if nargout == 5
                                return
                            end
                            
                            detBorders = gO.ephysDetBorders;
%                             assignin('base','detBorders',detBorders)
                            detBorders = detBorders{currDetRowsRel(currChan)};
                            if ~isempty(detBorders) & ~gO.plotFull
                                detBorders = detBorders(r(currDet),:);
                            end
                            
                            detParams = gO.ephysDetParams;
                            detParams = detParams{currDetRowsRel(currChan)};
                            if ~isempty(detParams) & ~gO.plotFull
                                detParams = detParams(r(currDet));
                            end
                            
                        case 2
                            currDet = gO.simultImagingCurrDetNum;
                            currChan = gO.simultImagingCurrDetRow;
                            
                            ephysDetNum = r(gO.simultEphysCurrDetNum);
                            
                            currChans = detInfo.ROI;

                            temp = ~cellfun('isempty',detStruct(currEphysChan).DetInds);
                            temp2 = detStruct(currEphysChan).DetInds(temp);
                            goodrows = [];
                            for i = 1:length(temp2)
                                if find(temp2{i}(ephysDetNum,:),1)
                                    goodrows = [goodrows; i];
                                end
                            end
                            numChans = length(goodrows);
                            currChans = currChans(temp);
                            currChans = currChans(goodrows);
                            [~,currChansRel] = ismember(currChans,detInfo.ROI);
                            
                            [~,c] = find(detStruct(currEphysChan).DetInds{currChansRel(currChan)}(ephysDetNum,:));
                            c = unique(c);
                            numDets = length(c);
                            
                            if nargout == 2
                                return
                            end
                            
                            detMat = gO.imagingDets;
                            detMat = detMat(currChansRel(currChan),:);
%                             detMat = detMat(currChan,:);
                            
                            detIdx = find(~isnan(detMat));
                            detNum = c(currDet);
                            if ~gO.plotFull
                                detIdx = detIdx(detNum);
                            end
                            
                            nonSimDetInfo = gO.imagingDetInfo;
                            nonSimDetInfo = nonSimDetInfo(currChansRel(currChan));
%                             nonSimDetInfo = nonSimDetInfo(currChan);
                            chanOgNum = nonSimDetInfo.Roi;
                            
                            chanNum = currChansRel(currChan);
                            
                            if nargout == 5
                                return
                            end
                            
                            detBorders = gO.imagingDetBorders{currChansRel(currChan)};
                            if ~isempty(detBorders) & ~gO.plotFull
                                detBorders = detBorders(c(currDet),:);
                            end
                            
                            detParams = gO.imagingDetParams{currChansRel(currChan)};
                            if ~isempty(detParams) & ~gO.plotFull
                                detParams = detParams(c(currDet));
                            end
                            
                    end
            end
        end
        
        %%
        function ephysPlot(gO,ax,forSpectro)
            if nargin < 3
                forSpectro = 0;
            end
            
            [numDets,numChans,chanNum,chanOgNum,detNum,detIdx,detBorders,detParams] = extractDetStruct(gO,1);
            
%             currDetNum = gO.ephysCurrDetNum;
%             currDetRow = gO.ephysCurrDetRow;
            
%             currDetRows = 1:length(gO.ephysDetInfo);
%             emptyChans = [];
%             % Filtering out channels with no detections
%             for j = 1:length(currDetRows)
%                 if isempty(find(~isnan(gO.ephysDets(currDetRows(j),:)),1))
%                     emptyChans = [emptyChans, j];
%                 end
%             end
            
%             currDetRows(emptyChans) = [];
%             currDetRow = currDetRows(currDetRow);
            
%             numDets = length(find(~isnan(gO.ephysDets(currDetRow,:))));
%             chan = gO.ephysDetInfo(currDetRow).Channel;
            
%             currDetBorders = gO.ephysDetBorders{currDetRow};
            currDetBorders = detBorders;
            
            if numDets == 0
                return
            end
            
            if ~gO.plotFull
                gO.ephysDetUpButt.Enable = 'on';
                gO.ephysDetDwnButt.Enable = 'on';
                
%                 currDetParamsRows = gO.ephysDetParams{currDetRow};
%                 if ~isempty(currDetParamsRows)
%                     currDetParams = currDetParamsRows(currDetNum);
%                     assignin('base','currDetParams',currDetParams)
%                     temp = [fieldnames([currDetParams]), squeeze(struct2cell([currDetParams]))];
%                     gO.ephysDetParamsTable.Data = temp;
%                     gO.ephysDetParamsTable.RowName = [];
%                     gO.ephysDetParamsTable.ColumnName = {'Electrophysiology','Values'};
%                 end

                if ~isempty(detParams)
                    temp = [fieldnames([detParams]), squeeze(struct2cell([detParams]))];
                    gO.ephysDetParamsTable.Data = temp;
                    gO.ephysDetParamsTable.RowName = [];
                    gO.ephysDetParamsTable.ColumnName = {'Electrophysiology','Values'};
                end
                
%                 currDetBorders = gO.ephysDetBorders{currDetRow};
%                 if ~isempty(currDetBorders)
%                     currDetBorders = currDetBorders(currDetNum,:);
%                 end
                
%                 detIdx = gO.ephysDets(currDetRow,:);
%                 detIdx = find(~isnan(detIdx));
%                 detIdx = detIdx(currDetNum);
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
                    chanOgNum = gO.ephysDetInfo(gO.ephysFixWinDetRow).Channel;
                    chanNum = gO.ephysFixWinDetRow;
                    if chanOgNum == gO.ephysRefCh
                        axTitle = ['Channel #',num2str(chanOgNum), ' (Ref)'];
                    else
                        axTitle = ['Channel #',num2str(chanOgNum)];
                    end
                elseif gO.fixWin == 0
                    if chanOgNum == gO.ephysRefCh
                        axTitle = ['Channel #',num2str(chanOgNum), ' (Ref)',...
                            '      Detection #',...
                            num2str(detNum),'/',num2str(numDets)];
                    else
                        axTitle = ['Channel #',num2str(chanOgNum),'      Detection #',...
                            num2str(detNum),'/',num2str(numDets)];
                    end
                    
                end
            elseif gO.plotFull
                gO.ephysDetUpButt.Enable = 'off';
                gO.ephysDetDwnButt.Enable = 'off';
                gO.ephysCurrDetNum = 1;
                
%                 currDetParamsRows = gO.ephysDetParams{currDetRow};
%                 if ~isempty(currDetParamsRows)
%                     currDetParamsAvg = mean(cell2mat(struct2cell(currDetParamsRows)),3);
%                     temp = [fieldnames([currDetParamsRows(1)]),...
%                         mat2cell(currDetParamsAvg,ones(1,length(currDetParamsAvg)))];
%                     gO.ephysDetParamsTable.Data = temp;
%                     gO.ephysDetParamsTable.RowName = [];
%                     gO.ephysDetParamsTable.ColumnName = {'','Mean values'};
%                 end
                if ~isempty(detParams)
                    currDetParamsAvg = mean(cell2mat(struct2cell(detParams)),3);
                    temp = [fieldnames([detParams(1)]),...
                        mat2cell(currDetParamsAvg,ones(1,length(currDetParamsAvg)))];
                    gO.ephysDetParamsTable.Data = temp;
                    gO.ephysDetParamsTable.RowName = [];
                    gO.ephysDetParamsTable.ColumnName = {'Electrophysiology','Mean values'};
                end
                
%                 detInds = gO.ephysDets(currDetRow,:);
%                 detInds = find(~isnan(detInds));
                tDetInds = gO.ephysTaxis(detIdx);
                
                winIdx = 1:length(gO.ephysTaxis);
                tWin = gO.ephysTaxis;
                                
                if chanOgNum == gO.ephysRefCh
                    axTitle = ['Channel #',num2str(chanOgNum),' (Ref)',...
                        '      #Detections = ',num2str(numDets)];
                else
                    axTitle = ['Channel #',num2str(chanOgNum),'      #Detections = ',...
                        num2str(numDets)];
                end
            end
            
            if forSpectro
                try
                    w1 = gO.ephysDetInfo(1).DetSettings.W1;
                    w2 = gO.ephysDetInfo(1).DetSettings.W2;
                catch
                    w1 = 150;
                    w2 = 250;
                    warning('Cutoff set to default 150-250 Hz')
                end
                spectrogramMacher(gO.ephysData(chanNum,winIdx),gO.ephysFs,w1,w2)
                return
            end
                        
            data = [];
            axLims = [];
            yLabels = [];
            [b,a] = butter(2,5/(gO.ephysFs/2),'high');
            switch sum(gO.ephysTypSelected)
                case 1
                    if gO.ephysTypSelected(1)
                        if gO.highPassRawEphys == 1
                            temp = filtfilt(b,a,gO.ephysData(chanNum,:));
                            data = temp(winIdx);
%                             axLims = [tWin(1), tWin(end), min(temp), max(temp)];
                            axLims = [min(temp), max(temp)];
                        elseif gO.highPassRawEphys == 0
                            data = gO.ephysData(chanNum,winIdx);
%                             axLims = [tWin(1), tWin(end),...
                            axLims = [min(gO.ephysData(chanNum,:)), max(gO.ephysData(chanNum,:))];
                        end
                        yLabels = string(gO.ephysYlabel);
                    elseif gO.ephysTypSelected(2)
                        data = gO.ephysDoGGed(chanNum,winIdx);
%                         axLims = [tWin(1), tWin(end),...
                        axLims = [min(gO.ephysDoGGed(chanNum,:)), max(gO.ephysDoGGed(chanNum,:))];
                        yLabels = string(gO.ephysYlabel);
                    elseif gO.ephysTypSelected(3)
                        data = gO.ephysInstPow(chanNum,winIdx);
%                         axLims = [tWin(1), tWin(end),...
                        axLims = [min(gO.ephysInstPow(chanNum,:)), max(gO.ephysInstPow(chanNum,:))];
                        temp = find(gO.ephysYlabel=='[');
                        yLabels = string(['Power ',gO.ephysYlabel(temp:end-1),...
                                '^2]']);
                    end
                case 2
                    if gO.ephysTypSelected(1)
                        if gO.highPassRawEphys == 1
                            tempfull = filtfilt(b,a,gO.ephysData(chanNum,:));
                            temp = tempfull(winIdx);
%                             axLims = [axLims; tWin(1), tWin(end),...
                            axLims = [axLims; min(tempfull), max(tempfull)];
                        elseif gO.highPassRawEphys == 0
                            temp = gO.ephysData(chanNum,winIdx);
%                             axLims = [axLims; tWin(1), tWin(end),...
                            axLims = [axLims; min(gO.ephysData(chanNum,:)), max(gO.ephysData(chanNum,:))];
                        end
                        data = [data; temp];
                        yLabels = [string(yLabels); string(gO.ephysYlabel)];
                    end
                    if gO.ephysTypSelected(2)
                        data = [data; gO.ephysDoGGed(chanNum,winIdx)];
%                         axLims = [axLims; tWin(1), tWin(end),...
                        axLims = [axLims; min(gO.ephysDoGGed(chanNum,:)), max(gO.ephysDoGGed(chanNum,:))];
                        yLabels = [string(yLabels); string(gO.ephysYlabel)];
                    end
                    if gO.ephysTypSelected(3)
                        data = [data; gO.ephysInstPow(chanNum,winIdx)];
%                         axLims = [axLims; tWin(1), tWin(end),...
                        axLims = [axLims; min(gO.ephysInstPow(chanNum,:)), max(gO.ephysInstPow(chanNum,:))];
                        temp = find(gO.ephysYlabel=='[');
                        yLabels = [string(yLabels); string(['Power ',gO.ephysYlabel(temp:end-1),...
                                '^2]'])];
                    end
                case 3
                    if gO.highPassRawEphys == 1
                        tempfull = filtfilt(b,a,gO.ephysData(chanNum,:));
                        temp = tempfull(winIdx);
%                         axLims = [tWin(1), tWin(end),...
                        axLims = [min(tempfull), max(tempfull)];
                    elseif gO.highPassRawEphys == 0
                        temp = gO.ephysData(chanNum,winIdx);
%                         axLims = [tWin(1), tWin(end),...
                        axLims = [min(gO.ephysData(chanNum,:)), max(gO.ephysData(chanNum,:))];
                    end
                    data = [temp;...
                        gO.ephysDoGGed(chanNum,winIdx);...
                        gO.ephysInstPow(chanNum,winIdx)];
                    axLims = [axLims;... %axLims(1:2), ...
                        min(gO.ephysDoGGed(chanNum,:)), max(gO.ephysDoGGed(chanNum,:));
                        min(gO.ephysInstPow(chanNum,:)), max(gO.ephysInstPow(chanNum,:))];
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
                        xline(ax(i),tDetInds(j),'Color','g','LineWidth',1);
                        if ~isempty(currDetBorders)
                            xline(ax(i),gO.ephysTaxis(currDetBorders(j,1)),'--b','LineWidth',1);
                            xline(ax(i),gO.ephysTaxis(currDetBorders(j,2)),'--b','LineWidth',1);
                            hL = data(i,:);
                            temp1 = find(tWin==gO.ephysTaxis(currDetBorders(j,1)));
                            temp2 = find(tWin==gO.ephysTaxis(currDetBorders(j,2)));
                            hL(1:temp1-1) = nan;
                            hL(temp2+1:end) = nan;
                            plot(ax(i),tWin,hL,'-r','LineWidth',0.75)
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
            
            [numDets,numChans,chanNum,chanOgNum,detNum,detIdx,detBorders,detParams] = extractDetStruct(gO,2);
%             currDetNum = gO.imagingCurrDetNum;
%             currDetRow = gO.imagingCurrDetRow;
            
%             currDetRows = 1:length(gO.imagingDetInfo);
%             emptyChans = [];
%             % Filtering out channels with no detections
%             for j = 1:length(currDetRows)
%                 if isempty(find(~isnan(gO.imagingDets(currDetRows(j),:)),1))
%                     emptyChans = [emptyChans, j];
%                 end
%             end
%             currDetRows(emptyChans) = [];
%             currDetRow = currDetRows(currDetRow);
            
%             numDets = length(find(~isnan(gO.imagingDets(currDetRow,:))));
%             chan = gO.imagingDetInfo(currDetRow).Roi;
            
%             currDetBorders = gO.imagingDetBorders{currDetRow};
            currDetBorders = detBorders;
            
            if numDets == 0
                return
            end
            
            if ~gO.plotFull
                gO.imagingDetUpButt.Enable = 'on';
                gO.imagingDetDwnButt.Enable = 'on';
                
%                 currDetParamsRows = gO.imagingDetParams{currDetRow};
%                 if ~isempty(currDetParamsRows)
%                     currDetParams = currDetParamsRows(currDetNum);
%                     assignin('base','currDetParams',currDetParams)
%                     temp = [fieldnames([currDetParams]), squeeze(struct2cell([currDetParams]))];
%                     gO.imagingDetParamsTable.Data = temp;
%                     gO.imagingDetParamsTable.RowName = [];
%                     gO.imagingDetParamsTable.ColumnName = {'Imaging','Values'};
%                 end
                if ~isempty(detParams)
                    temp = [fieldnames([detParams]), squeeze(struct2cell([detParams]))];
                    gO.imagingDetParamsTable.Data = temp;
                    gO.imagingDetParamsTable.RowName = [];
                    gO.imagingDetParamsTable.ColumnName = {'Imaging','Values'};
                end
                
%                 detIdx = gO.imagingDets(currDetRow,:);
%                 detIdx = find(~isnan(detIdx));
%                 detIdx = detIdx(currDetNum);
                tDetInds = gO.imagingTaxis(detIdx);

                win = 0.5;
                win = round(win*gO.imagingFs,0);
                
                
                if ~isempty(currDetBorders)
%                     currDetBorders = currDetBorders(currDetNum,:);
                    
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
                    chanOgNum = gO.imagingDetInfo(gO.imagingFixWinDetRow).Roi;
                    chanNum = gO.imagingFixWinDetRow;
                    axTitle = ['ROI #',num2str(chanOgNum)];
                elseif gO.fixWin == 0
                    axTitle = ['ROI #',num2str(chanOgNum),'      Detection #',...
                        num2str(detNum),'/',num2str(numDets)];
                end
                
            elseif gO.plotFull
                gO.imagingDetUpButt.Enable = 'off';
                gO.imagingDetDwnButt.Enable = 'off';
                gO.imagingCurrDetNum = 1;
                
%                 currDetParamsRows = gO.imagingDetParams{currDetRow};
%                 if ~isempty(currDetParamsRows)
%                     currDetParamsAvg = mean(cell2mat(struct2cell(currDetParamsRows)),3);
%                     temp = [fieldnames([currDetParamsRows(1)]),...
%                         mat2cell(currDetParamsAvg,ones(1,length(currDetParamsAvg)))];
%                     gO.imagingDetParamsTable.Data = temp;
%                     gO.imagingDetParamsTable.RowName = [];
%                     gO.imagingDetParamsTable.ColumnName = {'','Mean values'};
%                 end

                if ~isempty(detParams)
                    currDetParamsAvg = mean(cell2mat(struct2cell(detParams)),3);
                    temp = [fieldnames([detParams(1)]),...
                        mat2cell(currDetParamsAvg,ones(1,length(currDetParamsAvg)))];
                    gO.imagingDetParamsTable.Data = temp;
                    gO.imagingDetParamsTable.RowName = [];
                    gO.imagingDetParamsTable.ColumnName = {'Imaging','Mean values'};
                end
                
%                 detInds = gO.imagingDets(currDetRow,:);
%                 detInds = find(~isnan(detInds));
                tDetInds = gO.imagingTaxis(detIdx);
                
                winIdx = 1:length(gO.imagingTaxis);
                tWin = gO.imagingTaxis;
                
                axTitle = ['ROI #',num2str(chanOgNum),'      #Detections = ',...
                    num2str(numDets)];
            end
            
            if gO.imagingTypSelected(1)
                data = gO.imagingData(chanNum,winIdx);
                axLims = [min(gO.imagingData(chanNum,:)), max(gO.imagingData(chanNum,:))];
            elseif gO.imagingTypSelected(2)
                data = gO.imagingSmoothed(chanNum,winIdx);
                axLims = [min(gO.imagingSmoothed(chanNum,:)), max(gO.imagingSmoothed(chanNum,:))];
            end
            
            yLabels = string(gO.imagingYlabel);
            
            for i = 1:min(size(data))
                plot(ax(i),tWin,data(i,:))
                hold(ax(i),'on')
                for j = 1:length(tDetInds)
                    xline(ax(i),tDetInds(j),'Color','g','LineWidth',1);
                    if ~isempty(currDetBorders)
                        xline(ax(i),gO.imagingTaxis(currDetBorders(j,1)),'--b','LineWidth',1);
                        xline(ax(i),gO.imagingTaxis(currDetBorders(j,2)),'--b','LineWidth',1);
                        hL = data(i,:);
                        temp1 = find(tWin==gO.imagingTaxis(currDetBorders(j,1)));
                        temp2 = find(tWin==gO.imagingTaxis(currDetBorders(j,2)));
                        hL(1:temp1-1) = nan;
                        hL(temp2+1:end) = nan;
                        plot(ax(i),tWin,hL,'-r','LineWidth',0.75)
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
        function runPlot(gO,ax)
            if gO.runDataTypSelected(1)
                data = gO.runVeloc;
                axTitle = 'Running velocity';
                axYlabel = 'Velocity [cm/s]';
            elseif gO.runDataTypSelected(2)
                data = gO.runAbsPos;
                axTitle = 'Running - Absolute position';
                axYlabel = 'Absolute position [cm]';
            elseif gO.runDataTypSelected(3)
                data = gO.runRelPos;
                axTitle = 'Running - Relative position';
                axYlabel = 'Relative position [%]';
            end
            
            plot(ax,gO.runTaxis,data)
            title(ax,axTitle)
            ylabel(ax,axYlabel)
            xlabel(ax,'Time [s]')
            
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
                        ax = [gO.ax11];
                        linkaxes(ax,'x')
                        runPlot(gO,ax)
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
                    if gO.loaded(3)
                        switch ephysAxCount
                            case 0
                                ax = [gO.ax22];
                            case 1
                                ax = [gO.ax22];
                            case 2
                                ax = [gO.ax33];
                            case 3
                                ax = [gO.ax44];
                        end
                        linkaxes(ax,'x')
                        runPlot(gO,ax)                        
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
                    if gO.loaded(3)
                        switch ephysAxCount
                            case 0
                                
                            case 1
                                ax = [gO.ax33];
                            case 2
                                ax = [gO.ax44];
                            case 3
                                ax = [gO.ax55];
                        end
                        linkaxes(ax,'x')
                        runPlot(gO,ax)
                    end
            end
        end
        
        %%
        function [win] = windowMacher(gO,dTyp,chanNum,detNum,winLen)
            if nargin < 5 || isempty(winLen)
                winLen = 0.25;
            end
            switch dTyp
                case 1
                    detArray = gO.ephysDets;
                    fs = gO.ephysFs;
                    lenData = length(gO.ephysData);
                case 2
                    detArray = gO.imagingDets;
                    fs = gO.imagingFs;
                    lenData = length(gO.imagingData);
            end
            
            dets = detArray(chanNum,:);
            dets = find(~isnan(dets));
            detInd = dets(detNum);

            winLen = round(fs*winLen);
            if (detInd-winLen) > 1
                winStart = detInd-winLen;
            else
                winStart = 1;
            end
            if (detInd+winLen) <= lenData
                winEnd = detInd+winLen;
            else
                winEnd = lenData;
            end
            win = winStart:winEnd;
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
        function imagingTypMenuSel(gO,~,~)
            [idx,tf] = listdlg('ListString',{'Raw','Gauss smoothed'},...
                'PromptString','Select data type(s) to show detections on!');
            if ~tf
                return
            end
            
            gO.imagingTypSelected(:) = 0;
            gO.imagingTypSelected(idx) = 1;
            
            smartplot(gO)
        end
        
        %%
        function runTypMenuSel(gO,~,~)
            [idx,tf] = listdlg('ListString',{'Velocity','Absolute position','Relative position'},...
                'PromptString','Select data type to show detections on!',...
                'SelectionMode','single');
            if ~tf
                return
            end
            
            gO.runDataTypSelected(:) = 0;
            gO.runDataTypSelected(idx) = 1;
            
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
                gO.showEventSpectroMenu.Enable = 'on';
            elseif gO.plotFull == 0
                gO.plotFull = 1;
                gO.fixWinSwitch.Value = 0;
                gO.showEventSpectroMenu.Enable = 'off';
                fixWinSwitchPress(gO)
            end
            smartplot(gO)
        end
        
        %%
        function showEventSpectro(gO,~,~)
            ephysPlot(gO,[],1)
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
%             cd(newdir)
            
            newlist = dir([newdir,'\*DASsave*.mat']);
            if isempty(newlist)
                warndlg('Selected directory does not include any save files!')
                return
            end
            newlist = {newlist.name};
            gO.fileList.String = newlist;
            gO.selDir = newdir;
        end
        
        %%
        function loadSaveButtPress(gO,~,~)
            val = gO.fileList.Value;
            if ~isempty(gO.fileList.String)
                fname = gO.fileList.String{val};
                fnameFull = [gO.selDir,'\',fname];
            else
                warndlg('No file selected!')
                return
            end
            
            gO.ephysCurrDetNum = 1;
            gO.ephysCurrDetRow = 1;
            
            testload = matfile(fnameFull);

            gO.loaded(1) = 0;
            gO.ephysDetUpButt.Enable = 'off';
            gO.ephysDetDwnButt.Enable = 'off';
            gO.ephysChanUpButt.Enable = 'off';
            gO.ephysChanDwnButt.Enable = 'off';
            gO.ephysDetParamsTable.Data = {};
            gO.ephysDetParamsTable.ColumnName = {};
            gO.save2DbEphysCheckBox.Enable = 'off';

            if (~isempty(find(strcmp(fieldnames(testload),'ephysSaveData'),1)))...
                    & (~isempty(find(strcmp(fieldnames(testload),'ephysSaveInfo'),1)))
                load(fnameFull,'ephysSaveData','ephysSaveInfo')

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
                        if gO.ephysDetInfo(1).DetSettings.RefCh ~= 0
                            gO.ephysRefCh = gO.ephysDetInfo(1).DetSettings.RefCh;
                        end
                    end

                    gO.ephysDetUpButt.Enable = 'on';
                    gO.ephysDetDwnButt.Enable = 'on';
                    gO.ephysChanUpButt.Enable = 'on';
                    gO.ephysChanDwnButt.Enable = 'on';
                    gO.save2DbEphysCheckBox.Enable = 'on';

                    gO.loaded(1) = 1;

                    gO.ephysDoGGed = DoG(gO.ephysData,gO.ephysFs,150,250);
                    gO.ephysInstPow = instPow(gO.ephysData,gO.ephysFs,150,250);
                    
%                     axButtPress(gO,1,0,0)

                    
                end
            end
            
            gO.loaded(2) = 0;
            gO.imagingDetUpButt.Enable = 'off';
            gO.imagingDetDwnButt.Enable = 'off';
            gO.imagingRoiUpButt.Enable = 'off';
            gO.imagingRoiDwnButt.Enable = 'off';
            gO.save2DbImagingCheckBox.Enable = 'off';
            gO.imagingDetParamsTable.Data = {};
            gO.imagingDetParamsTable.ColumnName = {};

            if (~isempty(find(strcmp(fieldnames(testload),'imagingSaveData'),1)))...
                    & (~isempty(find(strcmp(fieldnames(testload),'imagingSaveInfo'),1)))
                load(fnameFull,'imagingSaveData','imagingSaveInfo')
                
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
                    gO.save2DbImagingCheckBox.Enable = 'on';
                    
                    gO.imagingSmoothed = smoothdata(gO.imagingData,...
                        2,'gaussian',10);
                    
                    gO.loaded(2) = 1;
%                     axButtPress(gO,2,0,0)
                end
            end
            
            gO.loaded(3) = 0;
            if (~isempty(find(strcmp(fieldnames(testload),'runData'),1)))
                load(fnameFull,'runData')
                
                if ~isempty(runData)
                    gO.runTaxis = runData.taxis;
                    gO.runAbsPos = runData.absPos;
                    gO.runRelPos = runData.relPos;
                    gO.runLap = runData.lapNum;
                    gO.runLicks = runData.licks;
                    gO.runVeloc = runData.veloc;
                    
                    gO.loaded(3) = 1;
                end
                
            end
            
            gO.simultMode = 0;
            gO.simultModeSwitch.Value = 0;
            gO.simultModeSwitch.Enable = 'off';
            gO.save2DbSimultCheckBox.Enable = 'off';
            if (~isempty(find(strcmp(fieldnames(testload),'simultSaveData'),1)))...
                    & (~isempty(find(strcmp(fieldnames(testload),'simultSaveInfo'),1)))
                load(fnameFull,'simultSaveData','simultSaveInfo')
                
                if ~isempty(simultSaveData) & ~isempty(simultSaveInfo)
                    gO.simultDets = simultSaveData;
                    gO.simultDetInfo = simultSaveInfo;
                    
                    gO.simultMode = 1;
                    gO.simultModeSwitch.Value = 1;
                    gO.simultModeSwitch.Enable = 'on';
                    gO.save2DbSimultCheckBox.Enable = 'on';
                    gO.save2DbEphysCheckBox.Enable = 'off';
                    gO.save2DbImagingCheckBox.Enable = 'off';
                    gO.fixWinSwitch.Enable = 'off';
                end
            end
                        
            %Preparing selection vectors for database saving
            gO.save2DbEphysCheckBox.Value = 0;
            gO.save2DbImagingCheckBox.Value = 0;
            gO.save2DbSimultCheckBox.Value = 0;
            gO.save2DbRunningChechBox.Value = 0;
            gO.save2DbSimultSelection = [0,0,0,0];
            gO.save2DbEphysSelection = cell(1,1);
            if gO.loaded(1)
                gO.save2DbEphysSelection = cell(length(gO.ephysDetBorders),1);
                for i = 1:length(gO.ephysDetBorders)
                    gO.save2DbEphysSelection{i} = false(size(gO.ephysDetBorders{i},1),1);
                end
            end
            gO.save2DbImagingSelection = cell(1,1);
            if gO.loaded(2)
                gO.save2DbImagingSelection = cell(length(gO.imagingDetBorders),1);
                for i = 1:length(gO.imagingDetBorders)
                    gO.save2DbImagingSelection{i} = false(size(gO.imagingDetBorders{i},1),1);
                end
            end
%             if gO.simultMode % if there is simult data, during loading simultMode is set to 1
%                 gO.save2DbSimultSelection = cell(length(gO.simultDets),1);
%                 for i = 1:length(gO.save2DbSimultSelection)
%                     numDets = 0;
%                     for j = 1:length(gO.simultDets(i).DetInds)
%                         numDets = numDets + sum(gO.simultDets(i).DetInds{j}(:));
%                     end
%                     gO.save2DbSimultSelection{i} = false(numDets,3);
%                 end
%             end
            
            for i = 1:2
                if gO.loaded(i)
                    axButtPress(gO,i,0,0)
                end
            end
            
            if ~isempty(find(gO.loaded, 1))
                gO.tabgrp.SelectedTab = gO.tabgrp.Children(2);
                gO.path2loadedSave = fnameFull;
            end
        end
        
        %%
        function fileListSel(gO,~,~)
            val = gO.fileList.Value;
            if ~isempty(gO.fileList.String)
                fname = gO.fileList.String{val};
                fnameFull = [gO.selDir,'\',fname];
            else
                warndlg('No DAS save files in current directory!')
                return
            end
            
            testload = matfile(fnameFull);
            
            if ~isempty(find(strcmp(fieldnames(testload),'comments'),1))
                load(fnameFull,'comments')
                gO.commentsTxt.String = comments;
            end
            
            gO.fnameTxt.String = fname;
            
            gO.ephysDetTypeTxt.String = '';
            gO.ephysChanTxt.String = '';
            gO.ephysDetSettingsTable.Data = [];
            gO.ephysDetSettingsTable.ColumnName = '';
            if ~isempty(find(strcmp(fieldnames(testload),'ephysSaveInfo'),1))
                load(fnameFull,'ephysSaveInfo')
                if ~isempty(ephysSaveInfo)
%                     gO.fnameTxt.String = fname;
                    gO.ephysDetTypeTxt.String = ephysSaveInfo.DetType;
                    gO.ephysChanTxt.String = sprintf('%d ',[ephysSaveInfo.Channel]);
                    gO.ephysDetSettingsTable.Data = squeeze(struct2cell(ephysSaveInfo(1).DetSettings))';
                    gO.ephysDetSettingsTable.ColumnName = fieldnames(ephysSaveInfo(1).DetSettings);
%                 else
%                     gO.ephysDetTypeTxt.String = '';
%                     gO.ephysChanTxt.String = '';
%                     gO.ephysParamTable.Data = [];
%                     gO.ephysParamTable.ColumnName = '';
                end
%             else
%                 gO.ephysDetTypeTxt.String = '';
%                 gO.ephysChanTxt.String = '';
%                 gO.ephysParamTable.Data = [];
%                 gO.ephysParamTable.ColumnName = '';
            end
            
            gO.imagingDetTypeTxt.String = '';
            gO.imagingRoiTxt.String = '';
            gO.imagingDetSettingsTable.Data = [];
            gO.imagingDetSettingsTable.ColumnName = '';
            if ~isempty(find(strcmp(fieldnames(testload),'imagingSaveInfo'),1))
                load(fnameFull,'imagingSaveInfo')
                if ~isempty(imagingSaveInfo)
                    gO.imagingDetTypeTxt.String = imagingSaveInfo.DetType;
                    gO.imagingRoiTxt.String = sprintf('%d ',[imagingSaveInfo.Roi]);
                    gO.imagingDetSettingsTable.Data = squeeze(struct2cell(imagingSaveInfo(1).DetSettings))';
                    gO.imagingDetSettingsTable.ColumnName = fieldnames(imagingSaveInfo(1).DetSettings);
%                 else
%                     gO.imagingDetTypeTxt.String = '';
%                     gO.imagingRoiTxt.String = '';
%                     gO.imagingParamTable.Data = [];
%                     gO.imagingParamTable.ColumnName = '';
                end
%             else
%                 gO.imagingDetTypeTxt.String = '';
%                 gO.imagingRoiTxt.String = '';
%                 gO.imagingParamTable.Data = [];
%                 gO.imagingParamTable.ColumnName = '';
            end
            
            if ~isempty(find(strcmp(fieldnames(testload),'simultSaveInfo'),1))
                load(fnameFull,'simultSaveInfo')
                if ~isempty(simultSaveInfo)
                    gO.simultIndicator.Value = 1;
                    temp = squeeze(struct2cell(simultSaveInfo(1).Settings))';
                    temp = [{simultSaveInfo.DetType},temp];
                    gO.simultSettingTable.Data = temp;
                    temp = fieldnames(simultSaveInfo(1).Settings);
                    temp = ['DetType',temp];
                    gO.simultSettingTable.ColumnName = temp;
                else
                    gO.simultIndicator.Value = 0;
                    gO.simultSettingTable.Data = [];
                    gO.simultSettingTable.ColumnName = '';
                end
            else
                gO.simultIndicator.Value = 0;
                gO.simultSettingTable.Data = [];
                gO.simultSettingTable.ColumnName = '';
            end
            
            gO.runIndicator.Value = 0;
            if ~isempty(find(strcmp(fieldnames(testload),'runData'),1))
                load(fnameFull,'runData')
                if ~isempty(runData)
                    gO.runIndicator.Value = 1;
%                 else
%                     gO.runIndicator.Value = 0;
                end
%             else
%                 gO.runIndicator.Value = 0;
            end
        end
        
        %%
        function axButtPressOld(gO,dTyp,detUpDwn,chanUpDwn)
%             switch dTyp
%                 case 1
%                     currDetRows = 1:length(gO.ephysDetInfo);
% %                     currChans = [gO.ephysDetInfo.Channel];
%                     
%                     currDetNum = gO.ephysCurrDetNum;
%                     currDetRow = gO.ephysCurrDetRow;
%                     detMat = gO.ephysDets;
%                 case 2
%                     currDetRows = 1:length(gO.imagingDetInfo);
% %                     currChans = [gO.imagingDetInfo.Roi];
%                     
%                     currDetNum = gO.imagingCurrDetNum;
%                     currDetRow = gO.imagingCurrDetRow;
%                     detMat = gO.imagingDets;
%                 case 3
%                     
%             end
%             
%             emptyChans = [];
%             % Filtering out channels with no detections
%             for j = 1:length(currDetRows)
%                 if isempty(find(~isnan(detMat(currDetRows(j),:)),1))
%                     emptyChans = [emptyChans, j];
%                 end
%             end
% %             currChans(emptyChans) = [];
%             currDetRows(emptyChans) = [];
%             
%             if chanUpDwn ~= 0
%                 currDetNum = 1;
%             end
% 
%             if (chanUpDwn == 0) & (detUpDwn == 0)
%                 currDetNum = 1;
%                 currDetRow = 1;
%             end
%             
%             if gO.plotFull == 0
%                 switch detUpDwn
%                     case 1
%                         temp = currDetRows(currDetRow);
%                         if currDetNum < length(find(~isnan(detMat(temp,:))))
%                             currDetNum = currDetNum + 1;
%                         end
%                     case -1
%                         if currDetNum > 1
%                             currDetNum = currDetNum - 1;
%                         end
%                 end
%             end
%                 
%             switch chanUpDwn
%                 case 1
%                     if currDetRow < length(currDetRows)
%                         currDetRow = currDetRow + 1;
%                     end
%                 case -1
%                     if currDetRow > 1
%                         currDetRow = currDetRow -1;
%                     end
%             end
%             
%             switch dTyp
%                 case 1
%                     gO.ephysCurrDetNum = currDetNum;
%                     gO.ephysCurrDetRow = currDetRow;
%                     gO.ephysFixWinDetRow = currDetRow;
%                 case 2
%                     gO.imagingCurrDetNum = currDetNum;
%                     gO.imagingCurrDetRow = currDetRow;
%                     gO.imagingFixWinDetRow = currDetRow;
%                 case 3
%                     
%             end
% 
%             smartplot(gO)
        end
        
        %%
        function axButtPress(gO,dTyp,detUpDwn,chanUpDwn)
            switch gO.simultMode
                case 0
                    switch dTyp
                        case 1
                            currChan = gO.ephysCurrDetRow;
                            currDet = gO.ephysCurrDetNum;
                        case 2
                            currChan = gO.imagingCurrDetRow;
                            currDet = gO.imagingCurrDetNum;
                    end
                case 1
                    switch dTyp
                        case 1
                            currChan = gO.simultEphysCurrDetRow;
                            currDet = gO.simultEphysCurrDetNum;
                        case 2
                            currChan = gO.simultImagingCurrDetRow;
                            currDet = gO.simultImagingCurrDetNum;
                    end
            end
            
            if nargin > 2
                if (chanUpDwn==0) & (detUpDwn==0)
                    currDet = 1;
                    currChan = 1;
                end

                if chanUpDwn ~= 0
                    currDet = 1;
                end
                
                [numDets,numChans] = extractDetStruct(gO,dTyp);

                switch chanUpDwn
                    case 0
    %                     currChan = 1;
                    case 1
                        if currChan < numChans
                            currChan = currChan + 1;
                        end
                    case -1
                        if currChan > 1
                            currChan = currChan - 1;
                        end
                end

                switch detUpDwn
                    case 0
    %                     currDet = 1;
                    case 1
                        if currDet < numDets
                            currDet = currDet + 1;
                        end
                    case -1
                        if currDet > 1
                            currDet = currDet - 1;
                        end
                end

            end
            
            switch gO.simultMode 
                case 0
                    switch dTyp
                        case 1
                            gO.ephysCurrDetNum = currDet;
                            gO.ephysCurrDetRow = currChan;
                            gO.ephysFixWinDetRow = currChan;
                            
                            temp = find(~cellfun('isempty',gO.save2DbEphysSelection));
                            temp = temp(gO.ephysCurrDetRow);
                            val = gO.save2DbEphysSelection{temp}(gO.ephysCurrDetNum);
                            gO.save2DbEphysCheckBox.Value = val;
                            
                        case 2
                            gO.imagingCurrDetNum = currDet;
                            gO.imagingCurrDetRow = currChan;
                            gO.imagingFixWinDetRow = currChan;
                            
                            temp = find(~cellfun('isempty',gO.save2DbImagingSelection));
                            temp = temp(gO.imagingCurrDetRow);
                            val = gO.save2DbImagingSelection{temp}(gO.imagingCurrDetNum);
                            gO.save2DbImagingCheckBox.Value = val;
                            
                    end
                    
                case 1
                    switch dTyp
                        case 1
                            gO.simultEphysCurrDetNum = currDet;
                            gO.simultEphysCurrDetRow = currChan;
                            gO.simultImagingCurrDetNum = 1;
                            gO.simultImagingCurrDetRow = 1;
                            
                        case 2
                            gO.simultImagingCurrDetNum = currDet;
                            gO.simultImagingCurrDetRow = currChan;
                            
                    end
                    [~,~,chanNum,~,ephysDetNum] = extractDetStruct(gO,1);
                    [~,~,roiNum,~,imagingDetNum] = extractDetStruct(gO,2);
                    [~,r,~] = intersect(gO.save2DbSimultSelection,[chanNum,ephysDetNum,roiNum,imagingDetNum],'rows');
                    if ~isempty(r)
                        gO.save2DbSimultCheckBox.Value = 1;
                    else
                        gO.save2DbSimultCheckBox.Value = 0;
                    end
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
        function simultModeSwitchPress(gO,~,~)
            if gO.simultModeSwitch.Value
                gO.simultMode = 1;
                gO.fixWinSwitch.Value = 0;
                fixWinSwitchPress(gO)
                gO.fixWinSwitch.Enable = 'off';
                gO.save2DbSimultCheckBox.Enable = 'on';
                gO.save2DbEphysCheckBox.Enable = 'off';
                gO.save2DbImagingCheckBox.Enable = 'off';
            elseif ~gO.simultModeSwitch.Value
                gO.simultMode = 0;
                gO.fixWinSwitch.Enable = 'on';
                gO.save2DbSimultCheckBox.Enable = 'off';
                gO.save2DbEphysCheckBox.Enable = 'on';
                gO.save2DbImagingCheckBox.Enable = 'on';
            end
            
            axButtPress(gO,1)
            axButtPress(gO,2)
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
        
        %%
        function save2DbCheckBoxPress(gO,checkboxID)
            
            switch checkboxID
                case 1
                    val = gO.save2DbEphysCheckBox.Value;
                    temp = find(~cellfun('isempty',gO.save2DbEphysSelection));
                    temp = temp(gO.ephysCurrDetRow);
                    gO.save2DbEphysSelection{temp}(gO.ephysCurrDetNum) = val;
                case 2
                    val = gO.save2DbImagingCheckBox.Value;
                    temp = find(~cellfun('isempty',gO.save2DbImagingSelection));
                    temp = temp(gO.imagingCurrDetRow);
                    gO.save2DbImagingSelection{temp}(gO.imagingCurrDetNum) = val;
                case 3
                    val = gO.save2DbSimultCheckBox.Value;
                    
                    [~,~,chanNum,~,ephysDetNum] = extractDetStruct(gO,1);
                    [~,~,roiNum,~,imagingDetNum] = extractDetStruct(gO,2);
                    temp = [chanNum,ephysDetNum,roiNum,imagingDetNum];
                    
                    if val
                        gO.save2DbSimultSelection = [gO.save2DbSimultSelection; temp];
                    else
                        [~,r,~] = intersect(gO.save2DbSimultSelection,temp,'rows');
                        if ~isempty(r)
                            gO.save2DbSimultSelection(r(1),:) = [];
                        end
                    end
                    
                case 4
                    return
            end
        end
        
        %%
        function save2DbButtonPress(gO,~,~)
            
            selected = [(~isempty(find(vertcat(gO.save2DbEphysSelection{:}),1))&&~gO.simultMode),...
                (~isempty(find(vertcat(gO.save2DbImagingSelection{:}),1))&&~gO.simultMode),...
                ((size(gO.save2DbSimultSelection,1)~=1) && gO.simultMode)];
            
            if sum(selected)==2
                answer = questdlg('Which selection do you want to save?',...
                    'Choose data to save','Electrophysiology','Imaging',...
                    'Cancel','Electrophysiology');
                if strcmp(answer,'Electrophysiology')
                    selected(:) = 0;
                    selected(1) = 1;
                elseif strcmp(answer,'Imaging')
                    selected(:) = 0;
                    selected(2) = 1;
                else
                    return
                end
            elseif sum(selected)==3
                errordlg('There is an error! Try restarting the GUI!')
                return
            end
            
            newSaveStruct = [];
            if selected(1)
                for i = 1:length(gO.save2DbEphysSelection)
                    if isempty(find(gO.save2DbEphysSelection{i},1))
                        continue
                    end
                    
                    for j = 1:length(gO.save2DbEphysSelection{i})
                        if ~gO.save2DbEphysSelection{i}(j)
                            continue
                        end

                        win = windowMacher(gO,1,i,j,0.25);
                        
                        tempStruct.source = gO.path2loadedSave;
                        tempStruct.simult = 0;
                        tempStruct.parallel = 0;
                                                
                        tempStruct.ephysEvents.Taxis = gO.ephysTaxis(win);
                        tempStruct.ephysEvents.DataWin.Raw = gO.ephysData(i,win);
                        tempStruct.ephysEvents.DataWin.BP = gO.ephysDoGGed(i,win);
                        tempStruct.ephysEvents.DataWin.Power = gO.ephysInstPow(i,win);
                        tempStruct.ephysEvents.Params = gO.ephysDetParams{i}(j);
                        tempStruct.ephysEvents.DetSettings = gO.ephysDetInfo(i).DetSettings;
                        tempStruct.ephysEvents.ChanNum = gO.ephysDetInfo(i).Channel;
                        tempStruct.ephysEvents.DetNum = j;
                        
                        newSaveStruct = [newSaveStruct; tempStruct];
                    end
                    
                end
                
            end
            
            if selected(2)
                
                for i = 1:length(gO.save2DbImagingSelection)
                    if isempty(find(gO.save2DbImagingSelection{i},1))
                        continue
                    end
                    
                    for j = 1:length(gO.save2DbImagingSelection{i})
                        if ~gO.save2DbImagingSelection{i}(j)
                            continue
                        end
                        
                        win = windowMacher(gO,2,i,j,0.25);
                        
                        tempStruct.source = gO.path2loadedSave;
                        tempStruct.simult = 0;
                        tempStruct.parallel = 0;                         
                        
                        tempStruct.imagingEvents.Taxis = gO.imagingTaxis(win);
                        tempStruct.imagingEvents.DataWin.Raw = gO.imagingData(i,win);
                        tempStruct.imagingEvents.DataWin.Smoothed = gO.imagingSmoothed(i,win);
                        tempStruct.imagingEvents.Params = gO.imagingDetParams{i}(j);
                        tempStruct.imagingEvents.DetSettings = gO.imagingDetInfo(i).DetSettings;
                        tempStruct.imagingEvents.ROINum = gO.imagingDetInfo(i).Roi;
                        tempStruct.imagingEvents.DetNum = j;
                        
                        newSaveStruct = [newSaveStruct; tempStruct];
                    end
                end
%             
            end
            
            if selected(3)
                for i = 2:size(gO.save2DbSimultSelection,1)
                    currRow = gO.save2DbSimultSelection(i,:);
                    ephysWin = windowMacher(gO,1,currRow(1),currRow(2),0.25);
                    imagingWin = windowMacher(gO,2,currRow(3),currRow(4),0.25);
                    
                    tempStruct.source = gO.path2loadedSave;
                    tempStruct.simult = 1;
                    tempStruct.parallel = 0;
                    
                    tempStruct.ephysEvents.Taxis = gO.ephysTaxis(ephysWin);
                    tempStruct.ephysEvents.DataWin.Raw = gO.ephysData(currRow(1),ephysWin);
                    tempStruct.ephysEvents.DataWin.BP = gO.ephysDoGGed(currRow(1),ephysWin);
                    tempStruct.ephysEvents.DataWin.Power = gO.ephysInstPow(currRow(1),ephysWin);
                    tempStruct.ephysEvents.Params = gO.ephysDetParams{currRow(1)}(currRow(2));
                    tempStruct.ephysEvents.DetSettings = gO.ephysDetInfo(currRow(1)).DetSettings;
                    tempStruct.ephysEvents.ChanNum = gO.ephysDetInfo(currRow(1)).Channel;
                    tempStruct.ephysEvents.DetNum = currRow(2);
                    
                    tempStruct.imagingEvents.Taxis = gO.imagingTaxis(imagingWin);
                    tempStruct.imagingEvents.DataWin.Raw = gO.imagingData(currRow(3),imagingWin);
                    tempStruct.imagingEvents.DataWin.Smoothed = gO.imagingSmoothed(currRow(3),imagingWin);
                    tempStruct.imagingEvents.Params = gO.imagingDetParams{currRow(3)}(currRow(4));
                    tempStruct.imagingEvents.DetSettings = gO.imagingDetInfo(currRow(3)).DetSettings;
                    tempStruct.imagingEvents.ROINum = gO.imagingDetInfo(currRow(3)).Roi;
                    tempStruct.imagingEvents.DetNum = currRow(4);
                    
                    newSaveStruct = [newSaveStruct; tempStruct];
                end
            end
            
            if gO.save2DbRunningChechBox.Value && ~isempty(newSaveStruct)
                
                newSaveStruct.runDataWin.Velocity = gO.runVeloc;
%               
            end
            
            DASloc = mfilename('fullpath');
            if ~exist([DASloc(1:end-5),'DASeventDBdir\'],'dir')
                mkdir([DASloc(1:end-5),'DASeventDBdir\'])
            end
            dbFiles = dir([DASloc(1:end-5),'DASeventDBdir\','DASeventDB*.mat']);
            
            dbFiles = {dbFiles.name};
            dbFiles = ['Start a new database entry', dbFiles];
            
            [ind,tf] = listdlg('ListString',dbFiles,...
                'PromptString','Select DB to save in','SelectionMode','single');
            if ~tf
                return
            end
            
            if ind == 1
                dbName = inputdlg('Input name of new database entry!',...
                    'New DB entry',[1,35]);
                if isempty(dbName)
                    return
                else
                    saveFname = [DASloc(1:end-5),'DASeventDBdir\','DASeventDB_',dbName{:},'.mat'];
                    saveStruct = [];
                end
            else
                dbName = dbFiles{ind}(12:end-4);
                saveFname = dbFiles{ind};
                load(saveFname,'saveStruct')
            end
            
            if ~isempty(newSaveStruct)
                saveStruct = [saveStruct; newSaveStruct];
                
                try
                    save(saveFname,'saveStruct')
                catch
                    errordlg(['Error while saving! Probably caused by missing folder.'...
                        'Make sure DASeventDBdir folder is in the same location as DASeV.m file!'])
                    return
                end
            else
                errordlg('No selected events!')
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
                'KeyPressFcn',@ gO.keyboardPressFcn);%,...
                %'Color',[103,72,70]/255);
            
            %% Menus
            gO.optMenu = uimenu(gO.mainFig,...
                'Text','Options');
            gO.ephysTypMenu = uimenu(gO.optMenu,...
                'Text','Ephys data type selection',...
                'MenuSelectedFcn',@ gO.ephysTypMenuSel);
            gO.imagingTypMenu = uimenu(gO.optMenu,...
                'Text','Imaging data type selection',...
                'MenuSelectedFcn',@ gO.imagingTypMenuSel);
            gO.runTypMenu = uimenu(gO.optMenu,...
                'Text','Running data type selection',...
                'MenuSelectedFcn',@ gO.runTypMenuSel);
            gO.highPassRawEphysMenu = uimenu(gO.optMenu,...
                'Text','Apply high pass filter to displayed raw ephys data',...
                'Checked','off',...
                'MenuSelectedFcn',@ gO.highPassRawEphysMenuSel);
            gO.plotFullMenu = uimenu(gO.optMenu,...
                'Text','Plot full data / Plot individual detections',...
                'MenuSelectedFcn',@ gO.plotFullMenuSel);
            gO.showEventSpectroMenu = uimenu(gO.optMenu,...
                'Text','Show event spectrogram',...
                'MenuSelectedFcn',@ gO.showEventSpectro);
            
            %% Tabgroup
            gO.tabgrp = uitabgroup(gO.mainFig,...
                'Units','normalized',...
                'Position',[0,0,1,1],...
                'SelectionChangedFcn', @ gO.tabChanged);
            gO.loadTab = uitab(gO.tabgrp,...
                'Title','Load save');%,...
                %'BackgroundColor',[252,194,0]/255);
            gO.viewerTab = uitab(gO.tabgrp,...
                'Title','Event viewer');%,...
                %'BackgroundColor',[252,194,0]/255);
%             gO.eventDbTab = uitab(gO.tabgrp,...
%                 'Title','Event Database');
            
            %% loadTab members
            gO.selDirButt = uicontrol(gO.loadTab,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.01, 0.85, 0.1, 0.05],...
                'String','Change directory',...
                'Callback',@ gO.selDirButtPress);%,...
                %'BackgroundColor',[62,105,225]/255,...
                %'ForegroundColor',[1,1,1]);
            
            gO.loadDASSaveButt = uicontrol(gO.loadTab,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.01, 0.65, 0.1, 0.05],...
                'String','Load selected save',...
                'Callback',@ gO.loadSaveButtPress);%,...
                %'BackgroundColor',[62,105,225]/255,...
                %'ForegroundColor',[1,1,1]);
            
            initFileList = dir('*DASsave*.mat');
            initFileList(find(strcmp({initFileList.name},'DAS_LOG.mat'))) = [];
            initFileList = {initFileList.name};
            gO.fileList = uicontrol(gO.loadTab,...
                'Style','listbox',...
                'Units','normalized',...
                'Position',[0.12,0.1,0.3,0.9],...
                'String',initFileList,...
                'Callback',@ gO.fileListSel);%,...
                %'BackgroundColor',[62,105,225]/255,...
                %'ForegroundColor',[1,1,1]);
            
            gO.fileInfoPanel = uipanel(gO.loadTab,...
                'Position',[0.44,0.1,0.55,0.9],...
                'BorderType','beveledout');%,...
                %'BackgroundColor',[65,105,225]/255);
            gO.fnameLabel = uicontrol(gO.fileInfoPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.025, 0.89, 0.1, 0.05],...
                'String','File name:');
            gO.fnameTxt = uicontrol(gO.fileInfoPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.15, 0.89, 0.825, 0.05]);
            gO.commentsTxt = uicontrol(gO.fileInfoPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.025, 0.785, 0.95, 0.1]);                
            
            gO.ephysDetTypeLabel = uicontrol(gO.fileInfoPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.025, 0.68, 0.2, 0.05],...
                'String','Ephys detection type:');
            gO.ephysDetTypeTxt = uicontrol(gO.fileInfoPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.25, 0.68, 0.2, 0.05]);
            gO.ephysChanLabel = uicontrol(gO.fileInfoPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.025, 0.575, 0.2, 0.05],...
                'String','Ephys channel(s) #:');
            gO.ephysChanTxt = uicontrol(gO.fileInfoPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.25, 0.55, 0.2, 0.075]);
            gO.ephysDetSettingsTable = uitable(gO.fileInfoPanel,...
                'Units','normalized',...
                'Position',[0.025, 0.425, 0.45, 0.1],...
                'RowName','',...
                'FontSize',13,...
                'ColumnWidth',{75});
            
            gO.imagingDetTypeLabel = uicontrol(gO.fileInfoPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.525, 0.68, 0.225, 0.05],...
                'String','Imaging detection type:');
            gO.imagingDetTypeTxt = uicontrol(gO.fileInfoPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.775, 0.68, 0.2, 0.05]);
            gO.imagingRoiLabel = uicontrol(gO.fileInfoPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.525, 0.575, 0.2, 0.05],...
                'String','Imaging ROI(s) #:');
            gO.imagingRoiTxt = uicontrol(gO.fileInfoPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.775, 0.55, 0.2, 0.075]);
            gO.imagingDetSettingsTable = uitable(gO.fileInfoPanel,...
                'Units','normalized',...
                'Position',[0.525, 0.425, 0.45, 0.1],...
                'RowName','',...
                'FontSize',13,...
                'ColumnWidth',{75});
            
            gO.simultIndicator = uicontrol(gO.fileInfoPanel,...
                'Style','checkbox',...
                'Units','normalized',...
                'Position',[0.05, 0.3, 0.15, 0.05],...
                'String','with simultan',...
                'Enable','inactive');
            gO.simultSettingTable = uitable(gO.fileInfoPanel,...
                'Units','normalized',...
                'Position',[0.3, 0.27, 0.4, 0.1],...
                'RowName','',...
                'FontSize',13,...
                'ColumnWidth',{75});
            
            gO.runIndicator = uicontrol(gO.fileInfoPanel,...
                'Style','checkbox',...
                'Units','normalized',...
                'Position',[0.05, 0.2, 0.15, 0.05],...
                'String','with run data',...
                'Enable','inactive');
            
            kids = findobj(gO.fileInfoPanel,'Type','uicontrol','-or',...
                'Type','uitable');
            set(kids,'FontSize',12.5)
            %set(kids,'BackgroundColor',[252,194,0]/255)

                       
            
            %% viewerTab members
            gO.statPanel = uipanel(gO.viewerTab,...
                'Position',[0, 0.2, 0.3, 0.8],...
                'Title','Event parameters',...
                'BorderType','beveledout');
                %'BackgroundColor',[65,105,225]/255,...
                %'ForegroundColor',[1,1,1]);
                
            gO.ephysDetParamsTable = uitable(gO.statPanel,...
                'Units','normalized',...
                'Position',[0.01, 0.7, 0.98, 0.3],...
                'ColumnWidth',{200,150});
            gO.imagingDetParamsTable = uitable(gO.statPanel,...
                'Units','normalized',...
                'Position',[0.01, 0.35, 0.98, 0.3],...
                'ColumnWidth',{200,150});
            
            gO.save2DbPanel = uipanel(gO.viewerTab,...
                'Position',[0, 0, 0.3, 0.15],...
                'Title','Saving to database',...
                'BorderType','beveledout');
            gO.save2DbEphysCheckBox = uicontrol(gO.save2DbPanel,...
                'Style','checkbox',...
                'Units','normalized',...
                'Position',[0.01, 0.75, 0.4, 0.15],...
                'String','Select current ephys event',...
                'Callback',@(h,e) gO.save2DbCheckBoxPress(1));
            gO.save2DbImagingCheckBox = uicontrol(gO.save2DbPanel,...
                'Style','checkbox',...
                'Units','normalized',...
                'Position',[0.5, 0.75, 0.4, 0.15],...
                'String','Select current imaging event',...
                'Callback',@(h,e) gO.save2DbCheckBoxPress(2));
            gO.save2DbSimultCheckBox = uicontrol(gO.save2DbPanel,...
                'Style','checkbox',...
                'Units','normalized',...
                'Position',[0.01, 0.55, 0.4, 0.15],...
                'String','Select current simult. event pair',...
                'Callback',@(h,e) gO.save2DbCheckBoxPress(3));
            gO.save2DbRunningChechBox = uicontrol(gO.save2DbPanel,...
                'Style','checkbox',...
                'Units','normalized',...
                'Position',[0.5, 0.55, 0.4, 0.15],...
                'String','Save running data',...
                'Callback',@(h,e) gO.save2DbCheckBoxPress(4));
            gO.save2DbButton = uicontrol(gO.save2DbPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.1, 0.1, 0.8, 0.2],...
                'String','Save current selection to DB',...
                'Callback',@ gO.save2DbButtonPress);
            
            gO.plotPanel = uipanel(gO.viewerTab,...
                'Position',[0.3, 0, 0.7, 1],...
                'BorderType','beveledout');
                %'BackgroundColor',[252,194,0]/255,...
                %'ForegroundColor',[1,1,1],...
            gO.fixWinSwitch = uicontrol(gO.plotPanel,...
                'Style','checkbox',...
                'Units','normalized',...
                'Position',[0.95, 0.965, 0.05, 0.05],...
                'String','FixWin',...
                'Callback',@ gO.fixWinSwitchPress);
            gO.simultModeSwitch = uicontrol(gO.plotPanel,...
                'Style','checkbox',...
                'Units','normalized',...
                'Position',[0.95, 0.915, 0.05, 0.05],...
                'String','Simult',...
                'Callback',@ gO.simultModeSwitchPress);
            gO.ephysDetUpButt = uicontrol(gO.plotPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.965, 0.85, 0.035, 0.05],...
                'String','<HTML>Det&uarr',...
                'Callback',@(h,e) gO.axButtPress(1,1,0));
            gO.ephysDetDwnButt = uicontrol(gO.plotPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.965, 0.8, 0.035, 0.05],...
                'String','<HTML>Det&darr',...
                'Callback',@(h,e) gO.axButtPress(1,-1,0));
            gO.ephysChanUpButt = uicontrol(gO.plotPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.965, 0.75, 0.035, 0.05],...
                'String','<HTML>Chan&uarr',...
                'Callback',@(h,e) gO.axButtPress(1,0,1));
            gO.ephysChanDwnButt = uicontrol(gO.plotPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.965, 0.7, 0.035, 0.05],...
                'String','<HTML>Chan&darr',...
                'Callback',@(h,e) gO.axButtPress(1,0,-1));
            gO.ephysFixWinChanUpButt = uicontrol(gO.plotPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.965, 0.75, 0.035, 0.05],...
                'String','<HTML>Chan&uarr',...
                'Callback',@(h,e) gO.axButtPressFixWin(1,1),...
                'Visible','off',...
                'Enable','off');
            gO.ephysFixWinChanDwnButt = uicontrol(gO.plotPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.965, 0.7, 0.035, 0.05],...
                'String','<HTML>Chan&darr',...
                'Callback',@(h,e) gO.axButtPressFixWin(1,-1),...
                'Visible','off',...
                'Enable','off');
            
            gO.imagingDetUpButt = uicontrol(gO.plotPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.965, 0.6, 0.035, 0.05],...
                'String','<HTML>Det&uarr',...
                'Callback',@(h,e) gO.axButtPress(2,1,0));
            gO.imagingDetDwnButt = uicontrol(gO.plotPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.965, 0.55, 0.035, 0.05],...
                'String','<HTML>Det&darr',...
                'Callback',@(h,e) gO.axButtPress(2,-1,0));
            gO.imagingRoiUpButt = uicontrol(gO.plotPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.965, 0.5, 0.035, 0.05],...
                'String','<HTML>ROI&uarr',...
                'Callback',@(h,e) gO.axButtPress(2,0,1));
            gO.imagingRoiDwnButt = uicontrol(gO.plotPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.965, 0.45, 0.035, 0.05],...
                'String','<HTML>ROI&darr',...
                'Callback',@(h,e) gO.axButtPress(2,0,-1));

            kids = findobj(gO.plotPanel,'Type','uicontrol','-or',...
                'Type','uitable');
            %set(kids,'BackgroundColor',[252,194,0]/255);
            
            gO.ax11 = axes(gO.plotPanel,'Position',[0.1, 0.2, 0.85, 0.6],...
                'Visible','off');
            gO.ax11.Toolbar.Visible = 'on';
            gO.ax21 = axes(gO.plotPanel,'Position',[0.1, 0.55, 0.8, 0.4],...
                'Visible','off');
            gO.ax21.Toolbar.Visible = 'on';
            gO.ax22 = axes(gO.plotPanel,'Position',[0.1, 0.06, 0.8, 0.4],...
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

            %% Database tab elements
            
        end
    end
end