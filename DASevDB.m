classdef DASevDB < handle
    %% Initializing components
    properties (Access = private)
        mainFig
        
        %% menus
        optionsMenu
        showAvgParamsMenu
        displayAvgDataWinMenu
        
        ephysOptMenu
        ephysTypeChangeMenu
        ephysShowEventSpectroMenu
        
        imagingOptMenu
        imagingTypeChangeMenu
        
        runOptMenu
        runTypeChangeMenu
        showLicksMenu
        
        changeDbMenu
        deleteEventMenu
        
        exportMenu
        exportCurrLoadedParamsMenu
        
        %% tabs
        tabgroup
        eventTab
        statTab
        
        %% eventtab
        %% loadPanel
        loadEntryPanel
        entryListBox
        LBcontMenu
        LBcontMenuUpdate
        LBcontMenuDelete
        loadEntryButton
        
        %% infoPanel
        infoPanel
        sourceFileLabel
        sourceFileTxt
        sourceChanDetTable
        
        %% paramPanel
        paramPanel
        ephysParamTable
        imagingParamTable
        runParamTable
        
        %% plotPanel
        plotPanel
        eventUpButton
        eventDwnButton
        parallelChanUpButton
        parallelChanDwnButton
        showAvgParallelChanButton
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
        
        %% stattab
        %% dataPanel
        dataPanel
        statSelectPopMenu
        db4StatListBox
        statLaunchButton
        
        tTestSetupPanel
        tTestCritPText
        tTestCritPEdit
        tTestMu0EphysTable
        tTestMu0ImagingTable
%         tTestMu0Text
%         tTestMu0Edit
        tTestResultPanel
        tTestEphysResultTable
        tTestImagingResultTable
%         tTestResultPText1
%         tTestResultPText2
%         tTestResultCIText1
%         tTestResultCIText2
%         tTestResultH0Text
%         tTestResultHAText
        tTestResultSummText
                
        basicStatParamPanel
        basicStatParamTableBig
        basicStatParamTable1
        basicStatParamTable2
        %% graphPanel 
        graphPanel
        statGraphDataListbox
        statGraphTypePopMenu
        statGraphParamSelPopMenu
        statGraphPlotButton
        axStatTab
            
            
    end
    
    %% Initializing data stored in GUI
    properties (Access = private)
        loaded = [0, 0, 0];
        dbFileNames
        currEvent = 1;
        currParallelChan = 1;
        numEvents = 0;
        source
        simultFromSaveStruct
        parallelFromSaveStruct
        loadedEntryFname
        displayAvgDataWin = 0;
        
        ephysTypeSelected = [1, 0, 0]; %1==Raw; 2==Bandpass(DoG); 3==Power(InstPow)
        ephysEvents
        avgEphysEvents
        ephysParamUnits = [{'RawAmplitudePeakT'}, {'[s]'};...
            {'RawAmplitudeP2P'  }, {['[',char(956),'V',']']};...
            {'BpAmplitudePeakT' }, {'[s]'};...
            {'BpAmplitudeP2P'   }, {['[',char(956),'V',']']};...
            {'Length'           }, {'[s]'};...
            {'Frequency'        }, {'[Hz]'};...
            {'NumCycles'        }, {'[#Cycles]'};...
            {'AUC'              }, {['[',char(956),'V*s]']};...
            {'RiseTime'         }, {'[s]'};...
            {'RiseTime2080'     }, {'[s]'};...
            {'DecayTime'        }, {'[s]'};...
            {'DecayTime8020'    }, {'[s]'};...
            {'DecayTau'         }, {'[a.u.]'};...
            {'FWHM'             }, {'[s]'};...
            {'NumSimultEvents'  }, {'[# Events]'}];
        
        imagingTypeSelected = [1,0]; %1==Raw; 2==Smoothed
        imagingEvents
        avgImagingEvents
        imagingParamUnits = [{'RawAmplitudePeakT'}, {'[s]'};...
            {'RawAmplitudeP2P'  }, {['[',char(916),'F/F]']};...
            {'Length'           }, {'[s]'};...
            {'AUC'              },{['[',char(916),'F/F * s]']};...
            {'RiseTime'         }, {'[s]'};...
            {'RiseTime2080'     }, {'[s]'};...
            {'DecayTime'        }, {'[s]'};...
            {'DecayTime8020'    }, {'[s]'};...
            {'DecayTau'         }, {'[a.u.]'};...
            {'FWHM'             }, {'[s]'};...
            {'NumSimultEvents'  }, {'[# Events]'}];
        
        runTypeSelected = [1,0,0,0]; % 1==Velocity; 2==AbsPos; 3==RelPos; 4==ActivityStates
        showLicks = 0;
        runData
    end
    
    %% Constructor part
    methods (Access = public)
        %% Constructor function
        function gO = DASevDB
            createComponents(gO)
