classdef DAS < handle
    
    %% Initializing components
    properties (Access = private)
        mainfig
        
        MainTabOptionsMenu
        timedimChangeMenu
        showProcDataMenu
        showDetMarkersMenu
        showEphysDetMarkersMenu
        showEphysDetLegendMenu
        showImagingDetMarkersMenu
        showSimultMarkersMenu
        runPosModeMenu
        
        procTabOptionsMenu
        ephysLinkProcListBoxesMenu
        imagingLinkProcListBoxesMenu
        
        EvDetTabOptionsMenu
        ephysEventDetTabDataTypeMenu
        ephysEventDetTabFiltCutoffMenu
        eventDetTabWinSizeMenu
        imagingEventDetTabDataTypeMenu
        evDetTabYlimModeMenu
        showXtraDetFigsMenu
        showEventSpectroMenu
        
        procDataMenu
        showEphysProcInfoMenu
        showImagingProcInfoMenu
        
        SaveMenu
        SaveDetsMenu
        OpenDASeVMenu
        
        tabs
        maintab
        ephysProcTab
        imagingProcTab
        eventDetTab
        showProc
        
        %% Members of maintab
        Panel1Plot
        Panel2Plot
        Panel3Plot
        ModeselectionPanel
        ephysCheckBox
        imagingCheckBox
        runCheckBox
        importPanel
        ImportRHDButton
        ImportgorobjButton
        ImportruncsvButton
        importSettingsButton
        Dataselection1Panel
        DatasetListBoxLabel
        DatasetListBox
        Dataselection2Panel
        EphysListBoxLabel
        EphysListBox
        ImagingListBoxLabel
        ImagingListBox
        runSettingsPanel
        InputlicktimemsEditFieldLabel
        InputLickEditField
        LicksmsListBoxLabel
        LickTimesListBox       
        
        axes11
        axes21
        axes22
        axes31
        axes32
        
        axesPos1
        axesPos2
        axesPos3
        axesVeloc1
        axesVeloc2
        axesVeloc3
        
        %% Members of ephysProcTab
        ephysProcListBox
        ephysProcListBox2
        ephysProcListBox2ContMenu
        ephysProcListBox2ContMenuDel
        
        axesEphysProc1
        axesEphysProc2
        
        ephysProcPopMenu
        ephysProcSrcButtGroup
        ephysProcRawRadioButt
        ephysProcProcdRadioButt
        
        ephysArtSuppPanel
        ephysArtSuppTypePopMenu
        ephysArtSuppRefChanLabel
        ephysArtSuppRefChanEdit
        
        ephysFiltSettingsPanel
        filterTypePopMenu
        cutoffLabel
        w1Edit
        w2Edit
        filtOrderLabel
        filtOrderEdit
        ephysPeriodicFmaxLabel
        ephysPeriodicFmaxEdit
        ephysPeriodicFfundLabel
        ephysPeriodicFfundEdit
        ephysPeriodicStopbandWidthLabel
        ephysPeriodicStopbandWidthEdit
        ephysPeriodicPlotFFTCheckBox
        
        ephysSpectroPanel
        ephysSpectroFreqLimitLabel
        ephysSpectroFreqLimit1Edit
        ephysSpectroFreqLimit2Edit
        
        ephysSelNewIntervalsButton
        ephysRunProcButton
        
        %% Members of imagingProcTab
        imagingProcListBox
        imagingProcListBox2
        imagingProcListBox2ContMenu
        imagingProcListBox2ContMenuDel
        
        axesImagingProc1
        axesImagingProc2
        
        imagingProcPopMenu
        
        imagingProcSrcButtGroup
        imagingProcRawRadioButt
        imagingProcProcdRadioButt
        
        imagingFiltSettingsPanel
        imagingFilterTypePopMenu
        imagingFiltWinSizeText
        imagingFiltWinSizeEdit
        
        imagingRunProcButton
        
        %% Members of eventDetTab
        selIntervalsCheckBox
        
        ephysDetPopMenu
        ephysDetChSelListBox
        ephysDetUseProcDataCheckBox
        ephysDetRefChanLabel
        ephysDetRefChanEdit
        ephysDetArtSuppPopMenu
        
        ephysCwtDetPanel
        ephysCwtDetMinlenLabel
        ephysCwtDetMinlenEdit
        ephysCwtDetSdMultLabel
        ephysCwtDetSdMultEdit
        ephysCwtDetCutoffLabel
        ephysCwtDetW1Edit
        ephysCwtDetW2Edit
        ephysCwtDetRefValPopMenu
        ephysCwtDetPresetPopMenu
        ephysCwtDetPresetSaveButt
        ephysCwtDetPresetDelButt
        
        ephysAdaptDetPanel
        ephysAdaptDetStepLabel
        ephysAdaptDetStepEdit
        ephysAdaptDetMinwidthLabel
        ephysAdaptDetMinwidthEdit
        ephysAdaptDetMindistLabel
        ephysAdaptDetMindistEdit
        ephysAdaptDetRatioLabel
        ephysAdaptDetRatioEdit
        
        ephysDoGInstPowDetPanel
        ephysDoGInstPowDetFreqBandLabel
        ephysDoGInstPowDetW1Edit
        ephysDoGInstPowDetW2Edit
        ephysDoGInstPowDetSdMultLabel
        ephysDoGInstPowDetSdMultEdit
        ephysDoGInstPowDetMinLenLabel
        ephysDoGInstPowDetMinLenEdit
        ephysDogInstPowDetRefValPopMenu
        ephysDoGInstPowDetPresetPopMenu
        ephysDoGInstPowDetPresetSaveButt
        ephysDoGInstPowDetPresetDelButt
        
        ephysDetParamsPanel
        ephysDetParamsTable
        
        ephysDetRunButt
        ephysDetStatusLabel
        
        imagingDetPopMenu
        imagingDetChSelPopMenu
        imagingDetUseProcDataCheckBox
        
        imagingMeanSdDetPanel
        imagingMeanSdDetSdmultLabel
        imagingMeanSdDetSdmultEdit
        imagingMeanSdDetWinSizeLabel
        imagingMeanSdDetWinSizeEdit
        imagingMeanSdDetSlideAvgCheck
        
        imagingMlSpDetPanel
        imagingMlSpDetDFFSpikeText
        imagingMlSpDetDFFSpikeEdit
        imagingMlSpDetTauText
        imagingMlSpDetTauEdit
        imagingMlSpDetSigmaText
        imagingMlSpDetSigmaEdit
        
        
        imagingDetParamsPanel
        imagingDetParamsTable
        
        imagingDetRunButt
        imagingDetStatusLabel
        
        useRunData4DetsCheckBox
        useRunData4DetsPanel
        speedRange4DetsLabel
        speedRange4DetsEdit1
        speedRange4DetsEdit2
        minTimeInSpeedRangeLabel
        minTimeInSpeedRangeEdit
        
        simultDetPopMenu
        
        simultDetStandardPanel
        simultDetStandardDelayLabel
        simultDetStandardDelayEdit1
        simultDetStandardDelayEdit2
        
        simultDetRunButt
        simultDetStatusLabel
        
        axesEventDet1
        axesEventDet1UpButt
        axesEventDet1DownButt
        axesEventDet1ChanUpButt
        axesEventDet1ChanDownButt
        axesEventDet2
        axesEventDet2DetUpButt
        axesEventDet2DetDownButt
        axesEventDet2RoiUpButt
        axesEventDet2RoiDownButt
        
        delCurrEphysEventButton
        delCurrImagingEventButton
    end
    
    %% Initializing data stored in GUI
    properties (Access = private)
        timedim = 1;                        % Determines whether the guiobj uses seconds or milliseconds
        datatyp = [0, 0, 0];                % datatypes currently handled (ephys,imaging,running)
        showXtraDetFigs = 0;
        keyboardPressDtyp = 1;
        evDetTabSimultMode = 0;
        evDetTabYlimMode = 'global';
        simultFocusTyp = 1;                 % this stores from which datatype we are approaching
        mainTabPosPlotMode = 0;             % 0=absPos; 1=relPos
        doEphysDownSamp = 0;
        doEphysDownSamp_targetFs = 1250;
        importUpSamp = 0;
        importUpSamp_targetFs = 150;
        
        xtitle = 'Time [s]';
        
        rhdName
        ephys_data                          % Currently imported electrophysiology data
        ephys_downSampd = false;
        ephys_dogged
        ephys_instPowed
        % For storing processed electrophysiology data
        ephys_procced
        % Info on processed data
        ephys_proccedInfo = struct('Channel',{},'ProcDetails',{});
        ephys_artSupp4Det = 0;
        ephys_artSuppedData4DetListInds
        ephys_prevIntervalSel = [];
        ephys_detections                    % Location of detections on time axis
        ephys_globalDets
        ephys_eventComplexes = {};          % Event numbers for each detected complex (e.g. doublet, triplet,...)
        ephys_detBorders
        ephys_detectionsInfo
        ephys_detParams 
        ephys_detMarkerSelection
        ephys_detRunsNum = 0;               % Number of detection runs
        ephys_currDetRun                       % Detection run currently active in detection tab
        ephys_dettypes = ["CWT based"; "Adaptive threshold"; "DoG+InstPow"];
        ephys_taxis                         % Time axis for electrophysiology data
        ephys_fs                            % Sampling frequency of electrophysiology data
        ephys_ylabel = 'Voltage [\muV]';
        ephys_select                        % Currently selected channel
        ephys_datanames = {};             % Names of the imported electrophysiology data
        ephys_procdatanames = {};
        ephys_presets
        
        imaging_data                        % Currently imported imaging data
        imaging_upSampd = false;
        imaging_smoothed
        imaging_procced
        imaging_proccedInfo = struct('ROI',{},'ProcDetails',{});
        imaging_artSupp4Det = 0;
        imaging_artSuppedData4DetListInds
        imaging_detections
        imaging_globalDets
        imaging_eventComplexes = {};
        imaging_detBorders
        imaging_detParams
        imaging_detectionsInfo
        imaging_detMarkerSelection
        imaging_detRunsNum = 0;             % Number of detection runs
        imaging_currDetRun
        imaging_dettypes = ["Mean+SD"];
        imaging_taxis                       % Time axis for imaging data
        imaging_fs                          % Sampling frequency of imaging data
        imaging_ylabel = '\DeltaF/F';
        imaging_select                         % Currently selected ROI
        imaging_datanames = {};              % Names of the imported imaging data
        imaging_procDatanames = {};
        imaging_presets
        
        run_absPos                          % absolute position
        run_lap
        run_relPos
        run_veloc                           % Running velocity
        run_licks
        run_taxis                           % Time axis for running data
        run_fs                              % Sampling frequency of running data
        run_absPos_ylabel = 'Pos [cm]';
        run_relPos_ylabel = 'Pos [Lap%]';
        run_veloc_ylabel = 'Velocity [cm/s]';
        
        simult_detections
        simult_detectionsInfo
        simult_detParams
        simult_detRunsNum = 0;
        simult_detMarkerSelection
        
        eventDet1CurrIdx = 1;               % # in the dets array
        eventDet1CurrDet = 1;               % index of detection marker on one channel
        eventDet1CurrChan = 1;              % currently selected channel from data
        eventDet1DataType = 1;              % Type of data to show in eventdetTab
                                            % 1-Raw; 2-DoG; 3-InstPow
        eventDet1W1 = 150;
        eventDet1W2 = 250;
        eventDet1Win = 500;
        
        eventDet2CurrIdx = 1;
        eventDet2CurrDet = 1;
        eventDet2CurrRoi = 1;
        eventDet2DataType = 1;
        
        eventDet2GwinSize = 30;
        eventDet2Win = 500;
        
        eventDetSim1CurrDet = 1;
        eventDetSim1CurrChan = 1;
        eventDetSim2CurrDet = 1;
        eventDetSim2CurrRoi = 1;
        
    end
    
    %% constructor part
    methods (Access = public)
        % Constructor function
        function guiobj = DAS
            createComponents(guiobj)
            mainFigOpenFcn(guiobj)
            drawnow
            guiobj.mainfig.Visible = 'on';
            
            if nargout == 0
                clear guiobj
            end
        end
    end
    
    %% Helper functions
    methods (Access = private)
        
        %%
        function ephysplot(guiobj,ax,index)
            if isempty(index) | index == 0
                return
            end
            
            if isempty(guiobj.ephys_data)
                return
            end
            
            axParent = ax.Parent;
            if isempty(findobj(axParent,'Type','line'))
                ax.NextPlot = 'replace';
                firstplot = true;
            else
                ax.NextPlot = 'replacechildren';
                firstplot = false;
            end
            
            rawProc2Plot = [false, false];
            
            switch guiobj.tabs.SelectedTab.Title
                case 'Main tab'
                    % Separating incoming indices into raw/processed
                    rawInds = index(index <= size(guiobj.ephys_data,1));
                    procInds = index(index > size(guiobj.ephys_data,1));
                    procInds = procInds - size(guiobj.ephys_data,1);
                    
                    if ~isempty(rawInds)
                        rawProc2Plot(1) = true;
                        plot(ax,guiobj.ephys_taxis,guiobj.ephys_data(rawInds,:))
                        hold(ax,'on')
                        dataname = guiobj.ephys_datanames(rawInds);
                    end
                    if ~isempty(procInds)
                        rawProc2Plot(2) = true;
                        plot(ax,guiobj.ephys_taxis,guiobj.ephys_procced(procInds,:))
                        hold(ax,'on')
                        dataname = guiobj.ephysProcListBox2.String{procInds};
                    end
                    ax.NextPlot = 'replacechildren';
                    
                    if firstplot
                        setXlims(guiobj)
                    end
                case 'Electrophysiology data processing'
                    if ax == guiobj.axesEphysProc1
                        rawProc2Plot(1) = true;
                        rawInds = index;
                        plot(ax,guiobj.ephys_taxis,...
                            guiobj.ephys_data(index,:))
                        dataname = guiobj.ephys_datanames(index);
                    elseif ax == guiobj.axesEphysProc2
                        rawProc2Plot(2) = true;
                        procInds = index;
                        plot(ax,guiobj.ephys_taxis,...
                            guiobj.ephys_procced(index,:))
                        dataname = guiobj.ephys_procdatanames(index);
                    end
                    
                    if firstplot
                        axis(ax,'tight')
                    end
            end

            if length(index) == 1
                title(ax,dataname,'Interpreter','none')
            elseif length(index) > 1
                switch sum(rawProc2Plot)
                    case 1
                        if rawProc2Plot(1)
                            axTitle = ['Raw Channels: ', sprintf(' #%d', sort(rawInds))];
                        elseif rawProc2Plot(2)
                            axTitle = ['Proc Channels: ', sprintf(' #%d', [guiobj.ephys_proccedInfo(sort(procInds)).Channel])];
                        end
                        
                    case 2
                        axTitle = ['Raw Channels: ', sprintf(' #%d', sort(rawInds)),...
                            ' | Proc Channels: ', sprintf(' #%d', [guiobj.ephys_proccedInfo(sort(procInds)).Channel])];
                    
                end
                title(ax,axTitle)
            end
            xlabel(ax,guiobj.xtitle)
            ylabel(ax,guiobj.ephys_ylabel)
        end
                
        %%
        function imagingplot(guiobj,ax,index)
            if isempty(index) | index == 0
                return
            end
            
            if isempty(guiobj.imaging_data)
                return
            end
            
            axParent = ax.Parent;
            if isempty(findobj(axParent,'Type','line'))
                ax.NextPlot = 'replace';
                firstplot = true;
            else
                ax.NextPlot = 'replacechildren';
                firstplot = false;
            end
            
            rawProc2Plot = [false, false];
            
            switch guiobj.tabs.SelectedTab.Title
                case 'Main tab'
                    % Separating incoming indices into raw/processed
                    rawInds = index(index <= size(guiobj.imaging_data,1));
                    procInds = index(index > size(guiobj.imaging_data,1));
                    procInds = procInds - size(guiobj.imaging_data,1);
                                        
                    if ~isempty(rawInds)
                        rawProc2Plot(1) = true;
                        plot(ax,guiobj.imaging_taxis,guiobj.imaging_data(rawInds,:))
                        hold(ax,'on')
                        dataname = guiobj.imaging_datanames(rawInds);
                    end
                    if ~isempty(procInds)
                        rawProc2Plot(2) = true;
                        plot(ax,guiobj.imaging_taxis,guiobj.imaging_procced(procInds,:))
                        hold(ax,'on')
                        dataname = guiobj.imagingProcListBox2.String{procInds};
                    end
                    ax.NextPlot = 'replacechildren';

                case 'Imaging data processing'
                    if ax == guiobj.axesImagingProc1
                        rawProc2Plot(1) = true;
                        rawInds = index;
                        plot(ax,guiobj.imaging_taxis,...
                            guiobj.imaging_data(index,:))
                        dataname = guiobj.imaging_datanames(index);
                    elseif ax == guiobj.axesImagingProc2
                        rawProc2Plot(2) = true;
                        procInds = index;
                        plot(ax,guiobj.imaging_taxis,...
                            guiobj.imaging_procced(index,:))
                        dataname = guiobj.imaging_procDatanames(index);
                    end
            end
            
            if firstplot
                setXlims(guiobj)
            end
            
            if length(index) == 1
                title(ax,dataname,'Interpreter','none')
            elseif length(index) > 1
                switch sum(rawProc2Plot)
                    case 1
                        if rawProc2Plot(1)
                            axTitle = ['Raw ROIs: ', sprintf(' #%d', sort(rawInds))];
                        elseif rawProc2Plot(2)
                            axTitle = ['Proc ROIs: ', sprintf(' #%d', [guiobj.imaging_proccedInfo(sort(procInds)).ROI])];
                        end
                        
                    case 2
                        axTitle = ['Raw ROIs: ', sprintf(' #%d', sort(rawInds)),...
                            ' | Proc ROIs: ', sprintf(' #%d', [guiobj.imaging_proccedInfo(sort(procInds)).ROI])];
                    
                end
                title(ax,axTitle)
            end
            xlabel(ax,guiobj.xtitle)
            ylabel(ax,guiobj.imaging_ylabel);
        end
        
        %%
        function runposplot(guiobj)
            switch sum(guiobj.datatyp)
                case 1
                    ax = guiobj.axesPos1;
                case 2
                    ax = guiobj.axesPos2;
                case 3 
                    ax = guiobj.axesPos3;
            end
            
            axParent = ax.Parent;
            if isempty(findobj(axParent,'Type','line'))
                firstplot = true;
                ax.NextPlot = 'replace';
            else
                ax.NextPlot = 'replacechildren';
                firstplot = false;
            end
            
            switch guiobj.mainTabPosPlotMode 
                case 0
                    plot(ax,guiobj.run_taxis,guiobj.run_absPos)
                    ylabel(ax,guiobj.run_absPos_ylabel)
                    title(ax,'Absolute position')
                case 1
                    plot(ax,guiobj.run_taxis,guiobj.run_relPos)
                    ylabel(ax,guiobj.run_relPos_ylabel)
                    title(ax,'Relative position')
            end
            xlabel(ax,guiobj.xtitle)
            
            if firstplot
                ax.NextPlot = 'replacechildren';
            end
            
        end
        
        %%
        function runvelocplot(guiobj)
            switch sum(guiobj.datatyp)
                case 1
                    ax = guiobj.axesVeloc1;
                case 2
                    ax = guiobj.axesVeloc2;
                case 3 
                    ax = guiobj.axesVeloc3;
            end
            
            axParent = ax.Parent;
            if isempty(findobj(axParent,'Type','line'))
                firstplot = true;
                ax.NextPlot = 'replace';
            else
                ax.NextPlot = 'replacechildren';
                firstplot = false;
            end
            
            plot(ax,guiobj.run_taxis,guiobj.run_veloc)
            title(ax,'Running velocity','Interpreter','none')
            xlabel(ax,guiobj.xtitle)
            ylabel(ax,guiobj.run_veloc_ylabel)
            
            if firstplot
                ax.NextPlot = 'replacechildren';
            end
        end
        
        %%
        function plotpanelswitch(guiobj)
            zum = zoom(guiobj.mainfig);
            panobj = pan(guiobj.mainfig);
            
            if guiobj.runCheckBox.Value
                switch sum(guiobj.datatyp)
                    case 1
                        guiobj.Panel1Plot.Visible = 'on';
                        guiobj.Panel2Plot.Visible = 'off';
                        guiobj.Panel3Plot.Visible = 'off';
                        cla(guiobj.axes11)
                        guiobj.axes11.Visible = 'off';
                        guiobj.axesPos1.Visible = 'on';
                        guiobj.axesVeloc1.Visible = 'on';
                        
                        runposplot(guiobj)
                        runvelocplot(guiobj)
                    case 2
                        guiobj.Panel1Plot.Visible = 'off';
                        cla(guiobj.axes22)
                        guiobj.axes22.Visible = 'off';
                        guiobj.axesPos2.Visible = 'on';
                        guiobj.axesVeloc2.Visible = 'on';
                        guiobj.Panel2Plot.Visible = 'on';
                        guiobj.Panel3Plot.Visible = 'off';
                        
                        runposplot(guiobj)
                        runvelocplot(guiobj)
                        
                        % Plotting previously selected data
                        if guiobj.datatyp(1)
                            ephysplot(guiobj,guiobj.axes21,...
                                guiobj.ephys_select)
                        elseif guiobj.datatyp(2)
                            imagingplot(guiobj,guiobj.axes21,...
                                guiobj.imaging_select)
                        end
                    case 3
                        guiobj.Panel1Plot.Visible = 'off';
                        guiobj.Panel2Plot.Visible = 'off';
                        guiobj.Panel3Plot.Visible = 'on';
                        
                        runposplot(guiobj)
                        runvelocplot(guiobj)
                        
                        ephysplot(guiobj,guiobj.axes31,guiobj.ephys_select)
                        imagingplot(guiobj,guiobj.axes32,guiobj.imaging_select)
                end
            elseif ~guiobj.runCheckBox.Value
                switch sum(guiobj.datatyp)
                    case 1
                        guiobj.Panel1Plot.Visible = 'on';
                        guiobj.Panel2Plot.Visible = 'off';
                        guiobj.Panel3Plot.Visible = 'off';
                        cla(guiobj.axesPos1)
                        guiobj.axesPos1.Visible = 'off';
                        cla(guiobj.axesVeloc1)
                        guiobj.axesVeloc1.Visible = 'off';
                        guiobj.axes11.Visible = 'on';
                        
                        if guiobj.datatyp(1)
                            ephysplot(guiobj,guiobj.axes11,...
                                guiobj.ephys_select)
                        elseif guiobj.datatyp(2)
                            imagingplot(guiobj,guiobj.axes11,...
                                guiobj.imaging_select)
                        end
                    case 2
                        guiobj.Panel1Plot.Visible = 'off';
                        cla(guiobj.axesPos2)
                        guiobj.axesPos2.Visible = 'off';
                        cla(guiobj.axesVeloc2)
                        guiobj.axesVeloc2.Visible = 'off';
                        guiobj.axes22.Visible = 'on';
                        guiobj.Panel2Plot.Visible = 'on';
                        guiobj.Panel3Plot.Visible = 'off';
                        
                        ephysplot(guiobj,guiobj.axes21,guiobj.ephys_select)
                        imagingplot(guiobj,guiobj.axes22,guiobj.imaging_select)
                    case 3
                        warndlg('Something isn''t right')
                end
            end
            
            allAx = findobj(guiobj.mainfig,'Type','axes');
            actAx = findobj(allAx,'Visible','on');
            actAx = findobj(actAx,'Type','axes');
            inactAx = findobj(allAx,'Visible','off');
            inactAx = findobj(inactAx,'Type','axes');
            setAllowAxesZoom(zum,actAx,true)
            setAllowAxesZoom(zum,inactAx,false)
            setAllowAxesPan(panobj,actAx,true)
            setAllowAxesPan(panobj,inactAx,false)
            
        end
        
        %% 
        function setXlims(guiobj)
                        
            if sum(guiobj.datatyp)==0
                return
            end
            
            if isempty(guiobj.ephys_taxis)
                eTaxis = [0,0];
            else
                eTaxis = [guiobj.ephys_taxis(1),guiobj.ephys_taxis(end)];
            end
            if isempty(guiobj.imaging_taxis)
                iTaxis = [0,0];
            else
                iTaxis = [guiobj.imaging_taxis(1),guiobj.imaging_taxis(end)];
            end
            if isempty(guiobj.run_taxis)
                rTaxis = [0,0];
            else
                rTaxis = [guiobj.run_taxis(1),guiobj.run_taxis(end)];
            end
            [~,minInd] = min([eTaxis(1),iTaxis(1),rTaxis(1)]);
            [~,maxInd] = max([eTaxis(2),iTaxis(2),rTaxis(2)]);
            xlimits = [0,0];
            switch minInd
                case 1
                    xlimits(1) = eTaxis(1);
                case 2
                    xlimits(1) = iTaxis(1);
                case 3
                    xlimits(1) = rTaxis(1);
            end
            switch maxInd
                case 1
                    xlimits(2) = eTaxis(2);
                case 2
                    xlimits(2) = iTaxis(2);
                case 3
                    xlimits(2) = rTaxis(2);
            end
            switch sum(guiobj.datatyp)
                case 1
                    ax = findobj(guiobj.Panel1Plot,'Type','axes');
                case 2
                    ax = findobj(guiobj.Panel2Plot,'Type','axes');
                case 3
                    ax = findobj(guiobj.Panel3Plot,'Type','axes');
            end
            
            axis(ax,'tight')
            set(ax,'XLim',xlimits)
            set(ax,'NextPlot','replacechildren')
            
        end
        
        %%
        function ephysDetMarkerPlot(guiobj,fromMenu)
            % fromMenu signals whether call is coming from menu press
            if nargin == 1
                fromMenu = 0;
            end
            ephysAxes = [];
            
            switch sum(guiobj.datatyp)
                case 1
                    if guiobj.datatyp(1)
                        ephysAxes = guiobj.axes11;
                    end
                case 2
                    if guiobj.datatyp(1)
                        ephysAxes = guiobj.axes21;
                    end
                case 3
                    if guiobj.datatyp(1)
                        ephysAxes = guiobj.axes31;
                    end
            end
            if isempty(ephysAxes)
                return
            end
            
            if fromMenu && strcmp(guiobj.showEphysDetMarkersMenu.Checked,'off')
                cla(ephysAxes)
                return
            end
            
            if strcmp(guiobj.showEphysDetMarkersMenu.Checked,'on')
                hold(ephysAxes,'on')
                
                detPlot(ephysAxes,guiobj.ephys_detections{guiobj.ephys_detMarkerSelection},[],guiobj.ephys_taxis,...
                    'stars','r',[])
            end
            
            ephysAxes.NextPlot = 'replacechildren';
        end
        
        %%
        function imagingDetMarkerPlot(guiobj,fromMenu)
            % fromMenu signals whether call is coming from menu press
            if nargin == 1
                fromMenu = 0;
            end
            imagingAxes = [];
            
            switch sum(guiobj.datatyp)
                case 1
                    if guiobj.datatyp(2)
                        imagingAxes = guiobj.axes11;
                    end
                case 2
                    if guiobj.datatyp(2) && guiobj.datatyp(1)
                        imagingAxes = guiobj.axes22;
                    else
                        imagingAxes = guiobj.axes21;
                    end
                case 3
                    if guiobj.datatyp(2)
                        imagingAxes = guiobj.axes32;
                    end
            end
            if isempty(imagingAxes)
                return
            end
            
            if fromMenu && strcmp(guiobj.showImagingDetMarkersMenu.Checked,'off')
                cla(imagingAxes)
                return
            end
            
            if strcmp(guiobj.showImagingDetMarkersMenu.Checked,'on')
                hold(imagingAxes,'on')
                
                detPlot(imagingAxes,guiobj.imaging_detections{guiobj.imaging_detMarkerSelection},[],guiobj.imaging_taxis,...
                    'stars','r',[])
                
                imagingAxes.NextPlot = 'replacechildren';
            end
            
        end
        
        %%
        function simultDetMarkerPlot(guiobj,fromMenu)
            % fromMenu signals whether call is coming from menu press
            if nargin == 1
                fromMenu = 0;
            end
            ax = [];
            
            switch sum(guiobj.datatyp)
                case 1
                    return
                case 2
                    if guiobj.datatyp(2) && guiobj.datatyp(1)
                        ax = [guiobj.axes21, guiobj.axes22];
                    else
                        return
                    end
                case 3
                    ax = [guiobj.axes31, guiobj.axes32];
            end
            if isempty(ax)
                return
            end
            
            for i = 1:length(ax)
                if fromMenu && strcmp(guiobj.showSimultMarkersMenu.Checked,'off')
                    cla(ax(i))
                    return
                end
                
                if strcmp(guiobj.showSimultMarkersMenu.Checked,'on')
                    hold(ax(i),'on')
                    for j = 1:size(guiobj.simult_detections,1)
%                         plot(ax(i),guiobj.ephys_taxis,guiobj.simult_detections(j,:),...
%                             'k*','MarkerSize',12)
                        simDets = guiobj.simult_detections(j,1:2);
                        simDets = guiobj.ephys_detections{simDets(1)}(simDets(2));
                        detPlot(ax(i),simDets,[],guiobj.ephys_taxis,'stars','r',[])
                    end
                    ax(i).NextPlot = 'replacechildren';
                end
            end
            
        end
        
        %%
        function smartplot(guiobj)
            dtyp = guiobj.datatyp;
            switch guiobj.tabs.SelectedTab.Title
                case 'Main tab'
                    switch sum(dtyp)
                        case 1
                            if dtyp(1)
                                ephysplot(guiobj,guiobj.axes11,guiobj.ephys_select)
                            elseif dtyp(2)
                                imagingplot(guiobj,guiobj.axes11,guiobj.imaging_select)
                            elseif dtyp(3)
                                runposplot(guiobj)
                                runvelocplot(guiobj)
                            end
                        case 2
                            if dtyp(1)
                                ephysplot(guiobj,guiobj.axes21,guiobj.ephys_select)
                            end
                            if dtyp(2) && dtyp(1)
                                imagingplot(guiobj,guiobj.axes22,guiobj.imaging_select)
                            elseif dtyp(2) && ~dtyp(1)
                                imagingplot(guiobj,guiobj.axes21,guiobj.imaging_select)
                            end
                            if dtyp(3)
                                runposplot(guiobj)
                                runvelocplot(guiobj)
                            end
                        case 3
                            ephysplot(guiobj,guiobj.axes31,guiobj.ephys_select)
                            imagingplot(guiobj,guiobj.axes32,guiobj.imaging_select)
                            runposplot(guiobj)
                            runvelocplot(guiobj)
                    end
                case 'Electrophysiology data processing'
                    ephysplot(guiobj,guiobj.axesEphysProc1,...
                        guiobj.ephys_select)
            end
            
