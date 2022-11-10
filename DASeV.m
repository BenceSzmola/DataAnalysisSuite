classdef DASeV < handle
    %% Initializing components
    properties (Access = private)
        mainFig
        
        %% menus
        optMenu
        plotFullMenu
        enableKbSlideMenu
        setKbSlideStepSizeMenu
        parallelModeMenu
        eventYlimModeMenu
        eventYlimSetCustomMenu
        winLenMenu
        
        ephysOptMenu
        ephysTypMenu
        highPassRawEphysMenu
        showEventSpectroMenu
        editSpectroFreqLimsMenu
        makeFoilDistrPlotMenu
        
        imagingOptMenu
        imagingTypMenu
        
        runOptMenu
        runTypMenu
        showLicksMenu
        
        simultOptMenu
        simultFocusMenu
        
        dbMenu
        openDASevDBMenu
        
        helpMenu
        showKeyShortcutsMenu
        
        %% tabs
        tabgrp
        loadTab
        viewerTab
        eventDbTab
        
        %% loadTab members
        currDirPanel
        currDirTxt
        selDirButt
        
        fileListBox
        fileListContMenu
        fileListContMenuUpdate
        
        DASsaveAnalyserCheckRHDCheckBox
        DASsaveAnalyserBestChSelModePopMenu
        DASsaveAnalyserBestChInputEdit
        DASsaveAnalyserButton
        
        saveFileAnalysisSourceButtonGroup
        saveFileAnalysisSourceDirRadioButton
        saveFileAnalysisSourceFileRadioButton
        
        globalEventAnalyserButton
        
        
        fileInfoPanel
        fnameLabel
        fnameTxt
        commentsTxt
        ephysDetTypeLabel
        ephysDetTypeTxt
        ephysChanLabel
        ephysChanTxt
        ephysDownSampIndicator
        ephysDetSettingsTable
        imagingDetTypeLabel
        imagingDetTypeTxt
        imagingRoiLabel
        imagingRoiTxt
        imagingUpSampIndicator
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
        save2DbEphys_wPar_CheckBox      % save with parallel imaging
        save2DbEphys_wPar_RoiSelect     % select which ROIs to use in parallel Saving
        save2DbEphysClrSelButton
        save2DbEphysSelAllButton
        save2DbEphysSelAllCurrChButton
        save2DbImagingCheckBox
        save2DbImaging_wPar_CheckBox    % save with parallel ephys
        save2DbImaging_wPar_ChanSelect  % select which channels to use in parallel saving
        save2DbImagingClrSelButton
        save2DbImagingSelAllButton
        save2DbImagingSelAllCurrRoiButton
        save2DbSimultCheckBox
        save2DbSimultClrSelButton
        save2DbSimultSelAllButton
        save2DbRunningChechBox
        save2DbButton
        save2ExcelButton
        delSelectedEventsButton
        
        plotPanel
        fixWinSwitch
        simultModeSwitch
        ephysDetUpButt
        ephysDetDwnButt
        ephysChanUpButt
        ephysChanDwnButt
        ephysDelCurrEvButt
        imagingDetUpButt
        imagingDetDwnButt
        imagingRoiUpButt
        imagingRoiDwnButt
        imagingDelCurrEvButt
        
        
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
        selDirFiles
        path2loadedSave
        xLabel = 'Time [s]';
        loaded = [0,0,0,0]; % ephys-imaging-running-simultan (0-1)
        prevNumAx = 1;
        plotFull = 0;
        enableKbSlide = false;
        kbSlidingStepSize = 0.2;
        fixWin = 0;
        simultMode = 0;
        simultFocusTyp = 1;
        parallelMode = 0;
        keyboardPressDtyp = 1;
        spectroFreqLims = [1,1000];
        eventYlimMode = 'global';
        eventYlimCustom_ephys = [-1000, 1000; -100, 100; -1, 20];
        eventYlimCustom_imaging = [-5, 10; -5, 10];
        save2DbEphysSelection = cell(1,1);
        save2DbEphysParallelRoiSelection = false(1,1);
        save2DbImagingSelection = cell(1,1);
        save2DbImagingParallelChanSelection = false(1,1);
        save2DbSimultSelection = [0,0,0,0];
        
        %% ephys stuff
        highPassRawEphys = 0;
        ephysRefCh = 0;
        ephysTypSelected = [true,false,false]; % raw-dog-instpow
        ephysWinLen = 0.25;
        ephysData
        ephysDoGGed
        ephysInstPow
        ephysFs
        ephysTaxis
        ephysDetSettings
        ephysDetParams
        ephysDets
        ephysGlobalDets
        ephysEventComplexes
        ephysDetBorders
        ephysYlabel
        ephysDetInfo
        ephysCurrDetNum = 1;
        ephysCurrDetRow = 1;
        ephysFixWinDetRow = 1;
        ephysParallDetRow = 1;
        
        %% imaging
        imagingTypSelected = [true,false];         % Raw-Gauss
        imagingWinLen = 0.25;
        imagingData
        imagingSmoothed
        imagingFs
        imagingTaxis
        imagingYlabel
        imagingDets
        imagingGlobalDets
        imagingEventComplexes
        imagingDetBorders
        imagingDetInfo
        imagingDetParams
        
        imagingCurrDetNum = 1;
        imagingCurrDetRow = 1;
        imagingFixWinDetRow = 1;
        imagingParallDetRow = 1;
        
        %% running
        runDataTypSelected = [1,0,0,0];       % Velocity-AbsPos-RelPos-still/moving
        showLicks = 0;
        runFs = 200;
        runTaxis
        runAbsPos
        runRelPos
        runLap
        runLicks
        runVeloc
        runActState                 % For showing activity status (still-moving)
        runActThr = 3;              % Threshold in cm/s for moving state
        
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
            if ~isempty(gO.selDirFiles)
                fileListSel(gO)
            end
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
        function [numDets,numChans,chanNum,chanOgNum,numDetsOg,detNum,detIdx,detBorders,detParams] = extractDetStruct(gO,dTyp,currChan,currDet)
            % [numDets,numChans,chanNum,chanOgNum,numDetsOg,detNum,detIdx,detBorders,detParams] = extractDetStruct(gO,dTyp,currChan,currDet)
            
            switch gO.simultMode
                case 0
                    switch dTyp
                        case 1
                            if nargin < 3
                                currChan = gO.ephysCurrDetRow;
                                currDet = gO.ephysCurrDetNum;
                            end
                            
                            dets = gO.ephysDets;
                            detInfo = gO.ephysDetInfo;
                            detBorders = gO.ephysDetBorders;
                            detParams = gO.ephysDetParams;
                        case 2
                            if nargin < 3
                                currChan = gO.imagingCurrDetRow;
                                currDet = gO.imagingCurrDetNum;
                            end
                            
                            dets = gO.imagingDets;
                            detInfo = gO.imagingDetInfo;
                            detBorders = gO.imagingDetBorders;
                            detParams = gO.imagingDetParams;
                    end
                    
                    currDetRows = 1:length(dets);

                    emptyRows = cellfun('isempty',dets);
                    dets(emptyRows) = [];
                    currDetRows(emptyRows) = [];
                    if dTyp==1
                        detInfo.DetChannel(emptyRows) = [];
                    elseif dTyp==2
                        detInfo.DetROI(emptyRows) = [];
                    end
                    if ~isempty(detBorders)
                        detBorders(emptyRows) = [];
                    end
                    if ~isempty(detParams)
                        detParams(emptyRows) = [];
                    end

                    numDets = length(dets{currChan});
                    numDetsOg = numDets;
                    numChans = length(currDetRows);
                    
                    if nargout == 2
                        return
                    end
                    
                    if dTyp == 1
                        chanOgNum = detInfo.DetChannel(currChan);
                        chanNum = find(detInfo.AllChannel == chanOgNum);
                    elseif dTyp == 2
                        chanOgNum = detInfo.DetROI(currChan);
                        chanNum = find(detInfo.AllROI == chanOgNum);
                    end
                    
                    detNum = currDet;
                    
                    if nargout == 6
                        return
                    end
                    
                    detIdx = dets{currChan};
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

                     switch gO.simultFocusTyp % this stores from which datatype we are approaching
                         case 1
                            chanFocus = detInfo.EphysChannels(gO.simultEphysCurrDetRow);
                            detStructFocus = detStruct(detStruct(:,1)==chanFocus,:);
                        case 2
                            chanFocus = detInfo.ROIs(gO.simultImagingCurrDetRow);
                            detStructFocus = detStruct(detStruct(:,3)==chanFocus,:);

                    end
                    
                    switch dTyp
                        case 1
                            if nargin < 3
                                currChan = gO.simultEphysCurrDetRow;
                                currDet = gO.simultEphysCurrDetNum;
                            end
                            
                            if gO.simultFocusTyp==1
                                chan = chanFocus;
                                numChans = length(unique(detStruct(:,1)));
                            elseif gO.simultFocusTyp==2
                                temp = unique(detStructFocus(detStructFocus(:,3)==chanFocus,4));
                                temp = temp(gO.simultImagingCurrDetNum);
                                detStructFocus = detStructFocus(detStructFocus(:,4)==temp,:);
                                chan = unique(detStructFocus(:,1));
                                chan = chan(currChan);
                                numChans = length(unique(detStructFocus(:,1)));
                            end
                            numDets = length(unique(detStructFocus(detStructFocus(:,1)==chan,2)));
                            numDetsOg = length(unique(detStruct(detStruct(:,1)==chan,2)));
                                                        
                            if nargout == 2
                                return
                            end
                            
                            currChanEvents = unique(detStructFocus(detStructFocus(:,1)==chan,2));
                            
                            nonSimDetInfo = gO.ephysDetInfo;
                            nonSimDetRow = find(nonSimDetInfo.DetChannel==chan);
                            chanOgNum = chan;
                            
                            detMat = gO.ephysDets{nonSimDetRow};
                            
                            detIdx = detMat;
                            detNum = currChanEvents(currDet);
                            if ~gO.plotFull
                                detIdx = detIdx(detNum);
                            end
                            
                            chanNum = find(nonSimDetInfo.AllChannel == chan);
                            
                            if nargout == 6
                                return
                            end
                            
                            detBorders = gO.ephysDetBorders{nonSimDetRow};
                            if ~isempty(detBorders) & ~gO.plotFull
                                detBorders = detBorders(currChanEvents(currDet),:);
                            end
                            
                            detParams = gO.ephysDetParams{nonSimDetRow};
                            if ~isempty(detParams) & ~gO.plotFull
                                detParams = detParams(currChanEvents(currDet));
                            end
                            
                        case 2
                            if nargin < 3
                                currChan = gO.simultImagingCurrDetRow;
                                currDet = gO.simultImagingCurrDetNum;
                            end
                            
                            if gO.simultFocusTyp==2
                                chan = chanFocus;
                                numChans = length(unique(detStruct(:,3)));
                            elseif gO.simultFocusTyp==1
                                temp = unique(detStructFocus(detStructFocus(:,1)==chanFocus,2));
                                temp = temp(gO.simultEphysCurrDetNum);
                                detStructFocus = detStructFocus(detStructFocus(:,2)==temp,:);
                                chan = unique(detStructFocus(:,3));
                                chan = chan(currChan);
                                numChans = length(unique(detStructFocus(:,3)));
                            end
                            numDets = length(unique(detStructFocus(detStructFocus(:,3)==chan,4)));
                            numDetsOg = length(unique(detStruct(detStruct(:,3)==chan,4)));

                            if nargout == 2
                                return
                            end
                            
                            currChanEvents = unique(detStructFocus(detStructFocus(:,3)==chan,4));
                            
                            nonSimDetInfo = gO.imagingDetInfo;
                            nonSimDetRow = find(nonSimDetInfo.DetROI==chan);
                            chanOgNum = chan;
                            
                            detMat = gO.imagingDets{nonSimDetRow};
                            
                            detIdx = detMat;
                            detNum = currChanEvents(currDet);
                            if ~gO.plotFull
                                detIdx = detIdx(detNum);
                            end
                            
                            chanNum = nonSimDetRow;
                            
                            if nargout == 6
                                return
                            end
                            
                            detBorders = gO.imagingDetBorders{nonSimDetRow};
                            if ~isempty(detBorders) & ~gO.plotFull
                                detBorders = detBorders(currChanEvents(currDet),:);
                            end
                            
                            detParams = gO.imagingDetParams{nonSimDetRow};
                            if ~isempty(detParams) & ~gO.plotFull
                                detParams = detParams(currChanEvents(currDet));
                            end
                                                        
                    end
            end
        end
        
        %%
        function kbSliding(gO,dir)
            if gO.keyboardPressDtyp == 1
                [ax,~,~] = smartplot(gO,true);
            elseif gO.keyboardPressDtyp == 2
                [~,ax,~] = smartplot(gO,false);
            end
            
            slideSize = gO.kbSlidingStepSize;
            
            currLims = get(ax(1), 'Xlim');
            
            if strcmp(dir, '+')
                currLims = currLims + slideSize;
            elseif strcmp(dir, '-')
                currLims = currLims - slideSize;
            end
            
            set(ax(1), 'Xlim', currLims)
        end
        
        %%
        function ephysPlot(gO,ax,forSpectro)
            if nargin < 3
                forSpectro = 0;
            end
            
            if gO.parallelMode ~= 1
                if ~sum(~cellfun('isempty',gO.ephysDets))
                    for i = 1:length(ax)
                        cla(ax(i), 'reset');
                    end
                    gO.ephysDetParamsTable.Data = '';
                    return
                end
                
                [numDets,~,chanNum,chanOgNum,numDetsOg,detNum,detIdx,detBorders,detParams] = extractDetStruct(gO,1);
                
                if gO.simultMode
                    [~,~,~,~,~,~,simDetIdx,simDetBorders,~] = extractDetStruct(gO,2);
                    simTaxis = gO.imagingTaxis;
                    simFs = gO.imagingFs;
                end
                
                currDetBorders = detBorders;

                if numDets == 0
                    return
                end

                if ~gO.plotFull
                    if ~isempty(detParams)
                        temp = [fieldnames([detParams]), squeeze(struct2cell([detParams]))];
                        gO.ephysDetParamsTable.Data = temp;
                        gO.ephysDetParamsTable.RowName = [];
                        gO.ephysDetParamsTable.ColumnName = {'Electrophysiology','Values'};
                    end

                    tDetInds = gO.ephysTaxis(detIdx);

                    win = gO.ephysWinLen;
                    win = round(win*gO.ephysFs);
                    if gO.simultMode
                        simTDetInd = simTaxis(simDetIdx);
                        simWin = 0.25;
                        simWin = round(simWin*simFs,0);
                    end

                    if ~isempty(currDetBorders)
                        if gO.simultMode
                            winStart = max(0, currDetBorders(1)-win);
                            winEnd = min(length(gO.ephysTaxis), currDetBorders(2)+win);
                            simWinStart = max(0, simDetBorders(1)-simWin);
                            simWinEnd = min(length(simTaxis), simDetBorders(2)+simWin);
                            if gO.ephysTaxis(winStart) > simTaxis(simWinStart)
                                winStart = find(gO.ephysTaxis > simTaxis(simWinStart), 1);
                            end
                            if gO.ephysTaxis(winEnd) < simTaxis(simWinEnd)
                                winEnd = find(gO.ephysTaxis > simTaxis(simWinEnd), 1);
                            end
                        else
                            winStart = currDetBorders(1)-win;
                            winEnd = currDetBorders(2)+win;
                        end
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
                        chanOgNum = gO.ephysDetInfo.AllChannel(gO.ephysFixWinDetRow);
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
                                num2str(detNum),'/',num2str(numDetsOg)];
                        else
                            if ~isempty(gO.ephysGlobalDets)
                                globEvNum = find(gO.ephysGlobalDets(:,gO.ephysCurrDetRow) == detNum);
                            else
                                globEvNum = [];
                            end
                            if ~isempty(globEvNum)
                                globEvTxt = [' (Global event #',num2str(globEvNum),')'];
                            else
                                globEvTxt = '';
                            end
                            
                            if ~gO.simultMode
                                axTitle = ['Channel #',num2str(chanOgNum),'      Detection #',...
                                    num2str(detNum),'/',num2str(numDetsOg), globEvTxt];
                            else
                                axTitle = ['Channel #',num2str(chanOgNum),'      Simult Detection #',...
                                    num2str(gO.simultEphysCurrDetNum),'/',num2str(numDetsOg),...
                                    ' (nonSimult #',num2str(detNum),')', globEvTxt];
                            end
                        end

                    end
                elseif gO.plotFull
                    gO.ephysCurrDetNum = 1;

                    if ~isempty(detParams)
                        currDetParamsAvg = mean(cell2mat(struct2cell(detParams)),2,'omitnan');
                        temp = [fieldnames([detParams(1)]),...
                            mat2cell(currDetParamsAvg,ones(1,length(currDetParamsAvg)))];
                        gO.ephysDetParamsTable.Data = temp;
                        gO.ephysDetParamsTable.RowName = [];
                        gO.ephysDetParamsTable.ColumnName = {'Electrophysiology','Mean values'};
                    end

                    tDetInds = gO.ephysTaxis(detIdx);

                    winIdx = 1:length(gO.ephysTaxis);
                    tWin = gO.ephysTaxis;

                    if chanOgNum == gO.ephysRefCh
                        axTitle = ['Channel #',num2str(chanOgNum),' (Ref)',...
                            '      #Detections = ',num2str(numDetsOg)];
                    else
                        axTitle = ['Channel #',num2str(chanOgNum),'      #Detections = ',...
                            num2str(numDetsOg)];
                    end
                end
                
                
            elseif gO.parallelMode == 1
                chanNum = gO.ephysParallDetRow;
                chanOgNum = gO.ephysDetInfo.AllChannel(chanNum);
                [~,~,imagingChanNum,~,~,imagingDetNum,~,~,~] = extractDetStruct(gO,2);
                [imagingWinIdx,~] = windowMacher(gO,2,imagingChanNum,imagingDetNum,0.25);
                imagingTWinIdx = gO.imagingTaxis(imagingWinIdx);
                [~,winStart] = min(abs(gO.ephysTaxis-imagingTWinIdx(1)));
                [~,winEnd] = min(abs(gO.ephysTaxis-imagingTWinIdx(end)));
                winIdx = winStart:winEnd;
                tWin = gO.ephysTaxis(winIdx);
                axTitle = ['Electrophysiology channel #',num2str(chanOgNum),...
                    ' - parallel time window'];
                tDetInds = [];
            end
            
            if forSpectro
                if gO.ephysTypSelected(2)
                    data4spectro = gO.ephysDoGGed;
                elseif gO.ephysTypSelected(1)
                    data4spectro = gO.ephysData;
                elseif gO.ephysTypSelected(3)
                    data4spectro = gO.ephysInstPow;
                end
                
                if ~isempty(currDetBorders)
                    relDetBords = find(ismember(winIdx, currDetBorders));
                else
                    relDetBords = [];
                end
                
                spectrogramMacher(data4spectro(chanNum,winIdx),gO.ephysFs,gO.spectroFreqLims,relDetBords)
                return
            end
            
            data = nan(3, length(gO.ephysTaxis));
            yLabels = strings(3,1);
            if gO.ephysTypSelected(1)
                if gO.highPassRawEphys == 1
                    [b,a] = butter(2,5/(gO.ephysFs/2),'high');
                    data(1,:) = filtfilt(b, a, gO.ephysData(chanNum,:));
                else
                    data(1,:) = gO.ephysData(chanNum,:);
                end
                yLabels(1) = gO.ephysYlabel;
            end
            if gO.ephysTypSelected(2)
                data(2,:) = gO.ephysDoGGed(chanNum,:);
                yLabels(2) = gO.ephysYlabel;
            end
            if gO.ephysTypSelected(3)
                data(3,:) = gO.ephysInstPow(chanNum,:);
                temp = find(gO.ephysYlabel == '[');
                yLabels(3) = string(['Power ', gO.ephysYlabel(temp:end-1), '^2]']);
            end
            
            types2del = any(isnan(data), 2);
            yLabels(types2del) = [];
            data(types2del,:) = [];
            if ~strcmp('custom', gO.eventYlimMode)
                ylimModeInput = gO.eventYlimMode;
            else
                temp = gO.eventYlimCustom_ephys;
                temp(types2del,:) = [];
                ylimModeInput = temp;
            end
            axLims = computeAxLims(data, ylimModeInput, gO.ephysTaxis, winIdx);
            data = data(:,winIdx);
            
            for i = 1:min(size(data))
                plot(ax(i),tWin,data(i,:))
                hold(ax(i),'on')

                for j = 1:length(tDetInds)
                    if ~isempty(currDetBorders)
                        if ~gO.plotFull
                            xline(ax(i),gO.ephysTaxis(currDetBorders(j,1)),'--g','LineWidth',.75);
                            xline(ax(i),gO.ephysTaxis(currDetBorders(j,2)),'--g','LineWidth',.75);
                        else
                            markerVal = max(data(i,currDetBorders(j,1):currDetBorders(j,2)))*1.25;
                            plot(ax(i),tDetInds(j),markerVal,'g*','MarkerSize',10)
                        end
                        hL = data(i,:);
                        temp1 = find(tWin==gO.ephysTaxis(currDetBorders(j,1)));
                        temp2 = find(tWin==gO.ephysTaxis(currDetBorders(j,2)));
                        hL(1:temp1-1) = nan;
                        hL(temp2+1:end) = nan;
                        plot(ax(i),tWin,hL,'-r','LineWidth',.75)
                    else
                        xline(ax(i),tDetInds(j),'Color','g','LineWidth',.75);
                    end
                end

                hold(ax(i),'off')
                xlabel(ax(i),gO.xLabel)
                ylabel(ax(i),yLabels(i,:))
                xlim(ax(i),[tWin(1),tWin(end)])
                ylim(ax(i),axLims(i,:))
                title(ax(i),axTitle)

                ax(i).Toolbar.Visible = 'on';
            end
            
        end
        
        %%
        function imagingPlot(gO,ax)
            if gO.parallelMode ~= 2
                if ~sum(~cellfun('isempty',gO.imagingDets))
                    cla(ax, 'reset');
                    gO.imagingDetParamsTable.Data = '';
                    return
                end
                
                [numDets,~,chanNum,chanOgNum,numDetsOg,detNum,detIdx,detBorders,detParams] = extractDetStruct(gO,2);

                if gO.simultMode
                    [~,~,~,~,~,~,simDetIdx,simDetBorders,~] = extractDetStruct(gO,1);
                    simTaxis = gO.ephysTaxis;
                    simFs = gO.ephysFs;
                end
                
                currDetBorders = detBorders;

                if numDets == 0
                    return
                end

                if ~gO.plotFull
                    if ~isempty(detParams)
                        temp = [fieldnames([detParams]), squeeze(struct2cell([detParams]))];
                        gO.imagingDetParamsTable.Data = temp;
                        gO.imagingDetParamsTable.RowName = [];
                        gO.imagingDetParamsTable.ColumnName = {'Imaging','Values'};
                    end

                    tDetInds = gO.imagingTaxis(detIdx);

                    win = gO.imagingWinLen;
                    win = round(win*gO.imagingFs,0);
                    if gO.simultMode
                        simTDetInd = simTaxis(simDetIdx);
                        simWin = 0.25;
                        simWin = round(simWin*simFs,4);
                    end

                    if ~isempty(currDetBorders)

                        if gO.simultMode
                            winStart = max(0, currDetBorders(1)-win);
                            winEnd = min(length(gO.imagingTaxis), currDetBorders(2)+win);
                            simWinStart = max(0, simDetBorders(1)-simWin);
                            simWinEnd = min(length(simTaxis), simDetBorders(2)+simWin);
                            if gO.imagingTaxis(winStart) > simTaxis(simWinStart)
                                winStart = find(gO.imagingTaxis > simTaxis(simWinStart), 1);
                            end
                            if gO.imagingTaxis(winEnd) < simTaxis(simWinEnd)
                                winEnd = find(gO.imagingTaxis > simTaxis(simWinEnd), 1);
                            end
                        else
                            winStart = currDetBorders(1)-win;
                            winEnd = currDetBorders(2)+win;
                        end
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

                    if gO.fixWin == 1
                        chanOgNum = gO.imagingDetInfo.AllROI(gO.imagingFixWinDetRow);
                        chanNum = gO.imagingFixWinDetRow;
                        axTitle = ['ROI #',num2str(chanOgNum)];
                    elseif gO.fixWin == 0
                        if ~isempty(gO.imagingGlobalDets)
                            globEvNum = find(gO.imagingGlobalDets(:,gO.imagingCurrDetRow) == detNum);
                        else
                            globEvNum = [];
                        end
                        if ~isempty(globEvNum)
                            globEvTxt = [' (Global event #',num2str(globEvNum),')'];
                        else
                            globEvTxt = '';
                        end
                        
                        if ~gO.simultMode
                            axTitle = ['ROI #',num2str(chanOgNum),'      Detection #',...
                                num2str(detNum),'/',num2str(numDetsOg), globEvTxt];
                        else
                            axTitle = ['ROI #',num2str(chanOgNum),'      Simult Detection #',...
                                num2str(gO.simultImagingCurrDetNum),'/',num2str(numDetsOg),...
                                ' (nonSimult #',num2str(detNum),')', globEvTxt];
                        end
                    end

                elseif gO.plotFull
                    gO.imagingCurrDetNum = 1;

                    if ~isempty(detParams)
                        currDetParamsAvg = mean(cell2mat(struct2cell(detParams)),2,'omitnan');
                        temp = [fieldnames([detParams(1)]),...
                            mat2cell(currDetParamsAvg,ones(1,length(currDetParamsAvg)))];
                        gO.imagingDetParamsTable.Data = temp;
                        gO.imagingDetParamsTable.RowName = [];
                        gO.imagingDetParamsTable.ColumnName = {'Imaging','Mean values'};
                    end

                    tDetInds = gO.imagingTaxis(detIdx);

                    winIdx = 1:length(gO.imagingTaxis);
                    tWin = gO.imagingTaxis;

                    axTitle = ['ROI #',num2str(chanOgNum),'      #Detections = ',...
                        num2str(numDets)];
                end
            elseif gO.parallelMode == 2
                chanNum = gO.imagingParallDetRow;
                chanOgNum = gO.imagingDetInfo.AllROI(chanNum);
                [~,~,ephysChanNum,~,~,ephysDetNum,~,~,~] = extractDetStruct(gO,1);
                [ephysWinIdx,~] = windowMacher(gO,1,ephysChanNum,ephysDetNum,0.25);
                ephysTWinIdx = gO.ephysTaxis(ephysWinIdx);
                [~,winStart] = min(abs(gO.imagingTaxis-ephysTWinIdx(1)));
                [~,winEnd] = min(abs(gO.imagingTaxis-ephysTWinIdx(end)));
                winIdx = winStart:winEnd;
                tWin = gO.imagingTaxis(winIdx);
                axTitle = ['Imaging ROI #',num2str(chanOgNum),...
                    ' - parallel time window'];
                tDetInds = [];
            end
            
            yLabels = string(gO.imagingYlabel);
            
            if gO.imagingTypSelected(1)
                data = gO.imagingData(chanNum,:);
            elseif gO.imagingTypSelected(2)
                data = gO.imagingSmoothed(chanNum,:);
            end
            
            if ~strcmp('custom', gO.eventYlimMode)
                ylimModeInput = gO.eventYlimMode;
            else
                ylimModeInput = gO.eventYlimCustom_imaging(gO.imagingTypSelected,:);
            end
            axLims = computeAxLims(data, ylimModeInput, gO.imagingTaxis, winIdx);
            data = data(:,winIdx);
            
            for i = 1:min(size(data))
                plot(ax(i),tWin,data(i,:))
                hold(ax(i),'on')

                for j = 1:length(tDetInds)
                    if ~isempty(currDetBorders)
                        if ~gO.plotFull
                            xline(ax(i),gO.imagingTaxis(currDetBorders(j,1)),'--g','LineWidth',.75);
                            xline(ax(i),gO.imagingTaxis(currDetBorders(j,2)),'--g','LineWidth',.75);
                        else
                            markerVal = max(data(i,currDetBorders(j,1):currDetBorders(j,2)))*1.25;
                            plot(ax(i),tDetInds(j),markerVal,'g*','MarkerSize',10)
                        end
                        hL = data(i,:);
                        temp1 = find(tWin==gO.imagingTaxis(currDetBorders(j,1)));
                        temp2 = find(tWin==gO.imagingTaxis(currDetBorders(j,2)));
                        hL(1:temp1-1) = nan;
                        hL(temp2+1:end) = nan;
                        plot(ax(i),tWin,hL,'-r','LineWidth',.75)
                    else
                        xline(ax(i),tDetInds(j),'Color','g','LineWidth',.75);
                    end
                end

                hold(ax(i),'off')
                xlabel(ax(i),gO.xLabel)
                ylabel(ax(i),yLabels(i,:))
                xlim(ax(i),[tWin(1),tWin(end)])
                ylim(ax(i),axLims(i,:))
                title(ax(i),axTitle)

                ax(i).Toolbar.Visible = 'on';
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
                axYlabel = 'Relative position [‰]';
            elseif gO.runDataTypSelected(4)
                data = gO.runActState;
                axTitle = 'Running - activity states';
                axYlabel = '';
            end
            
            plot(ax,gO.runTaxis,data)
            if gO.showLicks
                lickInds = find(gO.runLicks);
                for i = 1:length(lickInds) 
                    xline(ax,gO.runTaxis(lickInds(i)),'g','LineWidth',1);
                end
            end
            title(ax,axTitle)
            ylabel(ax,axYlabel)
            xlabel(ax,'Time [s]')
            if gO.runDataTypSelected(4)
                ylim(ax,[-0.1,1.1])
                yticks(ax,[0,1])
                yticklabels(ax,{'Still','Moving'})
            end

            ax.Toolbar.Visible = 'on';
        end
        
        %% 
        function [eAx,iAx,rAx] = smartplot(gO,onlyAx)
            if nargin < 2
                onlyAx = false;
            else
                eAx = [];
                iAx = [];
                rAx = [];
            end
            
            axVisSwitch(gO,sum(gO.loaded(1:3))+(sum(gO.ephysTypSelected)-1))

            switch sum(gO.loaded(1:3))
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
                        eAx = ax;
                        if ~onlyAx
                            linkaxes(ax,'x')
                            ephysPlot(gO,ax)
                        end
                    elseif gO.loaded(2)
                        ax = [gO.ax11];
                        iAx = ax;
                        if ~onlyAx
                            linkaxes(ax,'x')
                            imagingPlot(gO,ax)
                        end
                    elseif gO.loaded(3)
                        ax = [gO.ax11];
                        rAx = ax;
                        if ~onlyAx
                            linkaxes(ax,'x')
                            runPlot(gO,ax)
                        end
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
                        eAx = ax;
                        if ~onlyAx
                            linkaxes(ax,'x')
                            ephysPlot(gO,ax)
                        end
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
                        iAx = ax;
                        if ~onlyAx
                            linkaxes(ax,'x')
                            imagingPlot(gO,ax)
                        end
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
                        rAx = ax;
                        if ~onlyAx
                            linkaxes(ax,'x')
                            runPlot(gO,ax)
                        end
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
                        eAx = ax;
                        if ~onlyAx
                            linkaxes(ax,'x')
                            ephysPlot(gO,ax)
                        end
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
                        iAx = ax;
                        if ~onlyAx
                            linkaxes(ax,'x')
                            imagingPlot(gO,ax)
                        end
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
                        rAx = ax;
                        if ~onlyAx
                            linkaxes(ax,'x')
                            runPlot(gO,ax)
                        end
                    end
            end
            
            if nargout == 0
                clear eAx iAx rAx
            end
            
        end
        
        %%
        function [win,relBorders] = windowMacher(gO,dTyp,chanNum,detNum,winLen)
            if nargin < 5 || isempty(winLen)
                winLen = 0.25;
            end
            switch dTyp
                case 1
                    detCell = gO.ephysDets;
                    fs = gO.ephysFs;
                    lenData = length(gO.ephysData);
                    detBorders = gO.ephysDetBorders;
                case 2
                    detCell = gO.imagingDets;
                    fs = gO.imagingFs;
                    lenData = length(gO.imagingData);
                    detBorders = gO.imagingDetBorders;
            end
            
            winLen = round(fs*winLen);
            
            if ~isempty(detBorders) & (length(detBorders) >= chanNum) & (~isempty(detBorders{chanNum}))
                detBorders = detBorders{chanNum}(detNum,:);
                if (detBorders(1)-winLen) > 1
                    winStart = detBorders(1)-winLen;
                else
                    winStart = 1;
                end

                if (detBorders(2)+winLen) <= lenData
                    winEnd = detBorders(2)+winLen;
                else
                    winEnd = lenData;
                end
                relBorders = detBorders-winStart+1;
            else
                dets = detCell{chanNum};
                detInd = dets(detNum);
            
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
                relBorders = [];
            end
            win = winStart:winEnd;
        end
        
        %%
        function win = runWindowMacher(gO,tWin)
            if (tWin(1) > gO.runTaxis(end)) || (tWin(end) < gO.runTaxis(1))
                win = [];
                return
            end
            
            temp = gO.runTaxis-tWin(1);
            [~,winStart] = min(abs(temp));
            temp = gO.runTaxis-tWin(2);
            [~,winEnd] = min(abs(temp));
            win = winStart:winEnd;
        end
        
        %%
        function overwriteDASsave(gO,simult,dTyp)
            switch simult
                case 0
                    switch dTyp
                        case 1
                            ephysSaveData.RawData = gO.ephysData;
                            ephysSaveData.Fs = gO.ephysFs;
                            ephysSaveData.TAxis = gO.ephysTaxis;
                            ephysSaveData.YLabel = gO.ephysYlabel;
                            ephysSaveData.Dets = gO.ephysDets;
                            ephysSaveData.GlobalDets = gO.ephysGlobalDets;
                            ephysSaveData.EventComplexes = gO.ephysEventComplexes;
                            ephysSaveData.DetBorders = gO.ephysDetBorders;
                            ephysSaveData.DetParams = gO.ephysDetParams;
                            ephysSaveInfo = gO.ephysDetInfo;

                            save(gO.path2loadedSave, 'ephysSaveData', 'ephysSaveInfo', '-append')
                        case 2
                            imagingSaveData.RawData = gO.imagingData;
                            imagingSaveData.Fs = gO.imagingFs;
                            imagingSaveData.TAxis = gO.imagingTaxis;
                            imagingSaveData.YLabel = gO.imagingYlabel;
                            imagingSaveData.Dets = gO.imagingDets;
                            imagingSaveData.GlobalDets = gO.imagingGlobalDets;
                            imagingSaveData.EventComplexes = gO.imagingEventComplexes;
                            imagingSaveData.DetBorders = gO.imagingDetBorders;
                            imagingSaveData.DetParams = gO.imagingDetParams;
                            imagingSaveInfo = gO.imagingDetInfo;

                            save(gO.path2loadedSave, 'imagingSaveData', 'imagingSaveInfo', '-append')

                    end
                    
                case 1
                    simultSaveData = gO.simultDets;
                    simultSaveInfo = gO.simultDetInfo;
                    
                    save(gO.path2loadedSave, 'simultSaveData', 'simultSaveInfo', '-append')
                    
            end
        end
        
        %%
        function buttonEnabler(gO)
            allObjs = findobj(gO.mainFig, '-regexp', 'Tag', '^_');
            
            obj2enable = [];
            if gO.loaded(1)
                if sum(~cellfun('isempty', gO.ephysDets))
                    obj2enable = [obj2enable; findobj(allObjs, '-regexp', 'Tag', 'ephys')];
                else
                    obj2enable = [obj2enable; findobj(allObjs, '-regexp', 'Tag', 'ephys(?!Dets)')];
                end
                
                if ~gO.loaded(2)
                    obj2enable = setdiff(obj2enable, findobj(obj2enable, '-regexp', 'Tag', 'imaging'));
                end
            end
            
            if gO.loaded(2)
                if sum(~cellfun('isempty', gO.imagingDets))
                    obj2enable = [obj2enable; findobj(allObjs, '-regexp', 'Tag', 'imaging')];
                else
                    obj2enable = [obj2enable; findobj(allObjs, '-regexp', 'Tag', 'imaging(?!Dets)')];
                end
                
                if ~gO.loaded(1)
                    obj2enable = setdiff(obj2enable, findobj(obj2enable, '-regexp', 'Tag', 'ephys'));
                end
            end
            
            if gO.loaded(3)
                obj2enable = [obj2enable; findobj(allObjs, '-regexp', 'Tag', 'running')];
            end
            
            otherObjs = setdiff(allObjs, obj2enable);
            
            if gO.loaded(4) && ~gO.fixWin && ~gO.parallelMode && ~gO.plotFull
                if gO.simultMode
                    obj2enable = findobj(obj2enable, '-regexp', 'Tag', 'simult');
                    obj2enable = union(obj2enable, findobj(otherObjs, 'Tag', '_simult'));
                end
                obj2enable = union(obj2enable, findobj(otherObjs, '-regexp', 'Tag', 'simultSwitch'));
            end
            
            if ~gO.simultMode && ~gO.parallelMode && ~gO.plotFull
                if gO.fixWin
                    obj2enable = findobj(obj2enable, '-regexp', 'Tag', 'fixwin');
                    obj2enable = union(obj2enable, findobj(otherObjs, 'Tag', '_fixwin'));
                end
                obj2enable = union(obj2enable, findobj(otherObjs, '-regexp', 'Tag', 'fixwinSwitch'));
            end
            
            if (gO.loaded(1) && gO.loaded(2)) && ~gO.simultMode && ~gO.fixWin && ~gO.plotFull
                if gO.parallelMode
                    obj2enable = union(obj2enable, findobj(otherObjs, 'Tag', '_parallel'));
                    if gO.parallelMode == 1
                        obj2enable = findobj(obj2enable, '-regexp', 'Tag', 'parallel(?!Imaging)|parallelEphys');
                    elseif gO.parallelMode == 2
                        obj2enable = findobj(obj2enable, '-regexp', 'Tag', 'parallel(?!Ephys)|parallelImaging');
                    end
                end
                obj2enable = union(obj2enable, findobj(otherObjs, '-regexp', 'Tag', 'parallelSwitch'));
            end
            
            if ~gO.simultMode && ~gO.fixWin && ~gO.parallelMode
                if gO.plotFull
                    obj2enable = findobj(obj2enable, '-regexp', 'Tag', 'plotfull');
                    obj2enable = union(obj2enable, findobj(otherObjs, 'Tag', '_plotfull'));
                end
                obj2enable = union(obj2enable, findobj(otherObjs, '-regexp', 'Tag', 'plotfullSwitch'));
            end
            
            allObjs = setdiff(allObjs, obj2enable);
            set(allObjs, 'Enable', 'off')
            set(obj2enable, 'Enable', 'on')
            
        end
        
    end
    
    %% Callback functions
    methods (Access = private)
        
        %%
        function DASsaveAnalyserBestChSelModePopMenuCB(gO,~,~)
            if strcmp(gO.DASsaveAnalyserBestChSelModePopMenu.String{gO.DASsaveAnalyserBestChSelModePopMenu.Value}, 'Manual selection')
                gO.DASsaveAnalyserBestChInputEdit.Enable = 'on';
            else
                gO.DASsaveAnalyserBestChInputEdit.Enable = 'off';
            end
        end
        
        %%
        function saveFileAnalysisSourceCB(gO,~,ev)
            switch ev.NewValue.String
                case 'Select files'
                    gO.fileListBox.Max = 2;
                    gO.DASsaveAnalyserCheckRHDCheckBox.Value = 0;
                    gO.DASsaveAnalyserCheckRHDCheckBox.Enable = 'off';
                    
                case 'Whole directory'
                    gO.fileListBox.Max = 1;
                    gO.fileListBox.Value = gO.fileListBox.Value(1);
                    gO.DASsaveAnalyserCheckRHDCheckBox.Enable = 'on';
                    gO.fileListSel(gO)
            end
        end
        
        %%
        function DASsaveAnalyserCheckRHDCheckBoxCB(gO,h,~)
            if h.Value && strcmp(gO.saveFileAnalysisSourceButtonGroup.SelectedObject.String, 'Select files')
                h.Value = 0;
            end
        end
        
        %%
        function DASsaveAnalyserButtonCB(gO,~,~)
            if gO.DASsaveAnalyserBestChSelModePopMenu.Value == 1
                return
            end
            path = [gO.selDir,'\'];
            switch gO.saveFileAnalysisSourceButtonGroup.SelectedObject.String
                case 'Whole directory'
                    saveFnames = gO.selDirFiles;
                    
                case 'Select files'
                    saveFnames = gO.selDirFiles(gO.fileListBox.Value);
                    
            end
            checkRHD = logical(gO.DASsaveAnalyserCheckRHDCheckBox.Value);
            bestChMode = gO.DASsaveAnalyserBestChSelModePopMenu.String{gO.DASsaveAnalyserBestChSelModePopMenu.Value};
            if strcmp(gO.DASsaveAnalyserBestChSelModePopMenu.String{gO.DASsaveAnalyserBestChSelModePopMenu.Value}, 'Manual selection')
                bestChInd = str2double(gO.DASsaveAnalyserBestChInputEdit.String);
                if isempty(bestChInd) ||isnan(bestChInd)
                    eD = errordlg('Invalid channel input!');
                    pause(1)
                    if ishandle(eD)
                        close(eD)
                    end
                    return
                end
            else
                bestChInd = [];
            end
            makeExcel = true;
            DASsaveAnalyse(path,saveFnames,checkRHD,[true,false],bestChMode,bestChInd,makeExcel)
        end
        
        %%
        function globalEventAnalyserButtonCB(gO,~,~)
            path = [gO.selDir,'\'];
            switch gO.saveFileAnalysisSourceButtonGroup.SelectedObject.String
                case 'Whole directory'
                    saveFnames = gO.selDirFiles;
                    
                case 'Select files'
                    saveFnames = gO.selDirFiles(gO.fileListBox.Value);
                    
            end
            globalEventsAnalyzer(path,saveFnames)
        end
        
        %%
        function ephysTypMenuSel(gO,~,~)
            [idx,tf] = listdlg('ListString',{'Raw','DoG','InstPow'},...
                'PromptString','Select data type(s) to show detections on!',...
                'InitialValue', find(gO.ephysTypSelected));
            if ~tf
                return
            end
            
            gO.ephysTypSelected(:) = false;
            gO.ephysTypSelected(idx) = true;
            
            smartplot(gO)
        end
        
        %%
        function imagingTypMenuSel(gO,~,~)
            [idx,tf] = listdlg('ListString',{'Raw','Smoothed'},...
                'PromptString','Select data type to show detections on!',...
                'InitialValue', find(gO.imagingTypSelected),...
                'SelectionMode', 'single');
            if ~tf
                return
            end
            
            gO.imagingTypSelected(:) = false;
            gO.imagingTypSelected(idx) = true;
            
            smartplot(gO)
        end
        
        %%
        function runTypMenuSel(gO,~,~)
            [idx,tf] = listdlg('ListString',{'Velocity','Absolute position','Relative position','Still/Moving'},...
                'PromptString','Select data type to show detections on!',...
                'SelectionMode','single',...
                'InitialValue', find(gO.runDataTypSelected));
            if ~tf
                return
            end
            
            gO.runDataTypSelected(:) = 0;
            gO.runDataTypSelected(idx) = 1;
            
            smartplot(gO)
        end
        
        %%
        function changeWinSize(gO,~,~)
            prompt = {'Ephys | Window size around event [ms]', 'Imaging | Window size around event [ms]'};
            title = 'Window size around detected event';
            dims = [1,15];
            definput = {num2str(gO.ephysWinLen*2000), num2str(gO.imagingWinLen*2000)};
            
            answer = inputdlg(prompt,title,dims,definput);
            if isempty(answer)
                return
            end
            
            if gO.loaded(1)
                gO.ephysWinLen = str2double(answer{1})/2000;
            end
            if gO.loaded(2)
                gO.imagingWinLen = str2double(answer{2})/2000;
            end
            
            smartplot(gO)
        end
        
        %%
        function simultFocusMenuSel(gO,~,~)
            if gO.simultFocusTyp == 1
                gO.simultFocusTyp = 2;
                gO.simultFocusMenu.Text = 'Simultan mode focus --Imaging--';
            else
                gO.simultFocusTyp = 1;
                gO.simultFocusMenu.Text = 'Simultan mode focus --Ephys--';
            end
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
                if gO.enableKbSlide
                    gO.enableKbSlide = false;
                    gO.enableKbSlideMenu.Text = 'Keyboard sliding - OFF';
                    gO.enableKbSlideMenu.ForegroundColor = 'k';
                end
            elseif gO.plotFull == 0
                gO.plotFull = 1;
                gO.fixWinSwitch.Value = 0;
            end
            buttonEnabler(gO)
            smartplot(gO)
        end
        
        %%
        function enableKbSlideMenuCB(gO)
            if ~gO.plotFull
                return
            end
            
            gO.enableKbSlide = ~gO.enableKbSlide;
            if gO.enableKbSlide
                gO.enableKbSlideMenu.Text = 'Keyboard sliding - ON';
                gO.enableKbSlideMenu.ForegroundColor = 'g';
            else
                gO.enableKbSlideMenu.Text = 'Keyboard sliding - OFF';
                gO.enableKbSlideMenu.ForegroundColor = 'k';
            end
        end
        
        %%
        function setKbSlideStepSizeMenuCB(gO)
            prompt = 'Keyboard sliding step size [s]:';
            ttl = 'Sliding step size';
            dims = [1 35];
            definput = {num2str(gO.kbSlidingStepSize)};
            answ = inputdlg(prompt,ttl,dims,definput);
            answ = str2double(answ{1});
            if answ < 0
                eD = errordlg('Step size should be a positive number!');
                pause(1)
                if ishandle(eD)
                    close(eD)
                end
                setKbSlideStepSizeMenuCB(gO)
                return
            else
                gO.kbSlidingStepSize = answ;
                gO.setKbSlideStepSizeMenu.Text = sprintf('Set keyboard sliding step size| %.2f [s]',gO.kbSlidingStepSize);
            end
        end
        
        %%
        function parallelModeMenuSel(gO,changeVal)
            if changeVal && ~(isempty(gO.ephysDets) || isempty(gO.imagingDets))
                
                if gO.parallelMode < 2
                    gO.parallelMode = gO.parallelMode + 1;
                else
                    gO.parallelMode = 0;
                end
            end
            
            buttonEnabler(gO)
            
            if gO.parallelMode == 0
                gO.parallelModeMenu.Text = 'Parallel mode --OFF--';
                gO.parallelModeMenu.ForegroundColor = 'r';
            end
            
            if gO.parallelMode == 1
                gO.parallelModeMenu.Text = 'Parallel mode --Ephys--';
                gO.parallelModeMenu.ForegroundColor = 'g';
            elseif gO.parallelMode == 2
                gO.parallelModeMenu.Text = 'Parallel mode --Imaging--';
                gO.parallelModeMenu.ForegroundColor = 'b';
            end
            
            smartplot(gO)
        end
        
        %%
        function eventYlimModeMenuCB(gO)
            if strcmp(gO.eventYlimMode, 'global')
                gO.eventYlimMode = 'window';
                gO.eventYlimModeMenu.Text = 'Event plotting Y limit, current mode: window';
            elseif strcmp(gO.eventYlimMode, 'window')
                gO.eventYlimMode = 'custom';
                gO.eventYlimModeMenu.Text = 'Event plotting Y limit, current mode: custom';
            elseif strcmp(gO.eventYlimMode, 'custom')
                gO.eventYlimMode = 'global';
                gO.eventYlimModeMenu.Text = 'Event plotting Y limit, current mode: global';
            end
            
            smartplot(gO)
        end
        
        %%
        function eventYlimSetCustomMenuCB(gO)
            [gO.eventYlimCustom_ephys, gO.eventYlimCustom_imaging] = setCustomYlim(gO.eventYlimCustom_ephys,...
                gO.eventYlimCustom_imaging);
            
            if strcmp(gO.eventYlimMode, 'custom')
                smartplot(gO)
            end
        end
        
        %%
        function showEventSpectro(gO,~,~)
            ephysPlot(gO,[],1)
        end
        
        %%
        function editSpectroFreqLimsMenuCB(gO)
            prompt = {'Lower limit [Hz]','Upper limit [Hz]:'};
            ttl = 'Spectrogram frequency limits';
            dims = [1 35];
            definput = {num2str(gO.spectroFreqLims(1)), num2str(gO.spectroFreqLims(2))};
            answ = inputdlg(prompt,ttl,dims,definput);
            if isempty(answ)
                return
            end
            fmin = round(str2double(answ{1}));
            fmax = round(str2double(answ{2}));
            
            redo = false;
            if fmin < 1
                eD = errordlg('Lower limit shouldnt be smaller than 1 Hz!');
                pause(1)
                if ishandle(eD)
                    close(eD)
                end
                redo = true;
            elseif fmax > (gO.ephysFs / 2)
                eD = errordlg(sprintf('Upper limit shouldnt be larger than fs/2 (%.2f)!',gO.ephysFs/2));
                pause(1)
                if ishandle(eD)
                    close(eD)
                end
                redo = true;
            elseif fmin >= fmax
                eD = errordlg('Lower limit should be smaller than upper limit!');
                pause(1)
                if ishandle(eD)
                    close(eD)
                end
                redo = true;
            end
            
            if redo
                editSpectroFreqLimsMenuCB(gO)
                return
            else
                gO.spectroFreqLims = [fmin, fmax];
            end
        end
        
        %%
        function makeFoilDistrPlotCB(gO,~,~)
            % basic checks
            if isempty(gO.ephysDets) || ~any(~isnan(gO.ephysGlobalDets), 'all')
                eD = errordlg('No ephys global events!');
                pause(1)
                if ishandle(eD)
                    close(eD)
                end
                return
            end
            
            % check whether recording is actually from foil electrode (this is not 100% ofc)
            if max(gO.ephysDetInfo.AllChannel) > 32
                confirm = questdlg('Are you sure this is a foil electrode recording? If not the feature will not work correctly!');
                if ~strcmp(confirm, 'Yes')
                    return
                end
            end
            
            [~,~,~,~,~,detNum,~,~,~] = extractDetStruct(gO,1);
            globEvNum = gO.ephysGlobalDets(:,gO.ephysCurrDetRow) == detNum;
            if ~any(globEvNum)
                eD = errordlg('This is not a global event!');
                pause(1)
                if ishandle(eD)
                    close(eD)
                end
                return
            end
            globDet = gO.ephysGlobalDets(globEvNum,:);
            
            src = gO.path2loadedSave(find(gO.path2loadedSave == '\', 1, 'last') + 1:end);
            rawData = gO.ephysData(ismember(gO.ephysDetInfo.AllChannel, gO.ephysDetInfo.DetChannel),:);
            
            foilSpatialDistrPlotter(src, gO.ephysTaxis, gO.ephysFs, rawData, globDet, gO.ephysDets,...
                gO.ephysDetInfo.DetChannel, gO.ephysDetBorders, gO.ephysDetParams);
        end
        
        %%
        function showLicksMenuSel(gO,~,~)
            if gO.showLicks
                gO.showLicks = 0;
                gO.showLicksMenu.Text = 'Show licks on graphs --OFF--';
                gO.showLicksMenu.ForegroundColor = 'r';
            else
                gO.showLicks = 1;
                gO.showLicksMenu.Text = 'Show licks on graphs --ON--';
                gO.showLicksMenu.ForegroundColor = 'g';
            end
            
            smartplot(gO)
        end
        
        %%
        function showKeyShortcutsMenuCB(~,~,~)
            kbBinds = {'Ctrl+t', 'global', 'Changes tabs';...
                       'Delete', 'Event viewer tab', 'Delete current event';...
                       'Shift+Delete', 'Event viewer tab', 'Delete selected events';...
                       'Ctrl+a', 'Event viewer tab', 'Select all events';...
                       'y', 'Event viewer tab', 'Change Y limit mode';...
                       'f', 'Event viewer tab', 'Switch fixwin mode (if allowed)';...
                       's', 'Event viewer tab', 'Switch simult mode (if allowed)';...
                       'Ctrl+s', 'Event viewer tab', 'Save selected events';...
                       'Alt+s', 'Event viewer tab', 'Show event spectrogram';...
                       'w', 'Event viewer tab', 'Switch plot full mode (if allowed)';...
                       'Alt+w', 'Event viewer tab', 'Enable sliding mode (if allowed)';...
                       'p', 'Event viewer tab', 'Switch parallel mode (if allowed)';...
                       'd', 'Event viewer tab', 'Switch data type controlled by keys';...
                       'e', 'Event viewer tab', 'Select current ephys event (for saving/deleting)';...
                       'i' 'Event viewer tab', 'Select current imaging event (for saving/deleting)';...
                       '<HTML>&rarr', 'Event viewer tab', 'Next event';...
                       '<HTML>&larr', 'Event viewer tab', 'Prev. event';...
                       '<HTML>&rarr', 'Event viewer tab - KB slide mode', 'Slide right';...
                       '<HTML>&larr', 'Event viewer tab - KB slide mode', 'Slide left';...
                       '<HTML>&uarr', 'Event viewer tab', 'Next channel/ROI';...
                       '<HTML>&darr', 'Event viewer tab', 'Prev. channel/ROI'};
                   
            colNames = {'Key', 'Scope', 'Function'};
            temp = [colNames; kbBinds];
            [~, maxLenInds] = max(cellfun(@length, temp));
            wid1 = getTxtPixelSize(temp{maxLenInds(1),1});
            wid2 = getTxtPixelSize(temp{maxLenInds(2),2});
            wid3 = getTxtPixelSize(temp{maxLenInds(3),3});
            
            colWidths = {wid1+5, wid2+5, wid3+5};
            
            kbBindsFig = figure('Name', 'Keyboard shortcuts',...
                'NumberTitle', 'off',...
                'MenuBar', 'none',...
                'Units', 'normalized',...
                'Position', [0.3, 0.3, 0.5, 0.6],...
                'Visible', 'off');
            infoTxt = uicontrol(kbBindsFig,...
                'Style', 'text',...
                'Units', 'normalized',...
                'Position', [0, 0.92, 1, 0.08],...
                'String', {'If then keys don''t seems to work, make sure the focus isn''t on a UI element,'...
                            'and that no special mode is activated (like zoom on an axes)'},...
                'Max', 2);
            kbTable = uitable(kbBindsFig,...
                'Data', kbBinds,...
                'ColumnName', colNames,...
                'ColumnWidth', colWidths,...
                'Units', 'normalized',...
                'Position', [0, 0, 1, 0.92],...
                'Enable', 'inactive');
            
            extents = kbTable.Extent(3:4);
            extents(2) = extents(2) + infoTxt.Extent(4);
            kbBindsFig.Position(3:4) = kbBindsFig.Position(3:4).*(extents);
            kbBindsFig.Visible = 'on';
        end
        
        %%
        function tabChanged(gO,~,e)
            if nargin == 3
                if (e.NewValue == gO.tabgrp.Children(2)) & isempty(find(gO.loaded,1))
                    gO.tabgrp.SelectedTab = e.OldValue;
                    drawnow
                    eD = errordlg('No file loaded!');
                    pause(1)
                    if ishandle(eD)
                        close(eD)
                    end
                end
            else
                
            end
            
            switch gO.tabgrp.SelectedTab
                case gO.loadTab
                    uicontrol(gO.fileListBox)
                    
                case gO.viewerTab
                    gO.mainFig.CurrentObject = gO.plotPanel;
                    figure(gO.mainFig)
                    
            end
        end
        
        %%
        function selDirButtPress(gO,changeOrUpdate)
            if changeOrUpdate == 0
                newdir = uigetdir;
                if newdir == 0
                    return
                end
            else
                newdir = gO.selDir;
            end
            
            newlist = dir([newdir,'\*DASsave*.mat']);
            if isempty(newlist)
                warndlg('Selected directory does not include any save files!')
                return
            end
            newlist = {newlist.name};
            gO.selDirFiles = newlist;
            gO.fileListBox.Value = 1;
            gO.fileListBox.String = newlist;
            
            if changeOrUpdate == 0
                gO.selDir = newdir;
                gO.currDirTxt.String = newdir;
            end
        end
        
        %%
        function loadSaveButtPress(gO,~,~)
            val = gO.fileListBox.Value;
            if ~isempty(gO.path2loadedSave) && strcmp(gO.selDir, gO.path2loadedSave(1:find(gO.path2loadedSave == '\', 1, 'last') - 1))
                prevFname = gO.path2loadedSave(find(gO.path2loadedSave == '\', 1, 'last') + 1:end);
                prevLoadedInd = find(ismember(gO.selDirFiles, prevFname));
            else
                prevLoadedInd = [];
            end

            if strcmp([gO.selDir,'\',gO.selDirFiles{val}],gO.path2loadedSave)
                eD = errordlg('File already loaded!');
                pause(1)
                if ishandle(eD)
                    close(eD)
                end
                return
            end
            
            if ~isempty(gO.selDirFiles)
                fname = gO.selDirFiles{val};
                fnameFull = [gO.selDir,'\',fname];
            else
                eD = errordlg('No file selected!');
                pause(1)
                if ishandle(eD)
                    close(eD)
                end
                return
            end
                        
            wb1 = waitbar(0,'Starting to load file...');

            dataPresent = false(2,1); % indicates whether there has been data loaded
            
            gO.parallelMode = 0;
            
            gO.ephysCurrDetNum = 1;
            gO.ephysCurrDetRow = 1;
            
            testload = matfile(fnameFull);

            gO.loaded(1) = 0;
            gO.ephysDetParamsTable.Data = {};
            gO.ephysDetParamsTable.ColumnName = {};

            waitbar(0.25,wb1,'Looking for ephys data...')
            
            if sum(ismember(fieldnames(testload),{'ephysSaveData';'ephysSaveInfo'})) == 2
                load(fnameFull,'ephysSaveData','ephysSaveInfo')

                if ~isempty(ephysSaveData)
                    
                    waitbar(0.3,wb1,'Loading ephys data...')
                    
                    gO.ephysData = ephysSaveData.RawData;
                    gO.ephysFs = ephysSaveData.Fs;
                    if gO.spectroFreqLims(2) > (gO.ephysFs/2)
                        gO.spectroFreqLims(2) = gO.ephysFs/2;
                    end
                    gO.ephysTaxis = ephysSaveData.TAxis;
                    gO.ephysYlabel = ephysSaveData.YLabel;
                    gO.ephysDets = ephysSaveData.Dets;
                    if isfield(ephysSaveData, 'GlobalDets')
                        gO.ephysGlobalDets = ephysSaveData.GlobalDets;
                    end
                    if isfield(ephysSaveData, 'EventComplexes')
                        gO.ephysEventComplexes = ephysSaveData.EventComplexes;
                    else
                        gO.ephysEventComplexes = {};
                    end
                    if isempty(gO.ephysDets)
                        gO.parallelMode = 1;
                        parallelModeMenuSel(gO,0)
                    end
                    if isfield(ephysSaveData, 'DetBorders')
                        gO.ephysDetBorders = ephysSaveData.DetBorders;
                    else
                        gO.ephysDetBorders = cell(min(size(gO.ephysData)),1);
                    end
                    if isfield(ephysSaveData, 'DetParams')
                        gO.ephysDetParams = ephysSaveData.DetParams;
                    else
                        gO.ephysDetParams = cell(min(size(gO.ephysData)),1);
                    end
                    gO.ephysDetInfo = ephysSaveInfo;
                    if ~isempty(gO.ephysDetInfo)
                        if ~isempty(gO.ephysDetInfo.DetSettings) && isfield(gO.ephysDetInfo.DetSettings, 'RefCh')
                            gO.ephysRefCh = numSelCharConverter(gO.ephysDetInfo(1).DetSettings.RefCh);
                        end
                    end

                    gO.loaded(1) = 1;

                    gO.ephysDoGGed = DoG(gO.ephysData,gO.ephysFs,150,250);
                    gO.ephysInstPow = instPow(gO.ephysData,gO.ephysFs,150,250);
                    
                    dataPresent(1) = true;
                else
                    dataPresent(1) = false;
                end
            end
            
            gO.loaded(2) = 0;
            gO.imagingDetParamsTable.Data = {};
            gO.imagingDetParamsTable.ColumnName = {};

            waitbar(0.5,wb1,'Looking for imaging data...')
            
            if sum(ismember(fieldnames(testload),{'imagingSaveData';'imagingSaveInfo'})) == 2
                load(fnameFull,'imagingSaveData','imagingSaveInfo')
                
                if ~isempty(imagingSaveData)
                    
                    waitbar(0.6,wb1,'Loading imaging data...')
                    
                    gO.imagingData = imagingSaveData.RawData;
                    gO.imagingFs = imagingSaveData.Fs;
                    gO.imagingTaxis = imagingSaveData.TAxis;
                    gO.imagingYlabel = imagingSaveData.YLabel;
                    gO.imagingDets = imagingSaveData.Dets;
                    if isfield(imagingSaveData, 'GlobalDets')
                        gO.imagingGlobalDets = imagingSaveData.GlobalDets;
                    end
                    if isfield(imagingSaveData, 'EventComplexes')
                        gO.imagingEventComplexes = imagingSaveData.EventComplexes;
                    else
                        gO.imagingEventComplexes = {};
                    end
                    if isempty(gO.imagingDets)
                        gO.parallelMode = 2;
                        parallelModeMenuSel(gO,0)
                    end
                    
                    if isfield(imagingSaveData, 'DetBorders')
                        gO.imagingDetBorders = imagingSaveData.DetBorders;
                    else
                        gO.imagingDetBorders = cell(min(size(gO.imagingData)),1);
                    end
                    if isfield(imagingSaveData, 'DetParams')
                        gO.imagingDetParams = imagingSaveData.DetParams;
                    else
                        gO.imagingDetParams = cell(min(size(gO.imagingData)),1);
                    end
                    gO.imagingDetInfo = imagingSaveInfo;
                    
                    if strcmp(gO.imagingDetInfo.DetType,'Mean+SD')
                        if strcmp(gO.imagingDetInfo.DetSettings.WinType,'Gaussian')
                            gWinLen = gO.imagingDetInfo.DetSettings.WinLen;
                            gO.imagingSmoothed = smoothdata(gO.imagingData,...
                                2,'gaussian',gWinLen);
                        elseif strcmp(gO.imagingDetInfo.DetSettings.WinType,'3-point mean')
                            winLen = gO.imagingDetInfo.DetSettings.WinLen;
                            gO.imagingSmoothed = movmean(gO.imagingData,winLen);
                        end
                    else
                        gO.imagingSmoothed = smoothdata(gO.imagingData,...
                            2,'gaussian',10);
                    end
                    
                    gO.loaded(2) = 1;
                    
                    dataPresent(2) = true;
                else
                    dataPresent(2) = false;
                end
            end
            
            if (~dataPresent(1) || isempty(gO.ephysDets)) && (~dataPresent(2) || isempty(gO.imagingDets))
                gO.loaded(:) = 0;
                wD = warndlg('No detections, loading aborted!');
                pause(1)
                if ishandle(wD)
                    close(wD)
                end
                if ishandle(wb1)
                    close(wb1)
                end
                return
            end
            
            gO.loaded(3) = 0;
            
            waitbar(0.75,wb1,'Looking for running data...')
            
            if sum(ismember(fieldnames(testload),'runData'))==1
                load(fnameFull,'runData')
                
                if ~isempty(runData)
                    
                    waitbar(0.8,wb1,'Loading running data...')
                    
                    gO.runTaxis = runData.taxis;
                    gO.runAbsPos = runData.absPos;
                    gO.runRelPos = runData.relPos;
                    gO.runLap = runData.lapNum;
                    gO.runLicks = runData.licks;
                    gO.runVeloc = runData.veloc;
                    
                    gO.runActState = zeros(size(gO.runVeloc));
                    gO.runActState(gO.runVeloc >= gO.runActThr) = 1;
                    
                    gO.loaded(3) = 1;
                end
                
            end
            
            if sum(gO.loaded(1:2)) < 2
                if gO.loaded(1)
                    gO.keyboardPressDtyp = 1;
                elseif gO.loaded(2)
                    gO.keyboardPressDtyp = 2;
                end
            end
            
            
            
            gO.simultMode = 0;
            gO.loaded(4) = 0;
            gO.simultModeSwitch.Value = 0;
            
            waitbar(0.9,wb1,'Looking for simult data...')
            
            if sum(ismember(fieldnames(testload),{'simultSaveData';'simultSaveInfo'}))==2
                load(fnameFull,'simultSaveData','simultSaveInfo')
                
                if ~isempty(simultSaveData) & ~isempty(simultSaveInfo)
                    
                    waitbar(0.95,wb1,'Loading simult data...')
                    
                    gO.simultDets = simultSaveData;
                    gO.simultDetInfo = simultSaveInfo;
                    
                    gO.simultMode = 1;
                    gO.loaded(4) = 1;
                    gO.simultModeSwitch.Value = 1;
                end
            end
                        
            waitbar(0.99,wb1,'Finishing loading process...')
            
            %Preparing selection vectors for database saving
            gO.save2DbEphysCheckBox.Value = 0;
            gO.save2DbImagingCheckBox.Value = 0;
            gO.save2DbSimultCheckBox.Value = 0;
            gO.save2DbRunningChechBox.Value = 0;
            gO.save2DbSimultSelection = [0,0,0,0];
            
            gO.save2DbEphysSelection = cell(1,1);
            gO.save2DbEphysParallelRoiSelection = false(1,1);
            if gO.loaded(1)
                gO.save2DbEphysSelection = cell(length(gO.ephysDetBorders),1);
                if gO.loaded(2)
                    gO.save2DbEphysParallelRoiSelection = true(length(gO.imagingDetInfo.DetROI),1);
                end
                for i = 1:length(gO.ephysDetBorders)
                    gO.save2DbEphysSelection{i} = false(size(gO.ephysDetBorders{i},1),1);
                end
            end
            
            gO.save2DbImagingSelection = cell(1,1);
            gO.save2DbImagingParallelChanSelection = false(1,1);
            if gO.loaded(2)
                gO.save2DbImagingSelection = cell(length(gO.imagingDetBorders),1);
                if gO.loaded(1)
                    gO.save2DbImagingParallelChanSelection = true(length(gO.ephysDetInfo.AllChannel),1);
                end
                for i = 1:length(gO.imagingDetBorders)
                    gO.save2DbImagingSelection{i} = false(size(gO.imagingDetBorders{i},1),1);
                end
            end
            
            for i = 1:2
                if gO.loaded(i)
                    axButtPress(gO,i,0,0)
                end
            end
            
            gO.mainFig.Name = ['DAS Event Viewer - ',fname];
            
            buttonEnabler(gO)
            
            if ~isempty(find(gO.loaded, 1))
                if ~isempty(prevLoadedInd)
                    gO.fileListBox.String{prevLoadedInd} = prevFname;
                end

                gO.path2loadedSave = fnameFull;
                gO.fileListBox.String{val} = ['<HTML><FONT color="red"><b>', gO.fileListBox.String{val}, '</b></FONT></HTML>'];
                gO.tabgrp.SelectedTab = gO.tabgrp.Children(2);
                tabChanged(gO)

            end
            
            waitbar(1,wb1,'Done!')
            pause(0.5)
            if ishandle(wb1)
                close(wb1)
            end
            
        end
        
        %%
        function fileListKeyPressCB(gO,~,e)
            if strcmp(e.Key, 'return')
                loadSaveButtPress(gO)
            end
        end
        
        %%
        function fileListSel(gO,~,~)
            if gO.fileListBox.Max > 1
                return
            end
            
            val = gO.fileListBox.Value;
            if ~isempty(gO.selDirFiles)
                fname = gO.selDirFiles{val};
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
            gO.ephysDownSampIndicator.Value = 0;
            gO.ephysDetSettingsTable.Data = [];
            gO.ephysDetSettingsTable.ColumnName = '';
            if ~isempty(find(strcmp(fieldnames(testload),'ephysSaveInfo'),1))
                load(fnameFull,'ephysSaveInfo')
                if ~isempty(ephysSaveInfo)
                    gO.ephysDetTypeTxt.String = ephysSaveInfo.DetType;
                    gO.ephysChanTxt.String = sprintf('%d ',[ephysSaveInfo.DetChannel]);
                    if isfield(ephysSaveInfo, 'DownSamp')
                        gO.ephysDownSampIndicator.Value = ephysSaveInfo.DownSamp;
                    end
                    if ~isempty(ephysSaveInfo(1).DetSettings)
                        gO.ephysDetSettingsTable.Data = squeeze(struct2cell(ephysSaveInfo(1).DetSettings))';
                        gO.ephysDetSettingsTable.ColumnName = fieldnames(ephysSaveInfo(1).DetSettings);
                    end
                end
            end
            
            gO.imagingDetTypeTxt.String = '';
            gO.imagingRoiTxt.String = '';
            gO.imagingUpSampIndicator.Value = 0;
            gO.imagingDetSettingsTable.Data = [];
            gO.imagingDetSettingsTable.ColumnName = '';
            if ~isempty(find(strcmp(fieldnames(testload),'imagingSaveInfo'),1))
                load(fnameFull,'imagingSaveInfo')
                if ~isempty(imagingSaveInfo)
                    gO.imagingDetTypeTxt.String = imagingSaveInfo.DetType;
                    % account for earlier save files
                    try
                        gO.imagingRoiTxt.String = sprintf('%d ',[imagingSaveInfo.DetROI]);
                    catch
                        gO.imagingRoiTxt.String = sprintf('%d ',[imagingSaveInfo.Roi]);
                    end
                    if isfield(imagingSaveInfo, 'UpSamp')
                        gO.imagingUpSampIndicator.Value = imagingSaveInfo.UpSamp;
                    end
                    if ~isempty(imagingSaveInfo(1).DetSettings)
                        gO.imagingDetSettingsTable.Data = squeeze(struct2cell(imagingSaveInfo(1).DetSettings))';
                        gO.imagingDetSettingsTable.ColumnName = fieldnames(imagingSaveInfo(1).DetSettings);
                    end

                end
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
                end
            end
        end
        
        %%
        function axButtPress(gO,dTyp,detUpDwn,chanUpDwn)
            if (gO.parallelMode ~= dTyp)
                switch dTyp
                    case 1
                        if ~sum(~cellfun('isempty' ,gO.ephysDets))
                            smartplot(gO)
                            return
                        end
                        
                    case 2
                        if ~sum(~cellfun('isempty' ,gO.imagingDets))
                            smartplot(gO)
                            return
                        end
                        
                end
            end
            
            if (gO.parallelMode == dTyp) || gO.fixWin
                if nargin > 2
                    axButtPressAlter(gO,dTyp,chanUpDwn)
                else
                    axButtPressAlter(gO,dTyp,0)
                end
                return
            end
            
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
                if (chanUpDwn==0) && (detUpDwn==0)
                    currDet = 1;
                    currChan = 1;
                end

                if chanUpDwn ~= 0
                    currDet = 1;
                end
                
                [numDets,numChans] = extractDetStruct(gO,dTyp);

                switch chanUpDwn
                    case 0

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
                            gO.ephysFixWinDetRow = find(gO.ephysDetInfo.AllChannel == gO.ephysDetInfo.DetChannel(currChan));
                            
                            temp = find(~cellfun('isempty',gO.save2DbEphysSelection));
                            save2DbPanelKids = findobj(gO.save2DbPanel,'Type','UIControl');
                            if gO.ephysCurrDetRow <= length(temp)
                                temp = temp(gO.ephysCurrDetRow);
                                val = gO.save2DbEphysSelection{temp}(gO.ephysCurrDetNum);
                                gO.save2DbEphysCheckBox.Value = val;
                                gO.save2DbEphysCheckBox.Enable = 'on';
                                gO.save2DbEphysSelAllButton.Enable = 'on';
                                gO.save2DbEphysClrSelButton.Enable = 'on';
                                gO.save2DbButton.Enable = 'on';
                                if gO.loaded(3)
                                    gO.save2DbRunningChechBox.Enable = 'on';
                                end
                            else
                                set(save2DbPanelKids,'Enable','off')
                            end
                            
                        case 2
                            gO.imagingCurrDetNum = currDet;
                            gO.imagingCurrDetRow = currChan;
                            gO.imagingFixWinDetRow = currChan;
                            
                            temp = find(~cellfun('isempty',gO.save2DbImagingSelection));
                            save2DbPanelKids = findobj(gO.save2DbPanel,'Type','UIControl');
                            if gO.imagingCurrDetRow <= length(temp)
                                temp = temp(gO.imagingCurrDetRow);
                                val = gO.save2DbImagingSelection{temp}(gO.imagingCurrDetNum);
                                gO.save2DbImagingCheckBox.Value = val;
                                gO.save2DbImagingCheckBox.Enable = 'on';
                                gO.save2DbImagingClrSelButton.Enable = 'on';
                                gO.save2DbImagingSelAllButton.Enable = 'on';
                                gO.save2DbButton.Enable = 'on';
                                if gO.loaded(3)
                                    gO.save2DbRunningChechBox.Enable = 'on';
                                end
                            else
                                set(save2DbPanelKids,'Enable','off')
                            end
                            
                    end
                    
                case 1
                    switch dTyp
                        case 1
                            gO.simultEphysCurrDetNum = currDet;
                            gO.simultEphysCurrDetRow = currChan;
                            
                            if gO.simultFocusTyp==1
                                gO.simultImagingCurrDetNum = 1;
                                gO.simultImagingCurrDetRow = 1;
                            end
                        case 2
                            gO.simultImagingCurrDetNum = currDet;
                            gO.simultImagingCurrDetRow = currChan;
                            
                            if gO.simultFocusTyp==2
                                gO.simultEphysCurrDetNum = 1;
                                gO.simultEphysCurrDetRow = 1;
                            end
                            
                    end
                    [~,~,chanNum,~,~,ephysDetNum] = extractDetStruct(gO,1);
                    [~,~,roiNum,~,~,imagingDetNum] = extractDetStruct(gO,2);
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
        function axButtPressAlter(gO,dTyp,chanUpDwn)
            switch dTyp
                case 1
                    currDetRows = 1:length(gO.ephysDetInfo.AllChannel);
                    
                    if gO.parallelMode
                        altCurrDetRow = gO.ephysParallDetRow;
                    elseif gO.fixWin
                        altCurrDetRow = gO.ephysFixWinDetRow;
                    end
                case 2
                    currDetRows = 1:length(gO.imagingDetInfo.AllROI);
                    
                    if gO.parallelMode
                        altCurrDetRow = gO.imagingParallDetRow;
                    elseif gO.fixWin
                        altCurrDetRow = gO.imagingFixWinDetRow;
                    end
            end
            
            switch chanUpDwn
                case 0
                    
                case 1
                    if altCurrDetRow < length(currDetRows)
                        altCurrDetRow = altCurrDetRow + 1;
                    end
                case -1
                    if altCurrDetRow > 1
                        altCurrDetRow = altCurrDetRow -1;
                    end
            end
            
            switch dTyp
                case 1
                    if gO.parallelMode
                        gO.ephysParallDetRow = altCurrDetRow;
                    elseif gO.fixWin
                        gO.ephysFixWinDetRow = altCurrDetRow;
                    end
                case 2
                    if gO.parallelMode
                        gO.imagingParallDetRow = altCurrDetRow;
                    elseif gO.fixWin
                        gO.imagingFixWinDetRow = altCurrDetRow;
                    end
                    
            end

            smartplot(gO)
            
        end
        
        %%
        function delCurrEventButtonCB(gO,dTyp,delFullChan,currChan,detNum,inDelLoop)
            if nargin < 6
                inDelLoop = false;
            end
            
            switch gO.simultMode
                case 0
                    switch dTyp
                        case 1
                            if ~sum(~cellfun('isempty',gO.ephysDets))
                                return
                            end
                            
                            if nargin < 3
                                quest = 'Are you sure you want to delete the currently displayed ephys event?';
                                butt2 = 'Delete every detection on channel';
                            end
                            if nargin < 4
                                currChan = gO.ephysCurrDetRow;
                            end
                            currDet = gO.ephysCurrDetNum;
                        case 2
                            if ~sum(~cellfun('isempty',gO.imagingDets))
                                return
                            end
                            
                            if nargin < 3
                                quest = 'Are you sure you want to delete the currently displayed imaging event?';
                                butt2 = 'Delete every detection on ROI';
                            end
                            if nargin < 4
                                currChan = gO.imagingCurrDetRow;
                            end
                            currDet = gO.imagingCurrDetNum;
                    end
                    
                    if nargin < 3
                        answer = questdlg(quest,'Detection deletion confirmation','Yes',butt2,'Cancel','Yes');
                        switch answer
                            case butt2
                                delFullChan = true;
                            case {'','Cancel'}
                                return
                            otherwise
                                delFullChan = false;
                        end
                        [~,~,~,~,~,detNum,~,~,~] = extractDetStruct(gO,dTyp);
                    elseif isempty(delFullChan)
                        delFullChan = false;
                    end
                    
                    wb = waitbar(0, 'Starting deletion...');
                    switch dTyp
                        case 1 % ephys
                            
                            if delFullChan
                                gO.ephysDets(currChan) = [];
                                gO.ephysGlobalDets(:,currChan) = [];
                                gO.ephysEventComplexes(currChan) = [];
                                gO.ephysDetParams(currChan) = [];
                                gO.ephysDetBorders(currChan) = [];
                                gO.ephysDetInfo.DetChannel(currChan) = [];
                                gO.save2DbEphysSelection(currChan) = [];
                                
                                waitbar(0.33, wb, 'Running checks...')
                                
                                % check whether there are any detections on
                                % any channel
                                if ~sum(~cellfun('isempty',gO.ephysDets))
                                    gO.ephysDets = {};
                                    gO.ephysGlobalDets = [];
                                    gO.ephysEventComplexes = {};
                                    gO.ephysDetBorders = {};
                                    gO.ephysDetParams = {};
                                    gO.ephysDetInfo = [];
                                    gO.save2DbEphysSelection = cell(1,1);
                                    
%                                     smartplot(gO)
                                    axButtPress(gO,dTyp)
                                    waitbar(0.66, wb, 'Overwriting DASsave file...')
                                    overwriteDASsave(gO,gO.simultMode,dTyp)
                                    waitbar(1, wb, 'Done!')
                                    if ishandle(wb)
                                        close(wb)
                                    end
                                    return
                                end
                                
                                % make sure event display switches correctly
                                if currChan ~= 1
                                    currChan = currChan - 1;
                                end
                                currDet = 1;
                            else
                                gO.ephysDets{currChan}(detNum) = [];
                                
                                gO.ephysGlobalDets(gO.ephysGlobalDets(:,currChan) == detNum,currChan) = nan;
                                gO.ephysGlobalDets(gO.ephysGlobalDets(:,currChan) > detNum,currChan) = ...
                                    gO.ephysGlobalDets(gO.ephysGlobalDets(:,currChan) > detNum,currChan) - 1;
                                
                                gO.ephysDetParams{currChan}(detNum) = [];
                                gO.ephysDetBorders{currChan}(detNum,:) = [];
                                
                                gO.save2DbEphysSelection{currChan}(detNum) = [];
                                
                                maxSepInComplex = 0.1;
                                maxSepInComplex = round(maxSepInComplex * gO.ephysFs);
                                [evCompls, detParams] = extractEvComplexes(gO.ephysDetParams{currChan},...
                                    gO.ephysDetBorders{currChan}, maxSepInComplex);
                                gO.ephysEventComplexes{currChan} = evCompls;
                                gO.ephysDetParams{currChan} = detParams;
                                clear evCompls detParams

                                waitbar(0.33, wb, 'Running checks....')
                                
                                % if after deleting no detections are left on the given
                                % channel, delete that channel from the detection
                                % storage
                                detsLeft = length(gO.ephysDets{currChan});
                            
                                if detsLeft == 0
                                    % check whether there are any detections on
                                    % any channel
                                    if ~sum(~cellfun('isempty',gO.ephysDets))
                                        gO.ephysDets = {};
                                        gO.ephysGlobalDets = [];
                                        gO.ephysEventComplexes = {};
                                        gO.ephysDetBorders = {};
                                        gO.ephysDetParams = {};
                                        gO.ephysDetInfo = [];
                                        gO.save2DbEphysSelection = cell(1,1);
                                        
%                                         smartplot(gO)
                                        axButtPress(gO,dTyp)
                                        waitbar(0.66, wb, 'Overwriting DASsave file...')
                                        overwriteDASsave(gO,gO.simultMode,dTyp)
                                        waitbar(1, wb, 'Done!')
                                        if ishandle(wb)
                                            close(wb)
                                        end
                                        return
                                    end

                                    gO.ephysDets(currChan) = [];
                                    gO.ephysGlobalDets(:,currChan) = [];
                                    gO.ephysEventComplexes(currChan) = [];
                                    gO.ephysDetParams(currChan) = [];
                                    gO.ephysDetBorders(currChan) = [];
                                    gO.ephysDetInfo.DetChannel(currChan) = [];
                                    gO.save2DbEphysSelection(currChan) = [];

                                    % make sure event display switches correctly
                                    if currChan ~= 1
                                        currChan = currChan - 1;
                                    end
                                    currDet = 1;
                                else
                                    if currDet > length(gO.ephysDets{currChan})
                                        currDet = currDet - 1;
                                    end
                                end
                            end
                            
                            % controll globaldets container
                            gO.ephysGlobalDets(sum(~isnan(gO.ephysGlobalDets), 2) < 2,:) = [];
                            
                            gO.ephysCurrDetRow = currChan;
                            gO.ephysCurrDetNum = currDet;

                        case 2 % imaging
                            
                            if delFullChan
                                gO.imagingDets(currChan) = [];
                                gO.imagingGlobalDets(:,currChan) = [];
                                gO.imagingEventComplexes(currChan) = [];
                                gO.imagingDetParams(currChan) = [];
                                gO.imagingDetBorders(currChan) = [];
                                gO.imagingDetInfo.DetROI(currChan) = [];
                                gO.save2DbImagingSelection(currChan) = [];
                                
                                waitbar(0.33, wb, 'Running checks...')
                                
                                % check whether there are any detections on
                                % any channel
                                if ~sum(~cellfun('isempty',gO.imagingDets))
                                    gO.imagingDets = {};
                                    gO.imagingGlobalDets = [];
                                    gO.imagingEventComplexes = {};
                                    gO.imagingDetInfo = [];
                                    gO.imagingDetBorders = {};
                                    gO.imagingDetParams = {};
                                    gO.save2DbImagingSelection = cell(1,1);
                                    
%                                     smartplot(gO)
                                    axButtPress(gO,dTyp)
                                    waitbar(0.66, wb, 'Overwriting DASsave file...')
                                    overwriteDASsave(gO,gO.simultMode,dTyp)
                                    waitbar(1, wb, 'Done!')
                                    if ishandle(wb)
                                        close(wb)
                                    end
                                    return
                                end
                                
                                % make sure event display switches correctly
                                if currChan ~= 1
                                    currChan = currChan - 1;
                                end
                                currDet = 1;
                            else
                                gO.imagingDets{currChan}(detNum) = [];
                                
                                gO.imagingGlobalDets(gO.imagingGlobalDets(:,currChan) == detNum,currChan) = nan;
                                gO.imagingGlobalDets(gO.imagingGlobalDets(:,currChan) > detNum,currChan) = ...
                                    gO.imagingGlobalDets(gO.imagingGlobalDets(:,currChan) > detNum,currChan) - 1;
                                
                                gO.imagingDetParams{currChan}(detNum) = [];
                                gO.imagingDetBorders{currChan}(detNum,:) = [];
                                
                                gO.save2DbImagingSelection{currChan}(detNum) = [];
                                
                                maxSepInComplex = 0.1;
                                maxSepInComplex = round(maxSepInComplex * gO.imagingFs);
                                [evCompls, detParams] = extractEvComplexes(gO.imagingDetParams{currChan},...
                                    gO.imagingDetBorders{currChan}, maxSepInComplex);
                                gO.imagingEventComplexes{currChan} = evCompls;
                                gO.imagingDetParams{currChan} = detParams;
                                clear evCompls detParams

                                waitbar(0.33, wb, 'Running checks...')
                                
                                detsLeft = length(gO.imagingDets{currChan});
                                if detsLeft == 0
                                    % check whether there are any detections on
                                    % any channel
                                    if ~sum(~cellfun('isempty',gO.imagingDets))
                                        gO.imagingDets = {};
                                        gO.imagingGlobalDets = [];
                                        gO.imagingEventComplexes = {};
                                        gO.imagingDetInfo = [];
                                        gO.imagingDetBorders = {};
                                        gO.imagingDetParams = {};
                                        gO.save2DbImagingSelection = cell(1,1);
                                        
%                                         smartplot(gO)
                                        axButtPress(gO,dTyp)
                                        waitbar(0.66, wb, 'Overwriting DASsave file...')
                                        overwriteDASsave(gO,gO.simultMode,dTyp)
                                        waitbar(1, wb, 'Done!')
                                        if ishandle(wb)
                                            close(wb)
                                        end
                                        return
                                    end

                                    gO.imagingDets(currChan) = [];
                                    gO.imagingGlobalDets(:,currChan) = [];
                                    gO.imagingEventComplexes(currChan) = [];
                                    gO.imagingDetParams(currChan) = [];
                                    gO.imagingDetBorders(currChan) = [];
                                    gO.imagingDetInfo.DetROI(currChan) = [];
                                    gO.save2DbImagingSelection(currChan) = [];

                                    % make sure event display switches correctly
                                    if currChan ~= 1
                                        currChan = currChan - 1;
                                    end
                                    currDet = 1;
                                else
                                    if currDet > length(gO.imagingDets{currChan})
                                        currDet = currDet - 1;
                                    end
                                end
                            end
                            
                            % controll globaldets container
                            gO.imagingGlobalDets(sum(~isnan(gO.imagingGlobalDets), 2) < 2,:) = [];
                            
                            gO.imagingCurrDetRow = currChan;
                            gO.imagingCurrDetNum = currDet;
                    end
%                     smartplot(gO)
                    axButtPress(gO,dTyp)
                    
                case 1 % simult mode on
                    if isempty(gO.simultDets)
                        return
                    end
                    
                    switch dTyp
                        case 1
                            quest = 'Are you sure you want to delete the currently displayed ephys event from the simultaneous events?';
                        case 2
                            quest = 'Are you sure you want to delete the currently displayed imaging event from the simultaneous events?';
                    end
                    answer = questdlg(quest,'Detection deletion confirmation');
                    switch answer
                        case {'','No','Cancel'}
                            return
                    end
                    
                    [~,~,chanNum,chan,~,detNum,~,~,~] = extractDetStruct(gO,dTyp);
                    simDets = gO.simultDets;
                    simDetInfo = gO.simultDetInfo;
                    simDetsSel = gO.save2DbSimultSelection;
                    
                    switch dTyp
                        case 1
                            rows2nuke = (simDets(:,1) == chan) & (simDets(:,2) == detNum);
                            simDets(rows2nuke,:) = [];
                            
                            dbSelRows2nuke = (simDetsSel(:,1) == chanNum) & (simDetsSel(:,2) == detNum);
                            simDetsSel(dbSelRows2nuke,:) = [];
                            
                            if isempty(find(simDets(:,1) == chan, 1))
                                simDetInfo.EphysChannels(simDetInfo.EphysChannels == chan) = [];
                            end
                        case 2
                            rows2nuke = (simDets(:,3) == chan) & (simDets(:,4) == detNum);
                            simDets(rows2nuke,:) = [];
                            
                            dbSelRows2nuke = (simDetsSel(:,3) == chanNum) & (simDetsSel(:,4) == detNum);
                            simDetsSel(dbSelRows2nuke,:) = [];
                            
                            if isempty(find(simDets(:,3) == chan, 1))
                                simDetInfo.ROIs(simDetInfo.ROIs == chan) = [];
                            end
                    end
                    gO.simultDets = simDets;
                    gO.simultDetInfo = simDetInfo;
                    
                    gO.save2DbSimultSelection = simDetsSel;
                    
                    if isempty(simDets)
                        smartplot(gO)
                        return
                    end
                    
%                     smartplot(gO)
                    axButtPress(gO,dTyp)
            end
            if ~inDelLoop
                waitbar(0.66, wb, 'Overwriting DASsave file...')
                overwriteDASsave(gO,gO.simultMode,dTyp)
            end
            waitbar(1, wb, 'Done!')
            if ishandle(wb)
                close(wb)
            end
        end
        
        %%
        function delSelectedEventsButtonCB(gO)
            confDel = questdlg('Delete selected events?');
            if ~strcmp(confDel, 'Yes')
                return
            end
            
            if ~isempty(gO.ephysDetInfo)
                wb = waitbar(0,'Getting ephys selections...');
                ephysSel = cellfun(@(x) find(x), gO.save2DbEphysSelection, 'UniformOutput', false);
                chans = gO.ephysDetInfo.DetChannel;
                gO.ephysCurrDetNum = 1;
                gO.ephysCurrDetRow = 1;
                for ch = 1:length(ephysSel)
                    currRow = find(chans(ch) == gO.ephysDetInfo.DetChannel);
                    if isempty(currRow)
                        continue
                    elseif length(ephysSel{ch}) == length(gO.ephysDets{currRow})
                        delCurrEventButtonCB(gO, 1, true, currRow, false)
                    else
                        for ev = 1:length(ephysSel{ch})
                            if ev == length(ephysSel{ch})
                                inDelLoop = false;
                            else
                                inDelLoop = true;
                            end
                            waitbar((ev / length(ephysSel{ch})) * ch / length(ephysSel),wb,'Deleting selected ephys events...')
                            delCurrEventButtonCB(gO, 1, false, currRow, ephysSel{ch}(ev), inDelLoop)
                            numOfDeleted = ephysSel{ch}(ev);
                            ephysSel{ch}(ephysSel{ch} > numOfDeleted) = ephysSel{ch}(ephysSel{ch} > numOfDeleted) - 1;
                        end
                    end
                end
                if ishandle(wb)
                    close(wb)
                end
            end
            
            if ~isempty(gO.imagingDetInfo)
                wb = waitbar(0,'Getting imaging selections...');
                imagingSel = cellfun(@(x) find(x), gO.save2DbImagingSelection, 'UniformOutput', false);
                rois = gO.imagingDetInfo.DetROI;
                gO.imagingCurrDetNum = 1;
                gO.imagingCurrDetRow = 1;
                for roi = 1:length(imagingSel)
                    currRow = find(rois(roi) == gO.imagingDetInfo.DetROI);
                    if isempty(currRow)
                        continue
                    elseif length(imagingSel{roi}) == length(gO.imagingDets{currRow}) 
                        delCurrEventButtonCB(gO, 2, true, currRow, false)
                    else
                        for ev = 1:length(imagingSel{roi})
                            if ev == length(imagingSel{roi})
                                inDelLoop = false;
                            else
                                inDelLoop = true;
                            end
                            waitbar((ev / length(imagingSel{roi})) * roi / length(imagingSel),wb,'Deleting selected imaging events...')
                            delCurrEventButtonCB(gO, 2, false, currRow, imagingSel{roi}(ev), inDelLoop)
                            numOfDeleted = imagingSel{roi}(ev);
                            imagingSel{roi}(imagingSel{roi} > numOfDeleted) = imagingSel{roi}(imagingSel{roi} > numOfDeleted) - 1;
                        end
                    end
                end
                if ishandle(wb)
                    close(wb)
                end
            end
        end
        
        %%
        function fixWinSwitchPress(gO,~,~)
            gO.fixWin = gO.fixWinSwitch.Value;
            
            buttonEnabler(gO)
            
            if gO.fixWin
                gO.plotFull = 0;
                gO.parallelMode = 0;
                gO.parallelModeMenu.Text = 'Parallel mode --OFF--';
                gO.parallelModeMenu.ForegroundColor = 'r';
            end
            
            smartplot(gO)
            
        end
        
        %%
        function simultModeSwitchPress(gO,~,~)
            if gO.simultModeSwitch.Value
                gO.simultMode = 1;
                
                gO.fixWinSwitch.Value = 0;
                
                gO.parallelMode = 0;
                gO.parallelModeMenu.Text = 'Parallel mode --OFF--';
                gO.parallelModeMenu.ForegroundColor = 'r';
            elseif ~gO.simultModeSwitch.Value
                gO.simultMode = 0;
            end
            
            buttonEnabler(gO)
            
            axButtPress(gO,1)
            axButtPress(gO,2)
        end
        
        %%
        function keyboardPressFcn(gO,~,kD)
            
            if (length(kD.Modifier) == 1) && strcmp(kD.Modifier{1}, 'control') && strcmp(kD.Key, 't')
                currTabIdx = find(gO.tabgrp.Children == gO.tabgrp.SelectedTab);
                if currTabIdx < length(gO.tabgrp.Children)
                    gO.tabgrp.SelectedTab = gO.tabgrp.Children(currTabIdx + 1);
                else
                    gO.tabgrp.SelectedTab = gO.tabgrp.Children(1);
                end
                tabChanged(gO)
            end
            
            if gO.tabgrp.SelectedTab == gO.tabgrp.Children(2)
                detChanUpDwn = [0,0];
                switch kD.Key
                    case 'delete'
                        if (length(kD.Modifier) == 1) && strcmp(kD.Modifier{1}, 'shift')
                            delSelectedEventsButtonCB(gO)
                        else
                            delCurrEventButtonCB(gO,gO.keyboardPressDtyp)
                        end

                    case 'a'
                        if (length(kD.Modifier) == 1) && strcmp(kD.Modifier{1}, 'control')
                            gO.save2DbModifySelCB(gO.keyboardPressDtyp,'selAll')
                        end

                    case 'y'
                        eventYlimModeMenuCB(gO)
                        
                    case 't'
                        if isempty(kD.Modifier)
                            switch gO.keyboardPressDtyp
                                case 1
                                    ephysTypMenuSel(gO)
                                    
                                case 2
                                    imagingTypMenuSel(gO)
                                
                            end
                        end

                    case 'f'
                        if strcmp(gO.fixWinSwitch.Enable, 'on')
                            switch gO.fixWinSwitch.Value
                                case 0
                                    gO.fixWinSwitch.Value = 1;

                                case 1
                                    gO.fixWinSwitch.Value = 0;

                            end
                            fixWinSwitchPress(gO)
                        end

                    case 's'
                        if (length(kD.Modifier) == 1) && strcmp(kD.Modifier{1}, 'control')
                            save2DbButtonPress(gO,false)
                        elseif (length(kD.Modifier) == 1) && strcmp(kD.Modifier{1}, 'alt')
                            showEventSpectro(gO)
                        else
                            if strcmp(gO.simultModeSwitch.Enable, 'on')
                                switch gO.simultModeSwitch.Value
                                    case 0
                                        gO.simultModeSwitch.Value = 1;

                                    case 1
                                        gO.simultModeSwitch.Value = 0;

                                end
                                simultModeSwitchPress(gO)
                            end
                        end

                    case 'w'
                        if strcmp(gO.plotFullMenu.Enable, 'on')
                            if (length(kD.Modifier) == 1) && strcmp(kD.Modifier{1}, 'alt')
                                enableKbSlideMenuCB(gO)
                            else
                                plotFullMenuSel(gO)
                            end
                        end

                    case 'p'
                        if strcmp(gO.parallelModeMenu.Enable, 'on')
                            parallelModeMenuSel(gO,true)
                        end

                    case 'd'
                        if sum(gO.loaded) > 1
                            switch gO.keyboardPressDtyp
                                case 1
                                    gO.keyboardPressDtyp = 2;
                                case 2
                                    gO.keyboardPressDtyp = 1;
                            end
                        end

                    case 'rightarrow'
                        if gO.enableKbSlide
                            kbSliding(gO,'+')
                        else
                            detChanUpDwn = [1,0];
                        end

                    case 'leftarrow'
                        if gO.enableKbSlide
                            kbSliding(gO,'-');
                        else
                            detChanUpDwn = [-1,0];
                        end

                    case 'uparrow'
                        detChanUpDwn = [0,1];

                    case 'downarrow'
                        detChanUpDwn = [0,-1];

                    case 'e'            
                        if strcmp(gO.save2DbEphysCheckBox.Enable,'on')
                            switch gO.save2DbEphysCheckBox.Value
                                case 0
                                    gO.save2DbEphysCheckBox.Value = 1;
                                case 1
                                    gO.save2DbEphysCheckBox.Value = 0;
                            end
                            save2DbCheckBoxPress(gO,1)
                        end

                    case 'i'
                        if strcmp(gO.save2DbImagingCheckBox.Enable,'on')
                            switch gO.save2DbImagingCheckBox.Value
                                case 0
                                    gO.save2DbImagingCheckBox.Value = 1;
                                case 1
                                    gO.save2DbImagingCheckBox.Value = 0;
                            end
                            save2DbCheckBoxPress(gO,2)
                        end

                end

                if sum(detChanUpDwn) ~= 0
                    axButtPress(gO,gO.keyboardPressDtyp,detChanUpDwn(1),detChanUpDwn(2))
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
                    
                    [~,~,chanNum,~,~,ephysDetNum] = extractDetStruct(gO,1);
                    [~,~,roiNum,~,~,imagingDetNum] = extractDetStruct(gO,2);
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
        function save2DbParallelChanSelect(gO,parallel_dTyp)
            switch parallel_dTyp % type of the parallel data being saved
                case 1
                    chansLogic = gO.save2DbImagingParallelChanSelection;
                    allChans = gO.ephysDetInfo.AllChannel;
                    chanList = cell(length(allChans),1);
                    for i = 1:length(chanList)
                        chanList{i} = ['Channel #',num2str(allChans(i))];
                    end

                    [selRow,tf] = listdlg('ListString',chanList,'PromptString','Select which channel(s) to save parallel!',...
                        'InitialValue',find(chansLogic));
                    if ~tf
                        return
                    end
                    
                    chansLogic(:) = false;
                    chansLogic(selRow) = true;
                    gO.save2DbImagingParallelChanSelection = chansLogic;
                    
                case 2
                    chansLogic = gO.save2DbEphysParallelRoiSelection;
                    allChans = gO.imagingDetInfo.AllROI;
                    chanList = cell(length(allChans),1);
                    for i = 1:length(chanList)
                        chanList{i} = ['ROI #',num2str(allChans(i))];
                    end

                    [selRow,tf] = listdlg('ListString',chanList,'PromptString','Select which ROI(s) to save parallel!',...
                        'InitialValue',find(chansLogic));
                    if ~tf
                        return
                    end
                    
                    chansLogic(:) = false;
                    chansLogic(selRow) = true;
                    gO.save2DbEphysParallelRoiSelection = chansLogic;
                    
            end
            
        end
        
        %%
        function save2DbModifySelCB(gO,dTyp,operation)
            switch dTyp
                case 1 % ephys
                    selections = gO.save2DbEphysSelection;
                case 2 % imaging
                    selections = gO.save2DbImagingSelection;
                case 4 % simult
                    selections = gO.save2DbSimultSelection;
            end
            
            switch operation
                case 'clrAll'
                    if dTyp ~= 4
                        for i = 1:length(selections)
                            selections{i} = false(size(selections{i}));
                        end
                    else
                        selections = [0,0,0,0];
                    end
                    
                case 'selAll'
                    if dTyp ~= 4
                        for i = 1:length(selections)
                            selections{i} = true(size(selections{i}));
                        end
                    else
                        simDets = gO.simultDets;
                        selections = [0,0,0,0];
                        for i = 1:size(simDets,1)
                            chanNum = find(gO.ephysDetInfo.AllChannel == simDets(i,1));
                            ephysDetNum = simDets(i,2);
                            
                            roiNum = find(gO.imagingDetInfo.AllROI == simDets(i,3));
                            imagingDetNum = simDets(i,4);
                            
                            temp = [chanNum,ephysDetNum,roiNum,imagingDetNum];
                            selections = [selections; temp];
                        end
                    end
                    
                case {'selAllChan', 'selAllROI'}
                    if dTyp ~= 4
                        temp = find(~cellfun('isempty',selections));
                        switch dTyp
                            case 1
                                temp = temp(gO.ephysCurrDetRow);
                                
                            case 2
                                temp = temp(gO.imagingCurrDetRow);
                                
                        end
                        selections{temp}(:) = true;
                    end
                    
            end
            
            switch dTyp
                case 1 % ephys
                    gO.save2DbEphysSelection = selections;
                    axButtPress(gO,1)
                case 2 % imaging
                    gO.save2DbImagingSelection = selections;
                    axButtPress(gO,2)
                case 4 % simult
                    gO.save2DbSimultSelection = selections;
                    axButtPress(gO,1)
                    axButtPress(gO,2)
            end
        end
        
        %%
        function save2DbButtonPress(gO,save2Excel)
            
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
            
            if save2Excel
                eParams = [];
                iParams = [];
            else
                newSaveStruct = [];
            end
            
            if selected(1)
                for i = 1:length(gO.save2DbEphysSelection)
                    if isempty(find(gO.save2DbEphysSelection{i},1))
                        continue
                    end
                    
                    for j = 1:length(gO.save2DbEphysSelection{i})
                        if ~gO.save2DbEphysSelection{i}(j)
                            continue
                        end
                        
                        if save2Excel
                            temp = gO.ephysDetParams{i}(j);
                            temp.Channel = gO.ephysDetInfo.DetChannel(i);
                            eParams = [eParams; temp];
                        else
                            [win,relBorders] = windowMacher(gO,1,i,j,0.25);

                            tempStruct.source = string(gO.path2loadedSave);
                            tempStruct.simult = 0;
                            tempStruct.parallel = 0;

                            e_iAdj = find(gO.ephysDetInfo.AllChannel == gO.ephysDetInfo.DetChannel(i));

                            tempStruct.ephysEvents.Taxis = gO.ephysTaxis(win);
                            tempStruct.ephysEvents.DataWin.Raw = gO.ephysData(e_iAdj,win);
                            tempStruct.ephysEvents.DataWin.BP = gO.ephysDoGGed(e_iAdj,win);
                            tempStruct.ephysEvents.DataWin.Power = gO.ephysInstPow(e_iAdj,win);
                            tempStruct.ephysEvents.DetBorders = relBorders;
                            tempStruct.ephysEvents.Params = gO.ephysDetParams{i}(j);
                            tempStruct.ephysEvents.DetSettings = gO.ephysDetInfo.DetSettings;
                            tempStruct.ephysEvents.ChanNum = gO.ephysDetInfo.DetChannel(i);
                            tempStruct.ephysEvents.DetNum = j;

                            if gO.save2DbEphys_wPar_CheckBox.Value
                                tempStruct.parallel = 2;

                                refWin = gO.ephysTaxis(win);
                                [~,startInd] = min(abs(gO.imagingTaxis - refWin(1)));
                                [~,stopInd] = min(abs(gO.imagingTaxis - refWin(end)));
                                parWin = startInd:stopInd;
                                rois2save = gO.save2DbEphysParallelRoiSelection;

                                tempStruct.imagingEvents.Taxis = gO.imagingTaxis(parWin);
                                tempStruct.imagingEvents.DataWin.Raw = gO.imagingData(rois2save,parWin);
                                tempStruct.imagingEvents.DataWin.Smoothed = gO.imagingSmoothed(rois2save,parWin);
                                tempStruct.imagingEvents.DetBorders = [];
                                tempStruct.imagingEvents.Params = [];
                                tempStruct.imagingEvents.DetSettings = [];
                                tempStruct.imagingEvents.ROINum = gO.imagingDetInfo.DetROI(rois2save);
                                tempStruct.imagingEvents.DetNum = [];
                            end

                            if gO.save2DbRunningChechBox.Value
                                refWin = gO.ephysTaxis(win);
                                runWin = runWindowMacher(gO,[refWin(1),refWin(end)]);

                                if ~isempty(runWin)
                                    tempStruct.runData.Taxis = gO.runTaxis(runWin);
                                    tempStruct.runData.DataWin.Velocity = gO.runVeloc(runWin);
                                    tempStruct.runData.DataWin.AbsPos = gO.runAbsPos(runWin);
                                    tempStruct.runData.DataWin.RelPos = gO.runRelPos(runWin);
                                    tempStruct.runData.Lap = gO.runLap(runWin);
                                    tempStruct.runData.Licks = gO.runLicks(runWin);
                                    tempStruct.runData.ActState = gO.runActState(runWin);
                                else
                                    tempStruct.runData = [];
                                end
                            end

                            newSaveStruct = [newSaveStruct; tempStruct];
                        end
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
                        
                        if save2Excel
                            temp = gO.imagingDetParams{i}(j);
                            temp.ROI = gO.imagingDetInfo.DetROI(i);
                            iParams = [iParams; temp];
                        else
                            [win,relBorders] = windowMacher(gO,2,i,j,0.25);

                            tempStruct.source = string(gO.path2loadedSave);
                            tempStruct.simult = 0;
                            tempStruct.parallel = 0;

                            i_iAdj = find(gO.imagingDetInfo.AllROI == gO.imagingDetInfo.DetROI(i));

                            tempStruct.imagingEvents.Taxis = gO.imagingTaxis(win);
                            tempStruct.imagingEvents.DataWin.Raw = gO.imagingData(i_iAdj,win);
                            tempStruct.imagingEvents.DataWin.Smoothed = gO.imagingSmoothed(i_iAdj,win);
                            tempStruct.imagingEvents.DetBorders = relBorders;
                            tempStruct.imagingEvents.Params = gO.imagingDetParams{i}(j);
                            tempStruct.imagingEvents.DetSettings = gO.imagingDetInfo.DetSettings;
                            tempStruct.imagingEvents.ROINum = gO.imagingDetInfo.DetROI(i);
                            tempStruct.imagingEvents.DetNum = j;

                            if gO.save2DbImaging_wPar_CheckBox.Value
                                tempStruct.parallel = 1;

                                refWin = gO.imagingTaxis(win);
                                [~,startInd] = min(abs(gO.ephysTaxis - refWin(1)));
                                [~,stopInd] = min(abs(gO.ephysTaxis - refWin(end)));
                                parWin = startInd:stopInd;
                                chans2save = gO.save2DbImagingParallelChanSelection;

                                tempStruct.ephysEvents.Taxis = gO.ephysTaxis(parWin);
                                tempStruct.ephysEvents.DataWin.Raw = gO.ephysData(chans2save,parWin);
                                tempStruct.ephysEvents.DataWin.BP = gO.ephysDoGGed(chans2save,parWin);
                                tempStruct.ephysEvents.DataWin.Power = gO.ephysInstPow(chans2save,parWin);
                                tempStruct.ephysEvents.DetBorders = [];
                                tempStruct.ephysEvents.Params = [];
                                tempStruct.ephysEvents.DetSettings = [];
                                tempStruct.ephysEvents.ChanNum = gO.ephysDetInfo.AllChannel(chans2save);
                                tempStruct.ephysEvents.DetNum = [];
                            end

                            if gO.save2DbRunningChechBox.Value
                                refWin = gO.imagingTaxis(win);
                                runWin = runWindowMacher(gO,[refWin(1),refWin(end)]);
                                if ~isempty(runWin)
                                    tempStruct.runData.Taxis = gO.runTaxis(runWin);
                                    tempStruct.runData.DataWin.Velocity = gO.runVeloc(runWin);
                                    tempStruct.runData.DataWin.AbsPos = gO.runAbsPos(runWin);
                                    tempStruct.runData.DataWin.RelPos = gO.runRelPos(runWin);
                                    tempStruct.runData.Lap = gO.runLap(runWin);
                                    tempStruct.runData.Licks = gO.runLicks(runWin);
                                    tempStruct.runData.ActState = gO.runActState(runWin);
                                else
                                    tempStruct.runData = [];
                                end
                            end

                            newSaveStruct = [newSaveStruct; tempStruct];
                        end
                    end
                end
%             
            end
            
            if selected(3)
                for i = 2:size(gO.save2DbSimultSelection,1)
                    currRow = gO.save2DbSimultSelection(i,:);
                    e_iAdj = find(gO.ephysDetInfo.DetChannel == gO.ephysDetInfo.AllChannel(currRow(1)));
                    [ephysWin,ephysRelBorders] = windowMacher(gO,1,e_iAdj,currRow(2),0.25);
                    i_iAdj = find(gO.imagingDetInfo.DetROI == gO.imagingDetInfo.AllROI(currRow(3)));
                    [imagingWin,imagingRelBorders] = windowMacher(gO,2,i_iAdj,currRow(4),0.25);
                    
                    if save2Excel
                        temp = gO.ephysDetParams{e_iAdj}(currRow(2));
                        temp.Channel = gO.ephysDetInfo.AllChannel(currRow(1));
                        eParams = [eParams; temp];
                        
                        temp = gO.imagingDetParams{i_iAdj}(currRow(4));
                        temp.ROI = gO.imagingDetInfo.AllROI(currRow(3));
                        iParams = [iParams; temp];
                    else
                        eTaxis = gO.ephysTaxis;
                        iTaxis = gO.imagingTaxis;

                        if eTaxis(ephysWin(1)) > iTaxis(imagingWin(1))
                            ephysWin = find(eTaxis > iTaxis(imagingWin(1)), 1):ephysWin(end);
                        elseif eTaxis(ephysWin(1)) < iTaxis(imagingWin(1))
                            imagingWin = find(iTaxis > eTaxis(ephysWin(1)), 1):imagingWin(end);
                        end

                        if eTaxis(ephysWin(end)) < iTaxis(imagingWin(end))
                            ephysWin = ephysWin(1):find(eTaxis > iTaxis(imagingWin(end)), 1);
                        elseif eTaxis(ephysWin(end)) > iTaxis(imagingWin(end))
                            ephysWin = imagingWin(1):find(iTaxis > eTaxis(ephysWin(end)), 1);
                        end

                        tempStruct.source = string(gO.path2loadedSave);
                        tempStruct.simult = 1;
                        tempStruct.parallel = 0;

                        tempStruct.ephysEvents.Taxis = gO.ephysTaxis(ephysWin);
                        tempStruct.ephysEvents.DataWin.Raw = gO.ephysData(currRow(1),ephysWin);
                        tempStruct.ephysEvents.DataWin.BP = gO.ephysDoGGed(currRow(1),ephysWin);
                        tempStruct.ephysEvents.DataWin.Power = gO.ephysInstPow(currRow(1),ephysWin);
                        tempStruct.ephysEvents.DetBorders = ephysRelBorders;
                        tempStruct.ephysEvents.Params = gO.ephysDetParams{e_iAdj}(currRow(2));
                        tempStruct.ephysEvents.DetSettings = gO.ephysDetInfo.DetSettings;
                        tempStruct.ephysEvents.ChanNum = gO.ephysDetInfo.DetChannel(e_iAdj);
                        tempStruct.ephysEvents.DetNum = currRow(2);

                        tempStruct.imagingEvents.Taxis = gO.imagingTaxis(imagingWin);
                        tempStruct.imagingEvents.DataWin.Raw = gO.imagingData(currRow(3),imagingWin);
                        tempStruct.imagingEvents.DataWin.Smoothed = gO.imagingSmoothed(currRow(3),imagingWin);
                        tempStruct.imagingEvents.DetBorders = imagingRelBorders;
                        tempStruct.imagingEvents.Params = gO.imagingDetParams{i_iAdj}(currRow(4));
                        tempStruct.imagingEvents.DetSettings = gO.imagingDetInfo.DetSettings;
                        tempStruct.imagingEvents.ROINum = gO.imagingDetInfo.DetROI(i_iAdj);
                        tempStruct.imagingEvents.DetNum = currRow(4);

                        if gO.save2DbRunningChechBox.Value
                            refWin = gO.ephysTaxis(ephysWin);
                            runWin = runWindowMacher(gO,[refWin(1),refWin(end)]);
                            if ~isempty(runWin)
                                tempStruct.runData.Taxis = gO.runTaxis(runWin);
                                tempStruct.runData.DataWin.Velocity = gO.runVeloc(runWin);
                                tempStruct.runData.DataWin.AbsPos = gO.runAbsPos(runWin);
                                tempStruct.runData.DataWin.RelPos = gO.runRelPos(runWin);
                                tempStruct.runData.Lap = gO.runLap(runWin);
                                tempStruct.runData.Licks = gO.runLicks(runWin);
                                tempStruct.runData.ActState = gO.runActState(runWin);
                            else
                                tempStruct.runData = [];
                            end
                        end

                        newSaveStruct = [newSaveStruct; tempStruct];
                    end
                end
            end
            
            if save2Excel
                forInfoTab = cell(1,2);
                forInfoTab(1,:) = {'DASsave filename', gO.path2loadedSave};

                extInName = strfind(gO.path2loadedSave, '.mat');
                if ~isempty(extInName)
                    name4excel = gO.path2loadedSave(1:extInName-1);
                else
                    name4excel = gO.path2loadedSave;
                end
                DAS2Excel(forInfoTab,eParams,iParams,[name4excel,'_summary'])
            else
                if isempty(newSaveStruct)
                    errordlg('No events selected!')
                    return
                end

                DASloc = mfilename('fullpath');
                if ~exist([DASloc(1:end-5),'DASeventDBdir\'],'dir')
                    mkdir([DASloc(1:end-5),'DASeventDBdir\'])
                end
                dbFiles = dir([DASloc(1:end-5),'DASeventDBdir\','DASeventDB*.mat']);

                dbFiles = {dbFiles.name};
                dbFiles = ['Start a new database entry', dbFiles];

                [ind,tf] = listdlg('ListString',dbFiles,...
                    'PromptString','Select DB to save in','SelectionMode','single',...
                    'ListSize',[230,300]);
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
                    saveFname = [DASloc(1:end-5),'DASeventDBdir\',dbFiles{ind}];
                    load(saveFname,'saveStruct')

                    % Checking whether the user chose a fitting db entry
                    if saveStruct(1).simult
                        if ~selected(3)
                            errordlg(['The entry you chose contains simult events!',...
                                ' Choose another, or create a new one!'])
                            return
                        end
                    elseif ~saveStruct(1).simult
                        if selected(1) && isempty(find(ismember(fieldnames(saveStruct),'ephysEvents'),1))
                            errordlg(['The entry you chose contains only ',...
                                'imaging events! Choose another, ',...
                                'or create a new one!'])
                            return
                        end
                        if selected(2) && isempty(find(ismember(fieldnames(saveStruct),'imagingEvents'),1))
                            errordlg(['The entry you chose contains only ',...
                                'electrophysiological events! Choose another, or create a new one!'])
                            return
                        end
                    end

                    % control parallel saving
                    if saveStruct(1).parallel ~= 0
                        if ((saveStruct(1).parallel == 1) && gO.save2DbImaging_wPar_CheckBox.Value) ||...
                                ((saveStruct(1).parallel == 2) && gO.save2DbEphys_wPar_CheckBox.Value)
                            errordlg(['The entry you chose contains different type of parallel events',...
                                ' Choose another, or create a new one!'])
                            return
                        end
                    end
                end

                if ~isempty(newSaveStruct)
                    try
                        saveStruct = [saveStruct; newSaveStruct];
                    catch
                        saveStruct = [saveStruct, newSaveStruct'];
                    end

                    try
                        quest = sprintf('Save selected events to "%s"?', saveFname);
                        confSave = questdlg(quest);
                        if strcmp(confSave, 'Yes')
                            save(saveFname,'saveStruct')
                        
                            operationDoneMsg('Saving complete!')
                        else
                            return
                        end
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
        
        %%
        function testCB(gO,~,~)
            disp('gco after windowButtonDown')
            gco
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
            gO.plotFullMenu = uimenu(gO.optMenu,...
                'Text','Plot full data / Plot individual detections',...
                'MenuSelectedFcn',@ gO.plotFullMenuSel,...
                'Tag', '_plotfullSwitch');
            gO.enableKbSlideMenu = uimenu(gO.optMenu,...
                'Text', 'Keyboard sliding - OFF',...
                'MenuSelectedFcn', @(h,e) gO.enableKbSlideMenuCB,...
                'Tag', '_plotfull');
            gO.setKbSlideStepSizeMenu = uimenu(gO.optMenu,...
                'Text', sprintf('Set keyboard sliding step size| %.2f [s]',gO.kbSlidingStepSize),...
                'MenuSelectedFcn', @(h,e) gO.setKbSlideStepSizeMenuCB,...
                'Tag', '_plotfull');
            gO.parallelModeMenu = uimenu(gO.optMenu,...
                'Text','Parallel mode --OFF--',...
                'MenuSelectedFcn',@(h,e) gO.parallelModeMenuSel(1),...
                'ForegroundColor','r',...
                'Tag', '_parallelSwitch');
            gO.winLenMenu = uimenu(gO.optMenu,...
                'Text', 'Change window length',...
                'MenuSelectedFcn', @ gO.changeWinSize);
            gO.eventYlimModeMenu = uimenu(gO.optMenu,...
                'Text', sprintf('Event plotting Y limit, current mode: %s',gO.eventYlimMode),...
                'MenuSelectedFcn', @(h,e) gO.eventYlimModeMenuCB);
            gO.eventYlimSetCustomMenu = uimenu(gO.optMenu,...
                'Text', 'Set custom Y axis limits',...
                'MenuSelectedFcn', @(h,e) gO.eventYlimSetCustomMenuCB);
            
            gO.ephysOptMenu = uimenu(gO.mainFig,...
                'Text','Electrophysiology options');
            gO.ephysTypMenu = uimenu(gO.ephysOptMenu,...
                'Text','Ephys data type selection',...
                'MenuSelectedFcn',@ gO.ephysTypMenuSel);
            gO.highPassRawEphysMenu = uimenu(gO.ephysOptMenu,...
                'Text','Apply high pass filter to displayed raw ephys data',...
                'Checked','off',...
                'MenuSelectedFcn',@ gO.highPassRawEphysMenuSel,...
                'Tag', '_ephys_simult_parallel_fixwin_plotfull');
            gO.showEventSpectroMenu = uimenu(gO.ephysOptMenu,...
                'Text','Show event spectrogram',...
                'MenuSelectedFcn',@ gO.showEventSpectro,...
                'Tag', '_ephysDets_simult');
            gO.editSpectroFreqLimsMenu = uimenu(gO.ephysOptMenu,...
                'Text', 'Edit spectrogram frequency limits',...
                'MenuSelectedFcn', @(h,e) gO.editSpectroFreqLimsMenuCB);
            gO.makeFoilDistrPlotMenu = uimenu(gO.ephysOptMenu,...
                'Text', 'Create foil electrode topography plot',...
                'MenuSelectedFcn', @ gO.makeFoilDistrPlotCB,...
                'Tag', '_ephysDets_simult');
            
            gO.imagingOptMenu = uimenu(gO.mainFig,...
                'Text','Imaging options');
            gO.imagingTypMenu = uimenu(gO.imagingOptMenu,...
                'Text','Imaging data type selection',...
                'MenuSelectedFcn',@ gO.imagingTypMenuSel);
            
            gO.runOptMenu = uimenu(gO.mainFig,...
                'Text','Running options');
            gO.runTypMenu = uimenu(gO.runOptMenu,...
                'Text','Running data type selection',...
                'MenuSelectedFcn',@ gO.runTypMenuSel);
            gO.showLicksMenu = uimenu(gO.runOptMenu,...
                'Text','Show licks on graphs --OFF--',...
                'ForegroundColor','r',...
                'MenuSelectedFcn',@ gO.showLicksMenuSel);
            
            gO.simultOptMenu = uimenu(gO.mainFig,...
                'Text','Simultan mode options');
            gO.simultFocusMenu = uimenu(gO.simultOptMenu,...
                'Text','Simultan mode focus --Ephys--',...
                'MenuSelectedFcn',@ gO.simultFocusMenuSel,...
                'Tag', '_simult');
            
            gO.dbMenu = uimenu(gO.mainFig,...
                'Text','Database menu');
            gO.openDASevDBMenu = uimenu(gO.dbMenu,...
                'Text','Open DASevDB',...
                'MenuSelectedFcn','DASevDB');
            
            gO.helpMenu = uimenu(gO.mainFig,...
                'Text', 'Help');
            gO.showKeyShortcutsMenu = uimenu(gO.helpMenu,...
                'Text', 'Keyboard bindings',...
                'MenuSelectedFcn', @(h,e) gO.showKeyShortcutsMenuCB);
            
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
            gO.currDirPanel = uipanel(gO.loadTab,...
                'Position', [0.01, 0.9, 0.1, 0.1],...
                'BorderType', 'beveledout',...
                'Title', 'Current directory');
            gO.currDirTxt = uicontrol(gO.currDirPanel,...
                'Style', 'text',...
                'Units', 'normalized',...
                'Position', [0, 0, 1, 1],...
                'String', cd);
            gO.selDirButt = uicontrol(gO.loadTab,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.01, 0.85, 0.1, 0.05],...
                'String','Change directory',...
                'Callback',@(h,e) gO.selDirButtPress(0));%,...
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
                
            gO.DASsaveAnalyserCheckRHDCheckBox = uicontrol(gO.loadTab,...
                'Style', 'checkbox',...
                'Units', 'normalized',...
                'Position', [0.01, 0.4, 0.1, 0.05],...
                'String', 'Scan RHD files',...
                'Callback', @ gO.DASsaveAnalyserCheckRHDCheckBoxCB);
            gO.DASsaveAnalyserBestChSelModePopMenu = uicontrol(gO.loadTab,...
                'Style', 'popupmenu',...
                'Units', 'normalized',...
                'Position', [0.01, 0.35, 0.08, 0.05],...
                'String', {'--Best channel selection mode--', 'Most events', 'Highest average amplitude', 'Most event complexes', 'Manual selection'},...
                'Callback', @ gO.DASsaveAnalyserBestChSelModePopMenuCB);
            gO.DASsaveAnalyserBestChInputEdit = uicontrol(gO.loadTab,...
                'Style', 'edit',...
                'Units', 'normalized',...
                'Position', [0.095, 0.375, 0.015, 0.025],...
                'Enable', 'off');
            gO.DASsaveAnalyserButton = uicontrol(gO.loadTab,...
                'Style', 'pushbutton',...
                'Units', 'normalized',...
                'Position', [0.01, 0.3, 0.1, 0.05],...
                'String', 'Launch save file analysis',...
                'Callback', @ gO.DASsaveAnalyserButtonCB);
            
            gO.saveFileAnalysisSourceButtonGroup = uibuttongroup(gO.loadTab,...
                'Position', [0.01, 0.2, 0.1, 0.1],...
                'Title', 'Choose source',...
                'SelectionChangedFcn', @ gO.saveFileAnalysisSourceCB);
            gO.saveFileAnalysisSourceDirRadioButton = uicontrol(gO.saveFileAnalysisSourceButtonGroup,...
                'Style', 'radiobutton',...
                'Units', 'normalized',...
                'Position', [0.01, 0.55, 0.98, 0.45],...
                'String', 'Whole directory');
            gO.saveFileAnalysisSourceFileRadioButton = uicontrol(gO.saveFileAnalysisSourceButtonGroup,...
                'Style', 'radiobutton',...
                'Units', 'normalized',...
                'Position', [0.01, 0, 0.98, 0.45],...
                'String', 'Select files');
            
            gO.globalEventAnalyserButton = uicontrol(gO.loadTab,...
                'Style', 'pushbutton',...
                'Units', 'normalized',...
                'Position', [0.01, 0.15, 0.1, 0.05],...
                'String', 'Launch global event analysis',...
                'Callback', @ gO.globalEventAnalyserButtonCB);
            
            
            gO.fileListContMenu = uicontextmenu(gO.mainFig);
            gO.selDir           = cd;
            initFileList        = dir('*DASsave*.mat');
            initFileList(strcmp({initFileList.name},'DAS_LOG.mat')) = [];
            initFileList        = {initFileList.name};
            gO.selDirFiles      = initFileList;
            gO.fileListBox = uicontrol(gO.loadTab,...
                'Style','listbox',...
                'Units','normalized',...
                'Position',[0.12,0.1,0.3,0.9],...
                'String',initFileList,...
                'Max', 1,...
                'Callback',@ gO.fileListSel,...
                'UIContextMenu',gO.fileListContMenu,...
                'KeyPressFcn', @ gO.fileListKeyPressCB);%,...
                %'BackgroundColor',[62,105,225]/255,...
                %'ForegroundColor',[1,1,1]);
            gO.fileListContMenuUpdate = uimenu(gO.fileListContMenu,'Text','Update list',...
                'Callback',@(h,e) gO.selDirButtPress(1));
            
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
            gO.ephysDownSampIndicator = uicontrol(gO.fileInfoPanel,...
                'Style', 'checkbox',...
                'Units', 'normalized',...
                'Position', [0.025, 0.425, 0.4, 0.05],...
                'String', 'Downsampled',...
                'Enable', 'inactive');
            gO.ephysDetSettingsTable = uitable(gO.fileInfoPanel,...
                'Units','normalized',...
                'Position',[0.025, 0.3, 0.45, 0.1],...
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
            gO.imagingUpSampIndicator = uicontrol(gO.fileInfoPanel,...
                'Style', 'checkbox',...
                'Units', 'normalized',...
                'Position', [0.525, 0.425, 0.4, 0.05],...
                'String', 'Upsampled',...
                'Enable', 'inactive');
            gO.imagingDetSettingsTable = uitable(gO.fileInfoPanel,...
                'Units','normalized',...
                'Position',[0.525, 0.3, 0.45, 0.1],...
                'RowName','',...
                'FontSize',13,...
                'ColumnWidth',{75});
            
            gO.simultIndicator = uicontrol(gO.fileInfoPanel,...
                'Style','checkbox',...
                'Units','normalized',...
                'Position',[0.05, 0.15, 0.15, 0.05],...
                'String','with simultan',...
                'Enable','inactive');
            gO.simultSettingTable = uitable(gO.fileInfoPanel,...
                'Units','normalized',...
                'Position',[0.3, 0.02, 0.4, 0.1],...
                'RowName','',...
                'FontSize',13,...
                'ColumnWidth',{75});
            
            gO.runIndicator = uicontrol(gO.fileInfoPanel,...
                'Style','checkbox',...
                'Units','normalized',...
                'Position',[0.05, 0.05, 0.15, 0.05],...
                'String','with run data',...
                'Enable','inactive');
            
            kids = findobj(gO.fileInfoPanel,'Type','uicontrol','-or',...
                'Type','uitable');
            set(kids,'FontSize',12.5)
            %set(kids,'BackgroundColor',[252,194,0]/255)

                       
            
            %% viewerTab members
            gO.statPanel = uipanel(gO.viewerTab,...
                'Position',[0, 0.3, 0.3, 0.7],...
                'Title','Event parameters',...
                'BorderType','beveledout');
                %'BackgroundColor',[65,105,225]/255,...
                %'ForegroundColor',[1,1,1]);
                
            gO.ephysDetParamsTable = uitable(gO.statPanel,...
                'Units','normalized',...
                'Position',[0.01, 0.55, 0.98, 0.44],...
                'ColumnWidth',{200,150},...
                'CellSelectionCallback',@(h,e) paramTableHints(e));
            gO.imagingDetParamsTable = uitable(gO.statPanel,...
                'Units','normalized',...
                'Position',[0.01, 0.01, 0.98, 0.44],...
                'ColumnWidth',{200,150},...
                'CellSelectionCallback',@(h,e) paramTableHints(e));
            
            gO.save2DbPanel = uipanel(gO.viewerTab,...
                'Position',[0, 0, 0.3, 0.275],...
                'Title','Saving to database',...
                'BorderType','beveledout');
            gO.save2DbEphysCheckBox = uicontrol(gO.save2DbPanel,...
                'Style','checkbox',...
                'Units','normalized',...
                'Position',[0.01, 0.89, 0.35, 0.1],...
                'String','Select current ephys event',...
                'Callback',@(h,e) gO.save2DbCheckBoxPress(1),...
                'Tag', '_ephysDets');
            gO.save2DbEphys_wPar_CheckBox = uicontrol(gO.save2DbPanel,...
                'Style','checkbox',...
                'Units','normalized',...
                'Position',[0.4, 0.89, 0.35, 0.15],...
                'String','w/Parallel imaging',...
                'Tag', '_ephysDets_imaging');
            gO.save2DbEphys_wPar_RoiSelect = uicontrol(gO.save2DbPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.76, 0.89, 0.23, 0.1],...
                'String','Parallel ROIs',...
                'Callback',@(h,e) gO.save2DbParallelChanSelect(2),...
                'Tag', '_ephysDets_imaging');
            gO.save2DbEphysClrSelButton = uicontrol(gO.save2DbPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.01, 0.78, 0.3, 0.1],...
                'String','Clear all selected events',...
                'Callback',@(h,e) gO.save2DbModifySelCB(1,'clrAll'),...
                'Tag', '_ephysDets');
            gO.save2DbEphysSelAllButton = uicontrol(gO.save2DbPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.33, 0.78, 0.3, 0.1],...
                'String','Select all events',...
                'Callback',@(h,e) gO.save2DbModifySelCB(1,'selAll'),...
                'Tag', '_ephysDets');
            gO.save2DbEphysSelAllCurrChButton = uicontrol(gO.save2DbPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.66, 0.78, 0.3, 0.1],...
                'String','Select all events on channel',...
                'Callback',@(h,e) gO.save2DbModifySelCB(1,'selAllChan'),...
                'Tag', '_ephysDets');
            gO.save2DbImagingCheckBox = uicontrol(gO.save2DbPanel,...
                'Style','checkbox',...
                'Units','normalized',...
                'Position',[0.01, 0.65, 0.35, 0.1],...
                'String','Select current imaging event',...
                'Callback',@(h,e) gO.save2DbCheckBoxPress(2),...
                'Tag', '_imagingDets');
            gO.save2DbImaging_wPar_CheckBox = uicontrol(gO.save2DbPanel,...
                'Style','checkbox',...
                'Units','normalized',...
                'Position',[0.4, 0.65, 0.35, 0.1],...
                'String','w/Parallel ephys',...
                'Tag', '_imagingDets_ephys');
            gO.save2DbImaging_wPar_ChanSelect = uicontrol(gO.save2DbPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.76, 0.65, 0.23, 0.1],...
                'String','Parallel Chans',...
                'Callback',@(h,e) gO.save2DbParallelChanSelect(1),...
                'Tag', '_imagingDets_ephys');
            gO.save2DbImagingClrSelButton = uicontrol(gO.save2DbPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.01, 0.54, 0.3, 0.1],...
                'String','Clear all selected events',...
                'Callback',@(h,e) gO.save2DbModifySelCB(2,'clrAll'),...
                'Tag', '_imagingDets');
            gO.save2DbImagingSelAllButton = uicontrol(gO.save2DbPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.33, 0.54, 0.3, 0.1],...
                'String','Select all events',...
                'Callback',@(h,e) gO.save2DbModifySelCB(2,'selAll'),...
                'Tag', '_imagingDets');
            gO.save2DbImagingSelAllCurrRoiButton = uicontrol(gO.save2DbPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.66, 0.54, 0.3, 0.1],...
                'String','Select all events on ROI',...
                'Callback',@(h,e) gO.save2DbModifySelCB(2,'selAllROI'),...
                'Tag', '_imagingDets');
            gO.save2DbSimultCheckBox = uicontrol(gO.save2DbPanel,...
                'Style','checkbox',...
                'Units','normalized',...
                'Position',[0.01, 0.4, 0.4, 0.1],...
                'String','Select current simult. event pair',...
                'Callback',@(h,e) gO.save2DbCheckBoxPress(3),...
                'Tag', '_simult');
            gO.save2DbSimultClrSelButton = uicontrol(gO.save2DbPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.01, 0.29, 0.3, 0.1],...
                'String','Clear all selected events',...
                'Callback',@(h,e) gO.save2DbModifySelCB(4,'clrAll'),...
                'Tag', '_simult');
            gO.save2DbSimultSelAllButton = uicontrol(gO.save2DbPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.33, 0.29, 0.3, 0.1],...
                'String','Select all events',...
                'Callback',@(h,e) gO.save2DbModifySelCB(4,'selAll'),...
                'Tag', '_simult');
            gO.save2DbRunningChechBox = uicontrol(gO.save2DbPanel,...
                'Style','checkbox',...
                'Units','normalized',...
                'Position',[0.5, 0.4, 0.4, 0.1],...
                'String','Save running data',...
                'Callback',@(h,e) gO.save2DbCheckBoxPress(4),...
                'Tag', '_running_simult');
            gO.save2DbButton = uicontrol(gO.save2DbPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.6, 0.01, 0.35, 0.15],...
                'String','Save current selection to DB',...
                'Callback',@(h,e) gO.save2DbButtonPress(false));
            gO.save2ExcelButton = uicontrol(gO.save2DbPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.22, 0.01, 0.35, 0.15],...
                'String','Save current selection to Excel',...
                'Callback',@(h,e) gO.save2DbButtonPress(true));
            gO.delSelectedEventsButton = uicontrol(gO.save2DbPanel,...
                'Style', 'pushbutton',...
                'Units', 'normalized',...
                'Position', [0.01, 0.01, 0.2, 0.15],...
                'String', 'Del selected',...
                'Callback', @(h,e) gO.delSelectedEventsButtonCB);
            
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
                'Callback',@ gO.fixWinSwitchPress,...
                'Tag', '_fixwinSwitch');
            gO.simultModeSwitch = uicontrol(gO.plotPanel,...
                'Style','checkbox',...
                'Units','normalized',...
                'Position',[0.95, 0.915, 0.05, 0.05],...
                'String','Simult',...
                'Callback',@ gO.simultModeSwitchPress,...
                'Tag', '_simultSwitch');
            gO.ephysDetUpButt = uicontrol(gO.plotPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.965, 0.85, 0.035, 0.05],...
                'String','<HTML>Det&rarr',...
                'Callback',@(h,e) gO.axButtPress(1,1,0),...
                'Tag', '_ephysDets_simult_parallelImaging');
            gO.ephysDetDwnButt = uicontrol(gO.plotPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.965, 0.8, 0.035, 0.05],...
                'String','<HTML>Det&larr',...
                'Callback',@(h,e) gO.axButtPress(1,-1,0),...
                'Tag', '_ephysDets_simult_parallelImaging');
            gO.ephysChanUpButt = uicontrol(gO.plotPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.965, 0.75, 0.035, 0.05],...
                'String','<HTML>Chan&uarr',...
                'Callback',@(h,e) gO.axButtPress(1,0,1),...
                'Tag', '_ephys_simult_parallel_fixwin_plotfull');
            gO.ephysChanDwnButt = uicontrol(gO.plotPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.965, 0.7, 0.035, 0.05],...
                'String','<HTML>Chan&darr',...
                'Callback',@(h,e) gO.axButtPress(1,0,-1),...
                'Tag', '_ephys_simult_parallel_fixwin_plotfull');
            gO.ephysDelCurrEvButt = uicontrol(gO.plotPanel,...
                'Style', 'pushbutton',...
                'Units', 'normalized',...
                'Position', [0.965, 0.65, 0.035, 0.05],...
                'String', 'Del',...
                'Callback', @(h,e) gO.delCurrEventButtonCB(1),...
                'Tag', '_ephysDets_simult_parallelImaging');
            
            gO.imagingDetUpButt = uicontrol(gO.plotPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.965, 0.5, 0.035, 0.05],...
                'String','<HTML>Det&rarr',...
                'Callback',@(h,e) gO.axButtPress(2,1,0),...
                'Tag', '_imagingDets_simult_parallelEphys');
            gO.imagingDetDwnButt = uicontrol(gO.plotPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.965, 0.45, 0.035, 0.05],...
                'String','<HTML>Det&larr',...
                'Callback',@(h,e) gO.axButtPress(2,-1,0),...
                'Tag', '_imagingDets_simult_parallelEphys');
            gO.imagingRoiUpButt = uicontrol(gO.plotPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.965, 0.4, 0.035, 0.05],...
                'String','<HTML>ROI&uarr',...
                'Callback',@(h,e) gO.axButtPress(2,0,1),...
                'Tag', '_imaging_simult_parallel_fixwin_plotfull');
            gO.imagingRoiDwnButt = uicontrol(gO.plotPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.965, 0.35, 0.035, 0.05],...
                'String','<HTML>ROI&darr',...
                'Callback',@(h,e) gO.axButtPress(2,0,-1),...
                'Tag', '_imaging_simult_parallel_fixwin_plotfull');
            gO.imagingDelCurrEvButt = uicontrol(gO.plotPanel,...
                'Style', 'pushbutton',...
                'Units', 'normalized',...
                'Position', [0.965, 0.3, 0.035, 0.05],...
                'String', 'Del',...
                'Callback', @(h,e) gO.delCurrEventButtonCB(2),...
                'Tag', '_imagingDets_simult_parallelEphys');
            
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
            gO.ax31 = axes(gO.plotPanel,'Position',[0.1, 0.71, 0.8, 0.25],...
                'Visible','off');
            gO.ax31.Toolbar.Visible = 'on';
            gO.ax32 = axes(gO.plotPanel,'Position',[0.1, 0.38, 0.8, 0.25],...
                'Visible','off');
            gO.ax32.Toolbar.Visible = 'on';
            gO.ax33 = axes(gO.plotPanel,'Position',[0.1, 0.05, 0.8, 0.25],...
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
            gO.ax51 = axes(gO.plotPanel,'Position',[0.25, 0.825, 0.6, 0.135],...
                'Visible','off');
            gO.ax51.Toolbar.Visible = 'on';
            gO.ax52 = axes(gO.plotPanel,'Position',[0.25, 0.625, 0.6, 0.135],...
                'Visible','off');
            gO.ax52.Toolbar.Visible = 'on';
            gO.ax53 = axes(gO.plotPanel,'Position',[0.25, 0.425, 0.6, 0.135],...
                'Visible','off');
            gO.ax53.Toolbar.Visible = 'on';
            gO.ax54 = axes(gO.plotPanel,'Position',[0.25, 0.225, 0.6, 0.135],...
                'Visible','off');
            gO.ax54.Toolbar.Visible = 'on';
            gO.ax55 = axes(gO.plotPanel,'Position',[0.25, 0.05, 0.6, 0.1],...
                'Visible','off');
            gO.ax55.Toolbar.Visible = 'on';
%             align([gO.ax51,gO.ax52,gO.ax53,gO.ax54,gO.ax55],'Distribute','Distribute')
%             linkaxes([gO.ax51,gO.ax52,gO.ax53,gO.ax54,gO.ax55],'x')

            %% Database tab elements
            
        end
    end
end