%             
            if nargout == 0
                clear gO
            end
        end
    end
    
    %% Helper functions
    methods (Access = private)
        %%
        function getDBlist(gO,writeToGUI)
            DASloc = mfilename('fullpath');
            if ~exist([DASloc(1:end-7),'DASeventDBdir\'],'dir')
                DBentryList = {'No DB entries! First create them in DASeV!'};
                gO.entryListBox.Value = 1;
                gO.loadEntryButton.Enable = 'off';
            else
                DBentryList = dir([DASloc(1:end-7),'DASeventDBdir\','DASeventDB*.mat']);
                if isempty(DBentryList)
                    DBentryList = {'No DB entries! First create them in DASeV!'};
                    gO.entryListBox.Value = 1;
                    gO.loadEntryButton.Enable = 'off';
                else
                    DBentryList = {DBentryList.name};
                    gO.dbFileNames = DBentryList;
                    gO.entryListBox.Value = 1;
                    gO.loadEntryButton.Enable = 'on';
                end
            end
            
            if writeToGUI == 1
                gO.entryListBox.String = DBentryList;
            elseif writeToGUI == 2
                gO.db4StatListBox.String = DBentryList;
                gO.statGraphDataListbox.String = DBentryList;
            end
        end
        
        %%
        function axVisSwitch(gO,numAx)
            zum = zoom(gO.mainFig);
            panobj = pan(gO.mainFig);

            switch numAx
                case 1
                    actAxes = findobj(gO.plotPanel,'Tag','axGroup1');
                    inactAxes = findobj(gO.plotPanel,'-not','Tag','axGroup1',...
                        '-and','Type','axes');
                case 2
                    actAxes = findobj(gO.plotPanel,'Tag','axGroup2');
                    inactAxes = findobj(gO.plotPanel,'-not','Tag','axGroup2',...
                        '-and','Type','axes');
                case 3
                    actAxes = findobj(gO.plotPanel,'Tag','axGroup3');
                    inactAxes = findobj(gO.plotPanel,'-not','Tag','axGroup3',...
                        '-and','Type','axes');
                case 4
                    actAxes = findobj(gO.plotPanel,'Tag','axGroup4');
                    inactAxes = findobj(gO.plotPanel,'-not','Tag','axGroup4',...
                        '-and','Type','axes');
                case 5
                    actAxes = findobj(gO.plotPanel,'Tag','axGroup5');
                    inactAxes = findobj(gO.plotPanel,'-not','Tag','axGroup5',...
                        '-and','Type','axes');
            end
            
            for i = 1:length(inactAxes)
                cla(inactAxes(i))
            end
            
            set(inactAxes,'Visible','off')
            set(actAxes,'Visible','on')
            
            setAllowAxesZoom(zum,actAxes,true)
            setAllowAxesZoom(zum,inactAxes,false)
            setAllowAxesPan(panobj,actAxes,true)
            setAllowAxesPan(panobj,inactAxes,false)
        end
        
        %% 
        function smartplot(gO,doAxVisSwitch)
            if doAxVisSwitch
                axVisSwitch(gO,sum(gO.loaded)+(sum(gO.ephysTypeSelected)-1))
            end
            
%             outtxt = textwrap(gO.sourceFileTxt,{gO.source(gO.currEvent,:)})
            gO.sourceFileTxt.String = gO.source(gO.currEvent,:);
            gO.sourceFileTxt.Tooltip = gO.source(gO.currEvent,:);
            
            switch sum(gO.loaded)
                case 1
                    if gO.loaded(1)
                        switch sum(gO.ephysTypeSelected)
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
                        switch sum(gO.ephysTypeSelected)
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
                        switch sum(gO.ephysTypeSelected)
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
        function ephysPlot(gO,ax,forSpectro)
            if nargin < 3
                forSpectro = false;
            end
            
            type = gO.ephysTypeSelected;
            currEv = gO.ephysEvents(gO.currEvent);
            
            axTag = cell(length(ax),1);
            for i = 1:length(ax)
                axTag{i} = ax.Tag;
            end
            
            if gO.parallelFromSaveStruct(gO.currEvent) == 1
                row2show = gO.currParallelChan;
            else
                row2show = 1;
            end
            
            if forSpectro
                try
                    w1 = currEv.DetSettings.W1;
                    w2 = currEv.DetSettings.W2;
                catch
                    w1 = 150;
                    w2 = 250;
                    warning('Cutoff set to default 150-250 Hz')
                end
                fs = round(1 / (currEv.Taxis(2) - currEv.Taxis(1)));
                
                if gO.ephysTypeSelected(2)
                    data4spectro = currEv.DataWin.BP;
                elseif gO.ephysTypeSelected(1)
                    data4spectro = currEv.DataWin.Raw;
                elseif gO.ephysTypeSelected(3)
                    data4spectro = currEv.DataWin.Power;
                end
                
%                 spectrogramMacher(currEv.DataWin.Raw(row2show,:),fs,w1,w2)
                spectrogramMacher(data4spectro(row2show,:),fs,w1,w2)
%                 spectrogramMacher(data4spectro(row2show,currEv.DetBorders(1):currEv.DetBorders(2)),fs,w1,w2)
                return
            end
            
            dataWin = [];
            yLabels = [];
            plotTitle = [];
            if type(1)
                if ~gO.displayAvgDataWin
                    dataWin = [dataWin; currEv.DataWin.Raw(row2show,:)];
                    plotTitle = [plotTitle; "Raw data"];
                else
                    dataWin = [dataWin; gO.avgEphysEvents.Raw];
                    plotTitle = [plotTitle; "Average of Raw data"];
                end
                yLabels = [yLabels; "Voltage [\muV]"];
            end
            if type(2)
                if ~gO.displayAvgDataWin
                    dataWin = [dataWin; currEv.DataWin.BP(row2show,:)];
                    plotTitle = [plotTitle; "Bandpass filtered data"];
                else
                    dataWin = [dataWin; gO.avgEphysEvents.BP];
                    plotTitle = [plotTitle; "Average of Bandpass filtered data"];
                end
                yLabels = [yLabels; "Voltage [\muV]"];
            end
            if type(3)
                if ~gO.displayAvgDataWin
                    dataWin = [dataWin; currEv.DataWin.Power(row2show,:)];
                    plotTitle = [plotTitle; "Instantaneous power of data"];
                else
                    dataWin = [dataWin; gO.avgEphysEvents.Power];
                    plotTitle = [plotTitle; "Average of Instantaneous power"];
                end
                yLabels = [yLabels; "Power [\muV^2]"];
            end
            
            if ~gO.displayAvgDataWin
                taxisWin = currEv.Taxis;
            else
                taxisWin = gO.avgEphysEvents.Taxis;
            end
            
            for i = 1:length(ax)
                plot(ax(i),taxisWin,dataWin(i,:))
                
                hold(ax(i),'on')
%                 xline(ax(i),tDetInds(j),'Color','g','LineWidth',1);
                if ~isempty(currEv.DetBorders) & ~gO.displayAvgDataWin
                    xline(ax(i),taxisWin(currEv.DetBorders(1)),'--b','LineWidth',1);
                    xline(ax(i),taxisWin(currEv.DetBorders(2)),'--b','LineWidth',1);
                    hL = dataWin(i,:);
                    temp1 = find(taxisWin==taxisWin(currEv.DetBorders(1)));
                    temp2 = find(taxisWin==taxisWin(currEv.DetBorders(2)));
                    hL(1:temp1-1) = nan;
                    hL(temp2+1:end) = nan;
                    plot(ax(i),taxisWin,hL,'-r','LineWidth',0.75)
                end
                hold(ax(i),'off')
                
                ylabel(ax(i),yLabels(i))
                if gO.parallelFromSaveStruct(gO.currEvent) == 1
                    title(ax(i),strcat(plotTitle(i)," - parallel"))
                else
                    title(ax(i),plotTitle(i))
                end
                xlabel(ax(i),'Time [s]')
                axis(ax(i),'tight')
                ax(i).Tag = axTag{i};
            end
            
            if ~isempty(currEv.Params)
                temp = [fieldnames([currEv.Params]),squeeze(struct2cell([currEv.Params]))];
                gO.ephysParamTable.Data = temp;
                gO.ephysParamTable.ColumnName = {'Electrophysiology','Values'};
            end
            
            if gO.parallelFromSaveStruct(gO.currEvent) == 1
                gO.sourceChanDetTable.Data(1,:) = {currEv.ChanNum(row2show),[]};
            else
                gO.sourceChanDetTable.Data(1,:) = {currEv.ChanNum,currEv.DetNum};
            end
        end
        
        %%
        function imagingPlot(gO,ax)
            type = gO.imagingTypeSelected;
            currEv = gO.imagingEvents(gO.currEvent);
            axTag = ax.Tag;
            
            if gO.parallelFromSaveStruct(gO.currEvent) == 2
                row2show = gO.currParallelChan;
            else
                row2show = 1;
            end
            
            if type(1)
                if ~gO.displayAvgDataWin
                    dataWin = currEv.DataWin.Raw(row2show,:);
                    yLabels = '\DeltaF/F';
                    plotTitle = 'Raw imaging data';
                else
                    dataWin = gO.avgImagingEvents.Raw;
                    yLabels = '\DeltaF/F';
                    plotTitle = 'Average of Raw imaging data';
                end
            end
            if type(2)
                if ~gO.displayAvgDataWin
                    dataWin = currEv.DataWin.Smoothed(row2show,:);
                    yLabels = '\DeltaF/F';
                    plotTitle = 'Smoothed imaging data';
                else
                    dataWin = gO.avgImagingEvents.Smoothed;
                    yLabels = '\DeltaF/F';
                    plotTitle = 'Average of Smoothed imaging data';
                end
            end
            
            if ~gO.displayAvgDataWin
                taxisWin = currEv.Taxis;
            else
                taxisWin = gO.avgImagingEvents.Taxis;
            end
            
            plot(ax,taxisWin,dataWin)
            
            hold(ax,'on')
%             xline(ax,tDetInds(j),'Color','g','LineWidth',1);
            if ~isempty(currEv.DetBorders) & ~gO.displayAvgDataWin
                xline(ax,taxisWin(currEv.DetBorders(1)),'--b','LineWidth',1);
                xline(ax,taxisWin(currEv.DetBorders(2)),'--b','LineWidth',1);
                hL = dataWin;
                temp1 = find(taxisWin==taxisWin(currEv.DetBorders(1)));
                temp2 = find(taxisWin==taxisWin(currEv.DetBorders(2)));
                hL(1:temp1-1) = nan;
                hL(temp2+1:end) = nan;
                plot(ax,taxisWin,hL,'-r','LineWidth',0.75)
            end
            hold(ax,'off')
            
            ylabel(ax,yLabels)
            if gO.parallelFromSaveStruct(gO.currEvent) == 2
                title(ax,strcat(plotTitle," - parallel"))
            else
                title(ax,plotTitle)
            end
            xlabel(ax,'Time [s]')
            axis(ax,'tight')
            ax.Tag = axTag;
            
            if ~isempty(currEv.Params)
                temp = [fieldnames([currEv.Params]),squeeze(struct2cell([currEv.Params]))];
                gO.imagingParamTable.Data = temp;
                gO.imagingParamTable.ColumnName = {'Imaging','Values'};
            end
            
            if gO.parallelFromSaveStruct(gO.currEvent) == 2
                gO.sourceChanDetTable.Data(2,:) = {currEv.ROINum(row2show),[]};
            else
                gO.sourceChanDetTable.Data(2,:) = {currEv.ROINum,currEv.DetNum};
            end
        end
        
        %%
        function runPlot(gO,ax)
            type = gO.runTypeSelected;
            currEv = gO.runData(gO.currEvent);
            currEv = currEv.runData;
            if isempty(currEv)
                cla(ax,'reset')
                return
            end
            axTag = ax.Tag;
            
            if type(1)
                dataWin = currEv.DataWin.Velocity;
                yLabels = 'Velocity [cm/s]';
                plotTitle = 'Velocity on treadmill';
            elseif type(2)
                dataWin = currEv.DataWin.AbsPos;
                yLabels = 'Absolute position [cm]';
                plotTitle = 'Absolute position on treadmill';
            elseif type(3)
                dataWin = currEv.DataWin.RelPos;
                yLabels = 'Relative position [%]';
                plotTitle = 'Relative position on treadmill';
            elseif type(4)
                dataWin = currEv.ActState;
                yLabels = '';
                plotTitle = 'Activity state on treadmill';
            end
            
            plot(ax,currEv.Taxis,dataWin)
            if gO.showLicks
                lickInds = find(currEv.Licks);
                for i = 1:length(lickInds) 
                    xline(ax,currEv.Taxis(lickInds(i)),'g','LineWidth',1);
                end
            end
            xlabel(ax,'Time [s]')
            ylabel(ax,yLabels)
            title(ax,plotTitle)
            axis(ax,'tight')
            if type(4)
                ylim(ax,[-0.1,1.1])
                yticks(ax,[0,1])
                yticklabels(ax,{'Still','Moving'})
            end
            ax.Tag = axTag;
        end
        
        %%
        function changeCurrEv(gO,upDwn) 
            numEvs = gO.numEvents;
            currEv = gO.currEvent;
            switch upDwn
                case 0
                    % no change
                case 1
                    if currEv < numEvs
                        currEv = currEv + 1;
                    end
                case -1
                    if currEv > 1
                        currEv = currEv - 1;
                    end
            end
            gO.currEvent = currEv;
            gO.currParallelChan = 1;
            smartplot(gO,0)
        end
        
        %%
        function changeCurrParallelChan(gO,upDwn)
            currEvNum = gO.currEvent;
            currParCh = gO.currParallelChan;
            
            switch gO.parallelFromSaveStruct(currEvNum)
                case 1
                    numParChans = size(gO.ephysEvents(currEvNum).DataWin.Raw,1);
                case 2
                    numParChans = size(gO.imagingEvents(currEvNum).DataWin.Raw,1);
            end
            
            switch upDwn
                case 0
                    % no change
                case 1
                    if currParCh < numParChans
                        currParCh = currParCh + 1;
                    end
                case -1
                    if currParCh > 1
                        currParCh = currParCh - 1;
                    end
            end
            
            gO.currParallelChan = currParCh;
            smartplot(gO,0)
        end
        
        %%
        function computeMeanDataWin(gO)
            if gO.loaded(1)
                datawin = squeeze(struct2cell([gO.ephysEvents.DataWin]));
                rawEfiz = datawin(1,:);
                bpEfiz = datawin(2,:);
                powEfiz = datawin(3,:);
                winLens = cellfun('length',rawEfiz);
                [~,maxLenInd] = max(winLens);
                for i = 1:length(rawEfiz)
                    numParChans = size(rawEfiz{i},1);
                    toMax=max(winLens)-winLens(i);
                    if toMax~=0
                        toMaxHalf = toMax/2;
                        if mod(toMaxHalf,2)~=0
                            rawEfiz{i} = [zeros(numParChans,floor(toMaxHalf)),rawEfiz{i},zeros(numParChans,ceil(toMaxHalf))];
                            bpEfiz{i} = [zeros(numParChans,floor(toMaxHalf)),bpEfiz{i},zeros(numParChans,ceil(toMaxHalf))];
                            powEfiz{i} = [zeros(numParChans,floor(toMaxHalf)),powEfiz{i},zeros(numParChans,ceil(toMaxHalf))];
                        else
                            rawEfiz{i} = [zeros(numParChans,toMaxHalf),rawEfiz{i},zeros(numParChans,toMaxHalf)];
                            bpEfiz{i} = [zeros(numParChans,toMaxHalf),bpEfiz{i},zeros(numParChans,toMaxHalf)];
                            powEfiz{i} = [zeros(numParChans,toMaxHalf),powEfiz{i},zeros(numParChans,toMaxHalf)];
                        end
                    end
                end

                gO.avgEphysEvents.Raw = mean(cell2mat(rawEfiz'));
                gO.avgEphysEvents.BP = mean(cell2mat(bpEfiz'));
                gO.avgEphysEvents.Power = mean(cell2mat(powEfiz'));
                gO.avgEphysEvents.Taxis = gO.ephysEvents(maxLenInd).Taxis;
            end
            
            if gO.loaded(2)
                datawin = squeeze(struct2cell([gO.imagingEvents.DataWin]));
                rawImaging = datawin(1,:);
                smoothImaging = datawin(2,:);
                winLens = cellfun('size',rawImaging,2);
                [~,maxLenInd] = max(winLens);
                for i = 1:length(rawImaging)
                    numParChans = size(rawImaging{i},1);
                    toMax=max(winLens)-winLens(i);
                    if toMax~=0
                        toMaxHalf = toMax/2;
                        if mod(toMaxHalf,2)~=0
                            rawImaging{i} = [zeros(numParChans,floor(toMaxHalf)),rawImaging{i},zeros(numParChans,ceil(toMaxHalf))];
                            smoothImaging{i} = [zeros(numParChans,floor(toMaxHalf)),smoothImaging{i},zeros(numParChans,ceil(toMaxHalf))];
                        else
                            rawImaging{i} = [zeros(numParChans,toMaxHalf),rawImaging{i},zeros(numParChans,toMaxHalf)];
                            smoothImaging{i} = [zeros(numParChans,toMaxHalf),smoothImaging{i},zeros(numParChans,toMaxHalf)];
                        end
                    end
                end

                gO.avgImagingEvents.Raw = mean(cell2mat(rawImaging'));
                gO.avgImagingEvents.Smoothed = mean(cell2mat(smoothImaging'));
                gO.avgImagingEvents.Taxis = gO.imagingEvents(maxLenInd).Taxis;
            end
            
        end
        
        %%
        function [noParams,paramNames,paramMat] = extractParamMat(gO,dTyp,onlyNonZero,saveStruct) % varargin should be the savestructs
            noParams = false;
            if iscell(saveStruct)
                numSaveStructs = length(saveStruct);
                paramMat = cell(numSaveStructs,1);
            else
                numSaveStructs = 1;
                paramMat = [];
            end
            paramNames = [];
                        
            for i = 1:numSaveStructs
                switch dTyp
                    case 1
                        if iscell(saveStruct)
                            evs = [saveStruct{i}.ephysEvents];
                        else
                            evs = [saveStruct.ephysEvents];
                        end
                        
                    case 2
                        if iscell(saveStruct)
                            evs = [saveStruct{i}.imagingEvents];
                        else
                            evs = [saveStruct.imagingEvents];
                        end
                        
                end
                
                if ~isempty([evs.Params])
                    paramsCell = squeeze(struct2cell([evs.Params]));
                    paramsCell(cellfun('isempty', paramsCell)) = {nan};
                    paramMat{i} = cell2mat(paramsCell);
                                        
                    if i == 1
                        paramNames = fieldnames(evs(1).Params);
                    else
                        if ~isempty(setxor(paramNames, fieldnames(evs(1).Params)))
                            [paramNames,ia,ib] = intersect(paramNames, fieldnames(evs(1).Params), 'stable');
                            for j = 1:i-1                                
                                paramMat{j} = paramMat{j}(ia,:);
                            end
                            paramMat{i} = paramMat{i}(ib,:);
                        end
                    end
                    
                    
                    if onlyNonZero
                        nonZeroRows = any(paramMat{i},2);
                        if any(nonZeroRows)
                            paramNames(~nonZeroRows) = [];
                            paramMat{i}(~nonZeroRows,:) = [];
                        else
                            noParams = true;
                            return
                        end
                    end
                else
                    noParams = true;
                    return
                end
            end
            
            if numSaveStructs == 1
                paramMat = paramMat{:};
            end
        end
    end
    
    %% Callback functions
    methods (Access = private)
        %%
        function keyboardPressFcn(gO,~,kD)
            if sum(gO.loaded) == 0
                return
            end
            
            switch kD.Key
                case 'rightarrow'
                    upDwn = 1;
                case 'leftarrow'
                    upDwn = -1;
                otherwise
                    return
            end
            changeCurrEv(gO,upDwn)
        end
        
        %%
        function tabChanged(gO,~,e)
%             e.NewValue
%             isempty(find(gO.loaded,1))
%             if (e.NewValue == gO.tabgroup.Children(2)) & isempty(find(gO.loaded,1))
%                 gO.tabgroup.SelectedTab = e.OldValue;
%                 drawnow
%                 warndlg('No file loaded!')
%             end
        end
        
        %%
        function loadEntryButtonPress(gO,~,~)
            selInd = gO.entryListBox.Value;
            gO.loadedEntryFname = gO.dbFileNames{selInd};
            gO.currEvent = 1;
            gO.ephysEvents = [];
            gO.imagingEvents = [];
            gO.loaded = [0,0,0];
            gO.ephysParamTable.Data = {};
            gO.ephysParamTable.Visible = 'off';
            gO.imagingParamTable.Data = {};
            gO.imagingParamTable.Visible = 'off';
            gO.sourceChanDetTable.Data = cell(2,2);
            
            DASloc = mfilename('fullpath');
            file2load = [DASloc(1:end-7),'DASeventDBdir\',gO.loadedEntryFname];
            load(file2load,'saveStruct');
            if isempty(saveStruct)
                errordlg('Selected entry is empty!')
                return
            end
            
            gO.source = vertcat(saveStruct.source);
            if size(gO.source,1) ~= length(saveStruct)
                gO.source = horzcat(saveStruct.source);
            end
            
            gO.simultFromSaveStruct = [saveStruct.simult];
            gO.parallelFromSaveStruct = [saveStruct.parallel];
            
            gO.parallelChanDwnButton.Visible = 'off';
            gO.parallelChanUpButton.Visible = 'off';
            gO.showAvgParallelChanButton.Visible = 'off';
            if unique(gO.parallelFromSaveStruct) == 1
                gO.parallelChanDwnButton.Visible = 'on';
                gO.parallelChanUpButton.Visible = 'on';
                gO.showAvgParallelChanButton.Visible = 'on';
            end
            
%             temp = {'ephysTaxis';'ephysDataWin';'ephysParams';'imagingTaxis';...
%                 'imagingDataWin';'imagingParams';'simultEphysTaxis';...
%                 'simultEphysDataWin';'simultEphysParams';...
%                 'simultImagingTaxis';'simultImagingDataWin';'simultImagingParams'};
%             nameMatch = ismember(temp,string(fieldnames(saveStruct)))

%             if isempty(find([saveStruct.simult],1)) && ...
            if ismember('ephysEvents',string(fieldnames(saveStruct)))
                gO.numEvents = length(saveStruct);
                gO.loaded(1) = 1;
                gO.ephysEvents = [saveStruct.ephysEvents];
                gO.ephysParamTable.Visible = 'on';
            end
            
%             if isempty(find([saveStruct.simult],1)) && ...
            if ismember('imagingEvents',string(fieldnames(saveStruct)))
                
                gO.numEvents = length(saveStruct);
                gO.loaded(2) = 1;
                gO.imagingEvents = [saveStruct.imagingEvents];
                gO.imagingParamTable.Visible = 'on';
            end
%             
%             if ~isempty(find([saveStruct.simult],1))
%                 gO.numEvents = length(saveStruct);
%                 gO.loaded(1:2) = 1;
%                 gO.ephysEvents = [saveStruct.ephysEvents];
%                 gO.imagingEvents = [saveStruct.imagingEvents];
%                 gO.ephysParamTable.Visible = 'on';
%                 gO.imagingParamTable.Visible = 'on';
%             end
            
            if ismember('runData',string(fieldnames(saveStruct)))
                gO.loaded(3) = 1;
                fns = fieldnames(saveStruct);
                toRemove = fns(~ismember(fns,'runData'));
                gO.runData = rmfield(saveStruct,toRemove);
            end
            
            gO.mainFig.Name = ['DAS Event DataBase - ',gO.loadedEntryFname];
            
            computeMeanDataWin(gO)
            
            smartplot(gO,1)
        end
        
        %%
        function showAvgParamsMenuSel(gO,~,~)
            if gO.loaded(1) && ~isempty([gO.ephysEvents.Params])
                avg = mean(cell2mat(squeeze(struct2cell([gO.ephysEvents.Params]))),2,'omitnan');
                sd = std(cell2mat(squeeze(struct2cell([gO.ephysEvents.Params]))),[],2,'omitnan');
                avgSd = cell(length(avg),1);
                for i = 1:length(avg)
                    avgSd{i} = [num2str(avg(i)),' � ',num2str(sd(i))];
                end
                
                temp = [fieldnames([gO.ephysEvents(1).Params]),avgSd];
                gO.ephysParamTable.Data = temp;
                gO.ephysParamTable.ColumnName = {'Electrophysiology','Mean values'};
            end
            
            if gO.loaded(2) && ~isempty([gO.imagingEvents.Params])
                avg = mean(cell2mat(squeeze(struct2cell([gO.imagingEvents.Params]))),2,'omitnan');
                sd = std(cell2mat(squeeze(struct2cell([gO.imagingEvents.Params]))),[],2,'omitnan');
                avgSd = cell(length(avg),1);
                for i = 1:length(avg)
                    avgSd{i} = [num2str(avg(i)),' � ',num2str(sd(i))];
                end
                
                temp = [fieldnames([gO.imagingEvents(1).Params]),avgSd];
                gO.imagingParamTable.Data = temp;
                gO.imagingParamTable.ColumnName = {'Imaging','Mean values'};
            end
            
        end
        
        %%
        function displayAvgDataWinMenuSel(gO,~,~)
            if gO.displayAvgDataWin
                gO.displayAvgDataWin = 0;
                gO.displayAvgDataWinMenu.Text = 'Display the average data window --OFF--';
                gO.displayAvgDataWinMenu.ForegroundColor = 'r';
            else
                gO.displayAvgDataWin = 1;
                gO.displayAvgDataWinMenu.Text = 'Display the average data window --ON--';
                gO.displayAvgDataWinMenu.ForegroundColor = 'g';
            end
            
            smartplot(gO,0)
        end
        
        %%
        function ephysTypeMenuSel(gO,~,~)
            initVal = find(gO.ephysTypeSelected);
            [idx,tf] = listdlg('ListString',{'Raw','DoG','InstPow'},...
                'PromptString','Select data type(s) to show detections on!',...
                'InitialValue',initVal);
            if ~tf
                return
            end
            
            gO.ephysTypeSelected(:) = 0;
            gO.ephysTypeSelected(idx) = 1;
            
            smartplot(gO,1)
        end
        
        %%
        function imagingTypeMenuSel(gO,~,~)
            initVal = find(gO.imagingTypeSelected);
            [idx,tf] = listdlg('ListString',{'Raw','Gauss smoothed'},...
                'PromptString','Select data type(s) to show detections on!',...
                'SelectionMode','single','InitialValue',initVal);
            if ~tf
                return
            end
            
            gO.imagingTypeSelected(:) = 0;
            gO.imagingTypeSelected(idx) = 1;
            
            smartplot(gO,0)
        end
        
        %%
        function runTypeMenuSel(gO,~,~)
            initVal = find(gO.runTypeSelected);
            [idx,tf] = listdlg('ListString',{'Velocity','Absolute position','Relative position'},...
                'PromptString','Select data type to show detections on!',...
                'SelectionMode','single','InitialValue',initVal);
            if ~tf
                return
            end
            
            gO.runTypeSelected(:) = 0;
            gO.runTypeSelected(idx) = 1;
            
            smartplot(gO,0)
        end
        
        %%
        function showLicksMenuSel(gO,~,~)
            if gO.showLicks
                gO.showLicks = 0;
                gO.showLicksMenu.Text = 'Show licks on graph --OFF--';
                gO.showLicksMenu.ForegroundColor = 'r';
            else
                gO.showLicks = 1;
                gO.showLicksMenu.Text = 'Show licks on graph --ON--';
                gO.showLicksMenu.ForegroundColor = 'g';
            end
            smartplot(gO,0)
        end
        
        %%
        function deleteEntry(gO,delLoaded)
            if isempty(gO.entryListBox.String)
                errordlg('No entries!')
                return
            end
            
            DASloc = mfilename('fullpath');
            if ~delLoaded
                sel = gO.entryListBox.Value;

                if strcmp(gO.entryListBox.String{sel},gO.loadedEntryFname)
                    quest = ['Are you sure you want to delete the currently',...
                        ' loaded entry? (If you delete it, you can still browse',...
                        ' this entry until you load another one)'];
                    title = 'Confirm delete';
                    answer = questdlg(quest,title);
                    if ~strcmp(answer,'Yes')                
                        return
                    end
                end

                delete([DASloc(1:end-7),'DASeventDBdir\',gO.entryListBox.String{sel}])
                getDBlist(gO,1)
            else
                delete([DASloc(1:end-7),'DASeventDBdir\',gO.loadedEntryFname])
                getDBlist(gO,1)
            end
        end
        
        %%
        function deleteEventMenuSel(gO)
            currEv = gO.currEvent;
            
            if gO.numEvents > 1
                gO.numEvents = gO.numEvents-1;
            elseif gO.numEvents == 1
                warndlg('This is the last event! The whole entry will be deleted!')
                deleteEntry(gO,1)
                return
            elseif gO.numEvents == 0
                errordlg('No database group loaded!')
                return
            end
            
            gO.source(currEv,:) = [];
            gO.simultFromSaveStruct(currEv) = [];
            gO.parallelFromSaveStruct(currEv) = [];
            
            if gO.loaded(1)
                gO.ephysEvents(currEv) = [];
            end
            
            if gO.loaded(2)
                gO.imagingEvents(currEv) = [];
            end
            
            for i = 1:gO.numEvents
                saveStruct(i).source = gO.source(i,:);
                saveStruct(i).simult = gO.simultFromSaveStruct(i);
                saveStruct(i).parallel = gO.parallelFromSaveStruct(i);
                if gO.loaded(1)
                    saveStruct(i).ephysEvents = gO.ephysEvents(i);
                end
                if gO.loaded(2)
                    saveStruct(i).imagingEvents = gO.imagingEvents(i);
                end
            end
            
            if currEv > 1
                gO.currEvent = currEv-1;
            else
                gO.currEvent = 1;
            end
            
            smartplot(gO,0)
            
            DASloc = mfilename('fullpath');
            saveLoc = [DASloc(1:end-7),'DASeventDBdir\',gO.loadedEntryFname];
            save(saveLoc,'saveStruct')
        end
        
        %%
        function exportCurrLoadedParamsMenuSel(gO)
            if ~isempty(gO.ephysEvents)
                eEvs = [gO.ephysEvents];
                eParams = [eEvs.Params];
                
                chans = [eEvs.ChanNum];
                for i = 1:length(eParams)
                    eParams(i).Channel = chans(i);
                end
            else
                eParams = [];
            end
            
            if ~isempty(gO.imagingEvents)
                iEvs = [gO.imagingEvents];
                iParams = [iEvs.Params];
                
                rois = [iEvs.ROINum];
                for i = 1:length(iParams)
                    iParams(i).ROI = rois(i);
                end
            else
                iParams = [];
            end
            
            forInfoTab = cell(1,2);
            forInfoTab(1,:) = {'DB group name', gO.loadedEntryFname};
            
            extInName = strfind(gO.loadedEntryFname, '.mat');
            if ~isempty(extInName)
                name4excel = gO.loadedEntryFname(1:extInName-1);
            else
                name4excel = gO.loadedEntryFname;
            end
            DAS2Excel(forInfoTab,eParams,iParams,[name4excel,'_summary'])
        end
        
        %%
        function statSelectPopMenuCB(gO,~,~)
            switch gO.statSelectPopMenu.String{gO.statSelectPopMenu.Value}
                case '--Select statistic!--'
                    gO.basicStatParamPanel.Visible = 'off';
                    gO.basicStatParamTable1.Visible = 'off';
                    gO.basicStatParamTable2.Visible = 'off';
                    gO.basicStatParamTableBig.Visible = 'off';
                    gO.tTestSetupPanel.Visible = 'off';
                    gO.tTestResultPanel.Visible = 'off';
                    
                    gO.db4StatListBox.Enable = 'off';
                    gO.db4StatListBox.Value = 1;
                    gO.db4StatListBox.Max = 2;
                    
                case 'Basic statistical parameters'
                    gO.basicStatParamPanel.Visible = 'on';
                    gO.basicStatParamTable1.Visible = 'off';
                    gO.basicStatParamTable2.Visible = 'off';
                    gO.basicStatParamTableBig.Visible = 'off';
                    gO.tTestSetupPanel.Visible = 'off';
                    gO.tTestResultPanel.Visible = 'off';
                    
                    gO.db4StatListBox.Enable = 'on';
                    gO.db4StatListBox.Value = 1;
                    gO.db4StatListBox.Max = 1;
                    
                case {'One-sample t-Test','Two-sample t-Test'}
                    gO.tTestSetupPanel.Visible = 'on';
                    gO.tTestResultPanel.Visible = 'on';
                    gO.basicStatParamPanel.Visible = 'off';
                    gO.basicStatParamTable1.Visible = 'off';
                    gO.basicStatParamTable2.Visible = 'off';
                    gO.basicStatParamTableBig.Visible = 'off';
                    
                    gO.db4StatListBox.Enable = 'on';
                    if strcmp(gO.statSelectPopMenu.String{gO.statSelectPopMenu.Value},'One-sample t-Test')
                        gO.db4StatListBox.Value = 1;
                        gO.db4StatListBox.Max = 1;
                        gO.tTestMu0EphysTable.Visible = 'on';
                        gO.tTestMu0ImagingTable.Visible = 'on';
                    elseif strcmp(gO.statSelectPopMenu.String{gO.statSelectPopMenu.Value},'Two-sample t-Test')
                        gO.db4StatListBox.Value = 1;
                        gO.db4StatListBox.Max = 2;
                        gO.tTestMu0EphysTable.Visible = 'off';
                        gO.tTestMu0ImagingTable.Visible = 'off';
                    end
            end
        end
        
        %%
        function db4StatListBoxCB(gO,~,~)
            
            switch gO.statSelectPopMenu.String{gO.statSelectPopMenu.Value}
                case 'One-sample t-Test'
                    fNames = gO.db4StatListBox.String(gO.db4StatListBox.Value);
                    DASloc = mfilename('fullpath');

                    file2load = [DASloc(1:end-7),'DASeventDBdir\',fNames{1}];
                    load(file2load,'saveStruct');
                    
                    if sum(ismember(fieldnames(saveStruct),'ephysEvents'))
                        if isempty(saveStruct(1).ephysEvents.Params)
                            return
                        end
                        
                        gO.tTestMu0EphysTable.Enable = 'on';
                        fns = fieldnames(saveStruct(1).ephysEvents.Params);
                        temp = [fns, mat2cell(zeros(length(fns),1), ones(length(fns),1))];
                        gO.tTestMu0EphysTable.Data = temp;
                    else
                        gO.tTestMu0EphysTable.Enable = 'off';
                        gO.tTestMu0EphysTable.Data = [];
                    end
                    
                    if sum(ismember(fieldnames(saveStruct),'imagingEvents'))
                        if isempty(saveStruct(1).imagingEvents.Params)
                            return
                        end
                        
                        gO.tTestMu0ImagingTable.Enable = 'on';
                        fns = fieldnames(saveStruct(1).imagingEvents.Params);
                        temp = [fns, mat2cell(zeros(length(fns),1), ones(length(fns),1))];
                        gO.tTestMu0ImagingTable.Data = temp;
                    else
                        gO.tTestMu0ImagingTable.Enable = 'off';
                        gO.tTestMu0ImagingTable.Data = [];
                    end
                    
                case 'Two-sample t-Test'
                    if length(gO.db4StatListBox.Value) > 2
                        gO.db4StatListBox.Value = gO.db4StatListBox.Value(1:2);
                    end
                    
                otherwise
                    return
            end
        end
        
        %%
        function statLaunchButtonPress(gO,~,~)
            fNames = gO.db4StatListBox.String(gO.db4StatListBox.Value);
            DASloc = mfilename('fullpath');
            statEntries = cell(length(fNames),1);
            loaded4Stat = [0,0,0];
            for i = 1:length(fNames)
                file2load = [DASloc(1:end-7),'DASeventDBdir\',fNames{i}];
                load(file2load,'saveStruct');
                statEntries{i} = saveStruct;
            end

            switch gO.statSelectPopMenu.String{gO.statSelectPopMenu.Value}
                case '--Select statistic!--'
                    %%
                    
                case 'Basic statistical parameters'
                    %%
                    if length(fNames) > 1
                        errordlg('This statistic works on only one entry')
                        return
                    end
                    gO.basicStatParamTable1.Visible = 'off';
                    gO.basicStatParamTable2.Visible = 'off';
                    gO.basicStatParamTableBig.Visible = 'off';
                    
                    statEntries = statEntries{1};
                    
                    if sum(ismember(fieldnames(statEntries),'ephysEvents'))
                        [noParams,eParamNames,paramsMat] = extractParamMat(gO,1,false,statEntries);
                        if ~noParams
                            eAvg = mat2cell(mean(paramsMat,2,'omitnan'),ones(1,length(eParamNames)));
                            eSd = mat2cell(std(paramsMat,[],2,'omitnan'),ones(1,length(eParamNames)));
                            eMed = mat2cell(median(paramsMat,2,'omitnan'),ones(1,length(eParamNames)));
                            loaded4Stat(1) = 1;
                        end
                    end
                    
                    if sum(ismember(fieldnames(statEntries),'imagingEvents'))
                        [noParams,iParamNames,paramsMat] = extractParamMat(gO,2,false,statEntries);
                        if ~noParams
                            iAvg = mat2cell(mean(paramsMat,2,'omitnan'),ones(1,length(iParamNames)));
                            iSd = mat2cell(std(paramsMat,[],2,'omitnan'),ones(1,length(iParamNames)));
                            iMed = mat2cell(median(paramsMat,2,'omitnan'),ones(1,length(iParamNames)));
                            loaded4Stat(2) = 1;
                        end
                    end
                    
                    if sum(loaded4Stat) == 2
                        gO.basicStatParamTable1.ColumnName = {'Electrophysiology',...
                            'Mean','SD','Median'};
                        temp = [eParamNames,eAvg,eSd,eMed];
                        gO.basicStatParamTable1.Data = temp;
                        gO.basicStatParamTable1.ColumnWidth = {100,100,100,100};
                        gO.basicStatParamTable1.Visible = 'on';
                        
                        gO.basicStatParamTable2.ColumnName = {'Imaging',...
                            'Mean','SD','Median'};
                        temp = [iParamNames,iAvg,iSd,iMed];
                        gO.basicStatParamTable2.Data = temp;
                        gO.basicStatParamTable2.ColumnWidth = {100,100,100,100};
                        gO.basicStatParamTable2.Visible = 'on';
                    elseif loaded4Stat(1)
                        gO.basicStatParamTableBig.ColumnName = {'Electrophysiology',...
                            'Mean','SD','Median'};
                        temp = [eParamNames,eAvg,eSd,eMed];
                        gO.basicStatParamTableBig.Data = temp;
                        gO.basicStatParamTableBig.ColumnWidth = {100,100,100,100};
                        gO.basicStatParamTableBig.Visible = 'on';
                    elseif loaded4Stat(2)
                        gO.basicStatParamTableBig.ColumnName = {'Imaging',...
                            'Mean','SD','Median'};
                        temp = [iParamNames,iAvg,iSd,iMed];
                        gO.basicStatParamTableBig.Data = temp;
                        gO.basicStatParamTableBig.ColumnWidth = {100,100,100,100};
                        gO.basicStatParamTableBig.Visible = 'on';
                    elseif sum(loaded4Stat) == 0
                        
                    end
                    
                    
                case 'One-sample t-Test'
                    %%
                    if length(fNames) > 1
                        errordlg('This statistic works on only one entry')
                        return
                    end
                    alpha = str2double(gO.tTestCritPEdit.String);
                    
                    statEntries = statEntries{1};
                    
                    if sum(ismember(fieldnames(statEntries),'ephysEvents'))
                        e_mu0 = cell2mat(gO.tTestMu0EphysTable.Data(:,2));
                        [noParams,eParamNames,paramsMat] = extractParamMat(gO,1,true,statEntries);
                        if ~noParams
                            loaded4Stat(1) = 1;

                            e_h = zeros(length(eParamNames),1);
                            e_p = zeros(length(eParamNames),1);
                            e_ci = cell(length(eParamNames),1);
                            for i = 1:size(paramsMat,1)
                                [e_h(i),e_p(i),ciNum] = ttest(paramsMat(i,:),e_mu0(i),'Alpha',alpha);
                                e_ci{i} = ['         [',num2str(ciNum(1)),' , ',num2str(ciNum(2)),']'];
                            end

                            e_h = mat2cell(logical(e_h),ones(length(eParamNames),1));
                            e_p = mat2cell(e_p,ones(length(eParamNames),1));
                        end
                    end
                    
                    if sum(ismember(fieldnames(statEntries),'imagingEvents'))
                        i_mu0 = cell2mat(gO.tTestMu0ImagingTable.Data(:,2));
                        [noParams,iParamNames,paramsMat] = extractParamMat(gO,2,true,statEntries);
                        if ~noParams
                            loaded4Stat(2) = 1;
                            
                            i_h = zeros(length(iParamNames),1);
                            i_p = zeros(length(iParamNames),1);
                            i_ci = cell(length(iParamNames),1);
                            for i = 1:size(paramsMat,1)
                                [i_h(i),i_p(i),ciNum] = ttest(paramsMat(i,:),i_mu0(i),'Alpha',alpha);
                                i_ci{i} = ['         [',num2str(ciNum(1)),' , ',num2str(ciNum(2)),']'];
                            end

                            i_h = mat2cell(logical(i_h),ones(length(iParamNames),1));
                            i_p = mat2cell(i_p,ones(length(iParamNames),1));
                        end
                    end
                    
                    
                    if loaded4Stat(1)
                        gO.tTestEphysResultTable.ColumnName = {'Electrophysiology',...
                            'Null hypothesis rejected?','p-value','CI'};
                        gO.tTestEphysResultTable.ColumnFormat = {'char','logical','numeric','char'};
                        temp = [eParamNames,e_h,e_p,e_ci];
                        gO.tTestEphysResultTable.Data = temp;
                        gO.tTestEphysResultTable.ColumnWidth = {100,150,100,150};
                    else
                        gO.tTestEphysResultTable.Data = [];
                    end
                    if loaded4Stat(2)
                        gO.tTestImagingResultTable.ColumnName = {'Imaging',...
                            'Null hypothesis rejected?','p-value','CI'};
                        gO.tTestImagingResultTable.ColumnFormat = {'char','logical','numeric','char'};
                        temp = [iParamNames,i_h,i_p,i_ci];
                        gO.tTestImagingResultTable.Data = temp;
                        gO.tTestImagingResultTable.ColumnWidth = {100,150,100,150};
                    else
                        gO.tTestImagingResultTable.Data = [];
                    end
                    
                case 'Two-sample t-Test'
                    %%
                    if length(fNames) ~= 2
                        errordlg('This statistic works on two entries')
                        return
                    end
                    alpha = str2double(gO.tTestCritPEdit.String);
                    
                    if sum(ismember(fieldnames(statEntries{1}),'ephysEvents')) && sum(ismember(fieldnames(statEntries{2}),'ephysEvents'))
                        [noParams,eParamNames,paramsMat] = extractParamMat(gO,1,true,statEntries);
                        if ~noParams
                            loaded4Stat(1) = 1; 

                            e_h = zeros(length(eParamNames),1);
                            e_p = zeros(length(eParamNames),1);
                            e_ci = cell(length(eParamNames),1);
                            for i = 1:length(eParamNames)
                                [e_h(i),e_p(i),ciNum] = ttest2(paramsMat{1}(i,:),paramsMat{2}(i,:),'Alpha',alpha);
                                e_ci{i} = ['         [',num2str(ciNum(1)),' , ',num2str(ciNum(2)),']'];
                            end

                            e_h = mat2cell(logical(e_h),ones(length(eParamNames),1));
                            e_p = mat2cell(e_p,ones(length(eParamNames),1));
                        end
                    end
                    
                    if sum(ismember(fieldnames(statEntries{1}),'imagingEvents')) && sum(ismember(fieldnames(statEntries{2}),'imagingEvents'))                        
                        [noParams,iParamNames,paramsMat] = extractParamMat(gO,2,true,statEntries);
                        if ~noParams
                            loaded4Stat(2) = 1;

                            i_h = zeros(length(iParamNames),1);
                            i_p = zeros(length(iParamNames),1);
                            i_ci = cell(length(iParamNames),1);
                            for i = 1:length(iParamNames)
                                [i_h(i),i_p(i),ciNum] = ttest2(paramsMat{1}(i,:),paramsMat{2}(i,:),'Alpha',alpha);
                                i_ci{i} = ['         [',num2str(ciNum(1)),' , ',num2str(ciNum(2)),']'];
                            end

                            i_h = mat2cell(logical(i_h),ones(length(iParamNames),1));
                            i_p = mat2cell(i_p,ones(length(iParamNames),1));
                        end
                    end
                    
                    
                    if loaded4Stat(1)
                        gO.tTestEphysResultTable.ColumnName = {'Electrophysiology',...
                            'Null hypothesis rejected?','p-value','CI'};
                        gO.tTestEphysResultTable.ColumnFormat = {'char','logical','numeric','char'};
                        temp = [eParamNames,e_h,e_p,e_ci];
                        gO.tTestEphysResultTable.Data = temp;
                        gO.tTestEphysResultTable.ColumnWidth = {100,150,100,150};
                    else
                        gO.tTestEphysResultTable.Data = [];
                    end
                    if loaded4Stat(2)
                        gO.tTestImagingResultTable.ColumnName = {'Imaging',...
                            'Null hypothesis rejected?','p-value','CI'};
                        gO.tTestImagingResultTable.ColumnFormat = {'char','logical','numeric','char'};
                        temp = [iParamNames,i_h,i_p,i_ci];
                        gO.tTestImagingResultTable.Data = temp;
                        gO.tTestImagingResultTable.ColumnWidth = {100,150,100,150};
                    else
                        gO.tTestImagingResultTable.Data = [];
                    end
            end
        end
        
        %%
        function statGraphTypePopMenuCB(gO,~,~)
            graphType = gO.statGraphTypePopMenu.String{gO.statGraphTypePopMenu.Value};
            switch graphType
                case '---Select plot type---'
                    gO.statGraphDataListbox.Enable = 'off';
                
                case 'Histogram with fitted distribution'
                    gO.statGraphDataListbox.Enable = 'on';
                    gO.statGraphDataListbox.Value = gO.statGraphDataListbox.Value(1);
                    gO.statGraphDataListbox.Max = 1;
                    
                case 'Boxplot'
                    gO.statGraphDataListbox.Enable = 'on';
                    gO.statGraphDataListbox.Max = 2;
                
            end
        end
        
        %%
        function statGraphDataListboxCB(gO,~,~)
            fNames = gO.statGraphDataListbox.String(gO.statGraphDataListbox.Value);
            DASloc = mfilename('fullpath');

            eParamList = [];
            eSkip = false; % variable to signal when one of the selected group doesnt have the params
            iParamList = [];
            iSkip = false;
            
            for i = 1:length(fNames)
                file2load = [DASloc(1:end-7),'DASeventDBdir\',fNames{i}];
                load(file2load,'saveStruct');
                
                if ~eSkip && sum(ismember(fieldnames(saveStruct),'ephysEvents')) && ~isempty(saveStruct(1).ephysEvents.Params)
                    if i == 1
                        eFns = fieldnames(saveStruct(1).ephysEvents.Params);
                        eParamList = [{'---Ephys parameters---'}; eFns];
                    else
                        if ~isempty(setxor(eFns, fieldnames(saveStruct(1).ephysEvents.Params)))
                            [eFns,~,~] = intersect(eFns, fieldnames(saveStruct(1).ephysEvents.Params), 'stable');
                            eParamList = [{'---Ephys parameters---'}; eFns];
                        end
                    end
                else
                    eSkip = true;
                    eParamList = [];
                end

                if ~iSkip && sum(ismember(fieldnames(saveStruct),'imagingEvents')) && ~isempty(saveStruct(1).imagingEvents.Params)
                    if i == 1
                        iFns = fieldnames(saveStruct(1).imagingEvents.Params);
                        iParamList = [{'---Imaging parameters---'}; iFns];
                    else
                        if ~isempty(setxor(iFns, fieldnames(saveStruct(1).imagingEvents.Params)))
                            [iFns,~,~] = intersect(iFns, fieldnames(saveStruct(1).imagingEvents.Params), 'stable');
                            iParamList = [{'---Imaging parameters---'}; iFns];
                        end
                    end
                else
                    iSkip = true;
                    iParamList = [];
                end
            end
            
            temp = [{'Select which parameter to use!'}; eParamList; iParamList];
                        
            gO.statGraphParamSelPopMenu.Value = 1;
            gO.statGraphParamSelPopMenu.String = temp;
        end
        
        %%
        function statGraphPlotButtonPress(gO,~,~)
            if gO.statGraphParamSelPopMenu.Value == 0
                return
            end
            
            plotTypeSel = gO.statGraphTypePopMenu.String{gO.statGraphTypePopMenu.Value};
            if strcmp(plotTypeSel,'---Select plot type---')
                return
            end
            
            paramSel = gO.statGraphParamSelPopMenu.String{gO.statGraphParamSelPopMenu.Value};
            if ~isempty(intersect(paramSel, {'Select which parameter to use!','---Imaging parameters---','---Ephys parameters---'}))
                return
            end
            eStart = find(cellfun(@(x) strcmp('---Ephys parameters---',x), gO.statGraphParamSelPopMenu.String), 1);
            iStart = find(cellfun(@(x) strcmp('---Imaging parameters---',x), gO.statGraphParamSelPopMenu.String), 1);
            
            if ~isempty(eStart) && ~isempty(iStart)
                if gO.statGraphParamSelPopMenu.Value < iStart
                    dTyp = 1;
                elseif gO.statGraphParamSelPopMenu.Value > iStart
                    dTyp = 2;
                else
                    return
                end
            elseif ~isempty(eStart) && isempty(iStart)
                dTyp = 1;
            elseif isempty(eStart) && ~isempty(iStart)
                dTyp = 2;
            else 
                return
            end
            
            
            fNames = gO.statGraphDataListbox.String(gO.statGraphDataListbox.Value);
            DASloc = mfilename('fullpath');

            paramMat = [];
            
            for i = 1:length(fNames)
                file2load = [DASloc(1:end-7),'DASeventDBdir\',fNames{i}];
                load(file2load,'saveStruct');
                
                if (dTyp == 1) && sum(ismember(fieldnames(saveStruct),'ephysEvents'))
                    [noParams,eParamNames,tempParamMat] = extractParamMat(gO,1,false,saveStruct);
                    if ~noParams
                        paramMatInd = cellfun(@(x) strcmp(paramSel,x), eParamNames);
                        tempParamMat = tempParamMat(paramMatInd,:);
                        if ~isempty(paramMat) && length(tempParamMat) > size(paramMat,1)
                            lenDiff = length(tempParamMat) - size(paramMat,1);
                            paramMat(end:end+lenDiff,:) = nan;
                        elseif ~isempty(paramMat) && length(tempParamMat) < size(paramMat,1)
                            lenDiff = size(paramMat,1) - length(tempParamMat);
                            tempParamMat(end:end+lenDiff) = nan;
                        end
                        paramMat = [paramMat, tempParamMat'];
                        
                        paramUnitInd = strcmp(gO.ephysParamUnits(:,1),paramSel);
                        xTitle = [gO.ephysParamUnits{paramUnitInd,1},' ',gO.ephysParamUnits{paramUnitInd,2}];
                    end
                end
                if (dTyp == 2) && sum(ismember(fieldnames(saveStruct),'imagingEvents'))
                    [noParams,iParamNames,tempParamMat] = extractParamMat(gO,2,false,saveStruct);
                    if ~noParams
                        paramMatInd = cellfun(@(x) strcmp(paramSel,x), iParamNames);
                        tempParamMat = tempParamMat(paramMatInd,:);
                        if ~isempty(paramMat) && length(tempParamMat) > size(paramMat,1)
                            lenDiff = length(tempParamMat) - size(paramMat,1);
                            paramMat(end:end+lenDiff,:) = nan;
                        elseif ~isempty(paramMat) && length(tempParamMat) < size(paramMat,1)
                            lenDiff = size(paramMat,1) - length(tempParamMat);
                            tempParamMat(end:end+lenDiff) = nan;
                        end
                        paramMat = [paramMat, tempParamMat'];
                        
                        paramUnitInd = strcmp(gO.imagingParamUnits(:,1),paramSel);
                        xTitle = [gO.imagingParamUnits{paramUnitInd,1},' ',gO.imagingParamUnits{paramUnitInd,2}];
                    end
                end
            end
            
            if isempty(paramMat)
                return
            end
                        
            switch plotTypeSel
                case 'Histogram with fitted distribution'
                    axes(gO.axStatTab)
                    histfit(tempParamMat,[],'normal')
                    title(gO.axStatTab,['Distribution from: ',paramSel])
                    xlabel(gO.axStatTab,xTitle)
                    
                case 'Boxplot'
                    boxplot(gO.axStatTab,paramMat,fNames,'LabelOrientation','inline')
                    ylabel(gO.axStatTab,xTitle)
                    
            end
            
            
        end
    end
    
    %% gui component initialization and construction
    methods (Access = private)
        %%
        function createComponents(gO)
            %% Create figure
            gO.mainFig = figure('Units','normalized',...
                'Position',[0.1, 0.1, 0.75, 0.8],...
                'NumberTitle','off',...
                'Name','DAS Event DataBase',...
                'IntegerHandle','off',...
                'HandleVisibility','Callback',...
                'MenuBar','none',...
                'KeyPressFcn',@ gO.keyboardPressFcn);%,...
                %'Color',[103,72,70]/255);
            
            %% menus
            gO.optionsMenu = uimenu(gO.mainFig,...
                'Text','Options Menu');
            gO.showAvgParamsMenu = uimenu(gO.optionsMenu,...
                'Text','Show average parameters',...
                'MenuSelectedFcn',@ gO.showAvgParamsMenuSel);
            gO.displayAvgDataWinMenu = uimenu(gO.optionsMenu,...
                'Text','Display the average data window --OFF--',...
                'ForegroundColor','r',...
                'MenuSelectedFcn',@ gO.displayAvgDataWinMenuSel);
            
            gO.ephysOptMenu = uimenu(gO.mainFig,...
                'Text','Electrophysiological options');
            gO.ephysTypeChangeMenu = uimenu(gO.ephysOptMenu,...
                'Text','Change displayed ephys data',...
                'MenuSelectedFcn',@ gO.ephysTypeMenuSel);
            gO.ephysShowEventSpectroMenu = uimenu(gO.ephysOptMenu,...
                'Text','Show event spectrogram',...
                'MenuSelectedFcn',@(h,e) gO.ephysPlot([],true));
            
            gO.imagingOptMenu = uimenu(gO.mainFig,...
                'Text','Imaging options');
            gO.imagingTypeChangeMenu = uimenu(gO.imagingOptMenu,...
                'Text','Change displayed imaging data',...
                'MenuSelectedFcn',@ gO.imagingTypeMenuSel);
            
            gO.runOptMenu = uimenu(gO.mainFig,...
                'Text','Running options');
            gO.runTypeChangeMenu = uimenu(gO.runOptMenu,...
                'Text','Change displayed running data',...
                'MenuSelectedFcn',@ gO.runTypeMenuSel);
            gO.showLicksMenu = uimenu(gO.runOptMenu,...
                'Text','Show licks on graph --OFF--',...
                'ForegroundColor','r',...
                'MenuSelectedFcn',@ gO.showLicksMenuSel);
            
            gO.changeDbMenu = uimenu(gO.mainFig,...
                'Text','Manipulate DB');
            gO.deleteEventMenu = uimenu(gO.changeDbMenu,...
                'Text','Delete current event',...
                'Callback',@(h,e) gO.deleteEventMenuSel);
            
            gO.exportMenu = uimenu(gO.mainFig,...
                'Text','Export');
            gO.exportCurrLoadedParamsMenu = uimenu(gO.exportMenu,...
                'Text','Export currently loaded event parameters --> Excel',...
                'Callback',@(h,e) gO.exportCurrLoadedParamsMenuSel);
            
            %% tabs
            gO.tabgroup = uitabgroup(gO.mainFig,...
                'Units','normalized',...
                'Position',[0,0,1,1],...
                'SelectionChangedFcn', @ gO.tabChanged);
            gO.eventTab = uitab(gO.tabgroup,...
                'Title','Events');
            gO.statTab = uitab(gO.tabgroup,...
                'Title','Statistics');
                
            %% load panel
            gO.loadEntryPanel = uipanel(gO.eventTab,...
                'Position',[0.01, 0.8, 0.2, 0.19],...
                'BorderType','beveledout',...
                'Title','Database entries:');
            
            gO.LBcontMenu = uicontextmenu(gO.mainFig);
            gO.entryListBox = uicontrol(gO.loadEntryPanel,...
                'Style','listbox',...
                'Units','normalized',...
                'Position',[0.01, 0.15, 0.98, 0.84],...
                'String','',...
                'UIContextMenu',gO.LBcontMenu);
            gO.LBcontMenuUpdate = uimenu(gO.LBcontMenu,'Text','Update list',...
                'Callback',@(h,e) gO.getDBlist(1));
            gO.LBcontMenuDelete = uimenu(gO.LBcontMenu,'Text','Delete selected entry',...
                'Callback',@(h,e) gO.deleteEntry(0));
            getDBlist(gO,1)           
            gO.loadEntryButton = uicontrol(gO.loadEntryPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.75, 0.01, 0.24, 0.1],...
                'String','Load',...
                'Callback',@ gO.loadEntryButtonPress);
            
            %% info panel
            gO.infoPanel = uipanel(gO.eventTab,...
                'Position',[0.01, 0.59, 0.2, 0.2],...
                'BorderType','beveledout',...
                'Title','Event info');
            gO.sourceFileLabel = uicontrol(gO.infoPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.01, 0.85, 0.2, 0.15],...
                'String','Source file:');
            gO.sourceFileTxt = uicontrol(gO.infoPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.22, 0.71, 0.77, 0.28],...
                'String','');
            gO.sourceChanDetTable = uitable(gO.infoPanel,...
                'Units','normalized',...
                'Position',[0.01, 0.01, 0.98, 0.7],...
                'ColumnWidth',{100,75},...
                'ColumnName',{'Chan/ROI#','Det#'},...
                'RowName',{'Ephys','Imaging'},...
                'Data',cell(2,2));
            
            %% param panel
            gO.paramPanel = uipanel(gO.eventTab,...
                'Position',[0.01, 0.01, 0.2, 0.58],...
                'BorderType','beveledout',...
                'Title','Event parameters');
            gO.ephysParamTable = uitable(gO.paramPanel,...
                'Units','normalized',...
                'Position',[0.01, 0.55, 0.98, 0.44],...
                'ColumnWidth',{100,150},...
                'ColumnName',{'Electrophysiology','Values'},...
                'RowName',{},...
                'CellSelectionCallback',@(h,e) paramTableHints(e));
            gO.imagingParamTable = uitable(gO.paramPanel,...
                'Units','normalized',...
                'Position',[0.01, 0.01, 0.98, 0.44],...
                'ColumnWidth',{100,150},...
                'ColumnName',{'Imaging','Values'},...
                'RowName',{},...
                'CellSelectionCallback',@(h,e) paramTableHints(e));
            
            %% plot panel
            gO.plotPanel = uipanel(gO.eventTab,...
                'Position',[0.22, 0.01, 0.775, 0.98],...
                'BorderType','beveledout',...
                'TItle','Graphs');
            
            gO.eventUpButton = uicontrol(gO.plotPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.95, 0.95, 0.045, 0.035],...
                'String','<HTML>Event&rarr',...
                'Callback',@(h,e) gO.changeCurrEv(1));
            gO.eventDwnButton = uicontrol(gO.plotPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.95, 0.9, 0.045, 0.035],...
                'String','<HTML>Event&larr',...
                'Callback',@(h,e) gO.changeCurrEv(-1));
            gO.parallelChanUpButton = uicontrol(gO.plotPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.95, 0.8, 0.045, 0.035],...
                'String','<HTML>ParChan&uarr',...
                'Callback',@(h,e) gO.changeCurrParallelChan(1),...
                'Visible','off');
            gO.parallelChanDwnButton = uicontrol(gO.plotPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.95, 0.7, 0.045, 0.035],...
                'String','<HTML>ParChan&darr',...
                'Callback',@(h,e) gO.changeCurrParallelChan(-1),...
                'Visible','off');
            gO.showAvgParallelChanButton = uicontrol(gO.plotPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.95, 0.75, 0.045, 0.035],...
                'String','Avg Par.',...
                'Tooltip','Average of parallel time windows',...
                'Callback',@(h,e) gO.changeCurrParallelChan(0),...
                'Visible','off');
            
            gO.ax11 = axes(gO.plotPanel,'Position',[0.1, 0.2, 0.8, 0.6],...
                'Visible','off',...
                'Tag','axGroup1');
            gO.ax11.Toolbar.Visible = 'on';
            gO.ax21 = axes(gO.plotPanel,'Position',[0.1, 0.55, 0.8, 0.4],...
                'Visible','off',...
                'Tag','axGroup2');
            gO.ax21.Toolbar.Visible = 'on';
            gO.ax22 = axes(gO.plotPanel,'Position',[0.1, 0.06, 0.8, 0.4],...
                'Visible','off',...
                'Tag','axGroup2');
            gO.ax22.Toolbar.Visible = 'on';
            gO.ax31 = axes(gO.plotPanel,'Position',[0.1, 0.71, 0.8, 0.25],...
                'Visible','off',...
                'Tag','axGroup3');
            gO.ax31.Toolbar.Visible = 'on';
            gO.ax32 = axes(gO.plotPanel,'Position',[0.1, 0.38, 0.8, 0.25],...
                'Visible','off',...
                'Tag','axGroup3');
            gO.ax32.Toolbar.Visible = 'on';
            gO.ax33 = axes(gO.plotPanel,'Position',[0.1, 0.05, 0.8, 0.25],...
                'Visible','off',...
                'Tag','axGroup3');
            gO.ax33.Toolbar.Visible = 'on';
            gO.ax41 = axes(gO.plotPanel,'Position',[0.2, 0.8, 0.7, 0.175],...
                'Visible','off',...
                'Tag','axGroup4');
            gO.ax41.Toolbar.Visible = 'on';
            gO.ax42 = axes(gO.plotPanel,'Position',[0.2, 0.55, 0.7, 0.175],...
                'Visible','off',...
                'Tag','axGroup4');
            gO.ax42.Toolbar.Visible = 'on';
            gO.ax43 = axes(gO.plotPanel,'Position',[0.2, 0.3, 0.7, 0.175],...
                'Visible','off',...
                'Tag','axGroup4');
            gO.ax43.Toolbar.Visible = 'on';
            gO.ax44 = axes(gO.plotPanel,'Position',[0.2, 0.05, 0.7, 0.175],...
                'Visible','off',...
                'Tag','axGroup4');
            gO.ax44.Toolbar.Visible = 'on';
            gO.ax51 = axes(gO.plotPanel,'Position',[0.25, 0.85, 0.6, 0.135],...
                'Visible','off',...
                'Tag','axGroup5');
            gO.ax51.Toolbar.Visible = 'on';
            gO.ax52 = axes(gO.plotPanel,'Position',[0.25, 0.65, 0.6, 0.135],...
                'Visible','off',...
                'Tag','axGroup5');
            gO.ax52.Toolbar.Visible = 'on';
            gO.ax53 = axes(gO.plotPanel,'Position',[0.25, 0.45, 0.6, 0.135],...
                'Visible','off',...
                'Tag','axGroup5');
            gO.ax53.Toolbar.Visible = 'on';
            gO.ax54 = axes(gO.plotPanel,'Position',[0.25, 0.25, 0.6, 0.135],...
                'Visible','off',...
                'Tag','axGroup5');
            gO.ax54.Toolbar.Visible = 'on';
            gO.ax55 = axes(gO.plotPanel,'Position',[0.25, 0.05, 0.6, 0.135],...
                'Visible','off',...
                'Tag','axGroup5');
            gO.ax55.Toolbar.Visible = 'on';
            
            
            %% statistics Tab ---------------------------------------------
            
            %% dataPanel
            gO.dataPanel = uipanel(gO.statTab,...
                'Position',[0, 0, 0.49, 1],...
                'BorderType','beveledout',...
                'TItle','Data panel');
            gO.statSelectPopMenu = uicontrol(gO.dataPanel,...
                'Style','popupmenu',...
                'Units','normalized',...
                'Position',[0.01, 0.95, 0.3, 0.025],...
                'String',{'--Select statistic!--','Basic statistical parameters','One-sample t-Test','Two-sample t-Test'},...
                'Callback',@ gO.statSelectPopMenuCB);
            gO.db4StatListBox = uicontrol(gO.dataPanel,...
                'Style','listbox',...
                'Units','normalized',...
                'Position',[0.01,0.75,0.3,0.19],...
                'String','',...
                'Callback',@ gO.db4StatListBoxCB,...
                'Enable','off');
            getDBlist(gO,2)
            gO.statLaunchButton = uicontrol(gO.dataPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.01, 0.7, 0.15, 0.025],...
                'String','Launch',...
                'Callback',@ gO.statLaunchButtonPress);
            
            gO.basicStatParamPanel = uipanel(gO.dataPanel,...
                'Position',[0, 0, 1, 0.65],...
                'BorderType','beveledout',...
                'Title','Basic statistical parameters',...
                'Visible','off');
            gO.basicStatParamTableBig = uitable(gO.basicStatParamPanel,...
                'Units','normalized',...
                'Position',[0.01, 0.01, 0.98, 0.98],...
                'Visible','off',...
                'RowName','');
            gO.basicStatParamTable1 = uitable(gO.basicStatParamPanel,...
                'Units','normalized',...
                'Position',[0.01, 0.51, 0.98, 0.48],...
                'Visible','off',...
                'RowName','');
            gO.basicStatParamTable2 = uitable(gO.basicStatParamPanel,...
                'Units','normalized',...
                'Position',[0.01, 0.01, 0.98, 0.48],...
                'Visible','off',...
                'RowName','');
            
            gO.tTestSetupPanel = uipanel(gO.dataPanel,...
                'Position',[0.33, 0.66, 0.66, 0.33],...
                'BorderType','beveledout',...
                'Title','t-Test Setup',...
                'Visible','off');
            gO.tTestCritPText = uicontrol(gO.tTestSetupPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.1, 0.85, 0.5, 0.1],...
                'String','Critical p-value');
            gO.tTestCritPEdit = uicontrol(gO.tTestSetupPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.55, 0.85, 0.3, 0.1],...
                'String','0.05');
            gO.tTestMu0EphysTable = uitable(gO.tTestSetupPanel,...
                'Units','normalized',...
                'Position',[0.01, 0.1, 0.48, 0.7],...
                'RowName','',...
                'ColumnName',{'Electrophysiology',['Edit ',char(956),char(8320),' value']},...
                'Data',[],...
                'ColumnEditable',[false, true]);
            gO.tTestMu0ImagingTable = uitable(gO.tTestSetupPanel,...
                'Units','normalized',...
                'Position',[0.51, 0.1, 0.48, 0.7],...
                'RowName','',...
                'ColumnName',{'Imaging',['Edit ',char(956),char(8320),' value']},...
                'Data',[],...
                'ColumnEditable',[false, true]);
            
            gO.tTestResultPanel = uipanel(gO.dataPanel,...
                'Position',[0, 0, 1, 0.65],...
                'BorderType','beveledout',...
                'Title','t-Test Results',...
                'Visible','off');
            gO.tTestEphysResultTable = uitable(gO.tTestResultPanel,...
                'Units','normalized',...
                'Position',[0.1, 0.6, 0.8, 0.35],...
                'RowName','');
            gO.tTestImagingResultTable = uitable(gO.tTestResultPanel,...
                'Units','normalized',...
                'Position',[0.1, 0.2, 0.8, 0.35],...
                'RowName','');

            gO.tTestResultSummText = uicontrol(gO.tTestResultPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.1, 0.01, 0.8, 0.15],...
                'String','');
            
            %% graphPanel
            gO.graphPanel = uipanel(gO.statTab,...
                'Position',[0.51,0,0.49,1],...
                'BorderType','beveledout',...
                'Title','Graph panel');
            gO.statGraphDataListbox = uicontrol(gO.graphPanel,...
                'Style','listbox',...
                'Units','normalized',...
                'Position',[0.01,0.8,0.3,0.19],...
                'String','',...
                'Callback',@ gO.statGraphDataListboxCB,...
                'Enable','off');
            getDBlist(gO,2)
            gO.statGraphTypePopMenu = uicontrol(gO.graphPanel,...
                'Style','popupmenu',...
                'Units','normalized',...
                'Position',[0.4, 0.94, 0.4, 0.05],...
                'String',{'---Select plot type---','Histogram with fitted distribution','Boxplot'},...
                'Callback',@ gO.statGraphTypePopMenuCB);
            gO.statGraphParamSelPopMenu = uicontrol(gO.graphPanel,...
                'Style','popupmenu',...
                'Units','normalized',...
                'Position',[0.4, 0.88, 0.4, 0.05],...
                'String',{''});
            gO.statGraphPlotButton = uicontrol(gO.graphPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.4, 0.82, 0.4, 0.05],...
                'String','Create graph',...
                'Callback',@ gO.statGraphPlotButtonPress);
            gO.axStatTab = axes(gO.graphPanel,'Position',[0.1,0.1,0.8,0.65],...
                'Tag','axGroupStat');
                
        end
        
    end
end