%             setXlims(guiobj)
        end
        
        %%
        function eventDetPlotFcn(guiobj,dTyp,forSpectro,clrAx)
            if (nargin > 3) && clrAx
                switch dTyp
                    case 1
                        cla(guiobj.axesEventDet1,'reset');
                        guiobj.ephysDetParamsTable.Data = '';
                    case 2
                        cla(guiobj.axesEventDet2,'reset');
                        guiobj.imagingDetParamsTable.Data = '';
                end
                return
            end
            
            if nargin < 3
                forSpectro = 0;
            end
            
            switch dTyp
                case 1
                    ax = guiobj.axesEventDet1;
                    
                    switch guiobj.eventDet1DataType
                        case 1
                            if guiobj.ephys_artSupp4Det == 0
                                data = guiobj.ephys_data;
                            else
                                data = guiobj.ephys_procced(guiobj.ephys_artSuppedData4DetListInds,:);
                            end
                        case 2
                            data = guiobj.ephys_dogged;
                        case 3
                            data = guiobj.ephys_instPowed;
                    end
                    taxis = guiobj.ephys_taxis;
                    fs = guiobj.ephys_fs;
                    win = guiobj.eventDet1Win;
                    
                    yAxLbl = guiobj.ephys_ylabel;
                    plotTitle = 'Channel #';
                    simultDetNum = guiobj.eventDetSim1CurrDet;
                case 2
                    ax = guiobj.axesEventDet2;
                    
                    switch guiobj.eventDet2DataType
                        case 1
                            if guiobj.imaging_artSupp4Det == 0
                                data = guiobj.imaging_data;
                            else
                                data = guiobj.imaging_procced(guiobj.imaging_artSuppedData4DetListInds,:);
                            end
                        case 2
                            data = guiobj.imaging_smoothed;     
                    end
                    taxis = guiobj.imaging_taxis;
                    fs = guiobj.imaging_fs;
                    win = guiobj.eventDet2Win;
                    
                    yAxLbl = guiobj.imaging_ylabel;
                    plotTitle = 'ROI #';
                    simultDetNum = guiobj.eventDetSim2CurrDet;
            end
            
            [numDets,~,detNum,detInd,detBorders,chan,detParams] = extractDetStructs(guiobj,dTyp);
            if dTyp == 1
                if guiobj.ephys_artSupp4Det == 0
                    chanName = chan;
                    chanInd = chan;
                else
                    chanName = chan;
                    temp = guiobj.ephys_proccedInfo(guiobj.ephys_artSuppedData4DetListInds);
                    chanInd = find([temp.Channel] == chanName);
                end
            end
            if dTyp == 2
                if guiobj.imaging_artSupp4Det == 0
                    chanName = chan;
                    chanInd = chan;
                else
                    chanName = chan;
                    temp = guiobj.imaging_proccedInfo(guiobj.imaging_artSuppedData4DetListInds);
                    chanInd = find([temp.ROI] == chanName);
                end
            end
            if guiobj.evDetTabSimultMode
                if dTyp == 1
                    simDtyp = 2;
                    simTaxis = guiobj.imaging_taxis;
                    simFs = guiobj.imaging_fs;
                else
                    simDtyp = 1;
                    simTaxis = guiobj.ephys_taxis;
                    simFs = guiobj.ephys_fs;
                end
                [~,~,~,~,simDetBorders,~,~] = extractDetStructs(guiobj,simDtyp);
            end
            
%             if guiobj.evDetTabYlimMode == "global"
%                 axYMinMax = [min(data(chanInd,:)), max(data(chanInd,:))];
%             elseif guiobj.evDetTabYlimMode == "window"
%                 axYMinMax = [];
%             end
            
            switch dTyp
                case 1
                    if ~isempty(detParams)
                        temp = [fieldnames([detParams]), squeeze(struct2cell([detParams]))];
                        guiobj.ephysDetParamsTable.Data = temp;
                        guiobj.ephysDetParamsTable.RowName = [];
                        guiobj.ephysDetParamsTable.ColumnName = {'Electrophysiology','Values'};
                    end
                case 2
                    if ~isempty(detParams)
                        temp = [fieldnames([detParams]), squeeze(struct2cell([detParams]))];
                        guiobj.imagingDetParamsTable.Data = temp;
                        guiobj.imagingDetParamsTable.RowName = [];
                        guiobj.imagingDetParamsTable.ColumnName = {'Imaging','Values'};
                    end
            end

            tStamp = taxis(detInd);
%             win = guiobj.eventDet1Win/2000;
            win = win/2000;
            win = round(win*fs,0);
            if guiobj.evDetTabSimultMode
                simWin = guiobj.eventDet1Win/2000;
                simWin = round(simWin*simFs,0);
                
            end
            
            if ~isempty(detBorders)
                if guiobj.evDetTabSimultMode
                    winStart = max(0, detBorders(1)-win);
                    winEnd = min(length(taxis), detBorders(2)+win);
                    simWinStart = max(0, simDetBorders(1)-simWin);
                    simWinEnd = min(length(simTaxis), simDetBorders(2)+simWin);
                    if taxis(winStart) > simTaxis(simWinStart)
                        winStart = find(taxis > simTaxis(simWinStart), 1);
                    end
                    if taxis(winEnd) < simTaxis(simWinEnd)
                        winEnd = find(taxis > simTaxis(simWinEnd), 1);
                    end
                else
                    winStart = detBorders(1)-win;
                    winEnd = detBorders(2)+win;
                end
                if (winStart>0) & (winEnd <= length(taxis))
                    tWin = taxis(winStart:winEnd);
                    dataWin = data(chanInd,winStart:winEnd);
                    winInds = winStart:winEnd;
                elseif winStart <= 0
                    tWin = taxis(1:winEnd);
                    dataWin = data(chanInd,1:winEnd);
                    winInds = 1:winEnd;
                elseif winEnd > length(taxis)
                    tWin = taxis(winStart:end);
                    dataWin = data(chanInd,winStart:end);
                    winInds = winStart:length(taxis);
                end
            else
                if (detInd-win > 0) & (detInd+win <= length(taxis))
                    tWin = taxis(detInd-win:detInd+win);
                    dataWin = data(chanInd,detInd-win:detInd+win);
                elseif detInd-win <= 0
                    tWin = taxis(1:detInd+win);
                    dataWin = data(chanInd,1:detInd+win);
                elseif detInd+win > length(taxis)
                    tWin = taxis(detInd-win:end);
                    dataWin = data(chanInd,detInd-win:end);
                end
            end
            
            if forSpectro
                try
                    w1 = guiobj.ephys_detectionsInfo.DetSettings.W1;
                    w2 = guiobj.ephys_detectionsInfo.DetSettings.W2;
                catch
                    w1 = 150;
                    w2 = 250;
                    warning('Cutoff frequencies set to default 150-250')
                end
                
                if guiobj.ephys_artSupp4Det == 0
                    spectrogramMacher(guiobj.ephys_data(chanInd,winInds),fs,w1,w2)
                else
                    spectrogramMacher(data(chanInd,winInds),fs,w1,w2)
                end
                
            elseif ~forSpectro
                plot(ax,tWin,dataWin)
                hold(ax,'on')
                xline(ax,tStamp,'Color','g','LineWidth',1);
                if ~isempty(detBorders)
                    xline(ax,taxis(detBorders(1)),'--b','LineWidth',1);
                    xline(ax,taxis(detBorders(2)),'--b','LineWidth',1);
                    hL = dataWin;
                    temp1 = find(tWin==taxis(detBorders(1)));
                    temp2 = find(tWin==taxis(detBorders(2)));
                    hL(1:temp1-1) = nan;
                    hL(temp2+1:end) = nan;
                    plot(ax,tWin,hL,'-r','LineWidth',0.75)
                end
                hold(ax,'off')
                axis(ax,'tight')
                if strcmp(guiobj.evDetTabYlimMode, 'global')
                    axYMinMax = [min(data(chanInd,:)), max(data(chanInd,:))];
                    ylim(ax,axYMinMax)
                elseif strcmp(guiobj.evDetTabYlimMode, 'window')
                    ylim(ax,'auto')
                end
                xlabel(ax,guiobj.xtitle)
                ylabel(ax,yAxLbl);
                
                switch dTyp
                    case 1
                        if ~isempty(guiobj.ephys_globalDets)
                            globEvNum = find(guiobj.ephys_globalDets(:,guiobj.eventDet1CurrChan) == detNum);
                        else
                            globEvNum = [];
                        end
                        
                    case 2
                        if ~isempty(guiobj.imaging_globalDets)
                            globEvNum = find(guiobj.imaging_globalDets(:,guiobj.eventDet2CurrRoi) == detNum);
                        else
                            globEvNum = [];
                        end
                        
                end
                if ~isempty(globEvNum)
                    globEvTxt = [' (Global event #',num2str(globEvNum),')'];
                else
                    globEvTxt = '';
                end
                
                if ~guiobj.evDetTabSimultMode
                    title(ax,[plotTitle,num2str(chanName),'      Detection #',num2str(detNum),...
                        '/',num2str(numDets), globEvTxt])
                else
                    title(ax,[plotTitle,num2str(chanName),'      Simultan Detection #',num2str(simultDetNum),...
                        '/',num2str(numDets),' (nonSimult #',num2str(detNum),')', globEvTxt])
                end
            end
            
        end
        
        %%
        function eventDetAxesButtFcn(guiobj,dTyp,chanUpDwn,detUpDwn)
            if (dTyp == 1) && (isempty(guiobj.ephys_detections) || ~sum(~cellfun('isempty',guiobj.ephys_detections)))
                return
            elseif (dTyp == 2) && (isempty(guiobj.imaging_detections) || ~sum(~cellfun('isempty',guiobj.imaging_detections)))
                return
            end
            
            switch guiobj.evDetTabSimultMode
                case 0
                    switch dTyp
                        case 1
                            currChan = guiobj.eventDet1CurrChan;
                            currDet = guiobj.eventDet1CurrDet;
                        case 2
                            currChan = guiobj.eventDet2CurrRoi;
                            currDet = guiobj.eventDet2CurrDet;
                    end
                case 1
                    switch dTyp
                        case 1
                            currChan = guiobj.eventDetSim1CurrChan;
                            currDet = guiobj.eventDetSim1CurrDet;
                        case 2
                            currChan = guiobj.eventDetSim2CurrRoi;
                            currDet = guiobj.eventDetSim2CurrDet;
                    end
            end
            
            if nargin > 2
                if (chanUpDwn==0) & (detUpDwn==0)
                    currDet = 1;
                    currChan = 1;
                else
                    [numDets,numChans] = extractDetStructs(guiobj,dTyp);
                end

                switch chanUpDwn
                    case 0

                    case 1
                        if currChan < numChans
                            currChan = currChan + 1;
                            currDet = 1;
                        end
                    case -1
                        if currChan > 1
                            currChan = currChan - 1;
                            currDet = 1;
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
            
            switch guiobj.evDetTabSimultMode
                case 0
                    switch dTyp
                        case 1
                            guiobj.eventDet1CurrDet = currDet;
                            guiobj.eventDet1CurrChan = currChan;
                        case 2
                            guiobj.eventDet2CurrDet = currDet;
                            guiobj.eventDet2CurrRoi = currChan;
                    end
                    eventDetPlotFcn(guiobj,dTyp)
                case 1
                    switch dTyp
                        case 1
                            guiobj.eventDetSim1CurrDet = currDet;
                            guiobj.eventDetSim1CurrChan = currChan;
                            
                            eventDetPlotFcn(guiobj,1)
                            
                            if guiobj.simultFocusTyp==1
                                guiobj.eventDetSim2CurrDet = 1;
                                guiobj.eventDetSim2CurrRoi = 1;
                                eventDetPlotFcn(guiobj,2)
                            end
                            
                        case 2
                            guiobj.eventDetSim2CurrDet = currDet;
                            guiobj.eventDetSim2CurrRoi = currChan;
                            
                            eventDetPlotFcn(guiobj,2)
                            
                            if guiobj.simultFocusTyp==2
                                guiobj.eventDetSim1CurrDet = 1;
                                guiobj.eventDetSim1CurrChan = 1;
                                eventDetPlotFcn(guiobj,1)
                            end
                    end
            end
        end
                
        %%
        function [numDets,numChans,detNum,detInd,detBorders,chan,detParams] = extractDetStructs(guiobj,dTyp)
            switch guiobj.evDetTabSimultMode
                case 0
                    switch dTyp
                        case 1
                            currChan = guiobj.eventDet1CurrChan;
                            currDet = guiobj.eventDet1CurrDet;
                            detMat = guiobj.ephys_detections;
                            detInfo = guiobj.ephys_detectionsInfo;
                            detParams = guiobj.ephys_detParams;
                                                        
                            detBorders = guiobj.ephys_detBorders;
                            
                        case 2
                            currChan = guiobj.eventDet2CurrRoi;
                            currDet = guiobj.eventDet2CurrDet;
                            detMat = guiobj.imaging_detections;
                            detInfo = guiobj.imaging_detectionsInfo;
                            detParams = guiobj.imaging_detParams;
                                                        
                            detBorders = guiobj.imaging_detBorders;
                    end
                    
                    emptyRows = cellfun('isempty',detMat);
                    detMat(emptyRows) = [];
                    if dTyp==1
                        detInfo.DetChannel(emptyRows) = [];
                    elseif dTyp==2
                        detInfo.DetROI(emptyRows) = [];
                    end
                    if ~isempty(detBorders)
                        detBorders(emptyRows,:) = [];
                    end
                    if ~isempty(detParams)
                        detParams(emptyRows) = [];
                    end

                    numDets = length(detMat{currChan});
                    numChans = length(detMat);
                    
                    if nargout == 2
                        return
                    end
                    
                    if dTyp == 1
                        chan = detInfo.DetChannel(currChan);
                    elseif dTyp == 2
                        chan = detInfo.DetROI(currChan);
                    end

                    detNum = currDet;
                    detInd = detMat{currChan}(currDet);
                    
                    if ~isempty(detBorders{currChan})
                        detBorders = detBorders{currChan};
                        detBorders = detBorders(currDet,:);
                    else
                        detBorders = [];
                    end
                    if ~isempty(detParams{currChan})
                        detParams = detParams{currChan}(currDet);
                    else
                        detParams = [];
                    end
                    
                case 1
                    detStruct = guiobj.simult_detections;
                    
                    detInfo = guiobj.simult_detectionsInfo;
                    
                    switch guiobj.simultFocusTyp % this stores from which datatype we are approaching
                        case 1
                            chanFocus = detInfo.EphysChannels(guiobj.eventDetSim1CurrChan);
                            detStructFocus = detStruct(detStruct(:,1)==chanFocus,:);
                        case 2
                            chanFocus = detInfo.ROIs(guiobj.eventDetSim2CurrRoi);
                            detStructFocus = detStruct(detStruct(:,3)==chanFocus,:);
                            
                    end
                  
                    switch dTyp
                        case 1
                            currChan = guiobj.eventDetSim1CurrChan;
                            currDet = guiobj.eventDetSim1CurrDet;
                            
                            if guiobj.simultFocusTyp==1
                                chan = chanFocus;
                                numChans = length(unique(detStruct(:,1)));
                            elseif guiobj.simultFocusTyp==2
                                temp = unique(detStructFocus(detStructFocus(:,3)==chanFocus,4));
                                temp = temp(guiobj.eventDetSim2CurrDet);
                                detStructFocus = detStructFocus(detStructFocus(:,4)==temp,:);
                                chan = unique(detStructFocus(:,1));
                                chan = chan(currChan);
                                numChans = length(unique(detStructFocus(:,1)));
                            end
                            numDets = length(unique(detStructFocus(detStructFocus(:,1)==chan,2)));
                            
                            
                            if nargout == 2
                                return
                            end
                            
                            currChanEvents = unique(detStructFocus(detStructFocus(:,1)==chan,2));
                            
                            nonSimDetInfo = guiobj.ephys_detectionsInfo;
                            nonSimDetRow = find(nonSimDetInfo.DetChannel==chan);
                            
                            detMat = guiobj.ephys_detections{nonSimDetRow};
                            detNum = currChanEvents(currDet);
                            detInd = detMat(detNum);
                            
                            detBorders = guiobj.ephys_detBorders{nonSimDetRow};
                            if ~isempty(detBorders)
                                detBorders = detBorders(currChanEvents(currDet),:);
                            end
                            
                            detParams = guiobj.ephys_detParams{nonSimDetRow};
                            if ~isempty(detParams)
                                detParams = detParams(currChanEvents(currDet));
                            end
                            
                        case 2
                            currDet = guiobj.eventDetSim2CurrDet;
                            currChan = guiobj.eventDetSim2CurrRoi;
                            
                            if guiobj.simultFocusTyp==2
                                chan = chanFocus;
                                numChans = length(unique(detStruct(:,3)));
                            elseif guiobj.simultFocusTyp==1
                                temp = unique(detStructFocus(detStructFocus(:,1)==chanFocus,2));
                                temp = temp(guiobj.eventDetSim1CurrDet);
                                detStructFocus = detStructFocus(detStructFocus(:,2)==temp,:);
                                chan = unique(detStructFocus(:,3));
                                chan = chan(currChan);
                                numChans = length(unique(detStructFocus(:,3)));
                            end
                            numDets = length(unique(detStructFocus(detStructFocus(:,3)==chan,4)));
                            
                            if nargout == 2
                                return
                            end
                            
                            currChanEvents = unique(detStructFocus(detStructFocus(:,3)==chan,4));
                            
                            nonSimDetInfo = guiobj.imaging_detectionsInfo;
                            nonSimDetRow = find(nonSimDetInfo.DetROI==chan);
                            detMat = guiobj.imaging_detections{nonSimDetRow};
                            detNum = currChanEvents(currDet);
                            detInd = detMat(detNum);
                            
                            detBorders = guiobj.imaging_detBorders{nonSimDetRow};
                            if ~isempty(detBorders)
                                detBorders = detBorders(currChanEvents(currDet),:);
                            end
                            
                            detParams = guiobj.imaging_detParams{nonSimDetRow};
                            if ~isempty(detParams)
                                detParams = detParams(currChanEvents(currDet));
                            end
                            
                    end
            end
            
        end
        
        %%
        function resetGuiData(guiobj,rhdORgor)

            dtyp = guiobj.datatyp;
            showXtraFigs = guiobj.showXtraDetFigs;
            evDetYlimMode = guiobj.evDetTabYlimMode;
            evDetYlimModeMenuText = guiobj.evDetTabYlimModeMenu.Text;
            doImportUpSamp = guiobj.importUpSamp;
            doImportUpSamp_targetFs = guiobj.importUpSamp_targetFs;
            doImportEphysDownSamp = guiobj.doEphysDownSamp;
            doImportEphysDownSamp_targetFs = guiobj.doEphysDownSamp_targetFs;
            figLastPos = guiobj.mainfig.Position;
            figLastState = guiobj.mainfig.WindowState;
            evDetTabEphysDTyp = guiobj.eventDet1DataType;
            evDetTabImagingDTyp = guiobj.eventDet2DataType;
            
            close(guiobj.mainfig)
            delete(guiobj)
            
            mbox = msgbox('Resetting GUI please wait...');
            
            guiobj = DAS;
            toRun = [0,0,0,0,0,0];
            
            guiobj.mainfig.Position = figLastPos;
            guiobj.mainfig.WindowState = figLastState;
            guiobj.evDetTabYlimMode = evDetYlimMode;
            guiobj.evDetTabYlimModeMenu.Text = evDetYlimModeMenuText;
            guiobj.importUpSamp = doImportUpSamp;
            guiobj.importUpSamp_targetFs = doImportUpSamp_targetFs;
            guiobj.doEphysDownSamp = doImportEphysDownSamp;
            guiobj.doEphysDownSamp_targetFs = doImportEphysDownSamp_targetFs;
            guiobj.eventDet1DataType = evDetTabEphysDTyp;
            guiobj.eventDet2DataType = evDetTabImagingDTyp;
            
            if dtyp(1) == 1
                guiobj.ephysCheckBox.Value = 1;
                toRun(1) = 1;
                if rhdORgor == 1
                    toRun(4) = 1;
                elseif rhdORgor == 2
                    toRun(5) = 1;
                end
            end
            if dtyp(2) == 1
                guiobj.imagingCheckBox.Value = 1;
                toRun(2) = 1;
                toRun(5) = 1;
            end
            if dtyp(3) == 1
                guiobj.runCheckBox.Value = 1;
                toRun(3) = 1;
                toRun(6) = 1;
            end
            
            if toRun(1)
                ephysCheckBoxValueChanged(guiobj)
            end
            if toRun(2)
                imagingCheckBoxValueChanged(guiobj)
            end
            if toRun(3)
                runCheckBoxValueChanged(guiobj)
            end
            if toRun(4)
                ImportRHDButtonPushed(guiobj)
            end
            if toRun(5)
                ImportgorobjButtonPushed(guiobj)
            end
            if toRun (6)
                ImportruncsvButtonPushed(guiobj)
            end
            
            if showXtraFigs
                showXtraDetFigsMenuSel(guiobj)                
            end
                        
            delete(mbox)
        end
        
        %%
        function importSettingsUpdate(guiobj,h,~)
            runUpSamp = findobj(h,'String','Run upsampling after GOR import');
            guiobj.importUpSamp = runUpSamp.Value;
            targetFs = findobj(h,'Tag','fsGoalEdit');
            guiobj.importUpSamp_targetFs = str2double(targetFs.String);
            
            ephysDownSampChB = findobj(h,'String','Downsample electrophysiology data');
            guiobj.doEphysDownSamp = ephysDownSampChB.Value;
            downSampFs = findobj(h,'Tag','ephysDownSampTargetEdit');
            guiobj.doEphysDownSamp_targetFs = str2double(downSampFs.String);
        end
        
        %%
        function runImportUpSamp(guiobj,dTyp)
            targetFs = guiobj.importUpSamp_targetFs;
            
            switch dTyp
                case 1
                    ogFs = guiobj.ephys_fs;
                    ogTaxis = guiobj.ephys_taxis;
                    ogData = guiobj.ephys_data;
                    
                case 2
                    ogFs = guiobj.imaging_fs;
                    ogTaxis = guiobj.imaging_taxis;
                    ogData = guiobj.imaging_data;
                    
            end
            
            upsampMult = ceil(targetFs/ogFs);
            temp = zeros(size(ogData,1),size(ogData,2)*upsampMult);
            interpTaxis = linspace(ogTaxis(1),length(ogData)/ogFs+ogTaxis(1),length(ogTaxis)*upsampMult);
            for i = 1:size(ogData,1)
                temp(i,:) = spline(ogTaxis,ogData(i,:),interpTaxis);
            end
            ogData = temp;
            clear temp

            switch dTyp
                case 1
                    
                    
                case 2
                    guiobj.imaging_data = ogData;
                    guiobj.imaging_fs = ogFs*upsampMult;

                    guiobj.imaging_taxis = interpTaxis;
                    
                    guiobj.imaging_upSampd = true;
                    
            end
        end
        
        %%
        function runImportDownSamp(guiobj)
            targetFs = guiobj.doEphysDownSamp_targetFs;
            
            ogFs = guiobj.ephys_fs;
            ogTaxis = guiobj.ephys_taxis;
            ogData = guiobj.ephys_data;
            
%             lpFilt = makegausslpfir( targetFs/5, ogFs, 6 );
            [b,a] = butter(4,(targetFs/4)/(ogFs/2),'low');
            lpFilt_data = zeros(size(ogData));
            downSampFactor = ogFs/targetFs;
            downSamp_data = zeros(size(ogData,1),size(ogData,2)/downSampFactor);
            for i = 1:min(size(ogData))
%                 lpFilt_data(i,:) = firfilt( ogData(i,:), lpFilt );
                lpFilt_data(i,:) = filtfilt(b,a,ogData(i,:));
                downSamp_data(i,:) = downsample(lpFilt_data(i,:),downSampFactor);
            end
            
            newTaxis = linspace(ogTaxis(1),ogTaxis(end),length(ogTaxis)/downSampFactor);
            newFs = targetFs;
            
            guiobj.ephys_data = downSamp_data;
            guiobj.ephys_fs = newFs;
            guiobj.ephys_taxis = newTaxis;
            
            guiobj.ephys_downSampd = true;
        end
        
        %%
        function computeEphysDataTypes(guiobj)
            if guiobj.ephys_artSupp4Det == 0
                ephysData4Dets = guiobj.ephys_data;
            else 
                ephysData4Dets = guiobj.ephys_procced(guiobj.ephys_artSuppedData4DetListInds,:);
            end

            guiobj.ephys_dogged = DoG(ephysData4Dets,guiobj.ephys_fs,...
                guiobj.eventDet1W1,guiobj.eventDet1W2);
            guiobj.ephys_instPowed = instPow(ephysData4Dets,guiobj.ephys_fs,...
                guiobj.eventDet1W1,guiobj.eventDet1W2);
        end
        
        %%
        function computeImagingDataTypes(guiobj)
            if guiobj.imaging_artSupp4Det == 0
                data4dets = guiobj.imaging_data;
            else 
                data4dets = guiobj.imaging_procced(guiobj.imaging_artSuppedData4DetListInds,:);
            end

            guiobj.imaging_smoothed = smoothdata(data4dets,2,'gaussian',guiobj.eventDet2GwinSize);
        end
        
        %%
        function inds2use = convertRunInds4Dets(guiobj,dTyp)
            
            switch dTyp
                case 1
                    taxis = guiobj.ephys_taxis;
                case 2
                    taxis = guiobj.imaging_taxis;
            end
            
            inSpeedRangeInds = find((guiobj.run_veloc >= str2double(guiobj.speedRange4DetsEdit1.String)) &...
                (guiobj.run_veloc <= str2double(guiobj.speedRange4DetsEdit2.String)));
            indDiffs = diff(inSpeedRangeInds);
            indDiffsBreaks = find(indDiffs > 1);

            runTaxis = guiobj.run_taxis;
            
            inds2use = [];
            if isempty(indDiffsBreaks)
                segmentRunTaxis = runTaxis([inSpeedRangeInds(1),inSpeedRangeInds(end)]);
                if (segmentRunTaxis(2) - segmentRunTaxis(1)) > (str2double(guiobj.minTimeInSpeedRangeEdit.String) / 1000)
                    [~,segmentsBorders(1)] = min(abs(taxis - segmentRunTaxis(1)));

                    [~,segmentsBorders(2)] = min(abs(taxis - segmentRunTaxis(2)));
                    inds2use = segmentsBorders(1):segmentsBorders(2);
                end
            else
                for i = 1:length(indDiffsBreaks)
                    if i == 1
                        segmentRunTaxis = runTaxis([inSpeedRangeInds(1),inSpeedRangeInds(indDiffsBreaks(i))]);
                    else
                        segmentRunTaxis = runTaxis([inSpeedRangeInds(indDiffsBreaks(i-1)+1),inSpeedRangeInds(indDiffsBreaks(i))]);
                    end

                    if (segmentRunTaxis(2) - segmentRunTaxis(1)) > (str2double(guiobj.minTimeInSpeedRangeEdit.String) / 1000)
                        [~,segmentsBorders(1)] = min(abs(taxis - segmentRunTaxis(1)));

                        [~,segmentsBorders(2)] = min(abs(taxis - segmentRunTaxis(2)));
                        inds2use = [inds2use, segmentsBorders(1):segmentsBorders(2) ];
                    end
                end
            end
        end
        
        %%
        function inds2use = discardIntervals4Dets(guiobj,dTyp,data,chans,refchans)
            if (nargin < 5) || any(isnan(refchans))
                refchans = [];
            end
            
            inds2use = [];
            
            quest = 'Which method do you want to use to discard intervals?';
            questTitle = 'Interval selection method';
            btn1 = 'Timestamp entry';
            btn2 = 'Graphical';
            btn3 = 'Cancel';
            defbtn = btn1;
            selMethod = questdlg(quest,questTitle,btn1,btn2,btn3,defbtn);
            
            switch dTyp
                case 1
                    len = length(guiobj.ephys_data);
                    tAxis = guiobj.ephys_taxis;

                case 2
                    len = length(guiobj.imaging_data);
                    tAxis = guiobj.imaging_taxis;

            end
            
            switch selMethod
                case 'Cancel'
                    return
                    
                case 'Timestamp entry'
                    badIntervalsT = intervalInput(guiobj,dTyp);
                    
                    inds2use = 1:len;
                    for i = 1:size(badIntervalsT, 1)
                        [~, intervalStart] = min(abs(badIntervalsT(i,1) - tAxis));
                        [~, intervalEnd] = min(abs(badIntervalsT(i,2) - tAxis));
                        inds2use(intervalStart:intervalEnd) = nan;
                    end
                    inds2use(isnan(inds2use)) = [];
                    
                case 'Graphical'
                    indSelFig = figure('NumberTitle','off',...
                        'Name','Selection of intervals to discard',...
                        'WindowState','maximized',...
                        'WindowStyle','modal',...
                        'Visible','off');
                    if ~isempty(refchans)
                        temp = ismember(chans, refchans);
                        list4dlg = cell(length(chans), 1);
                        list4dlg(temp) = mat2cell([num2str(chans(temp)'), repmat(' (ref)', length(find(temp)), 1)], ones(length(find(temp)), 1));
                        list4dlg(~temp) = mat2cell(num2str(chans(~temp)'), ones(length(find(~temp)), 1));
                    else
                        list4dlg = mat2cell(num2str(chans'), ones(length(chans), 1));
                    end
                    if size(data,1) > 10
                        goodSel = false;
                        while ~goodSel
                            [ch2use, tf] = listdlg('ListString', list4dlg,...
                                'PromptString', 'Too many channels to display, select at most 10!',...
                                'ListSize', [300, 300]);
                            if ~tf
                                return
                            elseif length(ch2use) <= 10
                                goodSel = true;
                            end
                        end
                    else
                        ch2use = 1:length(chans);
                    end
                        
                    for i = 1:length(ch2use)
                        sp = subplot(length(ch2use), 1, i, 'Parent', indSelFig);
                        plot(sp, tAxis, data(ch2use(i),:))
                        title(sp, ['Ch #',list4dlg{ch2use(i)}])
                    end
                    sgtitle(indSelFig, 'Select intervals by clicking in one of the plots! Finish with Return key!')
                    
                    inpGud = false;
                    while ~inpGud
                        figure(indSelFig)
                        try
                            [selPoints, ~] = ginput;
                        catch
                            selPoints = [];
                        end
                        selPoints(selPoints <= tAxis(1)) = tAxis(1);
                        selPoints(selPoints > tAxis(end)) = tAxis(end);

                        if mod(length(selPoints), 2) == 0
                            inpGud = true;
                        else
                            eD = errordlg('Repeat selection and give pairs of indexes (start of segment, end of segment)!');
                            pause(1)
                            if ishandle(eD)
                                close(eD)
                            end
                        end
                    end
                    
                    if (length(selPoints) / 2) == 1
                        msgTxt = '%d interval selected!';
                    elseif (length(selPoints) / 2) == 0
                        msgTxt = 'No intervals selected!';
                    else
                        msgTxt = '%d intervals selected!';
                    end
                    mb = msgbox(sprintf(msgTxt, length(selPoints) / 2));
                    pause(1)
                    if ishandle(mb)
                        close(mb)
                    end
                    if ishandle(indSelFig)
                        close(indSelFig)
                    end
                    
                    inds2use = 1:len;
                    for i = 1:2:length(selPoints)
                        [~, intervalStart] = min(abs(selPoints(i) - tAxis));
                        [~, intervalEnd] = min(abs(selPoints(i+1) - tAxis));
                        inds2use(intervalStart:intervalEnd) = nan;
                    end
                    inds2use(isnan(inds2use)) = [];
                    
            end
        end
   
        %%
        function intervals = intervalInput(guiobj,dTyp)
            inputIntervalsFig = figure('NumberTitle','off',...
                'Name','Interval input',...
                'CloseRequestFcn',@(h,e) saveIntervals);

            colNames = {'Start','End'};
            intervalTable = uitable(inputIntervalsFig,...
                'Units','normalized',...
                'Position',[0.01, 0.1, 0.9, 0.8],...
                'ColumnName',colNames,...
                'ColumnEditable',true,...
                'Data',[0, 0],...
                'CellEditCallback',@ inputControll);

            uicontrol(inputIntervalsFig,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.01, 0.01, 0.1, 0.05],...
                'String','Add range',...
                'Callback',@(h,e) addRow);

            uiwait(inputIntervalsFig)

            function inputControll(~,event)
                switch dTyp
                    case 1
                        len = length(guiobj.ephys_data);
                        
                    case 2
                        len = length(guiobj.imaging_data);
                        
                end
                
                ind1 = event.Indices(1);
                ind2 = event.Indices(2);
                if event.NewData > len
                    intervalTable.Data(ind1,ind2) = len;
                elseif event.NewData < 1
                    intervalTable.Data(ind1,ind2) = 1;
                end
            end

            function addRow
                intervalTable.Data = [intervalTable.Data; [0, 0]];
            end

            function saveIntervals
                if (size(intervalTable.Data, 1) == 1) & (intervalTable.Data(1,:) == [0, 0]) 
                    intervals = [];
                elseif ~isempty(find(intervalTable.Data(:,1) >= intervalTable.Data(:,2), 1))
                    errordlg('Start shouldnt be higher then end of interval!')
                    return
                else
                    intervals = intervalTable.Data;
                    intervals = intervals(any(intervals, 2), :);
                end

                delete(inputIntervalsFig)
            end
        end
        
        %%
        function selNewIntervals = useNewOrOldIntervals(guiobj)
            selNewIntervals = true;
            if ~isempty(guiobj.ephys_prevIntervalSel)
                prevIntervals = guiobj.ephys_prevIntervalSel;
                prevSelFig = figure('Name', 'Previous interval selection',...
                    'NumberTitle', 'off');
                dataAvg = mean(guiobj.ephys_data);
                plot(guiobj.ephys_taxis, dataAvg)
                hold on
                title('Average of loaded data, red regions are discarded')
                redParts = dataAvg;
                redParts(prevIntervals) = nan;
                plot(guiobj.ephys_taxis, redParts, 'r')
                hold off

                usePrevSel = questdlg('Use previous selection?');
                if ishandle(prevSelFig)
                    close(prevSelFig)
                end
                switch usePrevSel
                    case 'Yes'
                        selNewIntervals = false;

                    case ''
                        return

                end
            end            
        end
        
        %%
        function selInds = makeProcDataSelFig(guiobj,dTyp,selMode)
            if nargin < 3
                selMode = true;
            end
            if dTyp == 1
                procInfo = guiobj.ephys_proccedInfo;
                chanTxt = 'Channel';
                dTypTxt = 'ephys';
            elseif dTyp == 2
                procInfo = guiobj.imaging_proccedInfo;
                chanTxt = 'ROI';
                dTypTxt = 'imaging';
            end
            
            if selMode
                figTitle = ['Select processed ',dTypTxt,' data for detection'];
            else
                figTitle = ['Processed ',dTypTxt,' data in memory'];
            end
            fig = figure('NumberTitle','off',...
                'Name',figTitle,...
                'Units','normalized',...
                'Position',[0.2, 0.4, 0.6, 0.3],...
                'MenuBar','none');
            
            listboxString = cell(1,length(procInfo));
            for i = 1:length(procInfo)
                ch = struct2cell(procInfo(i));
                ch = ch{1};
                numProcs = length(procInfo(i).ProcDetails);
                procTxt = [chanTxt,'#',num2str(ch),' | '];
                for j = 1:numProcs
                    procTxt = [procTxt,procInfo(i).ProcDetails(j).Type,', '];
                    fields = fieldnames(procInfo(i).ProcDetails(j).Settings);
                    vals = struct2cell(procInfo(i).ProcDetails(j).Settings);
                    for k = 1:length(fields)
                        if ~ischar(vals{k})
                                currVal = num2str(vals{k});
                        else
                                currVal = vals{k};
                        end
                        procTxt = [procTxt,fields{k},'=',currVal,' | '];
                    end
                    procTxt = [procTxt,' || '];
                end
                listboxString{i} = procTxt;
            end
            selList = uicontrol(fig,...
                'Style','listbox',...
                'Units','normalized',...
                'Position',[0.01, 0.1, 0.98, 0.89],...
                'String',listboxString,...
                'Max',2);
            if selMode
                uicontrol(fig,...
                    'Style','pushbutton',...
                    'Units','normalized',...
                    'Position',[0.8, 0.01, 0.19, 0.05],...
                    'String','Use selected data',...
                    'Callback','uiresume');
                uiwait

                if ~ishandle(fig)
                    selInds = [];
                    return
                end
                
                if isempty(listboxString)
                    selInds = [];
                else
                    selInds = selList.Value;
                end
                close(fig)
            end
        end
        
        %%
        function updateSpectroLabels(~,h,~)
            if ~strcmp(h.Type, 'axes')
                sps = findobj(h,'Type','axes');
            else
                sps = h;
            end
            for i = 1:length(sps)
                sps(i).YTickLabel = cellfun(@(x) num2str(x),mat2cell(2.^(sps(i).YTick'),...
                    ones(1,length(sps(i).YTick))),'UniformOutput',false);
            end
        end
        
    end
    
    %% Callback functions
    methods (Access = private)

        %% Button pushed function: ImportRHDButton
        function ImportRHDButtonPushed(guiobj)

            if ~isempty(guiobj.ephys_data)
                quest = 'GUI will be reset, have you saved everything you wanted?';
                title = 'GUI reset';
                btn1 = 'Yes, reset GUI';
                btn2 = 'No, don''t reset';
                btn3 = 'Import without resetting';
                defbtn = btn1;
                clrGUI = questdlg(quest,title,btn1,btn2,btn3,defbtn);
                if strcmp(clrGUI,btn1)
                    resetGuiData(guiobj,1)
                    return
                elseif strcmp(clrGUI,btn2) | isempty(clrGUI)
                    return
                end
            end
            
            guiobj.ephys_downSampd = false;
            
            [filename,path] = uigetfile('*.rhd');
            if filename == 0
                figure(guiobj.mainfig)
                return
            end
            guiobj.rhdName = filename(1:end-4);
%             drawnow;
            figure(guiobj.mainfig)
%             oldpath = cd(path);
            rhdStruct = read_Intan_RHD2000_file_szb([path,filename]);
%             cd(oldpath)
            guiobj.ephys_fs = rhdStruct.fs;
%             t_amp = rhdStruct.t_amplifier;
            data = rhdStruct.amplifier_data;
            % Check data dimensions
            if size(data,1) > size(data,2)
                data = data';
            end
            
            % Create and store time axis
%             guiobj.ephys_taxis = linspace(t_amp(1),...
%                 length(data)/guiobj.ephys_fs+t_amp(1),length(data));
            guiobj.ephys_taxis = rhdStruct.tAxis;
            
            % Store imported data in guiobj
            guiobj.ephys_data = data;
            datanames = cell(1,size(data,1));
            for i = 1:size(data,1)
                datanames{i} = [filename,' channel#',num2str(i)]; 
            end
            guiobj.ephys_datanames = datanames;
            
            % Populate selection list with data names
%             if guiobj.datatyp(2) == 0
                guiobj.DatasetListBox.String = datanames;
%             elseif guiobj.datatyp(2) == 1
                guiobj.EphysListBox.String = datanames;
%             end

            if guiobj.doEphysDownSamp
                runImportDownSamp(guiobj)
            end
%             assignin('base','downSampedRHD',guiobj.ephys_data)
            computeEphysDataTypes(guiobj)

            setXlims(guiobj)
            clear rhdStruct
        end

        %% Button pushed function: ImportgorobjButton
        function ImportgorobjButtonPushed(guiobj)
            
            if ~isempty(guiobj.ephys_data) | ~isempty(guiobj.imaging_data)
                quest = 'GUI will be reset, have you saved everything you wanted?';
                title = 'GUI reset';
                btn1 = 'Yes, reset GUI';
                btn2 = 'No, don''t reset';
                btn3 = 'Import without resetting';
                defbtn = btn1;
                clrGUI = questdlg(quest,title,btn1,btn2,btn3,defbtn);
                if strcmp(clrGUI,btn1)
                    resetGuiData(guiobj,2)
                    return
                elseif strcmp(clrGUI,btn2) | isempty(clrGUI)
                    return
                end
%                 return
            end
            
            % Getting variables from base workspace
            wsvars = evalin('base','whos');
            % Finding gorobj variables
            wsgorinds = strcmp({wsvars.class},'gorobj');
            wsgors = wsvars(wsgorinds);
            % Checking how many gorobjs were detected & if its more than 1,
            % user has to choose
            if length(wsgors)>1
                [ind,tf] = listdlg('PromptString','Choose which dataset to load!',...
                    'ListString',{wsgors.name},'SelectionMode','single');
                if ~tf
                    return
                end
                % Ensuring focus goes back to GUI
                drawnow;
                figure(guiobj.mainfig)
                wsgors = wsgors(ind);
            elseif isempty(wsgors)
                errordlg(['There are no gorobj variables in the base '...
                    'workspace (MES Curve analysis: export -> curves to '...
                    'variable)! Please add them or import data using the '...
                    'other methods!'])
                return
            end
            datanames = cell(1,length(wsgors));
            dtyp = zeros(1,length(wsgors));
            % Extracting variable from struct
            wsgors = evalin('base',wsgors.name);
            ie = 1;
            ica = 1;
            for i = 1:length(wsgors)
                if strcmp(get(wsgors(i),'yunit'),'scalar') | isempty(get(wsgors(i),'yunit'))
                    guiobj.imaging_data(ica,:) = get(wsgors(i),'extracty');
                    dtyp(i) = 2;
                    ica = ica+1;
                elseif ~isempty(find(get(wsgors(i),'yunit')=='V',1)) | ~isempty(find(get(wsgors(i),'yunit')=='A',1))
                    if ~isempty(find(get(wsgors(i),'yunit')=='V',1))
                        guiobj.ephys_ylabel = 'Voltage [\muV]';
                    elseif ~isempty(find(get(wsgors(i),'yunit')=='A',1))
                        guiobj.ephys_ylabel = 'Current [pA]';
                    end
                    guiobj.ephys_data(ie,:) = get(wsgors(i),'extracty');
                    dtyp(i) = 1;
                    ie = ie+1;
                end
                datanames{i} = get(wsgors(i),'name');
            end
            
            if dtyp(1)
                guiobj.ephys_downSampd = false;
            end
            if dtyp(2)
                guiobj.imaging_upSampd = false;
            end
            
            if (guiobj.datatyp(1) & ~guiobj.datatyp(2)) & isempty(find(dtyp==1,1))
                errordlg('Selected file does not include any electrophysiology data!')
                return
            end
            if (~guiobj.datatyp(1) & guiobj.datatyp(2)) & isempty(find(dtyp==2,1))
                errordlg('Selected file does not inclue any imaging data!')
                return
            end
            
            if isempty(find(dtyp,1))
                errordlg('Problem with the "yunit" property of the gorobj! Terminating import')
                return
            end

            % Insert data names into selection list and extract time axis, while differentiating between ephys and imaging
            if sum(guiobj.datatyp) == 1 || (sum(guiobj.datatyp)==2 && guiobj.datatyp(3)==1)
                if guiobj.datatyp(1)
                    guiobj.DatasetListBox.String = datanames(dtyp==1);
                    guiobj.EphysListBox.String = datanames(dtyp==1);
                    guiobj.ephys_datanames = datanames(dtyp==1);
                    if length(get(wsgors(find(dtyp==1,1)),'x')) == 2
                        taxis = get(wsgors(find(dtyp==1,1)),'x')*...
                            (10^-3/guiobj.timedim);
                        guiobj.ephys_fs = 1/taxis(2);
                        guiobj.ephys_taxis = linspace(taxis(1),...
                            length(guiobj.ephys_data)/guiobj.ephys_fs+taxis(1),...
                            length(guiobj.ephys_data));
                    else
                        guiobj.ephys_taxis = get(wsgors(find(dtyp==1,1)),'x');
                        guiobj.ephys_fs = 1/(guiobj.ephys_taxis(2)-guiobj.ephys_taxis(1));
                    end
                elseif guiobj.datatyp(2)
                    guiobj.DatasetListBox.String = datanames(dtyp==2);
                    guiobj.ImagingListBox.String = datanames(dtyp==2);
                    guiobj.imaging_datanames = datanames(dtyp==2);
                    if length(get(wsgors(find(dtyp==2,1)),'x')) == 2
                        taxis = get(wsgors(find(dtyp==2,1)),'x')*...
                            (10^-3/guiobj.timedim);
                        guiobj.imaging_fs = 1/taxis(2);
                        guiobj.imaging_taxis = linspace(taxis(1),...
                            length(guiobj.imaging_data)/guiobj.imaging_fs+taxis(1),...
                            length(guiobj.imaging_data));
                    else
                        guiobj.imaging_taxis = get(wsgors(find(dtyp==2,1)),'x');
                        guiobj.imaging_fs = 1/(guiobj.imaging_taxis(2)-guiobj.imaging_taxis(1));
                    end
                end
            elseif guiobj.datatyp(1) && guiobj.datatyp(2)
%                 guiobj.EphysListBox.String = datanames(dtyp==1);
%                 guiobj.ephys_datanames = datanames(dtyp==1);
%                 guiobj.ImagingListBox.String = datanames(dtyp==2);
%                 guiobj.imaging_datanames = datanames(dtyp==2);
                
                if ~isempty(find(dtyp==1, 1))
                    guiobj.EphysListBox.String = datanames(dtyp==1);
                    guiobj.ephys_datanames = datanames(dtyp==1);
                    
%                     taxis = get(wsgors(find(dtyp==1,1)),'x')*...
%                         (10^-3/guiobj.timedim);
%                     guiobj.ephys_fs = 1/taxis(2);
%                     guiobj.ephys_taxis = linspace(taxis(1),...
%                         length(guiobj.ephys_data)/guiobj.ephys_fs+taxis(1),...
%                         length(guiobj.ephys_data));
                    if length(get(wsgors(find(dtyp==1,1)),'x')) == 2
                        taxis = get(wsgors(find(dtyp==1,1)),'x')*...
                            (10^-3/guiobj.timedim);
                        guiobj.ephys_fs = 1/taxis(2);
                        guiobj.ephys_taxis = linspace(taxis(1),...
                            length(guiobj.ephys_data)/guiobj.ephys_fs+taxis(1),...
                            length(guiobj.ephys_data));
                    else
                        guiobj.ephys_taxis = get(wsgors(find(dtyp==1,1)),'x');
                        guiobj.ephys_fs = 1/(guiobj.ephys_taxis(2)-guiobj.ephys_taxis(1));
                    end
                end
                
                if ~isempty(find(dtyp==2,1))
                    guiobj.ImagingListBox.String = datanames(dtyp==2);
                    guiobj.imaging_datanames = datanames(dtyp==2);
                
%                     taxis = get(wsgors(find(dtyp==2,1)),'x')*...
%                         (10^-3/guiobj.timedim);
%                     guiobj.imaging_fs = 1/taxis(2);
%                     guiobj.imaging_taxis = linspace(taxis(1),...
%                         length(guiobj.imaging_data)/guiobj.imaging_fs+taxis(1),...
%                         length(guiobj.imaging_data));
                    if length(get(wsgors(find(dtyp==2,1)),'x')) == 2
                        taxis = get(wsgors(find(dtyp==2,1)),'x')*...
                            (10^-3/guiobj.timedim);
                        guiobj.imaging_fs = 1/taxis(2);
                        guiobj.imaging_taxis = linspace(taxis(1),...
                            length(guiobj.imaging_data)/guiobj.imaging_fs+taxis(1),...
                            length(guiobj.imaging_data));
                    else
                        guiobj.imaging_taxis = get(wsgors(find(dtyp==2,1)),'x');
                        guiobj.imaging_fs = 1/(guiobj.imaging_taxis(2)-guiobj.imaging_taxis(1));
                    end
                end
            end
            
            % upsampling call
            if guiobj.importUpSamp == 1
                if ~isempty(find(dtyp==2,1))
                    runImportUpSamp(guiobj,2)
                end
            end
            
            % check if downsampling ephys is needed
            if guiobj.doEphysDownSamp
                if ~isempty(find(dtyp==1,1))
                    runImportDownSamp(guiobj)
                end
            end
            
            % compute the various forms of ephys if it was loaded
            if ~isempty(find(dtyp==1,1))
                computeEphysDataTypes(guiobj)
            end
            
            setXlims(guiobj)
            
        end
        
        %%
        function ImportMatButtionPushed(guiobj)
            [filename,path] = uigetfile('*.mat');
            if filename == 0
                figure(guiobj.mainfig)
                return
            end
            
            varName = who('-file',[path,filename]);
            data = getfield(load([path,filename]),varName{1})';
            XaxisInfo = getfield(load([path,filename]),varName{2})';
                        
            if length(find(diff(cellfun('size',data,2)))) ~= 1
                groupBounds = find(diff(cellfun('size',data,2)));
                dataGroupList = cell(length(groupBounds)+1,1);
                for i = 1:length(groupBounds)
                    if i == 1
                        dataGroupList{i} = ['Rows ',num2str(1),' - ',num2str(groupBounds(1))];
                    else
                        dataGroupList{i} = ['Rows ',num2str(groupBounds(i-1)+1),' - ',num2str(groupBounds(i))];
                    end
                end
                dataGroupList{end} = ['Rows ',num2str(groupBounds(end)+1),' - ',num2str(length(data))];
                
                [selRow,tf] = listdlg('ListString',dataGroupList,'PromptString','Select which rows to load!',...
                    'SelectionMode','single');
                if ~tf
                    return
                end
                
                if selRow == 1
                    datanames = cell(1,groupBounds(1));
                    for i = 1:groupBounds(1)
                        datanames{i} = ['Row ',num2str(i)];
                    end
                    
                    data = cell2mat(data(1:groupBounds(selRow)));
                    taxis = cell2mat(XaxisInfo(1));
                elseif selRow == (length(groupBounds)+1)
                    datanames = cell(1,length(data)-groupBounds(end));
                    for i = 1:(length(data)-groupBounds(end))
                        datanames{i} = ['Row ',num2str(i+groupBounds(end))];
                    end
                    
                    data = cell2mat(data(groupBounds(end)+1:end));
                    taxis = cell2mat(XaxisInfo(groupBounds(end)+1));
                else
                    datanames = cell(1,groupBounds(selRow)-groupBounds(selRow-1));
                    for i = 1:(groupBounds(selRow)-groupBounds(selRow-1))
                        datanames{i} = ['Row ',num2str(i+groupBounds(selRow-1))];
                    end
                    
                    data = cell2mat(data(groupBounds(selRow-1)+1:groupBounds(selRow)));
                    taxis = cell2mat(XaxisInfo(groupBounds(selRow-1)+1));
                end
                
                
            else
                datanames = cell(1,length(data));
                for i = 1:length(data)
                    datanames{i} = ['Row ',num2str(i)];
                end
                data = cell2mat(data);
                taxis = XaxisInfo{1};
            end
            
%             size(data)
%             if size(data,1) > size(data,2)
%                 data = data';
%             end

            taxis = taxis/1000;
            
            upsampMult = 3;
            temp = zeros(size(data,1),size(data,2)*upsampMult);
            taxisOG = linspace(taxis(1),length(data)*taxis(2)+taxis(1),length(data));
            taxisInterp = linspace(taxis(1),length(data)*taxis(2)+taxis(1),length(taxisOG)*upsampMult);
            for i = 1:size(data,1)
                temp(i,:) = spline(taxisOG,data(i,:),taxisInterp);
            end
            data = temp;
            clear temp

            guiobj.imaging_data = data;
            guiobj.imaging_fs = (1/taxis(2))*upsampMult;
            
            guiobj.imaging_taxis = taxisInterp;
            
            guiobj.imaging_datanames = datanames;
            guiobj.ImagingListBox.String = datanames;
            
            setXlims(guiobj)
        end
        
        %%
        function importSettingsButtonPushed(guiobj)
            importSettingsFig = figure('Visible','off',...
                'Units','normalized',...
                'Position',[0.2, 0.2, 0.3, 0.5],...
                'NumberTitle','off',...
                'Name','Import settings',...
                'MenuBar','none',...
                'IntegerHandle','off',...
                'HandleVisibility','Callback',...
                'DeleteFcn',@ guiobj.importSettingsUpdate);
            
            upSampPanel = uipanel(importSettingsFig,...
                'Position',[0.01, 0.5, 0.98, 0.5],...
                'Title','Upsampling');
            runUpSamp = uicontrol(upSampPanel,...
                'Style','checkbox',...
                'Units','normalized',...
                'Position',[0.1, 0.85, 0.5, 0.1],...
                'String','Run upsampling after GOR import',...
                'Value',guiobj.importUpSamp);
            fsGoalLabel = uicontrol(upSampPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.1, 0.7, 0.4, 0.1],...
                'String','Target sampling rate [Hz]');
            fsGoalEdit = uicontrol(upSampPanel,...
                'Tag','fsGoalEdit',...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.55, 0.7, 0.2, 0.1],...
                'String',num2str(guiobj.importUpSamp_targetFs));
            
            ephysDownSampPanel = uipanel(importSettingsFig,...
                'Position',[0.01,0,0.98,0.5],...
                'Title','Ephys downsampling');
            runDownSamp = uicontrol(ephysDownSampPanel,...
                'Style','checkbox',...
                'Units','normalized',...
                'Position',[0.1, 0.85, 0.5, 0.1],...
                'String','Downsample electrophysiology data',...
                'Value',guiobj.doEphysDownSamp);
            ephysDownSampTargetLabel = uicontrol(ephysDownSampPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.1, 0.7, 0.4, 0.1],...
                'String','Target sampling rate [Hz]');
            ephysDownSampTargetEdit = uicontrol(ephysDownSampPanel,...
                'Tag','ephysDownSampTargetEdit',...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.55, 0.7, 0.2, 0.1],...
                'String',num2str(guiobj.doEphysDownSamp_targetFs),...
                'Callback',@(h,e) lpInfoUpdate);
            ephysDownSampLpInfoText = uicontrol(ephysDownSampPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.1, 0.55, 0.4, 0.1],...
                'String',['The anti-aliasing filter will cut at ',num2str(guiobj.doEphysDownSamp_targetFs/4),' Hz']);
            
            importSettingsFig.Visible = 'on';
            
            function lpInfoUpdate
                targetFs = str2double(ephysDownSampTargetEdit.String);
                cutFs = targetFs/4;
                ephysDownSampLpInfoText.String = ['The anti-aliasing filter will cut at ',num2str(cutFs),' Hz'];
            end
        end

        %% Value changed function: DatasetListBox
        function DatasetListBoxValueChanged(guiobj)
            index = guiobj.DatasetListBox.Value;
            
            if guiobj.datatyp(1)
                guiobj.ephys_select = index;
            elseif guiobj.datatyp(2)
                guiobj.imaging_select = index;
            end

            smartplot(guiobj)
            
            ephysDetMarkerPlot(guiobj)
            
            imagingDetMarkerPlot(guiobj)
        end

        %% Menu selected function: timedimChangeMenu
        function timedimChangeMenuSelected(guiobj)
            if guiobj.timedim == 1
                guiobj.xtitle = 'Time [ms]';
                
                guiobj.ephys_taxis = guiobj.ephys_taxis*10^3;
                
                guiobj.imaging_taxis = guiobj.imaging_taxis*10^3;
                
                guiobj.run_taxis = guiobj.run_taxis*10^3;
                
                guiobj.timedim = 10^-3;
            elseif guiobj.timedim == 10^-3
                guiobj.xtitle = 'Time [s]';
                
                guiobj.ephys_taxis = guiobj.ephys_taxis/10^3;
                
                guiobj.imaging_taxis = guiobj.imaging_taxis/10^3;

                guiobj.run_taxis = guiobj.run_taxis/10^3;
                
                guiobj.timedim = 1;
            end
            
%             if guiobj.datatyp(3)
%                 runposplot(guiobj)
%                 runvelocplot(guiobj)
%             end
%             if strcmp(guiobj.Dataselection1Panel.Visible,'on')
%                 DatasetListBoxValueChanged(guiobj,event);
%             elseif strcmp(guiobj.Dataselection2Panel.Visible,'on')           
%                 EphysListBoxValueChanged(guiobj,event);
%                 ImagingListBoxValueChanged(guiobj,event);
%             end

            smartplot(guiobj)
        end
        
        %%
        function showProcDataMenuSelected(guiobj)
            if strcmp(guiobj.showProcDataMenu.Checked,'off')
                if guiobj.datatyp(1) && guiobj.datatyp(2)
                    ephys_names = [guiobj.ephys_datanames';...
                        guiobj.ephysProcListBox2.String];
                    guiobj.EphysListBox.String = ephys_names;

                    imag_names = [guiobj.imaging_datanames';...
                        guiobj.imagingProcListBox2.String];
                    guiobj.ImagingListBox.String = imag_names;
                elseif guiobj.datatyp(1)
                    names = [guiobj.ephys_datanames';...
                        guiobj.ephysProcListBox2.String];
                    guiobj.DatasetListBox.String = names;
                elseif guiobj.datatyp(2)
                    names = [guiobj.imaging_datanames';...
                        guiobj.imagingProcListBox2.String];
                    guiobj.DatasetListBox.String = names;
                end
            
                guiobj.showProcDataMenu.Checked = 'on';
            elseif strcmp(guiobj.showProcDataMenu.Checked,'on')
                if guiobj.datatyp(1) && guiobj.datatyp(2)
                    ephys_names = guiobj.ephys_datanames(1:size(guiobj.ephys_data,1))';
                    guiobj.EphysListBox.String = ephys_names;
                    guiobj.EphysListBox.Value = 1;
                    guiobj.ephys_select = 1;

                    imag_names = guiobj.imaging_datanames(1:size(guiobj.imaging_data,1))';
                    guiobj.ImagingListBox.String = imag_names;
                    guiobj.ImagingListBox.Value = 1;
                    guiobj.imaging_select = 1;
                elseif guiobj.datatyp(1)
                    names = guiobj.ephys_datanames(1:size(guiobj.ephys_data,1))';
                    guiobj.DatasetListBox.String = names;
                    guiobj.DatasetListBox.Value = 1;
                    guiobj.ephys_select = 1;
                elseif guiobj.datatyp(2)
                    names = guiobj.imaging_datanames(1:size(guiobj.imaging_data,1))';
                    guiobj.DatasetListBox.String = names;
                    guiobj.DatasetListBox.Value = 1;
                    guiobj.imaging_select = 1;
                end
                
                guiobj.showProcDataMenu.Checked = 'off';
                smartplot(guiobj)
            end
            
        end
        
        %%
        function showEphysDetMarkers(guiobj)
            if isempty(guiobj.ephys_detections) || ~sum(~cellfun('isempty',guiobj.ephys_detections))
                return
            end
            
            if strcmp(guiobj.showEphysDetMarkersMenu.Checked,'off')
                guiobj.showEphysDetMarkersMenu.Checked = 'on';
                
                chansWithDets = find(~cellfun('isempty',guiobj.ephys_detections));
                [indx,tf] = listdlg('PromptString','Select which channel''s detection to show:',...
                    'SelectionMode','single','ListString',{num2str(chansWithDets)});
                if ~tf
                    return
                end
                guiobj.ephys_detMarkerSelection = indx;
            elseif strcmp(guiobj.showEphysDetMarkersMenu.Checked,'on')
                guiobj.showEphysDetMarkersMenu.Checked = 'off';
            end
            
            ephysDetMarkerPlot(guiobj,1)
        end
        
        %%
        function showEphysDetLegend(guiobj) 
            if strcmp(guiobj.showEphysDetLegendMenu.Checked,'on')
                guiobj.showEphysDetLegendMenu.Checked = 'off';
            elseif strcmp(guiobj.showEphysDetLegendMenu.Checked,'off')
                guiobj.showEphysDetLegendMenu.Checked = 'on';
            end
            ephysDetMarkerPlot(guiobj)
        end
        
        %%
        function showImagingDetMarkers(guiobj)
            if isempty(guiobj.imaging_detections)
                return
            end
            
            if strcmp(guiobj.showImagingDetMarkersMenu.Checked,'off')
                guiobj.showImagingDetMarkersMenu.Checked = 'on';
                
                roisWithDets = find(~cellfun('isempty',guiobj.imaging_detections));
                [indx,tf] = listdlg('PromptString','Select which ROI''s detection to show:',...
                    'SelectionMode','single','ListString',{num2str(roisWithDets)});
                if ~tf
                    return
                end
                guiobj.imaging_detMarkerSelection = indx;
            elseif strcmp(guiobj.showImagingDetMarkersMenu.Checked,'on')
                guiobj.showImagingDetMarkersMenu.Checked = 'off';
            end
            
            imagingDetMarkerPlot(guiobj,1)
        end
        
        %%
        function showSimultDetMarkers(guiobj)
            if isempty(guiobj.simult_detections)
                return
            end
            
            if strcmp(guiobj.showSimultMarkersMenu.Checked,'off')
                guiobj.showSimultMarkersMenu.Checked = 'on';
            elseif strcmp(guiobj.showSimultMarkersMenu.Checked,'on')
                guiobj.showSimultMarkersMenu.Checked = 'off';
            end
            
            simultDetMarkerPlot(guiobj,1)
        end
        
        %%
        function showXtraDetFigsMenuSel(guiobj)
            if strcmp(guiobj.showXtraDetFigsMenu.Checked,'on')
                guiobj.showXtraDetFigsMenu.Checked = 'off';
                guiobj.showXtraDetFigs = 0;
                
            else
                guiobj.showXtraDetFigsMenu.Checked = 'on';
                guiobj.showXtraDetFigs = 1;
            end
        end
        
        %% Button pushed function: ImportruncsvButton
        function ImportruncsvButtonPushed(guiobj)
            % Reading the running data from the csv
            [filename,path] = uigetfile('*.csv');
            if filename == 0
                figure(guiobj.mainfig)
                return
            end
%             drawnow;
            figure(guiobj.mainfig)
            oldpath = cd(path);
            % csvread shouldnt be used starting 2019a !!!
            rundata = csvread(filename,1,0);
            cd(oldpath)
            
            csvtype = questdlg('Treadmill or Gramophone recording?',...
                'CSV type','Treadmill','Gramophone','Cancel','Cancel');
            switch csvtype
                case 'Treadmill'
                    guiobj.run_taxis = rundata(:,1)*(10^-3);
                    guiobj.run_veloc = rundata(:,2);
                    guiobj.run_absPos = rundata(:,3);
                    guiobj.run_lap = rundata(:,4);
                    guiobj.run_relPos = rundata(:,5);
                    guiobj.run_licks = rundata(:,6);
                case 'Gramophone'
                    guiobj.run_veloc = rundata(:,2);
                    guiobj.run_taxis = rundata(:,1)*(10^-3)/guiobj.timedim;
                    guiobj.run_pos = zeros(length(rundata),1);
                case 'Cancel'
                    return
            end
            
            runposplot(guiobj)
            runvelocplot(guiobj)
%             lickplot(guiobj)
            
            setXlims(guiobj)
            
        end

        %% Value changed function: ephysCheckBox
        function ephysCheckBoxValueChanged(guiobj)
            % Determining whether ephys modules are needed
            value = guiobj.ephysCheckBox.Value;
            % Import buttons
            if value
                guiobj.ImportRHDButton.Enable = 'on';
                guiobj.ImportgorobjButton.Enable = 'on';
            elseif ~value
                guiobj.ImportRHDButton.Enable = 'off';
                if ~guiobj.imagingCheckBox.Value
                    guiobj.ImportgorobjButton.Enable = 'off';                    
                end
            end
            
            % Plot panel switching
            guiobj.datatyp = [guiobj.ephysCheckBox.Value,...
                guiobj.imagingCheckBox.Value, guiobj.runCheckBox.Value];
            plotpanelswitch(guiobj)
            
            % Data set panel swithcing
            if value && guiobj.imagingCheckBox.Value
                guiobj.Dataselection1Panel.Visible = 'off';
                guiobj.EphysListBox.String = guiobj.ephys_datanames;
                guiobj.ImagingListBox.String = guiobj.imaging_datanames;
                guiobj.Dataselection2Panel.Visible = 'on';
            elseif value && ~guiobj.imagingCheckBox.Value
                guiobj.Dataselection2Panel.Visible = 'off';
                guiobj.DatasetListBox.String = guiobj.ephys_datanames;
                guiobj.Dataselection1Panel.Visible = 'on';                
            elseif ~value && guiobj.imagingCheckBox.Value
                guiobj.Dataselection1Panel.Visible = 'on';
                guiobj.DatasetListBox.String = guiobj.imaging_datanames;
                guiobj.Dataselection2Panel.Visible = 'off';
            elseif ~value && ~guiobj.imagingCheckBox.Value
                guiobj.Dataselection1Panel.Visible = 'on';
                guiobj.Dataselection2Panel.Visible = 'off';
            end
        end

        %% Value changed function: imagingCheckBox
        function imagingCheckBoxValueChanged(guiobj)
            % Determining whether imaging data modules are needed
            value = guiobj.imagingCheckBox.Value;
            
            % Import buttons
            if value 
                guiobj.ImportgorobjButton.Enable = 'on';
            elseif ~value && ~guiobj.ephysCheckBox.Value
                guiobj.ImportgorobjButton.Enable = 'off';
            end
            
            % Plot panel switching
            guiobj.datatyp = [guiobj.ephysCheckBox.Value,...
                guiobj.imagingCheckBox.Value, guiobj.runCheckBox.Value];
            plotpanelswitch(guiobj)
            
            % Data set panel swithcing
            if value && guiobj.ephysCheckBox.Value
                guiobj.Dataselection2Panel.Visible = 'on';
                guiobj.EphysListBox.String = guiobj.ephys_datanames;
                guiobj.ImagingListBox.String = guiobj.imaging_datanames;
                guiobj.Dataselection1Panel.Visible = 'off';
            elseif value && ~guiobj.ephysCheckBox.Value
                guiobj.Dataselection1Panel.Visible = 'on';
                guiobj.DatasetListBox.String = guiobj.imaging_datanames;
                guiobj.DatasetListBox.Value = 1;
                guiobj.Dataselection2Panel.Visible = 'off';
            elseif ~value && guiobj.ephysCheckBox.Value
                guiobj.Dataselection1Panel.Visible = 'on';
                guiobj.DatasetListBox.String = guiobj.ephys_datanames;
                guiobj.DatasetListBox.Value = 1;
                guiobj.Dataselection2Panel.Visible = 'off';
            elseif ~value && ~guiobj.ephysCheckBox.Value
                guiobj.Dataselection1Panel.Visible = 'on';
                guiobj.Dataselection2Panel.Visible = 'off';
            end
        end

        %% Value changed function: runCheckBox
        function runCheckBoxValueChanged(guiobj)
            % Determining whether running data modules are needed
            value = guiobj.runCheckBox.Value;
            
            % Import buttons
            if value 
                guiobj.ImportruncsvButton.Enable = 'on';
%                 guiobj.runParamsPanel.Visible = 'on';
            elseif ~value
                guiobj.ImportruncsvButton.Enable = 'off';
%                 guiobj.runParamsPanel.Visible = 'off';
            end
            
            % Plot panel switching
            guiobj.datatyp = [guiobj.ephysCheckBox.Value,...
                guiobj.imagingCheckBox.Value, guiobj.runCheckBox.Value];
            plotpanelswitch(guiobj)
        end

        %% Value changed function: EphysListBox
        function EphysListBoxValueChanged(guiobj)
            index = guiobj.EphysListBox.Value;
            guiobj.ephys_select = index;
            
            smartplot(guiobj)
            
            ephysDetMarkerPlot(guiobj)
            
            simultDetMarkerPlot(guiobj)
        end

        %% Value changed function: ImagingListBox
        function ImagingListBoxValueChanged(guiobj)
            index = guiobj.ImagingListBox.Value;
            guiobj.imaging_select = index;
            
            smartplot(guiobj)
            
            imagingDetMarkerPlot(guiobj)
            
            simultDetMarkerPlot(guiobj)
        end
        
        %%    
        function tabSelected(guiobj,~,e)
            if e.NewValue == guiobj.tabs.Children(2)...
                    & isempty(guiobj.ephys_data)
                guiobj.tabs.SelectedTab = e.OldValue;
                erdlg = errordlg('No electrophysiology data loaded!');
                pause(1)
                if ishandle(erdlg)
                    close(erdlg)
                end
                return
            end
            if e.NewValue == guiobj.tabs.Children(3)...
                    & isempty(guiobj.imaging_data)
                guiobj.tabs.SelectedTab = e.OldValue;
                erdlg = errordlg('No imaging data loaded!');
                pause(1)
                if ishandle(erdlg)
                    close(erdlg)
                end
                return
            end
            
%             if e.OldValue == guiobj.tabs.Children(1)
                switch e.NewValue
                    case guiobj.tabs.Children(2)
                        guiobj.ephysProcListBox.String = guiobj.ephys_datanames;
                        if guiobj.ephys_select...
                                <= size(guiobj.ephys_data,1)
                            guiobj.ephysProcListBox.Value = guiobj.ephys_select;
                        else
                            guiobj.ephys_select = 1;
                            guiobj.ephysProcListBox.Value = 1;
                        end
                        
                    case guiobj.tabs.Children(3)
                        guiobj.imagingProcListBox.String = guiobj.imaging_datanames;
                        if guiobj.imaging_select...
                                <= size(guiobj.imaging_data,1)
                            guiobj.imagingProcListBox.Value = guiobj.imaging_select;
                        else
                            guiobj.imaging_select = 1;
                            guiobj.imagingProcListBox.Value = 1;
                        end
                        
                    case guiobj.tabs.Children(4)
                        if ~isempty(guiobj.ephys_data)
                            temp = 1:size(guiobj.ephys_data,1);
                            temp = {num2str(temp')};
                            guiobj.ephysDetChSelListBox.String = temp;
                        end
                end
                smartplot(guiobj)
%             end
        end
        
        %%
        function ephysProcPopMenuSelected(guiobj)
            procType = guiobj.ephysProcPopMenu.Value;
            
            switch procType
                case {1,4}
                    guiobj.ephysFiltSettingsPanel.Visible = 'off';
                    guiobj.ephysArtSuppPanel.Visible = 'off';
                    guiobj.ephysSpectroPanel.Visible = 'off';
                case 2
                    guiobj.ephysFiltSettingsPanel.Visible = 'on';
                    guiobj.ephysArtSuppPanel.Visible = 'off';
                    guiobj.ephysSpectroPanel.Visible = 'off';
                case 3
                    guiobj.ephysArtSuppPanel.Visible = 'on';
                    guiobj.ephysFiltSettingsPanel.Visible = 'off';
                    guiobj.ephysSpectroPanel.Visible = 'off';
                case 5
                    guiobj.ephysArtSuppPanel.Visible = 'off';
                    guiobj.ephysFiltSettingsPanel.Visible = 'off';
                    guiobj.ephysSpectroPanel.Visible = 'on';
            end
        end
        
        %%
        function linkProcListBoxesMenuCB(~,h)
            if strcmp(h.Checked, 'off')
                h.Checked = 'on';
            elseif strcmp(h.Checked, 'on')
                h.Checked = 'off';
            else
                return
            end
        end
        
        %%
        function ephysProcListBoxValueChanged(guiobj)
            idx = guiobj.ephysProcListBox.Value;
            if isempty(idx)
                return
            end
            
            guiobj.ephysProcSrcButtGroup.SelectedObject = guiobj.ephysProcRawRadioButt;
            
            ephysplot(guiobj,guiobj.axesEphysProc1,idx)
            
            if strcmp(guiobj.ephysLinkProcListBoxesMenu.Checked, 'on') && ~isempty(guiobj.ephys_procced)
                otherIdx = [];
                for i = 1:length(idx)
                    currInd = guiobj.ephysProcListBox2.Value;
                    chans = [guiobj.ephys_proccedInfo.Channel];
                    currChan = chans(currInd);
                    possInds = find(chans == idx(i));
                    if currChan > idx(i)
                        otherIdx = [otherIdx, max(possInds(possInds < min(currInd)))];
                    elseif currChan < idx(i)
                        otherIdx = [otherIdx, min(possInds(possInds > max(currInd)))];
                    else
                        otherIdx = [otherIdx, currInd(ismember(currChan, idx(i)))];
                    end
                end
                guiobj.ephysProcListBox2.Value = otherIdx;
                ephysplot(guiobj, guiobj.axesEphysProc2, otherIdx)
            end
        end
        
        %%
        function ephysProcListBox2ValueChanged(guiobj)
            idx = guiobj.ephysProcListBox2.Value;
            if isempty(idx)
                return
            end
            
            guiobj.ephysProcSrcButtGroup.SelectedObject = guiobj.ephysProcProcdRadioButt;
            
            ephysplot(guiobj,guiobj.axesEphysProc2,idx)
            
            if strcmp(guiobj.ephysLinkProcListBoxesMenu.Checked, 'on')
                otherIdx = [guiobj.ephys_proccedInfo(idx).Channel];
                guiobj.ephysProcListBox.Value = otherIdx;
                ephysplot(guiobj, guiobj.axesEphysProc1, otherIdx)
            end
        end
                
        %%
        function fiterTypePopMenuCallback(guiobj)
            selIdx = guiobj.filterTypePopMenu.Value;
            
            filtSettingPanelObjs = findobj(guiobj.ephysFiltSettingsPanel, '-regexp', 'Tag', 'ephysFilt');
            set(filtSettingPanelObjs, 'Visible', 'off')
            switch selIdx
                case 2 % Butterworth
                    set(filtSettingPanelObjs, 'Visible', 'on')
                    
                case 3  % DoG
                    objs = findobj(filtSettingPanelObjs, 'Tag', 'ephysFilt');
                    set(objs, 'Visible', 'on')
                    
            end
        end
        
        %%
        function ephysArtSuppTypePopMenuCB(guiobj)
            selIdx = guiobj.ephysArtSuppTypePopMenu.Value;
            
            artSuppPanelObjs = findobj(guiobj.ephysArtSuppPanel, '-regexp', 'Tag', 'ephysArtSupp');
            set(artSuppPanelObjs, 'Visible', 'off')
            switch selIdx                    
                case 2  % ref subtract
                    objs = findobj(artSuppPanelObjs, 'Tag', 'ephysArtSupp_refCh');
                    set(objs, 'Visible', 'on')
                    
                case 4 % periodic                   
                    objs = findobj(artSuppPanelObjs, 'Tag', 'ephysArtSupp_periodic');
                    set(objs, 'Visible', 'on')
                    
            end
        end
        
        %%
        function ephysSelNewIntervalsButtonCB(guiobj)
            switch guiobj.ephysProcSrcButtGroup.SelectedObject.String
                case 'Raw data'
                    data_idx = guiobj.ephysProcListBox.Value;
                    data = guiobj.ephys_data(data_idx,:);
                    
                    chans = data_idx;
                case 'Processed data'
                    data_idx = guiobj.ephysProcListBox2.Value;
                    data = guiobj.ephys_procced(data_idx,:);
                    
                    oldProcInfo = guiobj.ephys_proccedInfo;
                    chans = [oldProcInfo(data_idx).Channel];
            end
            
            inds2use = discardIntervals4Dets(guiobj,1,data,chans);
            guiobj.ephys_prevIntervalSel = inds2use;
        end
        
        %%
        function ephysRunProc(guiobj,callFromDetRun)
            guiobj.ephysRunProcButton.BackgroundColor = 'r';
            
            if (nargin == 2) && isstruct(callFromDetRun)
                selectedButt = 'Raw data';
                data_idx = callFromDetRun.data_idx;
                procGrp = callFromDetRun.procGrp;
                filtype = callFromDetRun.filtype;
                artSuppName = callFromDetRun.artSuppName;
                refChan = callFromDetRun.refChan;
            end
            
            if nargin == 1
                selectedButt = guiobj.ephysProcSrcButtGroup.SelectedObject;
                selectedButt = selectedButt.String;
            end
            switch selectedButt
                case 'Raw data'
                    if nargin == 1
                        data_idx = guiobj.ephysProcListBox.Value;
                    end
                    data = guiobj.ephys_data(data_idx,:);
                    
                    temp = num2cell(data_idx)';
                    newProcInfo = struct('Channel',temp,'ProcDetails',cell(size(temp)));
                    clear temp
                case 'Processed data'
                    data_idx = guiobj.ephysProcListBox2.Value;
                    data = guiobj.ephys_procced(data_idx,:);
                    
                    oldProcInfo = guiobj.ephys_proccedInfo;
                    temp = num2cell([oldProcInfo(data_idx).Channel])';
                    newProcInfo = struct('Channel',temp,'ProcDetails',cell(size(temp)));
                    for i = 1:length(data_idx)
                        newProcInfo(i).ProcDetails = oldProcInfo(data_idx(i)).ProcDetails;
                    end
                    clear temp
            end
            
            if isempty(data)
                guiobj.ephysRunProcButton.BackgroundColor = 'g';
                return
            end
            
            datanames = guiobj.ephys_datanames;
            procDatanames = guiobj.ephys_procdatanames;
            
            if nargin == 1
                procGrp = guiobj.ephysProcPopMenu.Value;
                procGrp = guiobj.ephysProcPopMenu.String{procGrp};
            end
            switch procGrp
                case 'Filtering'
                    if nargin == 1
                        filtype = guiobj.filterTypePopMenu.Value;
                        filtype = guiobj.filterTypePopMenu.String{filtype};
                    end
                    switch filtype
                        case 'Butterworth'
                            w1 = str2double(guiobj.w1Edit.String);
                            w2 = str2double(guiobj.w2Edit.String);
                            fOrd = str2double(guiobj.filtOrderEdit.String);
                            
                            if isnan(fOrd)
                                errordlg('Specify filter order!')
                                guiobj.ephysRunProcButton.BackgroundColor = 'g';
                                return
                            end
                            
                            if ~isnan(w1) && isnan(w2)
                                ftype = 'high';
                                fc = w1;
                            elseif isnan(w1) && ~isnan(w2)
                                ftype = 'low';
                                fc = w2;
                            elseif ~isnan(w1) && ~isnan(w2)
                                ftype = 'bandpass';
                                fc = [w1, w2];
                                fOrd = fOrd / 2;
                            elseif isnan(w1) && isnan(w2)
                                errordlg('Butterworth needs at least a lower or an upper cutoff!')
                                guiobj.ephysRunProcButton.BackgroundColor = 'g';
                                return
                            end
                            
                            fc = fc / (guiobj.ephys_fs / 2);
                            [b,a] = butter(fOrd,fc,ftype);
                            procced = zeros(size(data));
                            for i = 1:size(data,1)
                                procced(i,:) = filtfilt(b,a,data(i,:));
                            end
                            
                            procDetails = struct('Type','Filt-Butter','Settings',cell(1));
                            procDetails.Settings = struct('W1',w1,'W2',w2,'Order',fOrd);
                            for i = 1:length(data_idx)
                                newProcInfo(i).ProcDetails = [newProcInfo(i).ProcDetails; procDetails];
                            end
                            
                            txt4name = ['Butter(',num2str(fOrd),'| ',num2str(w1),'-',num2str(w2),')| '];
                            
                        case 'DoG'
                            w1 = str2double(guiobj.w1Edit.String);
                            w2 = str2double(guiobj.w2Edit.String);
                            if isnan(w1) || isnan(w2)
                                errordlg('DoG needs both upper and lower cutoff!')
                                guiobj.ephysRunProcButton.BackgroundColor = 'g';
                                return
                            end
                            procced = DoG(data,guiobj.ephys_fs,w1,w2);

                            procDetails = struct('Type','Filt-DoG','Settings',cell(1));
                            procDetails.Settings = struct('W1',w1,'W2',w2);
                            for i = 1:length(data_idx)
                                newProcInfo(i).ProcDetails = [newProcInfo(i).ProcDetails; procDetails];
                            end
                            
                            txt4name = ['DoG(',num2str(w1),'-',num2str(w2),')| '];
                            
                        otherwise
                            guiobj.ephysRunProcButton.BackgroundColor = 'g';
                            return
                            
                    end
                    
                    
                case 'Artifact Suppression'
                    if nargin == 1
                        artSuppType = guiobj.ephysArtSuppTypePopMenu.Value;
                        artSuppName = guiobj.ephysArtSuppTypePopMenu.String{artSuppType};
                    end
                    
                    switch artSuppName
                        case 'DFER'
                            procDetails = struct('Type','DFER','Settings',cell(1));
                            [procced,settingStr] = artSuppMaster(data,guiobj.ephys_taxis,guiobj.ephys_fs);
                            if isempty(procced)
                                guiobj.ephysRunProcButton.BackgroundColor = 'g';
                                return
                            end
                            procDetails.Settings = settingStr;
                            for i = 1:length(data_idx)
                                newProcInfo(i).ProcDetails = [newProcInfo(i).ProcDetails; procDetails];
                            end
                            txt4name = sprintf('DFER (%s-%s-%s)',settingStr.decompType,settingStr.flagType,settingStr.bssType);
                        case 'classic ref subtract'
                            if nargin == 1
                                refchInp = guiobj.ephysArtSuppRefChanEdit.String;
                                refChan = numSelCharConverter(refchInp);
                            end
                            
                            refChan = ismember([newProcInfo.Channel], refChan);
                            
                            if length(find(refChan)) == 1
                                procced = data - data(refChan,:);
                            else
                                procced = data - mean(data(refChan,:));
                            end
                            
                            if isempty(procced)
                                guiobj.ephysRunProcButton.BackgroundColor = 'g';
                                return
                            end
                            procDetails = struct('Type',artSuppName,'Settings',cell(1));
                            procDetails.Settings = struct('RefCh',refChan);
                            for i = 1:length(data_idx)
                                newProcInfo(i).ProcDetails = [newProcInfo(i).ProcDetails; procDetails];
                            end
                            
                            txt4name = 'refSubstr';
                            
                        case 'Periodic'
                            if nargin == 1
                                fmax = str2double(guiobj.ephysPeriodicFmaxEdit.String);
                                ffund = str2double(guiobj.ephysPeriodicFfundEdit.String);
                                stopbandwidth = str2double(guiobj.ephysPeriodicStopbandWidthEdit.String)/2;
                                plotfft = logical(guiobj.ephysPeriodicPlotFFTCheckBox.Value);
                                [procced,f_fund] = periodicNoise(data,[newProcInfo.Channel],guiobj.ephys_fs,fmax,ffund,stopbandwidth,plotfft);
                            else
                                [procced,f_fund,fmax,stopbandwidth] = periodicNoise(data,[newProcInfo.Channel],guiobj.ephys_fs);
                            end
                            if isempty(procced)
                                guiobj.ephysRunProcButton.BackgroundColor = 'g';
                                return
                            end

                            procDetails = struct('Type','Filt-Periodic','Settings',cell(1));
                            procDetails.Settings = struct('Fmax',fmax,'Ffund',f_fund,'Stopband',stopbandwidth);
                            for i = 1:length(data_idx)
                                newProcInfo(i).ProcDetails = [newProcInfo(i).ProcDetails; procDetails];
                            end
                            txt4name = sprintf('Periodic @%.2f',f_fund);
                            
                        otherwise
                            guiobj.ephysRunProcButton.BackgroundColor = 'g';
                            return
                            
                    end
                    
                case 'Compute FFT'
                    for i = 1:length(data_idx)
                        fftPlotTitle = sprintf('Ch #%d', newProcInfo(i).Channel);
                        freqspec(data(i,:),guiobj.ephys_fs,1,0,1000,fftPlotTitle)
                    end
                    
                    guiobj.ephysRunProcButton.BackgroundColor = 'g';
                    return
                    
                case 'CWT spectrogram'
                    doDiscard = questdlg('Do you want to discard some intervals?');
                    switch doDiscard
                        case 'Yes'
                            selNewIntervals = useNewOrOldIntervals(guiobj);
                            if selNewIntervals
                                inds2use = discardIntervals4Dets(guiobj,1,data,[newProcInfo.Channel]);
                                guiobj.ephys_prevIntervalSel = inds2use;
                            else
                                inds2use = guiobj.ephys_prevIntervalSel;
                            end
                            
                        case 'No'
                            inds2use = 1:size(data,2);
                            
                        otherwise
                            return
                            
                    end
                    for i = 1:length(data_idx)
                        chan = newProcInfo(i).Channel;
                        
                        freqLim = [str2double(guiobj.ephysSpectroFreqLimit1Edit.String), str2double(guiobj.ephysSpectroFreqLimit2Edit.String)];
                        cwtFig = figure('Name',sprintf('Channel #%d CWT Spectrogram', chan),...
                            'NumberTitle', 'off',...
                            'WindowState', 'maximized',...
                            'SizeChangedFcn', @ guiobj.updateSpectroLabels);
                        zoomObj = zoom(cwtFig);
                        zoomObj.ActionPostCallback = @ guiobj.updateSpectroLabels;
                        drawnow
                        [cfs,f] = cwt(data(i,:), 'amor', guiobj.ephys_fs, 'FrequencyLimits', freqLim);
                        cfs(:,setxor(1:size(data, 2), inds2use)) = nan;
                        imagesc(guiobj.ephys_taxis,log2(f),abs(cfs))
                        axis tight
                        ax = gca;
                        ax.YDir = 'normal';
                        ax.YTickLabel = num2str(2.^(ax.YTick'));
                        title(sprintf('Ch#%d CWT',chan))
                        xlabel('Time [s]')
                        ylabel('Frequency [Hz]')
                        c = colorbar;
                        c.Label.String = 'CWT coeff. magnitude';
                        clear cfs f ax
                    end
                    
                    guiobj.ephysRunProcButton.BackgroundColor = 'g';
                    return
                    
                otherwise
                    guiobj.ephysRunProcButton.BackgroundColor = 'g';
                    return
                    
            end
            
            for i = 1:length(data_idx)
                if isempty(procDatanames)
                    procDatanames = {[txt4name,' | ',...
                        datanames{data_idx(i)}]};
                elseif ~isempty(procDatanames)
                    switch selectedButt
                        case 'Raw data'
                            procDatanames = [procDatanames,...
                                [txt4name,' | ',datanames{data_idx(i)}]];
                        case 'Processed data'
                            procDatanames = [procDatanames,...
                                [txt4name,' | ',procDatanames{data_idx(i)}]];
                    end

                end
            end
            
            guiobj.ephys_procced = [guiobj.ephys_procced; procced];
            guiobj.ephys_proccedInfo = [guiobj.ephys_proccedInfo; newProcInfo];
            guiobj.ephys_procdatanames = procDatanames;
            guiobj.ephysProcListBox2.String = procDatanames;
            
            guiobj.ephysRunProcButton.BackgroundColor = 'g';
        end
                        
        %% Callback to monitor radiobutton press
        function ephysProcProcdRadioButtPushed(guiobj)
            if isempty(guiobj.ephys_procced)
                errordlg('No processed data!')
                guiobj.ephysProcSrcButtGroup.SelectedObject = ...
                    guiobj.ephysProcRawRadioButt;
                return
            end
        end
        
        %%
        function imagingProcListBoxValueChanged(guiobj)
            idx = guiobj.imagingProcListBox.Value;
            if idx == 0 | isnan(idx) | isempty(idx)
               return
            end
            
            guiobj.imagingProcSrcButtGroup.SelectedObject = guiobj.imagingProcRawRadioButt;
            
            imagingplot(guiobj,guiobj.axesImagingProc1,idx)
            
            if strcmp(guiobj.imagingLinkProcListBoxesMenu.Checked, 'on') && ~isempty(guiobj.imaging_procced)
                otherIdx = [];
                for i = 1:length(idx)
                    currInd = guiobj.imagingProcListBox2.Value;
                    chans = [guiobj.imaging_proccedInfo.ROI];
                    currChan = chans(currInd);
                    possInds = find(chans == idx(i));
                    if currChan > idx(i)
                        otherIdx = [otherIdx, max(possInds(possInds < min(currInd)))];
                    elseif currChan < idx(i)
                        otherIdx = [otherIdx, min(possInds(possInds > max(currInd)))];
                    else
                        otherIdx = [otherIdx, currInd(ismember(currChan, idx(i)))];
                    end
                end
                guiobj.imagingProcListBox2.Value = otherIdx;
                imagingplot(guiobj, guiobj.axesImagingProc2, otherIdx)
            end
        end
        
        %%
        function imagingProcListBox2ValueChanged(guiobj)
            idx = guiobj.imagingProcListBox2.Value;
            if idx == 0 | isnan(idx) | isempty(idx)
               return
            end
            
            guiobj.imagingProcSrcButtGroup.SelectedObject = guiobj.imagingProcProcdRadioButt;
            
            imagingplot(guiobj,guiobj.axesImagingProc2,idx)
            
            if strcmp(guiobj.imagingLinkProcListBoxesMenu.Checked, 'on')
                otherIdx = [guiobj.imaging_proccedInfo(idx).ROI];
                guiobj.imagingProcListBox.Value = otherIdx;
                imagingplot(guiobj, guiobj.axesImagingProc1, otherIdx)
            end
        end
        
        %%
        function imagingProcPopMenuSelected(guiobj)
            procType = guiobj.imagingProcPopMenu.Value;
            
            switch procType
                case 2
                    guiobj.imagingFiltSettingsPanel.Visible = 'on';
                otherwise
                    guiobj.imagingFiltSettingsPanel.Visible = 'off';
            end
        end
        
        %%
        function imagingFilterTypePopMenuSelected(guiobj)
            sel = guiobj.imagingFilterTypePopMenu.Value;
            
            filtPanelObjs = findobj(guiobj.imagingFiltSettingsPanel, 'Tag', 'imagingFilt');
            set(filtPanelObjs, 'Visible', 'off')
            
            switch sel
                case 2
                    set(filtPanelObjs, 'Visible', 'on')
                    
            end
                    
        end
        
        %%
        function imagingRunProc(guiobj)
            guiobj.imagingRunProcButton.BackgroundColor = 'r';
            
            proctype = guiobj.imagingProcPopMenu.Value;
            if proctype == 1
                guiobj.imagingRunProcButton.BackgroundColor = 'g';
                return
            end 
            proctype = guiobj.imagingProcPopMenu.String{proctype};
            
            selectedButt = guiobj.imagingProcSrcButtGroup.SelectedObject;
            selectedButt = selectedButt.String;
            
            switch selectedButt
                case 'Raw data'
                    data_idx = guiobj.imagingProcListBox.Value;
                    data = guiobj.imaging_data(data_idx,:);
                    
                    temp = num2cell(data_idx)';
                    newProcInfo = struct('ROI',temp,'ProcDetails',cell(size(temp)));
                    clear temp
                case 'Processed data'
                    data_idx = guiobj.imagingProcListBox2.Value;
                    data = guiobj.imaging_procced(data_idx,:);
                    
                    oldProcInfo = guiobj.imaging_proccedInfo;
                    temp = num2cell([oldProcInfo(data_idx).ROI])';
                    newProcInfo = struct('ROI',temp,'ProcDetails',cell(size(temp)));
                    for i = 1:length(data_idx)
                        newProcInfo(i).ProcDetails = oldProcInfo(data_idx(i)).ProcDetails;
                    end
                    clear temp
            end
                        
            datanames = guiobj.imaging_datanames;
            procDatanames = guiobj.imaging_procDatanames;
            switch proctype
                case 'Filtering'
                    filtype = guiobj.imagingFilterTypePopMenu.Value;
                    if filtype == 1
                        guiobj.imagingRunProcButton.BackgroundColor = 'g';
                        return
                    end
                    filtype = guiobj.imagingFilterTypePopMenu.String{filtype};
                    winsize = str2double(guiobj.imagingFiltWinSizeEdit.String);
                    switch filtype
                        case 'Gauss average'
                            if isnan(winsize)
                                errordlg('Specify window size!')
                                guiobj.imagingRunProcButton.BackgroundColor = 'g';
                                return
                            end
                            procc = smoothdata(data,2,'gaussian',winsize);
                            
                            procDetails = struct('Type','Filt-Gavg','Settings',cell(1));
                            procDetails.Settings = struct('WinSize',winsize);
                            for i = 1:length(data_idx)
                                newProcInfo(i).ProcDetails = [newProcInfo(i).ProcDetails; procDetails];
                            end
                            
                            txt4name = ['GaussAvg(win:',num2str(winsize),')'];
                            
                    end
            end
            
            for i = 1:length(data_idx)
                if isempty(procDatanames)
                    procDatanames = {[txt4name,' | ',...
                        datanames{data_idx(i)}]};
                elseif ~isempty(procDatanames)
                    switch selectedButt
                        case 'Raw data'
                            procDatanames = [procDatanames,...
                                [txt4name,' | ',...
                                datanames{data_idx(i)}]];
                        case 'Processed data'
                            procDatanames = [procDatanames,...
                                [txt4name,' | ',...
                                procDatanames{data_idx(i)}]];
                    end
                end
            end
            
            guiobj.imaging_procced = [guiobj.imaging_procced; procc];
            guiobj.imaging_proccedInfo = [guiobj.imaging_proccedInfo; newProcInfo];
            guiobj.imaging_procDatanames = procDatanames;
            guiobj.imagingProcListBox2.String = procDatanames;
            
            guiobj.imagingRunProcButton.BackgroundColor = 'g';
        end
        
        %% Callback to monitor radiobutton press
        function imagingProcProcdRadioButtPushed(guiobj)
            if isempty(guiobj.imaging_procced)
                errordlg('No processed data!')
                guiobj.imagingProcSrcButtGroup.SelectedObject = ...
                    guiobj.imagingProcRawRadioButt;
                return
            end
        end
        
        %%
        function ephysDetPopMenuSelected(guiobj)
            dettype = guiobj.ephysDetPopMenu.Value;
            dettype = guiobj.ephysDetPopMenu.String{dettype};
            
            switch dettype
                case 'CWT based'
                    guiobj.ephysAdaptDetPanel.Visible = 'off';
                    guiobj.ephysCwtDetPanel.Visible = 'on';
                    guiobj.ephysDoGInstPowDetPanel.Visible = 'off';
                case 'Adaptive threshold'
                    guiobj.ephysAdaptDetPanel.Visible = 'on';
                    guiobj.ephysCwtDetPanel.Visible = 'off';
                    guiobj.ephysDoGInstPowDetPanel.Visible = 'off';
                case 'DoG+InstPow'
                    guiobj.ephysAdaptDetPanel.Visible = 'off';
                    guiobj.ephysCwtDetPanel.Visible = 'off';
                    guiobj.ephysDoGInstPowDetPanel.Visible = 'on';
                otherwise
                    guiobj.ephysAdaptDetPanel.Visible = 'off';
                    guiobj.ephysCwtDetPanel.Visible = 'off';
                    guiobj.ephysDoGInstPowDetPanel.Visible = 'off';
            end
        end
        
        %%
        function ephysDetUseProcDataCheckBoxCB(guiobj)
            % disable channel selection listbox if processed data selection is enabled
            if guiobj.ephysDetUseProcDataCheckBox.Value
               guiobj.ephysDetChSelListBox.Enable = 'off';
            else
               guiobj.ephysDetChSelListBox.Enable = 'on';                
            end
            
        end
        
        %%
        function ephysDetRun(guiobj)
            guiobj.ephysDetStatusLabel.String = 'Detection running';
            guiobj.ephysDetStatusLabel.BackgroundColor = 'r';
            drawnow
            
            % check whether the raw or processed data should be used
            if ~guiobj.ephysDetUseProcDataCheckBox.Value
                chan = guiobj.ephysDetChSelListBox.Value;
                if isempty(chan)
                    ed = errordlg('No channel selected!');
                    pause(1)
                    if ishandle(ed)
                        close(ed)
                    end
                    guiobj.ephysDetStatusLabel.String = '--IDLE--';
                    guiobj.ephysDetStatusLabel.BackgroundColor = 'g';
                    return
                end
                data = guiobj.ephys_data(chan,:);
            else
                selInds = makeProcDataSelFig(guiobj,1);
                if isempty(selInds)
                    ed = errordlg('No channel selected!');
                    pause(1)
                    if ishandle(ed)
                        close(ed)
                    end
                    guiobj.ephysDetStatusLabel.String = '--IDLE--';
                    guiobj.ephysDetStatusLabel.BackgroundColor = 'g';
                    return
                end
                data = guiobj.ephys_procced(selInds,:);
                chan = [guiobj.ephys_proccedInfo(selInds).Channel];
                guiobj.ephys_artSupp4Det = 1;
                detinfo.DetSettings.ArtSupp = guiobj.ephys_proccedInfo(selInds(1)).ProcDetails(1).Type;
            end
            fs = guiobj.ephys_fs;
            tAxis = guiobj.ephys_taxis;
            showFigs = guiobj.showXtraDetFigs;
            refchInp = guiobj.ephysDetRefChanEdit.String;
            refch = numSelCharConverter(refchInp);
            
            dettype = guiobj.ephysDetPopMenu.Value;
            dettype = guiobj.ephysDetPopMenu.String{dettype};
            if strcmp(dettype,'--Ephys detection methods--')
                errordlg('Select detection method first!')
                guiobj.ephysDetStatusLabel.String = '--IDLE--';
                guiobj.ephysDetStatusLabel.BackgroundColor = 'g';
                return
            end
                        
            % check whether user requested interval selection
            if guiobj.selIntervalsCheckBox.Value
                if ~any(ismember(refch, chan))
                    inputData = [guiobj.ephys_data(refch,:); data];
                    inputChans = [refch, chan];
                else
                    inputData = data;
                    inputChans = chan;
                end
                
                selNewIntervals = useNewOrOldIntervals(guiobj);
                
                if selNewIntervals
                    inds2use_interval = discardIntervals4Dets(guiobj,1,inputData,inputChans,refch);
                    guiobj.ephys_prevIntervalSel = inds2use_interval;
                else
                    inds2use_interval = guiobj.ephys_prevIntervalSel;
                end
                
                if isempty(inds2use_interval)
                    warndlg('The whole recording was discarded!')
                    guiobj.ephysDetStatusLabel.String = '--IDLE--';
                    guiobj.ephysDetStatusLabel.BackgroundColor = 'g';
                    return
                end
            else
                inds2use_interval = 'all';
            end
            
            % check whether running data based detection was requested
            if guiobj.datatyp(3) && guiobj.useRunData4DetsCheckBox.Value
                inds2use_run = convertRunInds4Dets(guiobj,1);
                
                if isempty(inds2use_run)
                    warndlg('No sections satisfied the running specifications!')
                    guiobj.ephysDetStatusLabel.String = '--IDLE--';
                    guiobj.ephysDetStatusLabel.BackgroundColor = 'g';
                    return
                elseif (length(inds2use_run) / fs) < (str2double(guiobj.minTimeInSpeedRangeEdit.String) / 1000)
                    errordlg('The section falling in the specified speed range is too short!')
                    guiobj.ephysDetStatusLabel.String = '--IDLE--';
                    guiobj.ephysDetStatusLabel.BackgroundColor = 'g';
                    return
                end
                
                detinfo.DetSettings.SpeedRange = ['[',guiobj.speedRange4DetsEdit1.String,' , '...
                    guiobj.speedRange4DetsEdit2.String,']'];
                detinfo.DetSettings.MinTimeInRange = str2double(guiobj.minTimeInSpeedRangeEdit.String);
                
            else
                inds2use_run = 'all';
            end
            
            % merging the inds2use
            if strcmp(inds2use_interval, 'all') && strcmp(inds2use_run, 'all')
                inds2use = 'all';
            elseif xor(strcmp(inds2use_interval, 'all'), strcmp(inds2use_run, 'all'))
                if strcmp(inds2use_interval, 'all')
                    inds2use = inds2use_run;
                else
                    inds2use = inds2use_interval;
                end
            else
                inds2use = intersect(inds2use_run, inds2use_interval);
            end
            if isempty(inds2use)
                warndlg('No intervals remain for detection!')
                guiobj.ephysDetStatusLabel.String = '--IDLE--';
                guiobj.ephysDetStatusLabel.BackgroundColor = 'g';
                return
            end
            
            % Handling no input case when artsupp is enabled
            if (ismember(guiobj.ephysDetArtSuppPopMenu.Value, 4)) && (isempty(refch) || any(isnan(refch)))
                errordlg('Specifiy reference channel to use this type of artifact suppression!')
                guiobj.ephysDetStatusLabel.String = '--IDLE--';
                guiobj.ephysDetStatusLabel.BackgroundColor = 'g';
                return
            end
            
            if ~isempty(refch) && ~any(isnan(refch)) && any(refch ~= 0)
                switch dettype
                    case 'CWT based'
                        refVal = guiobj.ephysCwtDetRefValPopMenu.Value - 1;
                        
                    case 'DoG+InstPow'
                        refVal = guiobj.ephysDogInstPowDetRefValPopMenu.Value - 1;
                        
                    otherwise
                        refVal = 0;
                        
                end
                if refVal && (guiobj.ephysDetUseProcDataCheckBox.Value || (guiobj.ephysDetArtSuppPopMenu.Value ~= 1))
                    if any(~ismember(refch, chan))
                        errdlg = errordlg('To use refchan validation, refchan should be artifact suppressed as well!');
                        pause(1)
                        if ishandle(errdlg)
                            close(errdlg)
                        end
                        guiobj.ephysDetStatusLabel.String = '--IDLE--';
                        guiobj.ephysDetStatusLabel.BackgroundColor = 'g';
                        return
                    end
                end
            end
            
            % saving the artifact suppressed data as 
            if guiobj.ephysDetUseProcDataCheckBox.Value
                guiobj.ephys_artSuppedData4DetListInds = selInds;
            else
                switch guiobj.ephysDetArtSuppPopMenu.Value 
                    case 1 % no artifact suppression
                        guiobj.ephys_artSupp4Det = 0;
                    case 2 % periodic
                        guiobj.ephys_artSupp4Det = 1;
                        callFromDetRun.procGrp = 'Artifact Suppression';
                        callFromDetRun.filtype = [];
                        callFromDetRun.artSuppName = 'Periodic';
                        callFromDetRun.refChan = [];
                    case 3
                        guiobj.ephys_artSupp4Det = 1;
                        callFromDetRun.procGrp = 'Artifact Suppression';
                        callFromDetRun.filtype = [];
                        callFromDetRun.artSuppName = 'DFER';
                        callFromDetRun.refChan = [];
                    case 4 % ref chan subtract
                        guiobj.ephys_artSupp4Det = 1;
                        callFromDetRun.procGrp = 'Artifact Suppression';
                        callFromDetRun.filtype = [];
                        callFromDetRun.artSuppName = 'classic ref subtract';
                        callFromDetRun.refChan = refch;
                end
                if guiobj.ephys_artSupp4Det ~= 0
                    callFromDetRun.data_idx = chan;
                    ephysRunProc(guiobj,callFromDetRun)
                    temp = 1:size(guiobj.ephys_procced, 1);
                    selInds = temp(end - (length(chan)-1):end);
                    guiobj.ephys_artSuppedData4DetListInds = selInds;
                    data = guiobj.ephys_procced(guiobj.ephys_artSuppedData4DetListInds,:);
                    detinfo.DetSettings.ArtSupp = guiobj.ephys_proccedInfo(selInds(1)).ProcDetails(1).Type;
                else
                    guiobj.ephys_artSuppedData4DetListInds = [];
                end
            end
            
            if ~isempty(refch) && ~any(isnan(refch))
                switch dettype
                    case 'CWT based'
                        refVal = guiobj.ephysCwtDetRefValPopMenu.Value - 1;
                        
                    case 'DoG+InstPow'
                        refVal = guiobj.ephysDogInstPowDetRefValPopMenu.Value - 1;
                        
                    otherwise
                        refVal = 0;
                        
                end
                
                if refVal ~= 0
                    if guiobj.ephysDetUseProcDataCheckBox.Value || (guiobj.ephysDetArtSuppPopMenu.Value ~= 1)
                        if any(~ismember(refch, chan))
                            errdlg = errordlg('To use refchan validation, refchan should be artifact suppressed as well!');
                            pause(1)
                            if ishandle(errdlg)
                                close(errdlg)
                            end
                            guiobj.ephysDetStatusLabel.String = '--IDLE--';
                            guiobj.ephysDetStatusLabel.BackgroundColor = 'g';
                            return                            
                        end
                    end
                                        
                    if refch == 0
                        refchData = mean(data);
                    elseif length(refch) == 1
                        if all(ismember(refch, chan))
                            refchData = data(refch == chan,:);
                        else
                            refchData = guiobj.ephys_data(refch,:);
                        end
                    else
                        if all(ismember(refch, chan))
                            refchData = mean(data(ismember(chan, refch),:));
                        else
                            refchData = mean(guiobj.ephys_data(refch,:));
                        end
                    end
                    
                    if any(ismember(refch, chan))
                        data(ismember(chan, refch),:) = [];
                        chan(ismember(chan, refch)) = [];
                    end
                else
                    refchData = [];
                end
                            
            else
                refchData = [];
            end
            
            switch dettype
                case 'CWT based'
                    minLen = str2double(guiobj.ephysCwtDetMinlenEdit.String)/1000;
                    sdmult = str2double(guiobj.ephysCwtDetSdMultEdit.String);
                    w1 = str2double(guiobj.ephysCwtDetW1Edit.String);
                    w2 = str2double(guiobj.ephysCwtDetW2Edit.String);
                    refVal = guiobj.ephysCwtDetRefValPopMenu.Value - 1;
                    
                    % Handling no input cases
                    if (isempty(minLen)||isnan(minLen)) || (isempty(sdmult)||isnan(sdmult))...
                            || (isempty(w1)||isnan(w1)) || (isempty(w2)||isnan(w2))
                        errordlg('Missing parameters!')
                        guiobj.ephysDetStatusLabel.String = '--IDLE--';
                        guiobj.ephysDetStatusLabel.BackgroundColor = 'g';
                        return
                    end
                                                            
                    if refVal && (isempty(refch) || any(isnan(refch)))
                        errordlg('No reference channel specified!')
                        guiobj.ephysDetStatusLabel.String = '--IDLE--';
                        guiobj.ephysDetStatusLabel.BackgroundColor = 'g';
                        return
                    end
                    
                    if (refVal || (guiobj.ephysDetArtSuppPopMenu.Value ~= 1)) && ((length(chan) == 1) && (chan == refch))
                        errordlg('Requested channel and the reference channel are the same!')
                        guiobj.ephysDetStatusLabel.String = '--IDLE--';
                        guiobj.ephysDetStatusLabel.BackgroundColor = 'g';
                        return
                    end
                                        
                    if ~refVal
                        [dets,detBorders,detParams,evComplexes] = wavyDet(data,inds2use,tAxis,chan,fs,minLen,sdmult,w1,w2,0,0,[],showFigs);
                    elseif refVal
                        [dets,detBorders,detParams,evComplexes] = wavyDet(data,inds2use,tAxis,chan,fs,minLen,sdmult,w1,w2,refVal,refch,refchData,showFigs);
                    end
                    
                    detinfo.DetType = "CWT";
                    detinfo.DetSettings.W1 = w1;
                    detinfo.DetSettings.W2 = w2;
                    detinfo.DetSettings.MinLen = minLen*1000;
                    detinfo.DetSettings.SdMult = sdmult;
                    detinfo.DetSettings.RefVal = refVal;
%                     detinfo.DetSettings.RefCh = refch;
                    detinfo.DetSettings.RefCh = regexprep(refchInp, ' +', '');
                    
                case 'Adaptive threshold'
                    step = eval(guiobj.ephysAdaptDetStepEdit.String)/1000;
                    mindist = eval(guiobj.ephysAdaptDetMindistEdit.String)/1000;
                    minLen = eval(guiobj.ephysAdaptDetMinwidthEdit.String)/1000;
                    ratio = eval(guiobj.ephysAdaptDetRatioEdit.String)/100;
                    
                    % Handling no input cases
                    if (isempty(step)||isnan(step)) || (isempty(mindist)||isnan(mindist))...
                            || (isempty(minLen)||isnan(minLen)) || (isempty(ratio)||isnan(ratio))
                        errordlg('Missing parameters!')
                        guiobj.ephysDetStatusLabel.String = '--IDLE--';
                        guiobj.ephysDetStatusLabel.BackgroundColor = 'g';
                        return
                    end
                    
                    dets = cell(min(size(data)),1);
                    detBorders = cell(min(size(data)),1);
                    for i = 1:min(size(data))
                        [detsTemp,detBordersTemp] = adaptive_thresh(data(i,:),tAxis,fs,step,minLen,mindist,ratio,showFigs);
%                         dets(i,:) = detsTemp;
                        dets{i} = detsTemp;
                        detBorders(i) = detBordersTemp;
                    end
                    detParams = cell(min(size(data)),1);
                    
                    detinfo.DetType = "Adapt";
                    detinfo.DetSettings.Step = step*1000;
                    detinfo.DetSettings.MinLen = minLen*1000;
                    detinfo.DetSettings.MinDist = mindist*1000;
                    detinfo.DetSettings.Ratio = ratio;
                    
                    % to comply with a check later on
                    refVal = 0;
                    
                case 'DoG+InstPow'
                    w1 = str2double(guiobj.ephysDoGInstPowDetW1Edit.String);
                    w2 = str2double(guiobj.ephysDoGInstPowDetW2Edit.String);
                    sdmult = str2double(guiobj.ephysDoGInstPowDetSdMultEdit.String);
                    minLen = str2double(guiobj.ephysDoGInstPowDetMinLenEdit.String)/1000;
                    refVal = guiobj.ephysDogInstPowDetRefValPopMenu.Value - 1;
                    
                    % Handling no input cases
                    if (isempty(w1)||isnan(w1)) || (isempty(w2)||isnan(w2))...
                            || (isempty(sdmult)||isnan(sdmult)) || (isempty(minLen)||isnan(minLen))
                        errordlg('Missing parameters!')
                        guiobj.ephysDetStatusLabel.String = '--IDLE--';
                        guiobj.ephysDetStatusLabel.BackgroundColor = 'g';
                        return
                    end
                    
                    if refVal && (isempty(refch) || any(isnan(refch)))
                        errordlg('No reference channel specified!')
                        guiobj.ephysDetStatusLabel.String = '--IDLE--';
                        guiobj.ephysDetStatusLabel.BackgroundColor = 'g';
                        return
                    end
                    
                    if (refVal || (guiobj.ephysDetArtSuppPopMenu.Value ~= 1)) && ((length(chan) == 1) && (chan == refch))
                        errordlg('Requested channel and the reference channel are the same!')
                        guiobj.ephysDetStatusLabel.String = '--IDLE--';
                        guiobj.ephysDetStatusLabel.BackgroundColor = 'g';
                        return
                    end
                    
                    if ~refVal
                        [dets,detBorders,detParams,evComplexes] = DoGInstPowDet(data,inds2use,tAxis,chan,fs,w1,w2,sdmult,minLen,0,0,[],showFigs);
                    elseif refVal
                        [dets,detBorders,detParams,evComplexes] = DoGInstPowDet(data,inds2use,tAxis,chan,fs,w1,w2,sdmult,minLen,refVal,refch,refchData,showFigs);
                    end
                    
                    detinfo.DetType = "DoGInstPow";
                    detinfo.DetSettings.W1 = w1;
                    detinfo.DetSettings.W2 = w2;
                    detinfo.DetSettings.MinLen = minLen*1000;
                    detinfo.DetSettings.SdMult = sdmult;
                    detinfo.DetSettings.RefVal = refVal;
%                     detinfo.DetSettings.RefCh = refch;
                    detinfo.DetSettings.RefCh = regexprep(refchInp, ' +', '');
            end
            
            % eliminate channels from detection cell with no dets
            emptyCells = cellfun('isempty',dets);
            if ~isempty(find(emptyCells, 1))
                dets(emptyCells) = [];
                detBorders(emptyCells) = [];
                detParams(emptyCells) = [];
                chan(emptyCells) = [];
            end
            detinfo.DetChannel = chan;
            
            detinfo.DownSamp = guiobj.ephys_downSampd;
            
            % check whether the only detections are in the reference
            % channel
            if (refVal ~= 0) && (any(ismember(chan, refch)))
                temp = dets;
                temp(ismember(chan, refch)) = [];
                detsOnlyInRef = ~sum(~cellfun('isempty',temp));
            else
                detsOnlyInRef = false;
            end
            
            if ~sum(~cellfun('isempty',dets)) || detsOnlyInRef
                
                guiobj.ephys_detections = {};
                guiobj.ephys_globalDets = [];
                guiobj.ephys_eventComplexes = {};
                guiobj.ephys_detBorders = {};
                guiobj.ephys_detParams = {};
                guiobj.ephys_detectionsInfo = [];
                
                eD = errordlg('No events were found!');
                pause(1)
                if ishandle(eD)
                    close(eD)
                end
                eventDetPlotFcn(guiobj,1,0,1)
                guiobj.ephysDetStatusLabel.String = '--IDLE--';
                guiobj.ephysDetStatusLabel.BackgroundColor = 'g';
                return                
            end
            
            % find global events
            guiobj.ephys_globalDets = extractGlobalEvents(dets,round(0.05*fs));
            
            % recompute the ephys data types
            if (exist('w1','var') == 1) && (exist('w2','var') == 1)
                guiobj.eventDet1W1 = w1;
                guiobj.eventDet1W2 = w2;
            end
            computeEphysDataTypes(guiobj)
            
            % add running related parameters if relevant
            if guiobj.datatyp(3) && guiobj.useRunData4DetsCheckBox.Value
                for i = 1:length(detParams) % looping over channels
                    for j = 1:length(detParams{i}) % looping over dets
                        ephysBorders = detBorders{i}(j,:);
                        
                        runTaxis = guiobj.run_taxis;
                        ephysTaxis = guiobj.ephys_taxis;
                        [~,runBorders(1)] = min(abs(runTaxis - ephysTaxis(ephysBorders(1))));
                        [~,runBorders(2)] = min(abs(runTaxis - ephysTaxis(ephysBorders(2))));
                        
                        avgSpd = mean(guiobj.run_veloc(runBorders(1):runBorders(2)));
                        avgPos = mean(guiobj.run_relPos(runBorders(1):runBorders(2)));
                        detParams{i}(j).AvgSpeed = avgSpd;
                        detParams{i}(j).RelPos = avgPos;
                    end
                end
            end
                        
            guiobj.ephys_detections = dets;
            
            guiobj.ephys_eventComplexes = evComplexes;
            
            guiobj.ephys_detBorders = detBorders;
            
            guiobj.ephys_detParams = detParams;
            
            guiobj.ephys_detectionsInfo = detinfo;
            
            guiobj.evDetTabSimultMode = 0;
            
            guiobj.ephysDetStatusLabel.String = '--IDLE--';
            guiobj.ephysDetStatusLabel.BackgroundColor = 'g';
                        
            eventDetAxesButtFcn(guiobj,1,0,0);
        end
        
        %%
        function imagingDetPopMenuSelected(guiobj)
            dettype = guiobj.imagingDetPopMenu.Value;
            dettype = guiobj.imagingDetPopMenu.String{dettype};
            
            switch dettype
                case 'Mean+SD'
                    guiobj.imagingMeanSdDetPanel.Visible = 'on';
                    guiobj.imagingMlSpDetPanel.Visible = 'off';
                case 'MLspike based'
                    guiobj.imagingMlSpDetPanel.Visible = 'on';
                    guiobj.imagingMeanSdDetPanel.Visible = 'off';
                otherwise
                    guiobj.imagingMeanSdDetPanel.Visible = 'off';
                    guiobj.imagingMlSpDetPanel.Visible = 'off';
                
            end
        end
        
        %%
        function simultDetPopMenuSelected(guiobj)
            dettype = guiobj.simultDetPopMenu.Value;
            dettype = guiobj.simultDetPopMenu.String{dettype};
            
            switch dettype
                case 'Standard'
                    guiobj.simultDetStandardPanel.Visible = 'on';
                
            end
        end
        
        %%
        function imagingDetRun(guiobj)
            guiobj.imagingDetStatusLabel.String = 'Detection running';
            guiobj.imagingDetStatusLabel.BackgroundColor = 'r';
            drawnow
            
            dettype = guiobj.imagingDetPopMenu.Value;
            dettype = guiobj.imagingDetPopMenu.String{dettype};
            
            if ~guiobj.imagingDetUseProcDataCheckBox.Value
                data = guiobj.imaging_data;
                roi = 1:size(data,1);
                guiobj.imaging_artSupp4Det = 0;
            else
                selInds = makeProcDataSelFig(guiobj,2);
                guiobj.imaging_artSuppedData4DetListInds = selInds;
                if isempty(selInds)
                    ed = errordlg('No ROI selected!');
                    pause(1)
                    if ishandle(ed)
                        close(ed)
                    end
                    guiobj.imagingDetStatusLabel.String = '--IDLE--';
                    guiobj.imagingDetStatusLabel.BackgroundColor = 'g';
                    return
                end
                data = guiobj.imaging_procced(selInds,:);
                roi = [guiobj.imaging_proccedInfo(selInds).ROI];
                guiobj.imaging_artSupp4Det = 1;
                detinfo.DetSettings.ArtSupp = guiobj.imaging_proccedInfo(selInds(1)).ProcDetails(1).Type;
            end
            fs = guiobj.imaging_fs;
            
            % check whether running data based detection was requested
            if guiobj.datatyp(3) && guiobj.useRunData4DetsCheckBox.Value
                inds2use = convertRunInds4Dets(guiobj,2);
                
                detinfo.DetSettings.SpeedRange = ['[',guiobj.speedRange4DetsEdit1.String,' , '...
                    guiobj.speedRange4DetsEdit2.String,']'];
                detinfo.DetSettings.MinTimeInRange = str2double(guiobj.minTimeInSpeedRangeEdit.String);
                
                if isempty(inds2use)
                    warndlg('No sections satisfied the running specifications!')
                    guiobj.ephysDetStatusLabel.String = '--IDLE--';
                    guiobj.ephysDetStatusLabel.BackgroundColor = 'g';
                    return
                elseif (length(inds2use) / fs) < (str2double(guiobj.minTimeInSpeedRangeEdit.String) / 1000)
                    errordlg('The section falling in the specified speed range is too short!')
                    guiobj.ephysDetStatusLabel.String = '--IDLE--';
                    guiobj.ephysDetStatusLabel.BackgroundColor = 'g';
                    return
                end
            else
                inds2use = 'all';
            end            
            
            dets = cell(min(size(data)),1);
            detBorders = cell(min(size(data)),1);
            detParams = cell(min(size(data)),1);
            evComplexes = cell(min(size(data)),1);
            switch dettype
                case 'Mean+SD'
                    sdmult = str2double(guiobj.imagingMeanSdDetSdmultEdit.String);
                    winLen = str2double(guiobj.imagingMeanSdDetWinSizeEdit.String);
                    
                    detData = nan(size(data));
                    thr = nan(size(data,1),1);
                    extThr = nan(size(data,1),1);
                    
                    detinfo.DetType = 'Mean+SD';
                    detinfo.DetSettings.SdMult = sdmult;

                    if ~guiobj.imagingMeanSdDetSlideAvgCheck.Value
                        for i = 1:size(data,1)
                            detData(i,:) = smoothdata(data(i,:),'gaussian',winLen);
                            thr(i) = mean(detData(i,:)) + sdmult*std(detData(i,:));
                            extThr(i) = mean(detData(i,:)) + std(detData(i,:));
                        end
                        minLen = 0.03;
                        detinfo.DetSettings.WinType = 'Gaussian';
                        detinfo.DetSettings.WinLen = winLen;
                    else
                        for i = 1:size(data,1)
                            detData(i,:) = movmean(data(i,:),3);
                            thr(i) = mean(data(i,:)) + sdmult*std(data(i,:));
                            extThr(i) = mean(data(i,:)) + std(data(i,:));
                        end
                        minLen = 0;
                        detinfo.DetSettings.WinType = '3-point mean';
                        detinfo.DetSettings.WinLen = 3;
                    end
                    
                    [dets,detBorders] = commDetAlg(guiobj.imaging_taxis,1:size(data,1),inds2use,data,detData,...
                        [],0,[],[],fs,thr,0,minLen,extThr);
                    
                    for i = 1:size(data,1)
                        [detParams{i}, evComplexes{i}] = detParamMiner(2,dets{i},detBorders{i},fs,...
                            data(i,:),detData(i,:),[],guiobj.imaging_taxis);
                        
                    end

                case 'MLspike based' % in experimental phase
                    par = tps_mlspikes('par');
                    par.dt = 1/fs;
                    par.a = str2double(guiobj.imagingMlSpDetDFFSpikeEdit.String);
                    par.tau = str2double(guiobj.imagingMlSpDetTauEdit.String);
                    par.finetune.sigma = str2double(guiobj.imagingMlSpDetSigmaEdit.String);
                    par.dographsummary = false;
                    
                    numSpikes = zeros(size(data));
                    for i = 1:size(data,1)
                        numSpikes(i,:) = tps_mlspikes(data(i,:),par);
                        [binSize,binEdges] = histcounts(numSpikes(i,:));
                        if (binSize(end)/sum(binSize)) < 0.015
                            goodBin = mean(binEdges(end-1:end));
                            dets{i} = numSpikes(i,:)==goodBin;
                        end
                    end
                    
                    detinfo.DetType = 'MLspike based';
                    detinfo.DetSettings = par;
            end
            
            % eliminating empty rois from detection cell
            emptyCells = cellfun('isempty',dets);
            if ~isempty(find(emptyCells, 1))
                dets(emptyCells) = [];
                detBorders(emptyCells) = [];
                detParams(emptyCells) = [];
                roi(emptyCells) = [];
            end
            detinfo.DetROI = roi;
            
            detinfo.UpSamp = guiobj.imaging_upSampd;
            
            if ~sum(~cellfun('isempty',dets))
                guiobj.imaging_detections = {};
                guiobj.imaging_globalDets = [];
                guiobj.imaging_detectionsInfo = [];
                guiobj.imaging_detBorders = {};
                guiobj.imaging_detParams = {};
                
                warndlg('No detections!')
                eventDetPlotFcn(guiobj,2,0,1)
                guiobj.imagingDetStatusLabel.String = '--IDLE--';
                guiobj.imagingDetStatusLabel.BackgroundColor = 'g';
                return
            end
            
            % find global events
            guiobj.imaging_globalDets = extractGlobalEvents(dets,round(0.05*fs));
            
            % recompute the ephys data types
            if (exist('winLen','var') == 1)
                guiobj.eventDet2GwinSize = winLen;
            end
            computeImagingDataTypes(guiobj)
            
            % computing running related parameters if relevant
            if guiobj.datatyp(3) && guiobj.useRunData4DetsCheckBox.Value
                for i = 1:length(detParams) % looping over channels
                    for j = 1:length(detParams{i}) % looping over dets
                        imagingBorders = detBorders{i}(j,:);
                        
                        runTaxis = guiobj.run_taxis;
                        imagingTaxis = guiobj.imaging_taxis;
                        [~,runBorders(1)] = min(abs(runTaxis - imagingTaxis(imagingBorders(1))));
                        [~,runBorders(2)] = min(abs(runTaxis - imagingTaxis(imagingBorders(2))));
                        
                        avgSpd = mean(guiobj.run_veloc(runBorders(1):runBorders(2)));
                        avgPos = mean(guiobj.run_relPos(runBorders(1):runBorders(2)));
                        detParams{i}(j).AvgSpeed = avgSpd;
                        detParams{i}(j).RelPos = avgPos;
                    end
                end
            end
            
            guiobj.imaging_detections = dets;

            guiobj.imaging_detectionsInfo = detinfo;

            guiobj.imaging_detBorders = detBorders;

            guiobj.imaging_detParams = detParams;
            
            guiobj.imaging_eventComplexes = evComplexes;

            guiobj.evDetTabSimultMode = 0;
            
            guiobj.imagingDetStatusLabel.String = '--IDLE--';
            guiobj.imagingDetStatusLabel.BackgroundColor = 'g';
            
            eventDetAxesButtFcn(guiobj,2,0,0)
        end
        
        %%
        function simultDetRun(guiobj)
            if ~sum(~cellfun('isempty',guiobj.ephys_detections)) || ~sum(~cellfun('isempty',guiobj.imaging_detections))
                errordlg('Both electrophysiology and imaging detections are needed!')
                return
            end
            
            guiobj.simultDetStatusLabel.String = 'Detection running';
            guiobj.simultDetStatusLabel.BackgroundColor = 'r';
            drawnow
            
            dettype = guiobj.simultDetPopMenu.Value;
            dettype = guiobj.simultDetPopMenu.String{dettype};
            
            if strcmp(dettype,'--Simultan detection methods--')
                warndlg('Choose detection type!')
                return 
            end
            
            ephys_tAx = guiobj.ephys_taxis;
            ephysDetParams = guiobj.ephys_detParams;
            for i = 1:length(ephysDetParams)
                [ephysDetParams{i}.NumSimultEvents] = deal(0);
            end
            
            imaging_tAx = guiobj.imaging_taxis;
            imDetParams = guiobj.imaging_detParams;
            for i = 1:length(imDetParams)
                [imDetParams{i}.NumSimultEvents] = deal(0);
            end
            
            simultDets = [];
            
            switch dettype
                case 'Standard'
                    delay1 = str2double(guiobj.simultDetStandardDelayEdit1.String)/1000;
                    delay2 = str2double(guiobj.simultDetStandardDelayEdit2.String)/1000;
                    for ephysRowNum = 1:size(guiobj.ephys_detections,1)
                        chan = guiobj.ephys_detectionsInfo.DetChannel(ephysRowNum);
                        ephys_detInds = guiobj.ephys_detections{ephysRowNum};
                        
                        for imRowNum = 1:size(guiobj.imaging_detections,1)
                            imaging_detInds = guiobj.imaging_detections{imRowNum};
                            roi = guiobj.imaging_detectionsInfo.DetROI(imRowNum);
                                                        
                            for i = 1:length(ephys_detInds)
                                for j = 1:length(imaging_detInds)
                                    tDiff = imaging_tAx(imaging_detInds(j))...
                                        - ephys_tAx(ephys_detInds(i));
                                    if (tDiff > delay1) && (tDiff < delay2)
                                        eventPair = [chan,i,roi,j];
                                        
                                        % appending #simult events to
                                        % parameters
                                        temp = ephysDetParams{ephysRowNum}(i).NumSimultEvents;
                                        if ~isempty(temp)
                                            temp = temp + 1;
                                        else
                                            temp = 1;
                                        end
                                        ephysDetParams{ephysRowNum}(i).NumSimultEvents = temp;

                                        temp = imDetParams{imRowNum}(j).NumSimultEvents;
                                         if ~isempty(temp)
                                            temp = temp + 1;
                                        else
                                            temp = 1;
                                        end
                                        imDetParams{imRowNum}(j).NumSimultEvents = temp;
                                        
                                        simultDets = [simultDets; eventPair];
                                    end
                                end
                                
                            end
%                           
                        end
                        
                    end
                    
                    if isempty(simultDets)
                        warndlg('No simultaneous events found!')
                        guiobj.simultDetStatusLabel.String = '--IDLE--';
                        guiobj.simultDetStatusLabel.BackgroundColor = 'g';
                        return
                    end
                    
                    simultDets = sortrows(simultDets);

                    simultDetInfo.DetType = dettype;
                    simultDetInfo.EphysChannels = unique(simultDets(:,1));
                    simultDetInfo.ROIs = unique(simultDets(:,3));
                    simultDetInfo.Settings.Delay = ['[',num2str(delay1),' , ',num2str(delay2),']'];
            end
            
            if isempty(simultDets)
                warndlg('No simultaneous events found!')
                guiobj.simultDetStatusLabel.String = '--IDLE--';
                guiobj.simultDetStatusLabel.BackgroundColor = 'g';
                return
            end
            
            guiobj.simult_detections = simultDets;
            
            guiobj.simult_detectionsInfo = simultDetInfo;
            
            guiobj.ephys_detParams = ephysDetParams;
            guiobj.imaging_detParams = imDetParams;

            guiobj.evDetTabSimultMode = 1;

            eventDetAxesButtFcn(guiobj,1,0,0)
            eventDetAxesButtFcn(guiobj,2,0,0)
                        
            guiobj.simultDetStatusLabel.String = '--IDLE--';
            guiobj.simultDetStatusLabel.BackgroundColor = 'g';
        end
        
        %%
        function changeEventDetTabDataType(guiobj,dTyp)
            switch dTyp
                case 1
                    if isempty(guiobj.ephys_data)
                        warndlg('No electrophysiological data loaded!')
                        return
                    end
                    list = {'RawData','DoG','InstPow'};
                    [idx,tf] = listdlg('ListString',list,...
                        'InitialValue',guiobj.eventDet1DataType,...
                        'SelectionMode','single');
                    if ~tf
                        return
                    end
                    guiobj.eventDet1DataType = idx;
                    
                    eventDetAxesButtFcn(guiobj,1)
                case 2
                    if isempty(guiobj.imaging_data)
                        warndlg('No imaging data loaded!')
                        return
                    end
                    list = {'RawData','Gauss smoothed'};
                    [idx,tf] = listdlg('ListString',list,...
                        'InitialValue',guiobj.eventDet2DataType);
                    if ~tf
                        return
                    end
                    guiobj.eventDet2DataType = idx;
                    switch idx
                        case 2
                            guiobj.imaging_smoothed = smoothdata(guiobj.imaging_data,...
                                2,'gaussian',str2double(guiobj.imagingMeanSdDetWinSizeEdit.String));
                    end
                    eventDetAxesButtFcn(guiobj,2)
            end
        end
        
        %%
        function changeEventDetTabCutoff(guiobj)
            if isempty(guiobj.ephys_data)
                warndlg('No electrophysiological data loaded!')
                return
            end
            
            prompt = {'Lower cutoff [Hz]','Upper cutoff [Hz]'};
            title = 'Frequency band for EventDetTab electrophysiology graphs';
            dims = [1, 15];
            definput = {num2str(guiobj.eventDet1W1),...
                num2str(guiobj.eventDet1W2)};
            answer = inputdlg(prompt,title,dims,definput);
            if isempty(answer)
                return
            end
            guiobj.eventDet1W1 = str2double(answer{1});
            guiobj.eventDet1W2 = str2double(answer{2});
            
            computeEphysDataTypes(guiobj)
                        
            eventDetAxesButtFcn(guiobj,1)
        end
        
        %%
        function changeEventDetTabWinSize(guiobj)
            prompt = {'Ephys | Window size around event [ms]', 'Imaging | Window size around event [ms]'};
            title = 'Window size around detected event';
            dims = [1,15];
            definput = {num2str(guiobj.eventDet1Win), num2str(guiobj.eventDet2Win)};
            
            answer = inputdlg(prompt,title,dims,definput);
            if isempty(answer)
                return
            end
            
            if guiobj.datatyp(1)
                guiobj.eventDet1Win = str2double(answer{1});
                eventDetAxesButtFcn(guiobj,1)
            end
            if guiobj.datatyp(2)
                guiobj.eventDet2Win = str2double(answer{2});
                eventDetAxesButtFcn(guiobj,2)
            end
        end
        
        %%
        function evDetTabYlimModeMenuCB(guiobj)
            if strcmp(guiobj.evDetTabYlimMode, 'global')
                guiobj.evDetTabYlimMode = 'window';
                guiobj.evDetTabYlimModeMenu.Text = 'Event plotting Y limit, current mode: window';
            elseif strcmp(guiobj.evDetTabYlimMode, 'window')
                guiobj.evDetTabYlimMode = 'global';
                guiobj.evDetTabYlimModeMenu.Text = 'Event plotting Y limit, current mode: global';
            end
            
            eventDetAxesButtFcn(guiobj,1)
            eventDetAxesButtFcn(guiobj,2)
        end
        
        %%
        function mainFigOpenFcn(guiobj)
            % Check if logfile exists
            DASlocation = mfilename('fullpath');
            DASlocation = DASlocation(1:end-3);
            fID = fopen([DASlocation,'DAS_LOG.mat']);
            % If it does, load it, if it doesnt create it
            if fID >= 3
                try
                    load([DASlocation,'DAS_LOG.mat'])
                    disp('Log file found and loaded.')
                catch
                    disp('Log file could not be loaded! A new one will be generated when you close the GUI.')
                    return
                end
                
                try
                    temp = DAS_LOG.lastState.eventDetTab.ephys.DoGInstPow;
                    guiobj.ephysDoGInstPowDetW1Edit.String = temp.w1;
                    guiobj.ephysDoGInstPowDetW2Edit.String = temp.w2;
                    guiobj.ephysDoGInstPowDetSdMultEdit.String = temp.sdmult;
                    guiobj.ephysDoGInstPowDetMinLenEdit.String = temp.minLen;
                    guiobj.ephysDogInstPowDetRefValPopMenu.Value = temp.refVal;
                    clear temp
                catch
                    disp('Last state of DoG+InstPow detection settings could not be loaded! They will be saved when you close the GUI.')
                end
                
                try
                    temp = DAS_LOG.lastState.eventDetTab.ephys.CWT; 
                    guiobj.ephysCwtDetMinlenEdit.String = temp.minlen;
                    guiobj.ephysCwtDetSdMultEdit.String = temp.sdmult;
                    guiobj.ephysCwtDetW1Edit.String = temp.w1;
                    guiobj.ephysCwtDetW2Edit.String = temp.w2;
                    guiobj.ephysCwtDetRefValPopMenu.Value = temp.refVal;
                    clear temp
                catch
                    disp('Last state of CWT based detection settings could not be loaded! They will be saved when you close the GUI.')
                end
                
                guiobj.ephysDetRefChanEdit.String = DAS_LOG.lastState.eventDetTab.ephys.refChan;

                temp = DAS_LOG.presets.ephys;
                guiobj.ephys_presets = temp;
                try
                    presetList = guiobj.ephysDoGInstPowDetPresetPopMenu.String;
                    for i = 1:length(temp.evDetTab.DoGInstPow)
                         presetList = [presetList; string(temp.evDetTab.DoGInstPow(i).name)];
                    end
                    guiobj.ephysDoGInstPowDetPresetPopMenu.String = presetList;
                catch
                    disp('DoGInstPow presets could not be loaded!')
                end

                try
                    presetList = guiobj.ephysCwtDetPresetPopMenu.String;
                    for i = 1:length(temp.evDetTab.Cwt)
                         presetList = [presetList; string(temp.evDetTab.Cwt(i).name)];
                    end
                    guiobj.ephysCwtDetPresetPopMenu.String = presetList;
                catch
                    disp('CwtDet presets could not be loaded!')
                end
                clear temp

                try
                    temp = DAS_LOG.lastState.eventDetTab.imaging.MeanSd;
                    guiobj.imagingMeanSdDetSdmultEdit.String = temp.sdMult;
                    guiobj.imagingMeanSdDetWinSizeEdit.String = temp.winSize;
                    guiobj.imagingMeanSdDetSlideAvgCheck.Value = temp.slideAvgCheck;
                    clear temp
                catch
                    disp('Last state of Mean+Sd based imaging detection settings could not be loaded! They will be saved when you close the GUI.')
                end

                try
                    temp = DAS_LOG.lastState.eventDetTab.imaging.MLspike;
                    guiobj.imagingMlSpDetDFFSpikeEdit.String = temp.dFF;
                    guiobj.imagingMlSpDetSigmaEdit.String = temp.sigma;
                    guiobj.imagingMlSpDetTauEdit.String = temp.tau;
                    clear temp
                catch
                    disp('Last state of MLspike based detection settings could not be loaded! They will be saved when you close the GUI.')
                end

%                 fclose(fID);
            else
                disp('No log file found! It will be created when closing the GUI.')
            end
            
            fclose(fID);
        end
        
        %%
        function mainFigCloseFcn(guiobj)
            temp.w1 = guiobj.ephysDoGInstPowDetW1Edit.String;
            temp.w2 = guiobj.ephysDoGInstPowDetW2Edit.String;
            temp.sdmult = guiobj.ephysDoGInstPowDetSdMultEdit.String;
            temp.minLen = guiobj.ephysDoGInstPowDetMinLenEdit.String;
            temp.refVal = guiobj.ephysDogInstPowDetRefValPopMenu.Value;
            
            DAS_LOG.lastState.eventDetTab.ephys.DoGInstPow = temp;
            clear temp
            
            temp.minlen = guiobj.ephysCwtDetMinlenEdit.String;
            temp.sdmult = guiobj.ephysCwtDetSdMultEdit.String;
            temp.w1 = guiobj.ephysCwtDetW1Edit.String;
            temp.w2 = guiobj.ephysCwtDetW2Edit.String;
            temp.refVal = guiobj.ephysCwtDetRefValPopMenu.Value;
            
            DAS_LOG.lastState.eventDetTab.ephys.CWT = temp;
            clear temp
                        
            DAS_LOG.lastState.eventDetTab.ephys.refChan = guiobj.ephysDetRefChanEdit.String;
            
            DAS_LOG.presets.ephys = guiobj.ephys_presets;
            
            temp.sdMult = guiobj.imagingMeanSdDetSdmultEdit.String;
            temp.winSize = guiobj.imagingMeanSdDetWinSizeEdit.String;
            temp.slideAvgCheck = guiobj.imagingMeanSdDetSlideAvgCheck.Value;
            
            DAS_LOG.lastState.eventDetTab.imaging.MeanSd = temp;
            clear temp
            
            temp.dFF = guiobj.imagingMlSpDetDFFSpikeEdit.String;
            temp.sigma = guiobj.imagingMlSpDetSigmaEdit.String;
            temp.tau = guiobj.imagingMlSpDetTauEdit.String;
            
            DAS_LOG.lastState.eventDetTab.imaging.MLspike = temp;
            clear temp
            
            DASlocation = mfilename('fullpath');
            DASlocation = DASlocation(1:end-3);
            save([DASlocation,'DAS_LOG.mat'],'DAS_LOG')
            
            delete(guiobj)
        end
        
        %%
        function presetSave(guiobj,dtyp,procID)
%             display(varargin)
%             dtyp = varargin{1}
%             procID = varargin{2}
            answer = inputdlg('Name of preset:','Saving new preset');
%             assignin('base','answ',answer)
            if isempty(answer)
                return
            end
            
            switch dtyp
                case 1 %ephys
                    switch procID
                        case 1 % CWT based
                            temp = guiobj.ephysCwtDetPresetPopMenu.String;
%                             assignin('base','popmenustring',temp)
                            temp = [temp; string(answer{1})];
                            guiobj.ephysCwtDetPresetPopMenu.String = temp;
                            clear temp
                            
%                             temp = guiobj.ephys_presets.evDetTab.DoGInstPow;
%                             temp2 = temp.evDetTab.DoGInstPow;
                            new.name = answer{1};
                            new.w1 = guiobj.ephysCwtDetW1Edit.String;
                            new.w2 = guiobj.ephysCwtDetW2Edit.String;
                            new.sdmult = guiobj.ephysCwtDetSdMultEdit.String;
                            new.minLen = guiobj.ephysCwtDetMinlenEdit.String;
                            new.refVal = guiobj.ephysCwtDetRefValPopMenu.Value;
                            
                            if isempty(guiobj.ephys_presets) || ~isfield(guiobj.ephys_presets.evDetTab,'Cwt')
                                guiobj.ephys_presets.evDetTab.Cwt = [];
                            end
                            
                            guiobj.ephys_presets.evDetTab.Cwt = [guiobj.ephys_presets.evDetTab.Cwt, new];
                        case 2 % adaptive thresh
                            
                        case 3 % DogInstpow
                            temp = guiobj.ephysDoGInstPowDetPresetPopMenu.String;
%                             assignin('base','popmenustring',temp)
                            temp = [temp; string(answer{1})];
                            guiobj.ephysDoGInstPowDetPresetPopMenu.String = temp;
                            clear temp
                            
%                             temp = guiobj.ephys_presets.evDetTab.DoGInstPow;
%                             temp2 = temp.evDetTab.DoGInstPow;
                            new.name = answer{1};
                            new.w1 = guiobj.ephysDoGInstPowDetW1Edit.String;
                            new.w2 = guiobj.ephysDoGInstPowDetW2Edit.String;
                            new.sdmult = guiobj.ephysDoGInstPowDetSdMultEdit.String;
                            new.minLen = guiobj.ephysDoGInstPowDetMinLenEdit.String;
                            new.refVal = guiobj.ephysDogInstPowDetRefValPopMenu.Value;
                            
                            if isempty(guiobj.ephys_presets) || ~isfield(guiobj.ephys_presets.evDetTab,'DoGInstPow')
                                guiobj.ephys_presets.evDetTab.DoGInstPow = [];
                            end
                            
                            guiobj.ephys_presets.evDetTab.DoGInstPow = [guiobj.ephys_presets.evDetTab.DoGInstPow, new];
%                             temp = guiobj.ephys_presets.evDetTab.DoGInstPow;
                            
%                             temp = [temp, new];
                    end
                    
%                     guiobj.ephys_presets = [guiobj.ephys_presets; temp2];
%                     guiobj.ephys_presets = temp;
%                     clear temp
                case 2 %imaging
                    
            end
        end
        
        %%
        function presetDel(guiobj,dtyp,procID)
%             dtyp = varargin{1};
%             procID = varargin{2};
            [idx,tf] = listdlg('ListString',guiobj.ephysDoGInstPowDetPresetPopMenu.String);
            % There is a title as the first entry of the popmenu!
            if ~tf
                return 
            end
            
            switch dtyp
                case 1 %ephys
                    switch procID
                        case 1 % CWT based
                            guiobj.ephysCwtDetPresetPopMenu.Value = 1;
                            guiobj.ephysCwtDetPresetPopMenu.String(idx) = [];
                            guiobj.ephys_presets.evDetTab.Cwt(idx-1) = [];
                        case 2 % adaptive thresh
                            
                        case 3 % DogInstpow
                            guiobj.ephysDoGInstPowDetPresetPopMenu.Value = 1;
                            guiobj.ephysDoGInstPowDetPresetPopMenu.String(idx) = [];
                            guiobj.ephys_presets.evDetTab.DoGInstPow(idx-1) = [];
                    end
                case 2 %imaging
                    
            end
            
            
        end
        
        %%
        function presetSel(guiobj,dtyp,procID)
%             dtyp = varargin{1};
%             procID = varargin{2};
            switch dtyp
                case 1 % ephys
                    switch procID
                        case 1 % CWT based
                            selNum = guiobj.ephysCwtDetPresetPopMenu.Value-1;
                            if selNum == 0
                                return
                            end
                            temp = guiobj.ephys_presets.evDetTab.Cwt(selNum);
                            guiobj.ephysCwtDetW1Edit.String = temp.w1;
                            guiobj.ephysCwtDetW2Edit.String = temp.w2;
                            guiobj.ephysCwtDetSdMultEdit.String = temp.sdmult;
                            guiobj.ephysCwtDetMinlenEdit.String = temp.minLen;
                            guiobj.ephysCwtDetRefValPopMenu.Value = temp.refVal;
                        case 2 % adaptive thresh
                            
                        case 3 % DoGInstpow
                            selNum = guiobj.ephysDoGInstPowDetPresetPopMenu.Value-1;
                            if selNum == 0
                                return
                            end
                            temp = guiobj.ephys_presets.evDetTab.DoGInstPow(selNum);
                            guiobj.ephysDoGInstPowDetW1Edit.String = temp.w1;
                            guiobj.ephysDoGInstPowDetW2Edit.String = temp.w2;
                            guiobj.ephysDoGInstPowDetSdMultEdit.String = temp.sdmult;
                            guiobj.ephysDoGInstPowDetMinLenEdit.String = temp.minLen;
                            guiobj.ephysDogInstPowDetRefValPopMenu.Value = temp.refVal;
                    end
                case 2 % imaging
                    
            end
        end
        
        %%
        function saveDets(guiobj)
            if (isempty(guiobj.ephys_detections) || ~sum(~cellfun('isempty',guiobj.ephys_detections)))...
                    && (isempty(guiobj.imaging_detections) || ~sum(~cellfun('isempty',guiobj.imaging_detections)))
                choice = questdlg('Both datatypes have empty detections, save anyway?');
                switch choice
                    case {'No', ''}
                        return
                        
                end
            end
            
            wb = waitbar(0,'Saving detections...');
            
            list = [];
            if ~isempty(guiobj.ephys_data)
                list = [list,"Electrophysiology"];
            end
            if ~isempty(guiobj.imaging_data)
                list = [list,"Imaging"];
            end
            if ~isempty(guiobj.simult_detections)
                list = [list,"Simultaneous"];
            end
            if isempty(list)
                if ishandle(wb)
                    close(wb)
                end
                return
            end
            [detTypeToSave,tf] = listdlg('PromptString','Which detection (or dataset if there are no detections) do you want to save?',...
                'Name','Saving detections',...
                'ListString',list,'ListSize',[250, 100]);
            if ~tf
                if ishandle(wb)
                    close(wb)
                end
                return
            end
            
            saveAllChans = 0;
            quest = ['Do you want to save the all channels/ROIs, or only those',...
                ' which were used in the detection?'];
            title = 'Save all channels';
            answer = questdlg(quest,title,'All','Those used in detection','Cancel','All');
            if strcmp(answer,'All')
                saveAllChans = 1;
            elseif isempty(answer) || strcmp(answer,'Cancel')
                if ishandle(wb)
                    close(wb)
                end
                return
            end
                
            
            if ~isempty(find(list(detTypeToSave) == "Electrophysiology",1))...
                    || ~isempty(find(list(detTypeToSave) == "Simultaneous",1)) % ephys save
                waitbar(0.33, wb, 'Saving ephys...')
                
                ephysSaveData.TAxis = guiobj.ephys_taxis;
                ephysSaveData.YLabel = guiobj.ephys_ylabel;
                ephysSaveData.Fs = guiobj.ephys_fs;
                ephysSaveData.Dets = guiobj.ephys_detections;
                ephysSaveData.GlobalDets = guiobj.ephys_globalDets;
                ephysSaveData.DetBorders = guiobj.ephys_detBorders;
                ephysSaveData.DetParams = guiobj.ephys_detParams;
                ephysSaveData.EventComplexes = guiobj.ephys_eventComplexes;
                
                if ~isempty(guiobj.ephys_detectionsInfo)
                    ephysSaveInfo = guiobj.ephys_detectionsInfo;
                else
                    guiobj.ephys_detectionsInfo.DetType = "";
                    guiobj.ephys_detectionsInfo.DetSettings = [];
                    guiobj.ephys_detectionsInfo.ArtSupp = "";
                    guiobj.ephys_detectionsInfo.AllChannel = 1:min(size(guiobj.ephys_data));
                    guiobj.ephys_detectionsInfo.DetChannel = 1:min(size(guiobj.ephys_data));
                    ephysSaveInfo = guiobj.ephys_detectionsInfo;
                end
                
                if guiobj.ephys_artSupp4Det == 0
                    ephysData2Save = guiobj.ephys_data;
                else
                    ephysData2Save = guiobj.ephys_procced(guiobj.ephys_artSuppedData4DetListInds,:);
                end
                if ~saveAllChans
                    chans2Save = guiobj.ephys_detectionsInfo.DetChannel;
                    if guiobj.ephys_artSupp4Det ~= 0
                        temp = guiobj.ephys_proccedInfo(guiobj.ephys_artSuppedData4DetListInds);
                        temp = ismember([temp.Channel],chans2Save);
                        ephysSaveData.RawData = ephysData2Save(temp,:);
                    else
                        ephysSaveData.RawData = ephysData2Save(chans2Save,:);
                    end
                    ephysSaveInfo.AllChannel = chans2Save;
                else
                    ephysSaveData.RawData = ephysData2Save;
                    ephysSaveInfo.AllChannel = 1:min(size(guiobj.ephys_data));
                end
                
                                
            else
                ephysSaveData = [];
                ephysSaveInfo = [];
                
            end
            
            if ~isempty(find(list(detTypeToSave) == "Imaging",1))...
                    || ~isempty(find(list(detTypeToSave) == "Simultaneous",1)) % imaging save

                waitbar(0.66, wb, 'Saving imaging...')
                
                imagingSaveData.TAxis = guiobj.imaging_taxis;
                imagingSaveData.YLabel = guiobj.imaging_ylabel;
                imagingSaveData.Fs = guiobj.imaging_fs;
                imagingSaveData.RawData = guiobj.imaging_data;
                imagingSaveData.Dets = guiobj.imaging_detections;
                imagingSaveData.GlobalDets = guiobj.imaging_globalDets;
                imagingSaveData.DetBorders = guiobj.imaging_detBorders;
                imagingSaveData.DetParams = guiobj.imaging_detParams;
                imagingSaveData.EventComplexes = guiobj.imaging_eventComplexes;
                
                if ~isempty(guiobj.imaging_detectionsInfo)
                    imagingSaveInfo = guiobj.imaging_detectionsInfo;
                else
                    guiobj.imaging_detectionsInfo.DetType = '';
                    guiobj.imaging_detectionsInfo.DetSettings = [];
                    guiobj.imaging_detectionsInfo.DetROI = 1:size(guiobj.imaging_data,1);
                    guiobj.imaging_detectionsInfo.AllROI = 1:size(guiobj.imaging_data,1);
                    imagingSaveInfo = guiobj.imaging_detectionsInfo;
                end
                
                if guiobj.imaging_artSupp4Det == 0
                    imagingData2Save = guiobj.imaging_data;
                else
                    imagingData2Save = guiobj.imaging_procced(guiobj.imaging_artSuppedData4DetListInds,:);
                end
                if ~saveAllChans
                    chans2Save = guiobj.imaging_detectionsInfo.DetROI;
                    if guiobj.imaging_artSupp4Det ~= 0
                        temp = guiobj.imaging_proccedInfo(guiobj.imaging_artSuppedData4DetListInds);
                        temp = ismember([temp.ROI],chans2Save);
                        imagingSaveData.RawData = imagingData2Save(temp,:);
                    else
                        imagingSaveData.RawData = imagingData2Save(chans2Save,:);
                    end
                    imagingSaveInfo.AllROI = chans2Save;
                else
                    imagingSaveData.RawData = imagingData2Save;
                    imagingSaveInfo.AllROI = 1:size(guiobj.imaging_data,1);
                end
                                
            else
                imagingSaveData = [];
                imagingSaveInfo = [];
                
            end
            
            if ~isempty(find(list(detTypeToSave) == "Simultaneous",1)) % simult save
                                
                if isempty(guiobj.simult_detections)
                    errordlg('No simultan detections!')
                    if ishandle(wb)
                        close(wb)
                    end
                    return
                end
                
                waitbar(0.88, wb, 'Saving simult...')
                
                simultSaveData = guiobj.simult_detections;
                simultSaveInfo = guiobj.simult_detectionsInfo;
            else
                simultSaveData = [];
                simultSaveInfo = [];
            end
            
            runData = [];
            if ~isempty(guiobj.run_taxis)
                saveRun = questdlg('Do you want to save running data?',...
                    'Save running data');
                if ~tf
                    if ishandle(wb)
                        close(wb)
                    end
                    return
                end
                if strcmp(saveRun,'Yes')
                    waitbar(0.95, wb, 'Saving running...')
                    
                    runData.taxis = guiobj.run_taxis;
                    runData.veloc = guiobj.run_veloc;
                    runData.absPos = guiobj.run_absPos;
                    runData.relPos = guiobj.run_relPos;
                    runData.lapNum = guiobj.run_lap;
                    runData.licks = guiobj.run_licks;
                end
            end
            
            comments = inputdlg('Enter comment on detection:','Comments',...
                [10,100]);
            
            waitbar(0.99, wb, 'Creating savefile...')
            
            if isempty(guiobj.rhdName)
                fname = ['DASsave_',char(datetime('now','Format','yyMMdd_HHmmss'))];
            else
                fname = ['DASsave_',guiobj.rhdName];
            end
            
            [fname,path] = uiputfile('*.mat','Save DAS detections',fname);
            if fname==0
                if ishandle(wb)
                    close(wb)
                end
                return
            elseif ~contains(fname,'DASsave')
                fname = ['DASsave_',fname];
                warndlg(['File name automatically changed to: ',fname])
            end
            oldpath = cd(path);
            
            save(fname,'ephysSaveData','ephysSaveInfo','comments',...
                'imagingSaveData','imagingSaveInfo',...
                'simultSaveData','simultSaveInfo',...
                'runData')
            cd(oldpath)
            
            waitbar(1, wb, 'Saving successful!')
            pause(1)
            if ishandle(wb)
                close(wb)
            end
            
            if ~isempty(find(list(detTypeToSave) == "Electrophysiology",1))...
                    || ~isempty(find(list(detTypeToSave) == "Simultaneous",1))
                guiobj.ephysDetStatusLabel.String = sprintf('%s\nSaved',guiobj.ephysDetStatusLabel.String);
            end
            if ~isempty(find(list(detTypeToSave) == "Imaging",1))...
                    || ~isempty(find(list(detTypeToSave) == "Simultaneous",1))
                guiobj.imagingDetStatusLabel.String = sprintf('%s\nSaved',guiobj.ephysDetStatusLabel.String);
            end
            if ~isempty(find(list(detTypeToSave) == "Simultaneous",1))
                guiobj.ephysDetStatusLabel.String = sprintf('%s\nSaved',guiobj.ephysDetStatusLabel.String);
                guiobj.imagingDetStatusLabel.String = sprintf('%s\nSaved',guiobj.imagingDetStatusLabel.String);
                guiobj.simultDetStatusLabel.String = sprintf('%s\nSaved',guiobj.simultDetStatusLabel.String);
            end
        end
        
        %%
        function keyboardPressFcn(guiobj,~,kD)
            if guiobj.tabs.SelectedTab == guiobj.tabs.Children(4)
                if strcmp(kD.Key,'d') & (sum(guiobj.datatyp) > 1)
                    switch guiobj.keyboardPressDtyp
                        case 1
                            guiobj.keyboardPressDtyp = 2;
                        case 2
                            guiobj.keyboardPressDtyp = 1;
                    end
                    
                elseif strcmp(kD.Key,'delete')
                    delCurrEventButtonCB(guiobj,guiobj.keyboardPressDtyp);
                    
                else
                    detChanUpDwn = [0,0];
                    switch kD.Key
                        case 'rightarrow'
                            detChanUpDwn = [0,1];
                            
                        case 'leftarrow'
                            detChanUpDwn = [0,-1];
                            
                        case 'uparrow'
                            detChanUpDwn = [1,0];
                            
                        case 'downarrow'
                            detChanUpDwn = [-1,0];
                            
                    end

                    eventDetAxesButtFcn(guiobj,guiobj.keyboardPressDtyp,detChanUpDwn(1),detChanUpDwn(2))
                end
            else % MATbol importáláshoz
                if strcmp(kD.Key,'m')
                    ImportMatButtionPushed(guiobj)
                end
            end
        end
        
        %%
        function showEventSpectro(guiobj)
            if isempty(guiobj.ephys_detections)
                return
            end
            
            eventDetPlotFcn(guiobj,1,1)
        end
        
        %%
        function runPosModeMenuSelected(guiobj)
            switch guiobj.mainTabPosPlotMode
                case 0
                    guiobj.mainTabPosPlotMode = 1;
                case 1
                    guiobj.mainTabPosPlotMode = 0;
            end
            runposplot(guiobj)
        end
        
        %%
        function eventDetParamInputControll(guiobj,source,setting)
            if strcmp(setting,'sd')
                if str2double(source.String) < 1
                    source.String = '1';
                    warndlg('This parameter can''t be below 1!')
                end
            elseif strcmp(setting,'imgWinLen')
                if (str2double(source.String) < 1) || (str2double(source.String) > 0.1*length(guiobj.imaging_data))
                    source.String = '5';
                    warndlg('This parameter must be at least 1 and maximally 10% of the data''s length!')
                elseif mod(str2double(source.String),1) ~= 0
                    source.String = num2str(round(str2double(source.String)));
                    warndlg('This parameter must be an integer!')
                end
            end
        end
        
        %%
        function useRunData4DetsCheckBoxCB(guiobj)
            if guiobj.useRunData4DetsCheckBox.Value
                guiobj.useRunData4DetsPanel.Visible = 'on';
            else
                guiobj.useRunData4DetsPanel.Visible = 'off';
            end
        end
        
        %%
        function delCurrEventButtonCB(guiobj,dTyp)
            switch guiobj.evDetTabSimultMode
                case 0
                    switch dTyp
                        case 1
                            if ~sum(~cellfun('isempty',guiobj.ephys_detections))
                                return
                            end
                            
                            quest = 'Are you sure you want to delete the currently displayed ephys event?';
                            butt2 = 'Delete every detection on channel';
                        case 2
                            if ~sum(~cellfun('isempty',guiobj.imaging_detections))
                                return
                            end
                            
                            quest = 'Are you sure you want to delete the currently displayed imaging event?';
                            butt2 = 'Delete every detection on ROI';
                    end
                    answer = questdlg(quest,'Detection deletion confirmation','Yes',butt2,'Cancel','Yes');
                    switch answer
                        case butt2
                            delFullChan = true;
                        case {'','Cancel'}
                            return
                        otherwise
                            delFullChan = false;
                    end
                    
                    [~,~,detNum,~,~,~,~] = extractDetStructs(guiobj,dTyp);
                    
                    switch dTyp
                        case 1 % ephys
                            currChan = guiobj.eventDet1CurrChan;
                            currDet = guiobj.eventDet1CurrDet;
                            
                            if delFullChan
                                guiobj.ephys_detections(currChan) = [];
                                guiobj.ephys_globalDets(:,currChan) = [];
                                guiobj.ephys_detParams(currChan) = [];
                                guiobj.ephys_detBorders(currChan) = [];
                                guiobj.ephys_detectionsInfo.DetChannel(currChan) = [];
                                
                                % check whether there are any detections on
                                % any channel
                                if ~sum(~cellfun('isempty',guiobj.ephys_detections))
                                    guiobj.ephys_detections = {};
                                    guiobj.ephys_globalDets = [];
                                    guiobj.ephys_eventComplexes = {};
                                    guiobj.ephys_detBorders = {};
                                    guiobj.ephys_detParams = {};
                                    guiobj.ephys_detectionsInfo = [];
                                    
                                    eventDetPlotFcn(guiobj,1,0,1)
                                    return
                                end
                                
                                % make sure event display switches correctly
                                if currChan ~= 1
                                    currChan = currChan - 1;
                                    currDet = 1;
                                end
                            else
                                guiobj.ephys_detections{currChan}(detNum) = [];
                                inGlobDets = guiobj.ephys_globalDets(:,currChan) == detNum;
                                if any(inGlobDets)
                                    globDetNum = find(inGlobDets);
                                    if length(globDetNum) > 1
                                        errordlg('There is a problem with the global events array!')
                                        return
                                    end
                                    
                                    if isempty(find(~isnan(guiobj.ephys_globalDets(globDetNum,:)), 1))
                                        guiobj.ephys_globalDets(globDetNum,:) = [];
                                    else
                                        guiobj.ephys_globalDets(globDetNum,currChan) = nan;
                                    end
                                end
                                guiobj.ephys_detParams{currChan}(detNum) = [];
                                guiobj.ephys_detBorders{currChan}(detNum,:) = [];

                                % if after deleting no detections are left on the given
                                % channel, delete that channel from the detection
                                % storage
                                detsLeft = length(guiobj.ephys_detections{currChan});
                            
                                if detsLeft == 0
                                    % check whether there are any detections on
                                    % any channel
                                    if ~sum(~cellfun('isempty',guiobj.ephys_detections))
                                        guiobj.ephys_detections = {};
                                        guiobj.ephys_globalDets = [];
                                        guiobj.ephys_eventComplexes = {};
                                        guiobj.ephys_detBorders = {};
                                        guiobj.ephys_detParams = {};
                                        guiobj.ephys_detectionsInfo = [];
                                        
                                        eventDetPlotFcn(guiobj,1,0,1)
                                        return
                                    end

                                    guiobj.ephys_detections(currChan) = [];
                                    guiobj.ephys_globalDets(:,currChan) = [];
                                    guiobj.ephys_detParams(currChan) = [];
                                    guiobj.ephys_detBorders(currChan) = [];
                                    guiobj.ephys_detectionsInfo.DetChannel(currChan) = [];

                                    % make sure event display switches correctly
                                    if currChan ~= 1
                                        currChan = currChan - 1;
                                        currDet = 1;
                                    end
                                else
                                    if currDet ~= 1
                                        currDet = currDet - 1;
                                    end
                                end
                            end
                            
                            guiobj.eventDet1CurrChan = currChan;
                            guiobj.eventDet1CurrDet = currDet;

                        case 2 % imaging
                            currChan = guiobj.eventDet2CurrRoi;
                            currDet = guiobj.eventDet2CurrDet;
                            
                            if delFullChan
                                guiobj.imaging_detections(currChan) = [];
                                guiobj.imaging_globalDets(:,currChan) = [];
                                guiobj.imaging_detParams(currChan) = [];
                                guiobj.imaging_detBorders(currChan) = [];
                                guiobj.imaging_detectionsInfo.DetROI(currChan) = [];
                                
                                % check whether there are any detections on
                                % any channel
                                if ~sum(~cellfun('isempty',guiobj.imaging_detections))
                                    guiobj.imaging_detections = {};
                                    guiobj.imaging_globalDets = [];
                                    guiobj.imaging_detectionsInfo = [];
                                    guiobj.imaging_detBorders = {};
                                    guiobj.imaging_detParams = {};
                                    
                                    eventDetPlotFcn(guiobj,2,0,1)
                                    return
                                end
                                
                                % make sure event display switches correctly
                                if currChan ~= 1
                                    currChan = currChan - 1;
                                    currDet = 1;
                                end
                            else
                                guiobj.imaging_detections{currChan}(detNum) = [];
                                inGlobDets = guiobj.imaging_globalDets(:,currChan) == detNum;
                                if any(inGlobDets)
                                    globDetNum = find(inGlobDets);
                                    if length(globDetNum) > 1
                                        errordlg('There is a problem with the global events array!')
                                        return
                                    end
                                    
                                    if isempty(find(~isnan(guiobj.imaging_globalDets(globDetNum,:)), 1))
                                        guiobj.imaging_globalDets(globDetNum,:) = [];
                                    else
                                        guiobj.imaging_globalDets(globDetNum,currChan) = nan;
                                    end
                                end
                                guiobj.imaging_detParams{currChan}(detNum) = [];
                                guiobj.imaging_detBorders{currChan}(detNum,:) = [];

                                detsLeft = length(guiobj.imaging_detections{currChan});
                                if detsLeft == 0
                                    % check whether there are any detections on
                                    % any channel
                                    if ~sum(~cellfun('isempty',guiobj.imaging_detections))
                                        guiobj.imaging_detections = {};
                                        guiobj.imaging_globalDets = [];
                                        guiobj.imaging_detectionsInfo = [];
                                        guiobj.imaging_detBorders = {};
                                        guiobj.imaging_detParams = {};
                                        
                                        eventDetPlotFcn(guiobj,2,0,1)
                                        return
                                    end

                                    guiobj.imaging_detections(currChan) = [];
                                    guiobj.imaging_globalDets(:,currChan) = [];
                                    guiobj.imaging_detParams(currChan) = [];
                                    guiobj.imaging_detBorders(currChan) = [];
                                    guiobj.imaging_detectionsInfo.DetROI(currChan) = [];

                                    % make sure event display switches correctly
                                    if currChan ~= 1
                                        currChan = currChan - 1;
                                        currDet = 1;
                                    end
                                else
                                    if currDet ~= 1
                                        currDet = currDet - 1;
                                    end
                                end
                            end
                            guiobj.eventDet2CurrRoi = currChan;
                            guiobj.eventDet2CurrDet = currDet;
                    end
                    eventDetAxesButtFcn(guiobj,dTyp)
                    
                case 1 % simult mode on
                    if isempty(guiobj.simult_detections)
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
                    
                    [~,~,detNum,~,~,chan,~] = extractDetStructs(guiobj,dTyp);
                    simDets = guiobj.simult_detections;
                    simDetInfo = guiobj.simult_detectionsInfo;
                    
                    switch dTyp
                        case 1
                            rows2nuke = (simDets(:,1) == chan) & (simDets(:,2) == detNum);
                            simDets(rows2nuke,:) = [];
                            
                            if isempty(find(simDets(:,1) == chan, 1))
                                simDetInfo.EphysChannels(simDetInfo.EphysChannels == chan) = [];
                            end
                        case 2
                            rows2nuke = (simDets(:,3) == chan) & (simDets(:,4) == detNum);
                            simDets(rows2nuke,:) = [];
                            
                            if isempty(find(simDets(:,3) == chan, 1))
                                simDetInfo.ROIs(simDetInfo.ROIs == chan) = [];
                            end
                    end
                    guiobj.simult_detections = simDets;
                    guiobj.simult_detectionsInfo = simDetInfo;
                    
                    if isempty(simDets)
                        eventDetPlotFcn(guiobj,1,0,1)
                        eventDetPlotFcn(guiobj,2,0,1)
                        return
                    end
                    
                    eventDetAxesButtFcn(guiobj,1,0,0)
                    eventDetAxesButtFcn(guiobj,2,0,0)
            end
        end
        
        %%
        function delProcData(guiobj,dTyp)
            switch dTyp
                case 1
                    procData = guiobj.ephys_procced;
                    procInfo = guiobj.ephys_proccedInfo;
                    procNames = guiobj.ephys_procdatanames;
                    selInds = guiobj.ephysProcListBox2.Value;
                    if any(ismember(selInds, guiobj.ephys_artSuppedData4DetListInds))
                        eD = errordlg('Some of the selected indices are used for the currently stored detection, can''t delete!');
                        pause(1)
                        if ishandle(eD)
                            close(eD)
                        end
                        return
                    end
                    if length(selInds) == length(procInfo)
                        guiobj.ephysProcListBox2.Value = [];
                        cla(guiobj.axesEphysProc2)
                        guiobj.axesEphysProc2.Title = [];
                        guiobj.axesEphysProc2.XLabel = [];
                        guiobj.axesEphysProc2.YLabel = [];
                    else
                        guiobj.ephysProcListBox2.Value = 1;
                    end
                    guiobj.ephysProcListBox2.String(selInds) = [];
                    
                case 2
                    procData = guiobj.imaging_procced;
                    procInfo = guiobj.imaging_proccedInfo;
                    procNames = guiobj.imaging_procDatanames;  
                    selInds = guiobj.imagingProcListBox2.Value;
                    if any(ismember(selInds, guiobj.imaging_artSuppedData4DetListInds))
                        eD = errordlg('Some of the selected indices are used for the currently stored detection, can''t delete!');
                        pause(1)
                        if ishandle(eD)
                            close(eD)
                        end
                        return
                    end
                    if length(selInds) == length(procInfo)
                        guiobj.imagingProcListBox2.Value = [];
                        cla(guiobj.axesImagingProc2)
                        guiobj.axesImagingProc2.Title = [];
                        guiobj.axesImagingProc2.XLabel = [];
                        guiobj.axesImagingProc2.YLabel = [];
                    else
                        guiobj.imagingProcListBox2.Value = 1;
                    end
                    guiobj.imagingProcListBox2.String(selInds) = [];
                    
            end
            
            procData(selInds,:) = [];
            procInfo(selInds) = [];
            procNames(selInds) = [];
            
            switch dTyp
                case 1
                    guiobj.ephys_procced = procData;
                    guiobj.ephys_proccedInfo = procInfo;
                    guiobj.ephys_procdatanames = procNames;
                    ephysProcListBox2ValueChanged(guiobj)
                    
                case 2
                    guiobj.imaging_procced = procData;
                    guiobj.imaging_proccedInfo = procInfo;
                    guiobj.imaging_procDatanames = procNames;
                    imagingProcListBox2ValueChanged(guiobj)
                    
            end
            
        end
        
        %%
        function testcallback(varargin)
            display(varargin)
%             assignin('base','testinput',varargin)
%             get(h)
%             display(inp)
        end
        
    end
    
    %% guiobj initialization and construction
    methods (Access = private)

        % Create Figure and components
        function createComponents(guiobj)

            % Create figure
            guiobj.mainfig = figure('Visible','off',...
                'Units','normalized',...
                'Position',[0.1, 0.1, 0.8, 0.7],...
                'NumberTitle','off',...
                'Name','Data Analysis Suite',...
                'MenuBar','none',...
                'IntegerHandle','off',...
                'HandleVisibility','Callback',...
                'DeleteFcn',@(h,e) guiobj.mainFigCloseFcn,...
                'KeyPressFcn',@ guiobj.keyboardPressFcn);

            % Create OptionsMenu
            guiobj.MainTabOptionsMenu = uimenu(guiobj.mainfig,...
                'Text', 'MainTab Options');

            % Create timedimChangeMenu
            guiobj.timedimChangeMenu = uimenu(guiobj.MainTabOptionsMenu,...
                'MenuSelectedFcn',@(h,e) guiobj.timedimChangeMenuSelected,...
                'Text','Change between [s]/[ms]');
            
            % Create menu to display or hide processed data in main tab
            % listboxes
            guiobj.showProcDataMenu = uimenu(guiobj.MainTabOptionsMenu,...
                'Checked','off',...
                'Text','Show processed data in main tab',...
                'MenuSelectedFcn',@(h,e) guiobj.showProcDataMenuSelected);
            
            % Create display markers topmenu
            guiobj.showDetMarkersMenu = uimenu(guiobj.MainTabOptionsMenu,...
                'Text','Show detection markers');
            
            % Create menu to display detection markers
            guiobj.showEphysDetMarkersMenu = uimenu(guiobj.showDetMarkersMenu,...
                'Text','Show ephys detection markers',...
                'MenuSelectedFcn',@(h,e) guiobj.showEphysDetMarkers);
            guiobj.showEphysDetLegendMenu = uimenu(guiobj.showDetMarkersMenu,...
                'Text','Show ephys detection marker legend',...
                'MenuSelectedFcn',@(h,e) guiobj.showEphysDetLegend);
            guiobj.showImagingDetMarkersMenu = uimenu(guiobj.showDetMarkersMenu,...
                'Text','Show imaging detection markers',...
                'MenuSelectedFcn',@(h,e) guiobj.showImagingDetMarkers);
            guiobj.showSimultMarkersMenu = uimenu(guiobj.showDetMarkersMenu,...
                'Text','Show simultaneous detection markers',...
                'MenuSelectedFcn',@(h,e) guiobj.showSimultDetMarkers);
            
            guiobj.runPosModeMenu = uimenu(guiobj.MainTabOptionsMenu,...
                'MenuSelectedFcn',@(h,e) guiobj.runPosModeMenuSelected,...
                'Text','Switch position axes mode (absolute/relative)');
            
            % proc tabs options
            guiobj.procTabOptionsMenu = uimenu(guiobj.mainfig,...
                'Text', 'Processing tab options');
            guiobj.ephysLinkProcListBoxesMenu = uimenu(guiobj.procTabOptionsMenu,...
                'Text', 'Link ephys processing tab listboxes',...
                'Checked', 'on',...
                'MenuSelectedFcn', @(h,e) guiobj.linkProcListBoxesMenuCB(h));
            guiobj.imagingLinkProcListBoxesMenu = uimenu(guiobj.procTabOptionsMenu,...
                'Text', 'Link imaging processing tab listboxes',...
                'Checked', 'on',...
                'MenuSelectedFcn', @(h,e) guiobj.linkProcListBoxesMenuCB(h));
            
            
            guiobj.procDataMenu = uimenu(guiobj.mainfig,...
                'Text','Processed data options');
            guiobj.showEphysProcInfoMenu = uimenu(guiobj.procDataMenu,...
                'Text','Show info on processed ephys data',...
                'MenuSelectedFcn',@(h,e) guiobj.makeProcDataSelFig(1,false));
            guiobj.showImagingProcInfoMenu = uimenu(guiobj.procDataMenu,...
                'Text','Show info on processed imaging data',...
                'MenuSelectedFcn',@(h,e) guiobj.makeProcDataSelFig(2,false));
            
            guiobj.EvDetTabOptionsMenu = uimenu(guiobj.mainfig,...
                'Text','EventDetTab Options');
            guiobj.ephysEventDetTabDataTypeMenu = uimenu(guiobj.EvDetTabOptionsMenu,...
                'Text','Ephys data type in EventDetTab',...
                'MenuSelectedFcn',@(h,e) guiobj.changeEventDetTabDataType(1));
            guiobj.ephysEventDetTabFiltCutoffMenu = uimenu(guiobj.EvDetTabOptionsMenu,...
                'Text','EventDetTab - change cutoff frequencies',...
                'MenuSelectedFcn',@(h,e) guiobj.changeEventDetTabCutoff);
            guiobj.eventDetTabWinSizeMenu = uimenu(guiobj.EvDetTabOptionsMenu,...
                'Text','EventDetTab - change window size',...
                'MenuSelectedFcn',@(h,e) guiobj.changeEventDetTabWinSize);
            guiobj.imagingEventDetTabDataTypeMenu = uimenu(guiobj.EvDetTabOptionsMenu,...
                'Text','Imaging data type in EventDetTab',...
                'MenuSelectedFcn', @(h,e) guiobj.changeEventDetTabDataType(2));
            guiobj.evDetTabYlimModeMenu = uimenu(guiobj.EvDetTabOptionsMenu,...
                'Text',sprintf('Event plotting Y limit, current mode: %s',guiobj.evDetTabYlimMode),...
                'MenuSelectedFcn', @(h,e) guiobj.evDetTabYlimModeMenuCB);
            guiobj.showXtraDetFigsMenu = uimenu(guiobj.EvDetTabOptionsMenu,...
                'Text','Show extra detection figures',...
                'Checked','off',...
                'MenuSelectedFcn',@(h,e) guiobj.showXtraDetFigsMenuSel);
            guiobj.showEventSpectroMenu = uimenu(guiobj.EvDetTabOptionsMenu,...
                'Text','Show event spectrogram',...
                'MenuSelectedFcn',@(h,e) guiobj.showEventSpectro);

            guiobj.SaveMenu = uimenu(guiobj.mainfig,...
                'Text','Saving options');
            guiobj.SaveDetsMenu = uimenu(guiobj.SaveMenu,...
                'Text','Save detection',...
                'MenuSelectedFcn',@(h,e) guiobj.saveDets);
            guiobj.OpenDASeVMenu = uimenu(guiobj.SaveMenu,...
                'Text','Open DASeV',...
                'MenuSelectedFcn','DASeV');
            

            % Create tabgroup
            guiobj.tabs = uitabgroup(guiobj.mainfig,...
                'Units','normalized',...
                'Position',[0, 0, 1, 1],...
                'SelectionChangedFcn',@ guiobj.tabSelected);
            
            % Create tabs in tabgroup
            guiobj.maintab = uitab(guiobj.tabs,...
                'Title','Main tab');
            guiobj.ephysProcTab = uitab(guiobj.tabs,...
                'Title','Electrophysiology data processing');
            guiobj.imagingProcTab = uitab(guiobj.tabs,...
                'Title','Imaging data processing');
            guiobj.eventDetTab = uitab(guiobj.tabs,...
                'Title','Event detection');
            
            %% Elements of main tab %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            % Create Panel1Plot
            guiobj.Panel1Plot = uipanel(guiobj.maintab,...
                'Position',[0.4,0,0.6,1]);

            % Create Panel2Plot
            guiobj.Panel2Plot = uipanel(guiobj.maintab,...
                'Visible','off',...
                'Position',[0.4,0,0.6,1]);

            % Create Panel3Plot
            guiobj.Panel3Plot = uipanel(guiobj.maintab,...
                'Visible','off',...
                'Position',[0.4,0,0.6,1]);

            % Create ModeselectionPanel
            guiobj.ModeselectionPanel = uipanel(guiobj.maintab,...
                'Title','Mode selection',...
                'Position',[0,0.8,0.4,0.2]);

            % Create ephysCheckBox
            guiobj.ephysCheckBox = uicontrol(guiobj.ModeselectionPanel,...
                'Style','checkbox',...
                'Callback',@(h,e) guiobj.ephysCheckBoxValueChanged,...
                'String','Electrophysiology',...
                'Units','normalized',...
                'Position',[0, 0.05, 0.3, 1]);

            % Create imagingCheckBox
            guiobj.imagingCheckBox = uicontrol(guiobj.ModeselectionPanel,...
                'Style','checkbox',...
                'Callback',@(h,e) guiobj.imagingCheckBoxValueChanged,...
                'String','Imaging data (Ca2+)',...
                'Units','normalized',...
                'Position',[0.35, 0.05, 0.3, 1]);
            
            % Create runCheckBox
            guiobj.runCheckBox = uicontrol(guiobj.ModeselectionPanel,...
                'Style','checkbox',...
                'Callback',@(h,e) guiobj.runCheckBoxValueChanged,...
                'String','Running data',...
                'Units','normalized',...
                'Position',[0.7, 0.05, 0.3, 1]);

            % Create importPanel
            guiobj.importPanel = uipanel(guiobj.maintab,...
                'Title','Import data',...
                'Position',[0, 0.6, 0.4, 0.2]);

            % Create ImportRHDButton
            guiobj.ImportRHDButton = uicontrol(guiobj.importPanel,...
                'Style','pushbutton',...
                'Callback',@(h,e) guiobj.ImportRHDButtonPushed,...
                'Enable','off',...
                'Units','normalized',...
                'Position',[0, 0.3, 0.3, 0.3],...
                'String','Import RHD');

            % Create ImportgorobjButton
            guiobj.ImportgorobjButton = uicontrol(guiobj.importPanel,...
                'Style','pushbutton',...
                'Callback',@(h,e) guiobj.ImportgorobjButtonPushed,...
                'Enable','off',...
                'Units','normalized',...
                'Position',[0.35, 0.3, 0.3, 0.3],...
                'String','Import gorobj');

            % Create ImportruncsvButton
            guiobj.ImportruncsvButton = uicontrol(guiobj.importPanel,...
                'Style','pushbutton',...
                'Callback',@(h,e) guiobj.ImportruncsvButtonPushed,...
                'Enable','off',...
                'Units','normalized',...
                'Position',[0.7, 0.3, 0.3, 0.3],...
                'String','Import run csv');
            
            guiobj.importSettingsButton = uicontrol(guiobj.importPanel,...
                'Style','pushbutton',...
                'Callback',@(h,e) guiobj.importSettingsButtonPushed,...
                'Units','normalized',...
                'Position',[0.7, 0.01, 0.3, 0.15],...
                'String','Import settings');

            % Create Dataselection1Panel
            guiobj.Dataselection1Panel = uipanel(guiobj.maintab,...
                'Title','Data selection',...
                'Position',[0, 0.2, 0.4, 0.4]);

            % Create DatasetListBox
            guiobj.DatasetListBox = uicontrol(guiobj.Dataselection1Panel,...
                'Style','listbox',...
                'Units','normalized',...
                'Position',[0, 0, 1, 1],...
                'String','Electrophysiology data',...
                'Min',0,...
                'Max',10,...
                'Callback',@(h,e) guiobj.DatasetListBoxValueChanged);

            % Create Dataselection2Panel
            guiobj.Dataselection2Panel = uipanel(guiobj.maintab,...
                'Title','Data selection',...
                'Visible','off',...
                'Position',[0, 0.2, 0.4, 0.4]);
            
            % Create EphysListBox
            guiobj.EphysListBox = uicontrol(guiobj.Dataselection2Panel,...
                'Style','listbox',...
                'Units','normalized',...
                'Position',[0, 0.55, 1, 0.4],...
                'String','Electrophysiology data',...
                'Min',0,...
                'Max',10,...
                'Callback',@(h,e) guiobj.EphysListBoxValueChanged);
            
            % Create ImagingListBox
            guiobj.ImagingListBox = uicontrol(guiobj.Dataselection2Panel,...
                'Style','listbox',...
                'Units','normalized',...
                'Position',[0, 0.05, 1, 0.4],...
                'String','Imaging data',...
                'Min',0,...
                'Max',10,...
                'Callback',@(h,e) guiobj.ImagingListBoxValueChanged);
            
            guiobj.axes11 = axes(guiobj.Panel1Plot,...
                'Position',[0.1,0.2,0.85,0.6],...
                'NextPlot','replacechildren');
            guiobj.axes11.Toolbar.Visible = 'on';
            
            guiobj.axes21 = axes(guiobj.Panel2Plot,...
                'Position',[0.1,0.6,0.85,0.35],...
                'NextPlot','replacechildren');
            guiobj.axes21.Toolbar.Visible = 'on';
            guiobj.axes22 = axes(guiobj.Panel2Plot,...
                'Position',[0.1,0.1,0.85,0.35],...
                'NextPlot','replacechildren');
            guiobj.axes22.Toolbar.Visible = 'on';
            
            guiobj.axes31 = axes(guiobj.Panel3Plot,...
                'Position',[0.1,0.7,0.85,0.25],...
                'NextPlot','replacechildren');
            guiobj.axes31.Toolbar.Visible = 'on';
            guiobj.axes32 = axes(guiobj.Panel3Plot,...
                'Position',[0.1,0.38,0.85,0.25],...
                'NextPlot','replacechildren');
            guiobj.axes32.Toolbar.Visible = 'on';
            
            guiobj.axesPos1 = axes(guiobj.Panel1Plot,...
                'Position',[0.1,0.2,0.85,0.2],...
                'Visible','off',...
                'NextPlot','replacechildren');
            guiobj.axesPos1.Toolbar.Visible = 'on';
            guiobj.axesVeloc1 = axes(guiobj.Panel1Plot,...
                'Position',[0.1,0.5,0.85,0.2],...
                'Visible','off',...
                'NextPlot','replacechildren');
            guiobj.axesVeloc1.Toolbar.Visible = 'on';
            
            guiobj.axesPos2 = axes(guiobj.Panel2Plot,...
                'Position',[0.1,0.1,0.85,0.1],...
                'Visible','off',...
                'NextPlot','replacechildren');
            guiobj.axesPos2.Toolbar.Visible = 'on';
            guiobj.axesVeloc2 = axes(guiobj.Panel2Plot,...
                'Position',[0.1,0.3,0.85,0.2],...
                'Visible','off',...
                'NextPlot','replacechildren');
            guiobj.axesVeloc2.Toolbar.Visible = 'on';
            
            guiobj.axesPos3 = axes(guiobj.Panel3Plot,...
                'Position',[0.1,0.05,0.85,0.05],...
                'NextPlot','replacechildren');
            guiobj.axesPos3.Toolbar.Visible = 'on';
            guiobj.axesVeloc3 = axes(guiobj.Panel3Plot,...
                'Position',[0.1,0.2,0.85,0.1],...
                'NextPlot','replacechildren');
            guiobj.axesVeloc3.Toolbar.Visible = 'on';
            
            linkaxes([guiobj.axes11,guiobj.axes21,guiobj.axes22,...
                guiobj.axes31,guiobj.axes32,guiobj.axesPos1,...
                guiobj.axesPos2,guiobj.axesPos3,guiobj.axesVeloc1,...
                guiobj.axesVeloc2,guiobj.axesVeloc3],'x')
            
            %% Elements of ephys proc tab %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            % Create ephysProcListBox
            guiobj.ephysProcListBox = uicontrol(guiobj.ephysProcTab,...
                'Style','listbox',...
                'Units','normalized',...
                'Position',[0.01, 0.26, 0.3, 0.2],...
                'Min',1,...
                'Max',10,...
                'Callback',@(h,e) guiobj.ephysProcListBoxValueChanged,...
                'Tooltip','List of raw electrophysiology data');
            
            % Create ephysProcListBox2 for processed curves
            guiobj.ephysProcListBox2ContMenu = uicontextmenu(guiobj.mainfig);
            guiobj.ephysProcListBox2 = uicontrol(guiobj.ephysProcTab,...
                'Style','listbox',...
                'Units','normalized',...
                'Position',[0.01, 0.06, 0.3, 0.2],...
                'Min',1,...
                'Max',10,...
                'Callback',@(h,e) guiobj.ephysProcListBox2ValueChanged,...
                'Tooltip','List of processed electrophysiology data',...
                'UIContextMenu', guiobj.ephysProcListBox2ContMenu);
            guiobj.ephysProcListBox2ContMenuDel = uimenu(guiobj.ephysProcListBox2ContMenu,'Text','Delete selected',...
                'Callback',@(h,e) guiobj.delProcData(1));
            
            % Create ephysProcPopMenu
            guiobj.ephysProcPopMenu = uicontrol(guiobj.ephysProcTab,...
                'Style','popupmenu',...
                'Units','normalized',...
                'Position',[0.01, 0.8, 0.15, 0.15],...
                'String',{'--Choose processing type--','Filtering','Artifact Suppression','Compute FFT','CWT spectrogram'},...
                'Callback',@(h,e) guiobj.ephysProcPopMenuSelected);
            
            % Create buttongroup to choose between processing raw or
            % processed data
            guiobj.ephysProcSrcButtGroup = uibuttongroup(guiobj.ephysProcTab,...
                'Position',[0.2, 0.9, 0.15, 0.1],...
                'Title','Select from:');
            guiobj.ephysProcRawRadioButt = uicontrol(guiobj.ephysProcSrcButtGroup,...
                'Style','radiobutton',...
                'Units','normalized',...
                'Position',[0.1, 0.55, 0.8, 0.3],...
                'String','Raw data');
            guiobj.ephysProcProcdRadioButt = uicontrol(guiobj.ephysProcSrcButtGroup,...
                'Style','radiobutton',...
                'Units','normalized',...
                'Position',[0.1, 0.05, 0.8, 0.3],...
                'String','Processed data',...
                'Callback',@(h,e) guiobj.ephysProcProcdRadioButtPushed);
            
            
            
            % Create ephysFiltSettingsPanel
            guiobj.ephysFiltSettingsPanel = uipanel(guiobj.ephysProcTab,...
                'Position',[0.01, 0.6, 0.3, 0.3],...
                'Title','Filtering settings',...
                'Visible','off');
            
            % Create components of FiltSettingsPanel
            guiobj.filterTypePopMenu = uicontrol(guiobj.ephysFiltSettingsPanel,...
                'Style','popupmenu',...
                'Units','normalized',...
                'Position',[0.01, 0.85, 0.25, 0.1],...
                'String',{'--Select filter type--','Butterworth','DoG'},...
                'Callback',@(h,e) guiobj.fiterTypePopMenuCallback);
            guiobj.cutoffLabel = uicontrol(guiobj.ephysFiltSettingsPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.3, 0.85, 0.5, 0.1],...
                'String','Lower - Upper cutoff [Hz]',...
                'Visible','off',...
                'Tag','ephysFilt');
            guiobj.w1Edit = uicontrol(guiobj.ephysFiltSettingsPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.8, 0.85, 0.1, 0.1],...
                'Visible','off',...
                'Tooltip','Lower cutoff frequency [Hz]',...
                'String','150',...
                'Tag','ephysFilt');
            guiobj.w2Edit = uicontrol(guiobj.ephysFiltSettingsPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.9, 0.85, 0.1, 0.1],...
                'Visible','off',...
                'Tooltip','Upper cutoff frequency [Hz]',...
                'String','250',...
                'Tag','ephysFilt');
            guiobj.filtOrderLabel = uicontrol(guiobj.ephysFiltSettingsPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.3, 0.7, 0.5, 0.1],...
                'String','Filter order',...
                'Visible','off',...
                'Tag','ephysFilt_others');
            guiobj.filtOrderEdit = uicontrol(guiobj.ephysFiltSettingsPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.8, 0.7, 0.1, 0.1],...
                'String','4',...
                'Visible','off',...
                'Tag','ephysFilt_others');
            
            % Create ephysArtSuppPanel
            guiobj.ephysArtSuppPanel = uipanel(guiobj.ephysProcTab,...
                'Position',[0.01, 0.6, 0.3, 0.3],...
                'Title','Artifact Suppression',...
                'Visible','off');
            
            % Create components of ArtSuppPanel
            guiobj.ephysArtSuppTypePopMenu = uicontrol(guiobj.ephysArtSuppPanel,...
                'Style','popupmenu',...
                'Units','normalized',...
                'Position',[0.01, 0.85, 0.25, 0.1],...
                'String',{'--Select artifact suppression!--','classic ref subtract','DFER','Periodic'},...
                'Callback',@(h,e) guiobj.ephysArtSuppTypePopMenuCB);
            guiobj.ephysArtSuppRefChanLabel = uicontrol(guiobj.ephysArtSuppPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.4, 0.85, 0.3, 0.1],...
                'String','Reference channel',...
                'Tag','ephysArtSupp_refCh',...
                'Visible','off');
            guiobj.ephysArtSuppRefChanEdit = uicontrol(guiobj.ephysArtSuppPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.75, 0.85, 0.1, 0.1],...
                'Tag','ephysArtSupp_refCh',...
                'Visible','off');
            guiobj.ephysPeriodicFmaxLabel = uicontrol(guiobj.ephysArtSuppPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.3, 0.85, 0.5, 0.1],...
                'String','Max frequency [Hz]',...
                'Visible','off',...
                'Tag','ephysArtSupp_periodic');
            guiobj.ephysPeriodicFmaxEdit = uicontrol(guiobj.ephysArtSuppPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.8, 0.85, 0.1, 0.1],...
                'Visible','off',...
                'String','1000',...
                'Tag','ephysArtSupp_periodic');
            guiobj.ephysPeriodicFfundLabel = uicontrol(guiobj.ephysArtSuppPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.3, 0.75, 0.5, 0.1],...
                'String','Fundamental frequency [Hz]',...
                'Visible','off',...
                'Tag','ephysArtSupp_periodic');
            guiobj.ephysPeriodicFfundEdit = uicontrol(guiobj.ephysArtSuppPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.8, 0.75, 0.1, 0.1],...
                'Visible','off',...
                'Tag','ephysArtSupp_periodic');
            guiobj.ephysPeriodicStopbandWidthLabel = uicontrol(guiobj.ephysArtSuppPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.3, 0.65, 0.5, 0.1],...
                'String','Stopband width [Hz]',...
                'Visible','off',...
                'Tag','ephysArtSupp_periodic');
            guiobj.ephysPeriodicStopbandWidthEdit = uicontrol(guiobj.ephysArtSuppPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.8, 0.65, 0.1, 0.1],...
                'Visible','off',...
                'String','5',...
                'Tag','ephysArtSupp_periodic');
            guiobj.ephysPeriodicPlotFFTCheckBox = uicontrol(guiobj.ephysArtSuppPanel,...
                'Style', 'checkbox',...
                'Units', 'normalized',...
                'Position', [0.3, 0.55, 0.5, 0.1],...
                'Visible', 'off',...
                'String', 'Plot before&after FFT',...
                'Tag', 'ephysArtSupp_periodic');
            
            % spectrogram panel
            guiobj.ephysSpectroPanel = uipanel(guiobj.ephysProcTab,...
                'Position',[0.01, 0.6, 0.3, 0.3],...
                'Title','Spectrogram settings',...
                'Visible','off');
            guiobj.ephysSpectroFreqLimitLabel = uicontrol(guiobj.ephysSpectroPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.3, 0.85, 0.5, 0.1],...
                'String','Frequency limits [Hz]',...
                'Visible','on',...
                'Tag','ephysCWTspectrogram');
            guiobj.ephysSpectroFreqLimit1Edit = uicontrol(guiobj.ephysSpectroPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.8, 0.85, 0.1, 0.1],...
                'Visible','on',...
                'Tooltip','Lower frequency limit [Hz]',...
                'String','2',...
                'Tag','ephysCWTspectrogram');
            guiobj.ephysSpectroFreqLimit2Edit = uicontrol(guiobj.ephysSpectroPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.9, 0.85, 0.1, 0.1],...
                'Visible','on',...
                'Tooltip','Upper frequency limit [Hz]',...
                'String','500',...
                'Tag','ephysCWTspectrogram');
            
            guiobj.ephysRunProcButton = uicontrol(guiobj.ephysProcTab,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.25, 0.47, 0.05, 0.05],...
                'String','Run',...
                'Visible','on',...
                'BackgroundColor','g',...
                'Callback', @(h,e) guiobj.ephysRunProc);
            
            guiobj.ephysSelNewIntervalsButton = uicontrol(guiobj.ephysProcTab,...
                'Style', 'pushbutton',...
                'Units', 'normalized',...
                'Position', [0.1, 0.47, 0.05, 0.05],...
                'String', 'Select interval',...
                'Callback', @(h,e) guiobj.ephysSelNewIntervalsButtonCB);
            
            % Create axes
            guiobj.axesEphysProc1 = axes(guiobj.ephysProcTab,...
                'Position',[0.4, 0.6, 0.55, 0.35],...
                'NextPlot','replacechildren');
            guiobj.axesEphysProc1.Toolbar.Visible = 'on';
            guiobj.axesEphysProc2 = axes(guiobj.ephysProcTab,...
                'Position',[0.4, 0.1, 0.55, 0.35],...
                'NextPlot','replacechildren');
            guiobj.axesEphysProc2.Toolbar.Visible = 'on';
            linkaxes([guiobj.axesEphysProc1,guiobj.axesEphysProc2],'x');
            

            %% Elements of imaging proc tab %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            % Create imagingProcListBox
            guiobj.imagingProcListBox = uicontrol(guiobj.imagingProcTab,...
                'Style','listbox',...
                'Units','normalized',...
                'Position',[0.01, 0.26, 0.3, 0.2],...
                'Min',1,...
                'Max',10,...
                'Callback',@(h,e) guiobj.imagingProcListBoxValueChanged,...
                'Tooltip','List of raw imaging data');
            
            % Create imagingProcListBox2 for processed curves
            guiobj.imagingProcListBox2 = uicontrol(guiobj.imagingProcTab,...
                'Style','listbox',...
                'Units','normalized',...
                'Position',[0.01, 0.06, 0.3, 0.2],...
                'Min',1,...
                'Max',10,...
                'Callback',@(h,e) guiobj.imagingProcListBox2ValueChanged,...
                'Tooltip','List of processed imaging data');
            
            % Create imagingProcPopMenu
            guiobj.imagingProcPopMenu = uicontrol(guiobj.imagingProcTab,...
                'Style','popupmenu',...
                'Units','normalized',...
                'Position',[0.01, 0.8, 0.15, 0.15],...
                'String',{'--Processing type--','Filtering'},...
                'Callback',@(h,e) guiobj.imagingProcPopMenuSelected);
            
            % Create buttongroup to choose between processing raw or
            % processed data
            guiobj.imagingProcSrcButtGroup = uibuttongroup(guiobj.imagingProcTab,...
                'Position',[0.2, 0.9, 0.15, 0.1],...
                'Title','Select from:');
            guiobj.imagingProcRawRadioButt = uicontrol(guiobj.imagingProcSrcButtGroup,...
                'Style','radiobutton',...
                'Units','normalized',...
                'Position',[0.1, 0.55, 0.8, 0.3],...
                'String','Raw data');
            guiobj.imagingProcProcdRadioButt = uicontrol(guiobj.imagingProcSrcButtGroup,...
                'Style','radiobutton',...
                'Units','normalized',...
                'Position',[0.1, 0.05, 0.8, 0.3],...
                'String','Processed data',...
                'Callback',@(h,e) guiobj.imagingProcProcdRadioButtPushed);
            
            % Create imagingFiltSettingsPanel
            guiobj.imagingFiltSettingsPanel = uipanel(guiobj.imagingProcTab,...
                'Position',[0.01, 0.6, 0.3, 0.3],...
                'Title','Filtering settings',...
                'Visible','off');
            
            % Create components of FiltSettingsPanel
            guiobj.imagingFilterTypePopMenu = uicontrol(guiobj.imagingFiltSettingsPanel,...
                'Style','popupmenu',...
                'Units','normalized',...
                'Position',[0.01, 0.85, 0.25, 0.1],...
                'String',{'--Filter type--','Gauss average'},...
                'Callback',@(h,e) guiobj.imagingFilterTypePopMenuSelected);
            guiobj.imagingFiltWinSizeText = uicontrol(guiobj.imagingFiltSettingsPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.3, 0.85, 0.3, 0.1],...
                'String','Window size in samples',...
                'Visible','off',...
                'Tag','imagingFilt');
            guiobj.imagingFiltWinSizeEdit = uicontrol(guiobj.imagingFiltSettingsPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.65, 0.85, 0.1, 0.1],...
                'Visible','off',...
                'Tag','imagingFilt');
            
            guiobj.imagingRunProcButton = uicontrol(guiobj.imagingProcTab,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.2, 0.5, 0.1, 0.05],...
                'String','Run',...
                'BackgroundColor','g',...
                'Callback',@(h,e) guiobj.imagingRunProc);
            
            % Create axes
            guiobj.axesImagingProc1 = axes(guiobj.imagingProcTab,...
                'Position',[0.4, 0.6, 0.55, 0.35],...
                'NextPlot','replacechildren');
            guiobj.axesImagingProc1.Toolbar.Visible = 'on';
            guiobj.axesImagingProc2 = axes(guiobj.imagingProcTab,...
                'Position',[0.4, 0.1, 0.55, 0.35],...
                'NextPlot','replacechildren');
            guiobj.axesImagingProc2.Toolbar.Visible = 'on';
            linkaxes([guiobj.axesImagingProc1,guiobj.axesImagingProc2],'x');
            
            %% Elements of event detection tab %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            guiobj.selIntervalsCheckBox = uicontrol(guiobj.eventDetTab,...
                'Style','checkbox',...
                'Units','normalized',...
                'Position',[0.375, 0.96, 0.1, 0.03],...
                'String','Select interval');
            
            guiobj.ephysDetPopMenu = uicontrol(guiobj.eventDetTab,...
                'Style','popupmenu',...
                'Units','normalized',...
                'Position',[0.01, 0.94, 0.1, 0.05],...
                'String',{'--Ephys detection methods--','CWT based',...
                'Adaptive threshold','DoG+InstPow'},...
                'Callback',@(h,e) guiobj.ephysDetPopMenuSelected);
            
            guiobj.ephysDetChSelListBox = uicontrol(guiobj.eventDetTab,...
                'Style','listbox',...
                'Units','normalized',...
                'Position',[0.01, 0.785, 0.1, 0.15],...
                'String',{'--Select channel--'},...
                'Max',2);
            guiobj.ephysDetUseProcDataCheckBox = uicontrol(guiobj.eventDetTab,...
                'Style','checkbox',...
                'Units','normalized',...
                'Position',[0.01, 0.76, 0.1, 0.025],...
                'String','Select from processed',...
                'Callback',@(h,e) guiobj.ephysDetUseProcDataCheckBoxCB);
            
            guiobj.ephysDetRefChanLabel = uicontrol(guiobj.eventDetTab,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.12, 0.96, 0.1, 0.03],...
                'String','Reference channel');
            guiobj.ephysDetRefChanEdit = uicontrol(guiobj.eventDetTab,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.22, 0.96, 0.03, 0.03]);
            
            guiobj.ephysDetArtSuppPopMenu = uicontrol(guiobj.eventDetTab,...
                'Style','popupmenu',...
                'Units','normalized',...
                'Position',[0.255, 0.96, 0.1, 0.03],...
                'String',{'--Select artifact suppression method!--','Periodic','DFER','RefSubtract'});
            
            guiobj.ephysCwtDetPanel = uipanel(guiobj.eventDetTab,...
                'Position',[0.12, 0.65, 0.2, 0.3],...
                'Title','Settings for CWT based detection',...
                'Visible','off');
            guiobj.ephysCwtDetCutoffLabel = uicontrol(guiobj.ephysCwtDetPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.01 0.85, 0.5, 0.1],...
                'String','Frequency band [Hz]');
            guiobj.ephysCwtDetW1Edit = uicontrol(guiobj.ephysCwtDetPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.55, 0.85, 0.1, 0.1]);
            guiobj.ephysCwtDetW2Edit = uicontrol(guiobj.ephysCwtDetPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.65, 0.85, 0.1, 0.1]);
            guiobj.ephysCwtDetSdMultLabel = uicontrol(guiobj.ephysCwtDetPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.01, 0.7, 0.5, 0.1],...
                'String','SD multiplier');
            guiobj.ephysCwtDetSdMultEdit = uicontrol(guiobj.ephysCwtDetPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.55, 0.7, 0.1, 0.1],...
                'String','3',...
                'Callback', @(h,e) guiobj.eventDetParamInputControll(h,'sd'));
            guiobj.ephysCwtDetMinlenLabel = uicontrol(guiobj.ephysCwtDetPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.01, 0.55, 0.5, 0.1],...
                'String','Min event length [ms]');
            guiobj.ephysCwtDetMinlenEdit = uicontrol(guiobj.ephysCwtDetPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.55, 0.55, 0.1, 0.1],...
                'String','10');
            guiobj.ephysCwtDetRefValPopMenu = uicontrol(guiobj.ephysCwtDetPanel,...
                'Style','popupmenu',...
                'Units','normalized',...
                'Position',[0.01, 0.4, 0.5, 0.1],...
                'String',{'No refchan validation', 'Time match based refchan validation',...
                'Correlation based refchan validation'});
            guiobj.ephysCwtDetPresetPopMenu = uicontrol(guiobj.ephysCwtDetPanel,...
                'Style','popupmenu',...
                'Units','normalized',...
                'Position',[0.6, 0.25, 0.3, 0.1],...
                'String','--Presets--',...
                'Callback',@(h,e) guiobj.presetSel(1,1));
            guiobj.ephysCwtDetPresetSaveButt = uicontrol(guiobj.ephysCwtDetPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.6, 0.1, 0.15, 0.1],...
                'String','Save',...
                'Callback',@(h,e) guiobj.presetSave(1,1));
            guiobj.ephysCwtDetPresetDelButt = uicontrol(guiobj.ephysCwtDetPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.75, 0.1, 0.15, 0.1],...
                'String','Delete',...
                'Callback',@(h,e) guiobj.presetDel(1,1));
            
            guiobj.ephysAdaptDetPanel = uipanel(guiobj.eventDetTab,...
                'Position',[0.12, 0.65, 0.2, 0.3],...
                'Title','Settings for adaptive threshold detection',...
                'Visible','off');
            guiobj.ephysAdaptDetStepLabel = uicontrol(guiobj.ephysAdaptDetPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.01, 0.85, 0.7, 0.1],...
                'String','Step size [ms]');
            guiobj.ephysAdaptDetStepEdit = uicontrol(guiobj.ephysAdaptDetPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.72, 0.85, 0.1, 0.1],...
                'String','50');
            guiobj.ephysAdaptDetMinwidthLabel = uicontrol(guiobj.ephysAdaptDetPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.01, 0.7, 0.7, 0.1],...
                'String','Minimal event length [ms]');
            guiobj.ephysAdaptDetMinwidthEdit = uicontrol(guiobj.ephysAdaptDetPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.72, 0.7, 0.1, 0.1],...
                'String','10');
            guiobj.ephysAdaptDetMindistLabel = uicontrol(guiobj.ephysAdaptDetPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.01, 0.55, 0.7, 0.1],...
                'String','Minimal distance between events [ms]');
            guiobj.ephysAdaptDetMindistEdit = uicontrol(guiobj.ephysAdaptDetPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.72, 0.55, 0.1, 0.1],...
                'String','30');
            guiobj.ephysAdaptDetRatioLabel = uicontrol(guiobj.ephysAdaptDetPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.01, 0.4, 0.7, 0.1],...
                'String','Target ratio [%]');
            guiobj.ephysAdaptDetRatioEdit = uicontrol(guiobj.ephysAdaptDetPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.72, 0.4, 0.1, 0.1],...
                'String','99');
            
            guiobj.ephysDoGInstPowDetPanel = uipanel(guiobj.eventDetTab,...
                'Position',[0.12, 0.65, 0.2, 0.3],...
                'Title','Settings for DoG+InstPow based detection',...
                'Visible','off');
            guiobj.ephysDoGInstPowDetFreqBandLabel = uicontrol(guiobj.ephysDoGInstPowDetPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.01, 0.85, 0.5, 0.1],...
                'String','Lower-Upper cutoff [Hz]');
            guiobj.ephysDoGInstPowDetW1Edit = uicontrol(guiobj.ephysDoGInstPowDetPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.55, 0.85, 0.1, 0.1]);
            guiobj.ephysDoGInstPowDetW2Edit = uicontrol(guiobj.ephysDoGInstPowDetPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.65, 0.85, 0.1, 0.1]);
            guiobj.ephysDoGInstPowDetSdMultLabel = uicontrol(guiobj.ephysDoGInstPowDetPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.01, 0.7, 0.5, 0.1],...
                'String','SD multiplier');
            guiobj.ephysDoGInstPowDetSdMultEdit = uicontrol(guiobj.ephysDoGInstPowDetPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.55, 0.7, 0.1, 0.1],...
                'Callback', @(h,e) guiobj.eventDetParamInputControll(h,'sd'));
            guiobj.ephysDoGInstPowDetMinLenLabel = uicontrol(guiobj.ephysDoGInstPowDetPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.01, 0.55, 0.5, 0.1],...
                'String','Min event length [ms]');
            guiobj.ephysDoGInstPowDetMinLenEdit = uicontrol(guiobj.ephysDoGInstPowDetPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.55, 0.55, 0.1, 0.1]);
            guiobj.ephysDogInstPowDetRefValPopMenu = uicontrol(guiobj.ephysDoGInstPowDetPanel,...
                'Style','popupmenu',...
                'Units','normalized',...
                'Position',[0.01, 0.4, 0.4, 0.1],...
                'String',{'No refchan validation', 'Time match based refchan validation',...
                'Correlation based refchan validation'});
            guiobj.ephysDoGInstPowDetPresetPopMenu = uicontrol(guiobj.ephysDoGInstPowDetPanel,...
                'Style','popupmenu',...
                'Units','normalized',...
                'Position',[0.6, 0.25, 0.3, 0.1],...
                'String','--Presets--',...
                'Callback',@(h,e) guiobj.presetSel(1,3));
            guiobj.ephysDoGInstPowDetPresetSaveButt = uicontrol(guiobj.ephysDoGInstPowDetPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.6, 0.1, 0.15, 0.1],...
                'String','Save',...
                'Callback',@(h,e) guiobj.presetSave(1,3));
            guiobj.ephysDoGInstPowDetPresetDelButt = uicontrol(guiobj.ephysDoGInstPowDetPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.75, 0.1, 0.15, 0.1],...
                'String','Delete',...
                'Callback',@(h,e) guiobj.presetDel(1,3));
            
            guiobj.ephysDetParamsPanel = uipanel(guiobj.eventDetTab,...
                'Position',[0.325, 0.65, 0.125, 0.3],...
                'Title','Event parameters',...
                'Visible','on');
            guiobj.ephysDetParamsTable = uitable(guiobj.ephysDetParamsPanel,...
                'Units','normalized',...
                'Position',[0.01, 0.01, 0.98, 0.98],...
                'ColumnWidth',{100,75},...
                'CellSelectionCallback',@(h,e) paramTableHints(e));
                          
            guiobj.ephysDetRunButt = uicontrol(guiobj.eventDetTab,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.01, 0.705, 0.1, 0.05],...
                'String','Run ephys detection',...
                'Callback',@(h,e) guiobj.ephysDetRun);
            guiobj.ephysDetStatusLabel = uicontrol(guiobj.eventDetTab,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.01, 0.65, 0.1, 0.05],...
                'String','--IDLE--',...
                'Max',2,...
                'BackgroundColor','g');
            
            guiobj.imagingDetPopMenu = uicontrol(guiobj.eventDetTab,...
                'Style','popupmenu',...
                'Units','normalized',...
                'Position',[0.01, 0.58, 0.1, 0.05],...
                'String',{'--Imaging detection methods--','Mean+SD','MLspike based'},...
                'Callback',@(h,e) guiobj.imagingDetPopMenuSelected);
            guiobj.imagingDetUseProcDataCheckBox = uicontrol(guiobj.eventDetTab,...
                'Style','checkbox',...
                'Units','normalized',...
                'Position',[0.01, 0.5, 0.1, 0.05],...
                'String','Use processed data');
            
            guiobj.imagingMeanSdDetPanel = uipanel(guiobj.eventDetTab,...
                'Position',[0.12, 0.33, 0.2, 0.3],...
                'Title','Settings for mean+sd based detection',...
                'Visible','off');
            guiobj.imagingMeanSdDetSdmultLabel = uicontrol(guiobj.imagingMeanSdDetPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.1, 0.85, 0.3, 0.1],...
                'String','Sd multiplier');
            guiobj.imagingMeanSdDetSdmultEdit = uicontrol(guiobj.imagingMeanSdDetPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.41, 0.85, 0.1, 0.1],...
                'String','2',...
                'Callback', @(h,e) guiobj.eventDetParamInputControll(h,'sd'));
            guiobj.imagingMeanSdDetWinSizeLabel = uicontrol(guiobj.imagingMeanSdDetPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.1, 0.7, 0.3, 0.1],...
                'String','WinSize [samples]');
            guiobj.imagingMeanSdDetWinSizeEdit = uicontrol(guiobj.imagingMeanSdDetPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.41, 0.7, 0.1, 0.1],...
                'String','30',...
                'Callback', @(h,e) guiobj.eventDetParamInputControll(h,'imgWinLen'));
            guiobj.imagingMeanSdDetSlideAvgCheck = uicontrol(guiobj.imagingMeanSdDetPanel,...
                'Style','checkbox',...
                'Units','normalized',...
                'Position',[0.1, 0.3, 0.5, 0.1],...
                'String','Use 3-point average method');
            
            guiobj.imagingMlSpDetPanel = uipanel(guiobj.eventDetTab,...
                'Position',[0.12, 0.33, 0.2, 0.3],...
                'Title','Settings for MLspike based detection',...
                'Visible','off');
            guiobj.imagingMlSpDetDFFSpikeText = uicontrol(guiobj.imagingMlSpDetPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.1, 0.85, 0.5, 0.1],...
                'String',[char(916),'F/F of 1 spike']);
            guiobj.imagingMlSpDetDFFSpikeEdit = uicontrol(guiobj.imagingMlSpDetPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.65, 0.85, 0.3, 0.1],...
                'String','0.1');
            guiobj.imagingMlSpDetSigmaText = uicontrol(guiobj.imagingMlSpDetPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.1, 0.65, 0.5, 0.1],...
                'String',[char(963),' (noise parameter)']);
            guiobj.imagingMlSpDetSigmaEdit = uicontrol(guiobj.imagingMlSpDetPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.65, 0.65, 0.3, 0.1],...
                'String','0.02');
            guiobj.imagingMlSpDetTauText = uicontrol(guiobj.imagingMlSpDetPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.1, 0.45, 0.5, 0.1],...
                'String',[char(964),' (decay time constant)']);
            guiobj.imagingMlSpDetTauEdit = uicontrol(guiobj.imagingMlSpDetPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.65, 0.45, 0.3, 0.1],...
                'String','1');
            
            guiobj.imagingDetParamsPanel = uipanel(guiobj.eventDetTab,...
                'Position',[0.325, 0.33, 0.125, 0.3],...
                'Title','Event parameters',...
                'Visible','on');
            guiobj.imagingDetParamsTable = uitable(guiobj.imagingDetParamsPanel,...
                'Units','normalized',...
                'Position',[0.01, 0.01, 0.98, 0.98],...
                'ColumnWidth',{100,75},...
                'CellSelectionCallback',@(h,e) paramTableHints(e));
            
            guiobj.imagingDetRunButt = uicontrol(guiobj.eventDetTab,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.01, 0.385, 0.1, 0.05],...
                'String','Run imaging detection',...
                'Callback',@(h,e) guiobj.imagingDetRun);
            
            guiobj.imagingDetStatusLabel = uicontrol(guiobj.eventDetTab,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.01, 0.33, 0.1, 0.05],...
                'String','--IDLE--',...
                'Max',2,...
                'BackgroundColor','g');
            
            guiobj.useRunData4DetsCheckBox = uicontrol(guiobj.eventDetTab,...
                'Style','checkbox',...
                'Units','normalized',...
                'Position',[0.01, 0.26, 0.1, 0.07],...
                'String','Use run data',...
                'Callback',@(h,e) guiobj.useRunData4DetsCheckBoxCB);
            guiobj.useRunData4DetsPanel = uipanel(guiobj.eventDetTab,...
                'Position',[0.12, 0.16, 0.33, 0.15],...
                'Title','Running data for detection',...
                'Visible','off');
            guiobj.speedRange4DetsLabel = uicontrol(guiobj.useRunData4DetsPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.1, 0.75, 0.4, 0.2],...
                'String','Detect in speed range [cm/s]');
            guiobj.speedRange4DetsEdit1 = uicontrol(guiobj.useRunData4DetsPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.6, 0.75, 0.1, 0.2],...
                'String','0');
            guiobj.speedRange4DetsEdit2 = uicontrol(guiobj.useRunData4DetsPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.7, 0.75, 0.1, 0.2],...
                'String','5');
            guiobj.minTimeInSpeedRangeLabel = uicontrol(guiobj.useRunData4DetsPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.1, 0.5, 0.4, 0.2],...
                'String','Min T in range [ms]');
            guiobj.minTimeInSpeedRangeEdit = uicontrol(guiobj.useRunData4DetsPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.6, 0.5, 0.1, 0.2],...
                'String','500');
            
            guiobj.simultDetPopMenu = uicontrol(guiobj.eventDetTab,...
                'Style','popupmenu',...
                'Units','normalized',...
                'Position',[0.01, 0.065, 0.1, 0.085],...
                'String',{'--Simultan detection methods--','Standard'},...
                'Callback',@(h,e) guiobj.simultDetPopMenuSelected);
            guiobj.simultDetRunButt = uicontrol(guiobj.eventDetTab,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.01, 0.055, 0.1, 0.05],...
                'String','Run simultan detection',...
                'Callback',@(h,e) guiobj.simultDetRun);
            guiobj.simultDetStatusLabel = uicontrol(guiobj.eventDetTab,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.01, 0, 0.1, 0.05],...
                'String','--IDLE--',...
                'Max',2,...
                'BackgroundColor','g');
            
            guiobj.simultDetStandardPanel = uipanel(guiobj.eventDetTab,...
                'Position',[0.12, 0, 0.33, 0.15],...
                'Title','Settings for simultan detection',...
                'Visible','off');
            guiobj.simultDetStandardDelayLabel = uicontrol(guiobj.simultDetStandardPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.1, 0.75, 0.6, 0.2],...
                'String','Delay interval between LFP and imaging event [ms]',...
                'Tooltip','Positive value means LFP first and vice versa');
            guiobj.simultDetStandardDelayEdit1 = uicontrol(guiobj.simultDetStandardPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.7, 0.75, 0.1, 0.2],...
                'String','200');
            guiobj.simultDetStandardDelayEdit2 = uicontrol(guiobj.simultDetStandardPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.8, 0.75, 0.1, 0.2],...
                'String','300');
            
            guiobj.axesEventDet1 = axes(guiobj.eventDetTab,...
                'Position',[0.5, 0.6, 0.45, 0.35],...
                'NextPlot','replacechildren');
            guiobj.axesEventDet1.Toolbar.Visible = 'on';
            guiobj.axesEventDet1UpButt = uicontrol(guiobj.eventDetTab,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.96, 0.9, 0.03, 0.05],...
                'String','<HTML>Det&uarr',...
                'Callback',@(h,e) guiobj.eventDetAxesButtFcn(1,0,1));
            guiobj.axesEventDet1DownButt = uicontrol(guiobj.eventDetTab,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.96, 0.85, 0.03, 0.05],...
                'String','<HTML>Det&darr',...
                'Callback',@(h,e) guiobj.eventDetAxesButtFcn(1,0,-1));
            guiobj.axesEventDet1ChanUpButt = uicontrol(guiobj.eventDetTab,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.96, 0.75, 0.03, 0.05],...
                'String','<HTML>Chan&uarr',...
                'Callback',@(h,e) guiobj.eventDetAxesButtFcn(1,1,0));
            guiobj.axesEventDet1ChanDownButt = uicontrol(guiobj.eventDetTab,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.96, 0.7, 0.03, 0.05],...
                'String','<HTML>Chan&darr',...
                'Callback',@(h,e) guiobj.eventDetAxesButtFcn(1,-1,0));
                        
            guiobj.delCurrEphysEventButton = uicontrol(guiobj.eventDetTab,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.96, 0.6, 0.03, 0.05],...
                'String','Del',...
                'Tooltip','Delete currently displayed ephys event',...
                'Callback',@(h,e) guiobj.delCurrEventButtonCB(1));
            
            guiobj.axesEventDet2 = axes(guiobj.eventDetTab,...
                'Position',[0.5, 0.1, 0.45, 0.35],...
                'NextPlot','replacechildren');
            guiobj.axesEventDet2.Toolbar.Visible = 'on';
            guiobj.axesEventDet2DetUpButt = uicontrol(guiobj.eventDetTab,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.96, 0.4, 0.03, 0.05],...
                'String','<HTML>Det&uarr',...
                'Callback',@(h,e) guiobj.eventDetAxesButtFcn(2,0,1));
            guiobj.axesEventDet2DetDownButt = uicontrol(guiobj.eventDetTab,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.96, 0.35, 0.03, 0.05],...
                'String','<HTML>Det&darr',...
                'Callback',@(h,e) guiobj.eventDetAxesButtFcn(2,0,-1));
            guiobj.axesEventDet2RoiUpButt = uicontrol(guiobj.eventDetTab,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.96, 0.25, 0.03, 0.05],...
                'String','<HTML>ROI&uarr',...
                'Callback',@(h,e) guiobj.eventDetAxesButtFcn(2,1,0));
            guiobj.axesEventDet2RoiDownButt = uicontrol(guiobj.eventDetTab,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.96, 0.2, 0.03, 0.05],...
                'String','<HTML>ROI&darr',...
                'Callback',@(h,e) guiobj.eventDetAxesButtFcn(2,-1,0));
            
            guiobj.delCurrImagingEventButton = uicontrol(guiobj.eventDetTab,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.96, 0.1, 0.03, 0.05],...
                'String','Del',...
                'Tooltip','Delete currently displayed imaging event',...
                'Callback',@(h,e) guiobj.delCurrEventButtonCB(2));
            
        end
    end
    
end