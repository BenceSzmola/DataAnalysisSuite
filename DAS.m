classdef DAS < handle
    
    properties (Access = public)
        
    end
    
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
        
        EvDetTabOptionsMenu
        ephysEventDetTabDataTypeMenu
        ephysEventDetTabFiltCutoffMenu
        eventDetTabWinSizeMenu
        imagingEventDetTabDataTypeMenu
        showXtraDetFigsMenu
        showEventSpectroMenu
        
        MakewindowlargerMenu
        MakewindowsmallerMenu
        
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
        Dataselection1Panel
        DatasetListBoxLabel
        DatasetListBox
        Dataselection2Panel
        EphysListBoxLabel
        EphysListBox
        ImagingListBoxLabel
        ImagingListBox
        runParamsPanel
        InputlicktimemsEditFieldLabel
        InputLickEditField
        LicksmsListBoxLabel
        LickTimesListBox       
        
        axes11
        axes21
        axes22
        axes31
        axes32
        
        axesAbsPos1
        axesLapPos1
        axesAbsPos2
        axesLapPos2
        axesAbsPos3
        axesLapPos3
        axesveloc1
        axesveloc2
        axesveloc3
        
        %% Members of ephysProcTab
        ephysProcListBox
        ephysProcListBox2
        
        pushEphysProcDataButton
        
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
        ephysArtSuppRunButt
        
        ephysFiltParamPanel
        filterTypePopMenu
        cutoffLabel
        w1Edit
        w2Edit
        fmaxLabel
        fmaxEdit
        ffundLabel
        ffundEdit
        stopbandwidthLabel
        stopbandwidthEdit
        runFiltButton
        
        %% Members of imagingProcTab
        imagingProcListBox
        imagingProcListBox2
        
        axesImagingProc1
        axesImagingProc2
        
        imagingProcPopMenu
        
        imagingProcSrcButtGroup
        imagingProcRawRadioButt
        imagingProcProcdRadioButt
        
        imagingFiltParamPanel
        imagingFilterTypePopMenu
        imagingFiltWinSizeText
        imagingFiltWinSizeEdit
        imagingRunFiltButton
        
        %% Members of eventDetTab
        ephysDetPopMenu
        ephysDetChSelLabel
        ephysDetChSelPopMenu
        
        ephysCwtDetPanel
        ephysCwtDetMinlenLabel
        ephysCwtDetMinlenEdit
        ephysCwtDetSdMultLabel
        ephysCwtDetSdMultEdit
        ephysCwtDetCutoffLabel
        ephysCwtDetW1Edit
        ephysCwtDetW2Edit
        ephysCwtDetRefValCheck
        ephysCwtDetArtSuppPopMenu
        ephysCwtDetRefChanLabel
        ephysCwtDetRefChanEdit
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
        ephysDoGInstPowDetRefChanLabel
        ephysDoGInstPowDetRefChanEdit
        ephysDogInstPowDetRefValChBox
        ephysDoGInstPowDetArtSuppPopMenuLabel
        ephysDoGInstPowDetArtSuppPopMenu
        ephysDoGInstPowDetPresetPopMenu
        ephysDoGInstPowDetPresetSaveButt
        ephysDoGInstPowDetPresetDelButt
        
        ephysDetParamsPanel
        ephysDetParamsTable
        
        ephysDetRunButt
        ephysDetStatusLabel
        
        imagingDetPopMenu
        imagingDetChSelPopMenu
        
        imagingMeanSdDetPanel
        imagingMeanSdDetSdmultLabel
        imagingMeanSdDetSdmultEdit
        
        imagingDetParamsPanel
        imagingDetParamsTable
        
        imagingDetRunButt
        imagingDetStatusLabel
        
        simultDetPopMenu
        
        simultDetStandardPanel
        simultDetStandardDelayLabel
        simultDetStandardDelayEdit
        
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
    end
    
    %% Initializing data stored in GUI
    properties (Access = private)
        timedim = 1;                        % Determines whether the guiobj uses seconds or milliseconds
        datatyp = [0, 0, 0];                % datatypes currently handled (ephys,imaging,running)
        showXtraDetFigs = 0;
        keyboardPressDtyp = 1;
        evDetTabSimultMode = 0;
        
        xtitle = 'Time [s]';
        
        rhdName
        ephys_data                          % Currently imported electrophysiology data
        ephys_dogged
        ephys_instPowed
        % For storing processed electrophysiology data
        ephys_procced
        % Info on processed data: 2 column array, [channel, type of
        % processing]
        ephys_proccedInfo
        % Stores which proc type is which 
        ephys_procTypes = ["DoG"; "Periodic"];
        ephys_detections                    % Location of detections on time axis
        ephys_detBorders
        ephys_detectionsInfo = struct('DetType',[],'Channel',[],'Params',[],'DetRun',[]);
        ephys_detParams %= struct('Amplitude',[],'Length',[],'Frequency',[],...
            %'AUC',[],'RiseTime',[],'DecayTime',[],'FWHM',[]);
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
        imaging_smoothed
        imaging_procced
        imaging_proccedInfo
        imaging_procTypes = ["GaussAvg"];
        imaging_detections
        imaging_detBorders
        imaging_detParams
        imaging_detectionsInfo = struct('DetType',[],'Roi',[],'Params',[],'DetRun',[]);
        imaging_detMarkerSelection
        imaging_detRunsNum = 0;             % Number of detection runs
        imaging_currDetRun
        imaging_dettypes = ["Mean+SD"];
        imaging_taxis                       % Time axis for imaging data
        imaging_fs                          % Sampling frequency of imaging data
        imaging_ylabel = '\DeltaF/F';
        imag_select                         % Currently selected ROI
        imag_datanames = {};              % Names of the imported imaging data
        imag_proc_datanames = {};
        imaging_presets
        
        run_pos                             % Currently imported running data
        run_veloc                           % Running velocity
        run_taxis                           % Time axis for running data
        run_fs                              % Sampling frequency of running data
        run_pos_ylabel = 'Pos [%]';
        run_veloc_ylabel = 'Velocity [cm/s]';
        
        simult_detections
        simult_detectionsInfo %= struct('DetType',[],'EphysChannel',[],...
            %'ROI',[],'Params',[],'DetRun',[]);
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
        
        eventDetSim1CurrDet = 1;
        eventDetSim1CurrChan = 1;
        eventDetSim2CurrDet = 1;
        eventDetSim2CurrRoi = 1;
        
%         winsizes = [1280,780;1600,900;1920,1080;2560,1440;3840,2160];
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
        function ephysplot(guiobj,ax,index,value)
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
                firstplot = false;
            end
            
            switch guiobj.tabs.SelectedTab.Title
                case 'Main tab'
                    % Separating incoming indices into raw/processed
                    rawInds = index(index <= size(guiobj.ephys_data,1));
                    procInds = index(index > size(guiobj.ephys_data,1));
                    procInds = procInds - size(guiobj.ephys_data,1);
                    
                    if ~isempty(rawInds)
                        plot(ax,guiobj.ephys_taxis,guiobj.ephys_data(rawInds,:))
                        hold(ax,'on')
                        dataname = guiobj.ephys_datanames(rawInds);
                    end
                    if ~isempty(procInds)
                        plot(ax,guiobj.ephys_taxis,guiobj.ephys_procced(procInds,:))
                        hold(ax,'on')
                        dataname = guiobj.ephysProcListBox2.String{procInds};
                    end
%                     hold(ax,'off')
                    ax.NextPlot = 'replacechildren';
                case 'Electrophysiology data processing'
                    if ax == guiobj.axesEphysProc1
                        plot(ax,guiobj.ephys_taxis,...
                            guiobj.ephys_data(index,:))
                        dataname = guiobj.ephys_datanames(index);
                    elseif ax == guiobj.axesEphysProc2
                        plot(ax,guiobj.ephys_taxis,...
                            guiobj.ephys_procced(index,:))
                        dataname = guiobj.ephys_procdatanames(index);
                    end
            end

            if firstplot
                axis(ax,'tight')
                ax.NextPlot = 'replacechildren';
            end
            if length(index) == 1
                title(ax,dataname,'Interpreter','none')
            elseif length(index) > 1
                multitle = sprintf(' #%d',sort(index));
                title(ax,['Channels:',multitle])
            end
            xlabel(ax,guiobj.xtitle)
            ylabel(ax,guiobj.ephys_ylabel)
            xlimLink(guiobj)
        end
        
        %%
        function ephysprocplot(guiobj,ax,index,value,proctype)
            if isempty(index) | index == 0
                return
            end
            
            if isempty(findobj(ax,'Type','line'))
                firstplot = true;
                ax.NextPlot = 'replace';
            else
                firstplot = false;
            end
            
            plot(ax,guiobj.ephys_taxis,guiobj.ephys_procced(index,:))
            if firstplot
                axis(ax,'tight')
                ax.NextPlot = 'replacechildren';
            end
            if length(index) == 1
                title(ax,value,'Interpreter','none')
            elseif length(index) > 1
                multitle = sprintf(' #%d',sort(guiobj.ephys_proccedInfo(index,1)));
                if length(unique(proctype)) == 1
                    temp = char(guiobj.ephys_procTypes(unique(proctype)));
                    title(ax,[temp,'| Channels:',multitle])
                elseif length(unique(proctype)) > 1
                    title(ax,['Mixed| Channels:',multitle]);
                end
            end
            xlabel(ax,guiobj.xtitle)
            switch guiobj.ephys_procTypes(proctype)
                case 'DoG'
                    ylabel(ax,guiobj.ephys_ylabel)
            end
        end
        
        %%
        function imagingplot(guiobj,ax,index,value)
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
                firstplot = false;
            end
            
            switch guiobj.tabs.SelectedTab.Title
                case 'Main tab'
                    % Separating incoming indices into raw/processed
                    rawInds = index(index <= size(guiobj.imaging_data,1));
                    procInds = index(index > size(guiobj.imaging_data,1));
                    procInds = procInds - size(guiobj.imaging_data,1);
                                        
                    if ~isempty(rawInds)
                        plot(ax,guiobj.imaging_taxis,guiobj.imaging_data(rawInds,:))
                        hold(ax,'on')
                        dataname = guiobj.imag_datanames(rawInds);
                    end
                    if ~isempty(procInds)
                        plot(ax,guiobj.imaging_taxis,guiobj.imaging_procced(procInds,:))
                        hold(ax,'on')
                        dataname = guiobj.imagingProcListBox2.String{procInds};
                    end
%                     hold(ax,'off')
                    ax.NextPlot = 'replacechildren';

                case 'Imaging data processing'
                    if ax == guiobj.axesImagingProc1
                        plot(ax,guiobj.imaging_taxis,...
                            guiobj.imaging_data(index,:))
                        dataname = guiobj.imag_datanames(index);
                    elseif ax == guiobj.axesImagingProc2
                        plot(ax,guiobj.imaging_taxis,...
                            guiobj.imaging_procced(index,:))
                        dataname = guiobj.imag_proc_datanames(index);
                    end
            end
            
            if firstplot
                axis(ax,'tight')
                ax.NextPlot = 'replacechildren';
            end
            
            if length(index) == 1
                title(ax,dataname,'Interpreter','none')
            elseif length(index) > 1
                multitle = sprintf(' #%d',sort(index));
                title(ax,['ROIs:',multitle])
            end
            xlabel(ax,guiobj.xtitle)
            ylabel(ax,guiobj.imaging_ylabel);
            xlimLink(guiobj)
        end
        
        %%
        function runposplot(guiobj)
            switch sum(guiobj.datatyp)
                case 1
                    AbsAx = guiobj.axesAbsPos1;
                    LapAx = guiobj.axesLapPos1;
                case 2
                    AbsAx = guiobj.axesAbsPos2;
                    LapAx = guiobj.axesLapPos2;
                case 3 
                    AbsAx = guiobj.axesAbsPos3;
                    LapAx = guiobj.axesLapPos3;
            end
%             plot(AbsAx,guiobj.run_pos,zeros(size(guiobj.run_pos)))
%             axis(AbsAx,'tight')
%             xlabel(AbsAx,'Absolute position')
%             
%             plot(LapAx,guiobj.
        end
        
        %%
        function runvelocplot(guiobj)
            switch sum(guiobj.datatyp)
                case 1
                    ax = guiobj.axesveloc1;
                case 2
                    ax = guiobj.axesveloc2;
                case 3 
                    ax = guiobj.axesveloc3;
            end
            plot(ax,guiobj.run_taxis,guiobj.run_veloc)
            axis(ax,'tight')
            title(ax,'Running velocity','Interpreter','none')
            xlabel(ax,guiobj.xtitle)
            ylabel(ax,guiobj.run_veloc_ylabel)
            xlimLink(guiobj)
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
                        guiobj.axesAbsPos1.Visible = 'on';
                        guiobj.axesLapPos1.Visible = 'on';
                        guiobj.axesveloc1.Visible = 'on';
                        
                        runposplot(guiobj)
                        runvelocplot(guiobj)
                    case 2
                        guiobj.Panel1Plot.Visible = 'off';
                        cla(guiobj.axes22)
                        guiobj.axes22.Visible = 'off';
                        guiobj.axesAbsPos2.Visible = 'on';
                        guiobj.axesLapPos2.Visible = 'on';
                        guiobj.axesveloc2.Visible = 'on';
                        guiobj.Panel2Plot.Visible = 'on';
                        guiobj.Panel3Plot.Visible = 'off';
                        
                        runposplot(guiobj)
                        runvelocplot(guiobj)
                        
                        % Plotting previously selected data
                        if guiobj.datatyp(1)
                            ephysplot(guiobj,guiobj.axes21,...
                                guiobj.ephys_select,...
                                [])
                        elseif guiobj.datatyp(2)
                            imagingplot(guiobj,guiobj.axes21,...
                                guiobj.imag_select,...
                                [])
                        end
                    case 3
                        guiobj.Panel1Plot.Visible = 'off';
                        guiobj.Panel2Plot.Visible = 'off';
                        guiobj.Panel3Plot.Visible = 'on';
                        
                        runposplot(guiobj)
                        runvelocplot(guiobj)
                        
                        ephysplot(guiobj,guiobj.axes31,guiobj.ephys_select,...
                            [])
                        imagingplot(guiobj,guiobj.axes32,guiobj.imag_select,...
                            [])
                end
            elseif ~guiobj.runCheckBox.Value
                switch sum(guiobj.datatyp)
                    case 1
                        guiobj.Panel1Plot.Visible = 'on';
                        guiobj.Panel2Plot.Visible = 'off';
                        guiobj.Panel3Plot.Visible = 'off';
                        cla(guiobj.axesAbsPos1)
                        guiobj.axesAbsPos1.Visible = 'off';
                        cla(guiobj.axesLapPos1)
                        guiobj.axesLapPos1.Visible = 'off';
                        cla(guiobj.axesveloc1)
                        guiobj.axesveloc1.Visible = 'off';
                        guiobj.axes11.Visible = 'on';
                        
                        if guiobj.datatyp(1)
                            ephysplot(guiobj,guiobj.axes11,...
                                guiobj.ephys_select,...
                                [])
                        elseif guiobj.datatyp(2)
                            imagingplot(guiobj,guiobj.axes11,...
                                guiobj.imag_select,...
                                [])
                        end
                    case 2
                        guiobj.Panel1Plot.Visible = 'off';
                        cla(guiobj.axesAbsPos2)
                        guiobj.axesAbsPos2.Visible = 'off';
                        cla(guiobj.axesLapPos2)
                        guiobj.axesLapPos2.Visible = 'off';
                        cla(guiobj.axesveloc2)
                        guiobj.axesveloc2.Visible = 'off';
                        guiobj.axes22.Visible = 'on';
                        guiobj.Panel2Plot.Visible = 'on';
                        guiobj.Panel3Plot.Visible = 'off';
                        
                        ephysplot(guiobj,guiobj.axes21,guiobj.ephys_select,...
                            [])
                        imagingplot(guiobj,guiobj.axes22,guiobj.imag_select,...
                            [])
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
        function lickplot(guiobj)
%             licks = guiobj.LickTimesListBox.String;
%             licks = str2double(licks);
%             allaxes = findobj(guiobj.mainfig,'Type','axes');
%             for i = 1:length(allaxes)
%                 for j = 1:length(licks)
% %                     yminmax = allaxes(i).YLim;
% %                     line(allaxes(i),[licks(j),licks(j)],yminmax,'Color','r')
%                     xline(allaxes(i),licks(j),'Color','r');
%                 end
%             end
        end
        
        %%
        function ephysDetMarkerPlot(guiobj,fromMenu)
            % fromMenu signals whether call is coming from menu press
            if nargin == 1
                fromMenu = 0;
            end
            detSel = guiobj.ephys_detMarkerSelection;
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
                markers = {'r*','r+','ro','rx','rs','rd','rp','rh'};
                hold(ephysAxes,'on')
                legendLabels = cell(1,length(detSel));
                markerObjs = [];
                markerIdx = 0;
                for i = 1:length(detSel)
                    legendLabels{i} = ['Chan#',num2str(i)];
                    if markerIdx+1 > length(markers)
                        markerIdx = 1;
                    else
                        markerIdx = markerIdx + 1;
                    end
                    p = plot(ephysAxes,guiobj.ephys_taxis,...
                        guiobj.ephys_detections(detSel(i),:),markers{markerIdx},...
                        'MarkerSize',12);
                    markerObjs = [markerObjs; p];
                end
                if strcmp(guiobj.showEphysDetLegendMenu.Checked,'on')
                    legend(ephysAxes,markerObjs,legendLabels)
                elseif strcmp(guiobj.showEphysDetLegendMenu.Checked,'off')
                    legend(ephysAxes,'off')
                end
%                 hold(ephysAxes,'off')
                ephysAxes.NextPlot = 'replacechildren';
            end
        end
        
        %%
        function imagingDetMarkerPlot(guiobj,fromMenu)
            % fromMenu signals whether call is coming from menu press
            if nargin == 1
                fromMenu = 0;
            end
%             detSel = guiobj.imaging_detMarkerSelection;
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
    %             for i = 1:length(detSel)
    %                 plot(imagingAxes,guiobj.imaging_taxis,...
    %                     guiobj.imaging_detections(detSel(i),:),'r*','MarkerSize',12)
    %             end
                for i = 1:size(guiobj.imaging_detections,1)
                    plot(imagingAxes,guiobj.imaging_taxis,...
                        guiobj.imaging_detections(i,:),'g*','MarkerSize',12)
                end
%                 hold(imagingAxes,'off')
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
    %                     dets = guiobj.simult_detections(j,:);
    %                     dets = round(dets*guiobj.ephys_fs,4);
    %                     marks = nan(1,length(guiobj.ephys_taxis));
    %                     marks(dets) = 0;
                        plot(ax(i),guiobj.ephys_taxis,guiobj.simult_detections(j,:),...
                            'k*','MarkerSize',12)
                    end
    %                 if i == 1
    %                     for j = 1:size(guiobj.simultan_detections,1)
    %                         plot(ax(i),guiobj.ephys_taxis,...
    %                             'k*','MarkerSize',12)
    %                     end
    %                 elseif i == 2
    %                     for j = 1:size(guiobj.simultan_detections,1)
    %                         plot(ax(i),guiobj.imaging_taxis,...
    %                             guiobj.imaging_detections(j,:),'g*','MarkerSize',12)
    %                     end
    %                 end
%                     hold(ax(i),'off')
                    ax(i).NextPlot = 'replacechildren';
                end
            end
            
        end
        
        %%
        function xlimLink(guiobj)
%             allaxes = findobj(guiobj.mainfig,'Type','axes');
%             
%             xmin = 0;
%             xmax = 1;
%             for i = 1:length(allaxes)
%                 if isempty(findobj(allaxes(i),'Type','line'))
%                     continue 
%                 end
%                 temp = allaxes(i).XLim;
%                 display(i)
%                 display(temp)
%                 if temp(1) < xmin
%                     xmin = temp(1);
%                 end
%                 if temp(2) > xmax
%                     xmax = temp(2);
%                 end
%             end
%             linkaxes(allaxes,'x')
%             allaxes(1).XLim = [xmin xmax];
%             display('xlimlink end')
        end
        
        %%
        function smartplot(guiobj)
            dtyp = guiobj.datatyp;
            switch guiobj.tabs.SelectedTab.Title
                case 'Main tab'
                    switch sum(dtyp)
                        case 1
                            if dtyp(1)
                                ephysplot(guiobj,guiobj.axes11,guiobj.ephys_select,...
                                    [])
                            elseif dtyp(2)
                                imagingplot(guiobj,guiobj.axes11,guiobj.imag_select,...
                                    [])
                            elseif dtyp(3)
                                runposplot(guiobj)
                                runvelocplot(guiobj)
                            end
                        case 2
                            if dtyp(1)
                                ephysplot(guiobj,guiobj.axes21,guiobj.ephys_select,...
                                    [])
                            end
                            if dtyp(2)
                                imagingplot(guiobj,guiobj.axes22,guiobj.imag_select,...
                                    [])
                            end
                            if dtyp(3)
                                runposplot(guiobj)
                                runvelocplot(guiobj)
                            end
                        case 3
                            ephysplot(guiobj,guiobj.axes31,guiobj.ephys_select,...
                                [])
                            imagingplot(guiobj,guiobj.axes32,guiobj.imag_select,...
                                [])
                            runposplot(guiobj)
                            runvelocplot(guiobj)
                    end
                case 'Electrophysiology data processing'
                    ephysplot(guiobj,guiobj.axesEphysProc1,...
                        guiobj.ephys_select,...
                        [])
            end
            xlimLink(guiobj)
        end
        
        %%
        function eventDetAxesButtFcnOld(guiobj,axNum,detRoi,upDwn)
%             switch axNum
%                 case 1 %ephys axes
%                     if isempty(guiobj.ephys_detections)
%                         return
%                     end
%                     
% %                     assignin('base','dets',guiobj.ephys_detections)
% %                     assignin('base','detinfo',guiobj.ephys_detectionsInfo)
%                     
%                     switch guiobj.eventDet1DataType
%                         case 1
%                             data = guiobj.ephys_data;
%                         case 2
%                             data = guiobj.ephys_dogged;
%                         case 3
%                             data = guiobj.ephys_instPowed;
%                     end
% %                     assignin('base','efizdetinfo',guiobj.ephys_detectionsInfo)
%                     currDetRun = guiobj.ephys_currDetRun;
% %                     currDetRows = find(guiobj.ephys_detectionsInfo(:,3)==currDetRun);
% %                     currChans = guiobj.ephys_detectionsInfo(currDetRows,1);
%                     currDetRows = find([guiobj.ephys_detectionsInfo.DetRun]==currDetRun);
%                     currChans = [guiobj.ephys_detectionsInfo(currDetRows).Channel];
%                     emptyChans = [];
%                     
% %                     display('currChans before')
% %                     currChans
%                     
%                     % Filtering out channels with no detections
%                     for j = 1:length(currDetRows)
%                         if isempty(find(~isnan(guiobj.ephys_detections(currDetRows(j),:)),1))
%                             emptyChans = [emptyChans, j];
%                         end
%                     end
%                     currChans(emptyChans) = [];
%                     currDetRows(emptyChans) = [];
%                     
% %                     display('currChans after')
% %                     currChans
%                     
% %                     assignin('base','detinfo',guiobj.ephys_detectionsInfo)
%                     
% %                     display('guiobj curridx')
% %                     display(guiobj.eventDet1CurrIdx)
%                     
%                     ax = guiobj.axesEventDet1;
%                     switch detRoi
%                         case 0
% %                             assignin('base','detinfo',guiobj.ephys_detectionsInfo)
% %                             assignin('base','curdetrun',currDetRun)
% %                             find(guiobj.ephys_detectionsInfo(:,3)==currDetRun,currChans(1))
% %                             guiobj.eventDet1CurrIdx = find(guiobj.ephys_detectionsInfo(:,3)==currDetRun,currChans(1));
% %                             guiobj.eventDet1CurrIdx = guiobj.eventDet1CurrIdx(end);
%                             guiobj.eventDet1CurrDet = 1;
%                             guiobj.eventDet1CurrChan = 1;
%                         case 1
%                             switch upDwn
%                                 case 1
% %                                     temp = find(currChans == (currChans(guiobj.eventDet1CurrChan)));
%                                     temp = currDetRows(guiobj.eventDet1CurrChan);
% %                                     temp = currDetRows(temp)
%                                     if guiobj.eventDet1CurrDet < length(find(~isnan(guiobj.ephys_detections(temp,:))))
%                                         guiobj.eventDet1CurrDet = ...
%                                             guiobj.eventDet1CurrDet + 1;
%                                     end
%                                 case 2
%                                     if guiobj.eventDet1CurrDet > 1
%                                         guiobj.eventDet1CurrDet = ...
%                                             guiobj.eventDet1CurrDet - 1;
%                                     end
%                             end
%                         case 2
%                             guiobj.eventDet1CurrDet = 1;
% %                             temp = find(guiobj.ephys_detectionsInfo(:,3)==currDetRun);
% %                             currChans = guiobj.ephys_detectionsInfo(temp,1);
%                             switch upDwn
%                                 case 1
%                                     if guiobj.eventDet1CurrChan < length(currChans)
%                                         guiobj.eventDet1CurrChan = ...
%                                             guiobj.eventDet1CurrChan + 1;
%                                         guiobj.eventDet1CurrIdx = ...
%                                             guiobj.eventDet1CurrIdx + 1;
%                                     end
%                                 case 2
%                                     if guiobj.eventDet1CurrChan > 1
%                                         guiobj.eventDet1CurrChan = ...
%                                             guiobj.eventDet1CurrChan - 1;
%                                         guiobj.eventDet1CurrIdx = ...
%                                             guiobj.eventDet1CurrIdx - 1;
%                                     end
%                                     
%                             end
%                     end
%                     
% %                     chan = guiobj.ephysDetChSelPopMenu.Value;
%                     chan = currChans(guiobj.eventDet1CurrChan);
%                     axYMinMax = [min(data(chan,:)), max(data(chan,:))];
% %                     currDetRows
% %                     currDet = guiobj.eventDet1CurrIdx
% %                     currDet = currChans(guiobj.eventDet1CurrChan)+currDetRows(1)-1
%                     currDetRow = currDetRows(guiobj.eventDet1CurrChan);
%                     numDets = length(find(~isnan(guiobj.ephys_detections(currDetRow,:))));
%                     detInd = guiobj.eventDet1CurrDet;
%                     %%%
% %                     assignin('base','efizdets',guiobj.ephys_detections)
%                     %%%
%                     tInd = find(~isnan(guiobj.ephys_detections(currDetRow,:)));
%                     tInd = tInd(detInd);
%                     tStamp = guiobj.ephys_taxis(tInd);
% %                     win = round(0.25 * guiobj.ephys_fs,4);
%                     win = guiobj.eventDet1Win/2000;
%                     win = round(win*guiobj.ephys_fs,4);
%                     if (tInd-win > 0) & (tInd+win <= length(guiobj.ephys_taxis))
%                         tWin = guiobj.ephys_taxis(tInd-win:tInd+win);
% %                         dataWin = guiobj.ephys_data(chan,tInd-win:tInd+win);
%                         dataWin = data(chan,tInd-win:tInd+win);
%                     elseif tInd-win <= 0
%                         tWin = guiobj.ephys_taxis(1:tInd+win);
% %                         dataWin = guiobj.ephys_data(chan,1:tInd+win);
%                         dataWin = data(chan,1:tInd+win);
%                     elseif tInd+win > length(guiobj.ephys_taxis)
%                         tWin = guiobj.ephys_taxis(tInd-win:end);
% %                         dataWin = guiobj.ephys_data(chan,tInd-win:end);
%                         dataWin = data(chan,tInd-win:end);
%                     end
% %                     dataWin = guiobj.ephys_data(chan,tInd-win:tInd+win);
%                     plot(ax,tWin,dataWin)
%                     hold(ax,'on')
% %                     line(ax,[tStamp tStamp],axYMinMax,...
% %                         'Color','r')
%                     xline(ax,tStamp,'Color','r','LineWidth',1);
%                     hold(ax,'off')
%                     axis(ax,'tight')
%                     ylim(ax,axYMinMax)
%                     xlabel(ax,guiobj.xtitle)
%                     ylabel(ax,guiobj.ephys_ylabel);
%                     title(ax,['Channel#',num2str(chan),'      Detection#',num2str(detInd),...
%                         '/',num2str(numDets)])
%                     
%                     %%% testing FWHM
% %                     halfmax = data(chan,tInd)/2
% %                     aboveHM = find(data(chan,:)>halfmax);
% %                     assignin('base','aboveHM',aboveHM)
% %                     assignin('base','tInd',tInd)
% %                     aboveHMtInd = find(aboveHM==tInd);
% %                     steps = diff(aboveHM);
% %                     disconts = find(steps~=1);
% %                     lowbord = aboveHM(disconts(find((disconts)<aboveHMtInd,1,'last'))+1);
% %                     highbord = aboveHM(disconts(find(disconts>aboveHMtInd,1)));
% %                     FWHM = (highbord-lowbord)/20
%                     
% %                     display('----------------------------------------')
%                     
%                 case 2
%                     if isempty(guiobj.imaging_detections)
%                         return
%                     end
%                     
%                     ax = guiobj.axesEventDet2;
%                     switch detRoi
%                         case 0
%                             guiobj.eventDet2CurrDet = 1;
%                         case 1
%                             switch upDwn
%                                 case 1
%                                     if guiobj.eventDet2CurrDet < length(find(~isnan(guiobj.imaging_detections(guiobj.eventDet2CurrRoi,:))))
%                                         guiobj.eventDet2CurrDet = ...
%                                             guiobj.eventDet2CurrDet + 1;
%                                     end
%                                 case 2
%                                     if guiobj.eventDet2CurrDet > 1
%                                         guiobj.eventDet2CurrDet = ...
%                                             guiobj.eventDet2CurrDet - 1;
%                                     end
%                             end
%                         case 2
%                             guiobj.eventDet2CurrDet = 1;
%                             switch upDwn
%                                 case 1
%                                     if guiobj.eventDet2CurrRoi < size(guiobj.imaging_data,1)
%                                         guiobj.eventDet2CurrRoi = ...
%                                             guiobj.eventDet2CurrRoi + 1;
%                                     end
%                                 case 2
%                                     if guiobj.eventDet2CurrRoi > 1
%                                         guiobj.eventDet2CurrRoi = ...
%                                             guiobj.eventDet2CurrRoi - 1;
%                                     end
%                             end
%                     end
%                     
%                     roi = guiobj.eventDet2CurrRoi;
% %                     currDet = guiobj.eventDet2CurrIdx;
%                     detInd = guiobj.eventDet2CurrDet;
%                     tInd = find(~isnan(guiobj.imaging_detections(roi,:)));
%                     tInd = tInd(detInd);
%                     tStamp = guiobj.imaging_taxis(tInd);
%                     win = round(1 * guiobj.imaging_fs);
%                     tWin = guiobj.imaging_taxis(tInd-win:tInd+win);
%                     dataWin = guiobj.imaging_data(roi,tInd-win:tInd+win);
%                     plot(ax,tWin,dataWin)
%                     hold(ax,'on')
%                     line(ax,[tStamp tStamp],[min(dataWin), max(dataWin)],...
%                         'Color','r')
%                     hold(ax,'off')
%                     axis(ax,'tight')
%                     xlabel(ax,guiobj.xtitle)
%                     ylabel(ax,guiobj.imaging_ylabel);
%                     title(ax,['ROI#',num2str(roi),' Detection#',num2str(detInd)])
%             end
        end
        
        %%
        function eventDetAxesButtFcnOld2(guiobj,dTyp,detRoi,upDwn)
            switch dTyp
                case 1 % ephys
                    if isempty(guiobj.ephys_detections)
                        return
                    end
                    
                    detMat = guiobj.ephys_detections;
                    
                    currDetRun = guiobj.ephys_currDetRun;
                    currDetRows = find([guiobj.ephys_detectionsInfo.DetRun]==currDetRun);
                    currChans = [guiobj.ephys_detectionsInfo(currDetRows).Channel];
                    emptyChans = [];
                    
                    % Filtering out channels with no detections
                    for j = 1:length(currDetRows)
                        if isempty(find(~isnan(detMat(currDetRows(j),:)),1))
                            emptyChans = [emptyChans, j];
                        end
                    end
                    currChans(emptyChans) = [];
                    currDetRows(emptyChans) = [];
                    
                    currDetNum = guiobj.eventDet1CurrDet;
                    currChanNum = guiobj.eventDet1CurrChan;
                    
                case 2 % imaging
                    if isempty(guiobj.imaging_detections)
                        return
                    end
                    
                    data = guiobj.imaging_data;
                    
                    detMat = guiobj.imaging_detections;
                    
                    currDetRun = guiobj.imaging_currDetRun;
                    currDetRows = find([guiobj.imaging_detectionsInfo.DetRun]==currDetRun);
                    currChans = [guiobj.imaging_detectionsInfo(currDetRows).Roi];
                    emptyChans = [];
                    
                    % Filtering out channels with no detections
                    for j = 1:length(currDetRows)
                        if isempty(find(~isnan(detMat(currDetRows(j),:)),1))
                            emptyChans = [emptyChans, j];
                        end
                    end
                    currChans(emptyChans) = [];
                    currDetRows(emptyChans) = [];
                    
                    currDetNum = guiobj.eventDet2CurrDet;
                    currChanNum = guiobj.eventDet2CurrRoi;
                    
            end
            
            switch detRoi
                case 0
                    currDetNum = 1;
                    currChanNum = 1;
                case 1
                    switch upDwn
                        case 1
                            temp = currDetRows(currChanNum);
                            if currDetNum < length(find(~isnan(detMat(temp,:))))
                                currDetNum = currDetNum + 1;
                            end
                        case 2
                            if currDetNum > 1
                                currDetNum = currDetNum - 1;
                            end
                    end
                case 2
                    currDetNum = 1;
                    switch upDwn
                        case 1
                            if currChanNum < length(currChans)
                                currChanNum = currChanNum + 1;
                            end
                        case 2
                            if currChanNum > 1
                                currChanNum = currChanNum - 1;
                            end

                    end
            end
            
            switch dTyp
                case 1
                    guiobj.eventDet1CurrDet = currDetNum;
                    guiobj.eventDet1CurrChan = currChanNum;
                case 2
                    guiobj.eventDet2CurrDet = currDetNum;
                    guiobj.eventDet2CurrRoi = currChanNum;
            end
            
            if (dTyp==1) | (dTyp==2)
                eventDetPlotFcn(guiobj,dTyp,currChans,currDetRows,0)
            end
            
        end
        
        %%
        function eventDetPlotFcn(guiobj,dTyp,forSpectro)
            if nargin < 3
                forSpectro = 0;
            end
            
            switch dTyp
                case 1
                    ax = guiobj.axesEventDet1;
                    
                    switch guiobj.eventDet1DataType
                        case 1
                            data = guiobj.ephys_data;
                        case 2
                            data = guiobj.ephys_dogged;
                        case 3
                            data = guiobj.ephys_instPowed;
                    end
                    taxis = guiobj.ephys_taxis;
                    fs = guiobj.ephys_fs;
                    
                    
                    yAxLbl = guiobj.ephys_ylabel;
                    plotTitle = 'Channel#';
                case 2
                    ax = guiobj.axesEventDet2;
                    
                    switch guiobj.eventDet2DataType
                        case 1    
                            data = guiobj.imaging_data;
                        case 2
                            data = guiobj.imaging_smoothed;     
                    end
                    taxis = guiobj.imaging_taxis;
                    fs = guiobj.imaging_fs;
                    
                    yAxLbl = guiobj.imaging_ylabel;
                    plotTitle = 'ROI#';
            end
            
            [numDets,numChans,detNum,detInd,detBorders,chan,detParams] = extractDetStructs(guiobj,dTyp);
            
            axYMinMax = [min(data(chan,:)), max(data(chan,:))];
            
            switch dTyp
                case 1
                    if ~isempty(detParams)
                        temp = [fieldnames([detParams]), squeeze(struct2cell([detParams]))];
                        guiobj.ephysDetParamsTable.Data = temp;
                        guiobj.ephysDetParamsTable.RowName = [];
                        guiobj.ephysDetParamsTable.ColumnName = {'','Values'};
                    end
                case 2
                    if ~isempty(detParams)
                        temp = [fieldnames([detParams]), squeeze(struct2cell([detParams]))];
                        guiobj.imagingDetParamsTable.Data = temp;
                        guiobj.imagingDetParamsTable.RowName = [];
                        guiobj.imagingDetParamsTable.ColumnName = {'','Values'};
                    end
            end

            tStamp = taxis(detInd);
            win = guiobj.eventDet1Win/2000;
            win = round(win*fs,0);
            
            if ~isempty(detBorders)
                winStart = detBorders(1)-win;
                winEnd = detBorders(2)+win;
                if (winStart>0) & (winEnd <= length(taxis))
                    tWin = taxis(winStart:winEnd);
                    dataWin = data(chan,winStart:winEnd);
                    winInds = winStart:winEnd;
                elseif winStart <= 0
                    tWin = taxis(1:winEnd);
                    dataWin = data(chan,1:winEnd);
                    winInds = 1:winEnd;
                elseif winEnd > length(taxis)
                    tWin = taxis(winStart:end);
                    dataWin = data(chan,winStart:end);
                    winInds = winStart:length(taxis);
                end
            else
                if (detInd-win > 0) & (detInd+win <= length(taxis))
                    tWin = taxis(detInd-win:detInd+win);
                    dataWin = data(chan,detInd-win:detInd+win);
                elseif detInd-win <= 0
                    tWin = taxis(1:detInd+win);
                    dataWin = data(chan,1:detInd+win);
                elseif detInd+win > length(taxis)
                    tWin = taxis(detInd-win:end);
                    dataWin = data(chan,detInd-win:end);
                end
            end
            
            if forSpectro
                try
                    w1 = guiobj.ephys_detectionsInfo(currDetRow).Params.W1;
                    w2 = guiobj.ephys_detectionsInfo(currDetRow).Params.W2;
                catch
                    w1 = 150;
                    w2 = 250;
                    warning('Cutoff frequencies set to default 150-250')
                end
                
                spectrogramMacher(guiobj.ephys_data(chan,winInds),fs,w1,w2)
                
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
                ylim(ax,axYMinMax)
                xlabel(ax,guiobj.xtitle)
                ylabel(ax,yAxLbl);
                title(ax,[plotTitle,num2str(chan),'      Detection#',num2str(detNum),...
                    '/',num2str(numDets)])
            end
            
        end
        
        %%
        function eventDetAxesButtFcn(guiobj,dTyp,chanUpDwn,detUpDwn)
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
                end

                if chanUpDwn ~= 0
                    currDet = 1;
                end
                
                [numDets,numChans] = extractDetStructs(guiobj,dTyp);

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

%                 if (chanUpDwn==0) & (detUpDwn==0)
%                     currDet = 1;
%                     currChan = 1;
%                 end
% 
%                 if chanUpDwn ~= 0
%                     currDet = 1;
%                 end
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
                            guiobj.eventDetSim2CurrDet = 1;
                            guiobj.eventDetSim2CurrRoi = 1;
                            
                            eventDetPlotFcn(guiobj,1)
                            eventDetPlotFcn(guiobj,2)

                        case 2
                            guiobj.eventDetSim2CurrDet = currDet;
                            guiobj.eventDetSim2CurrRoi = currChan;
                            
                            eventDetPlotFcn(guiobj,2)
                    end
            end
        end
        
        %%
        function simEventDetPlotFcn(guiobj,dTyp)
            
            switch dTyp
                case 1
                    ax = guiobj.axesEventDet1;
                    taxis = guiobj.ephys_taxis;
                    fs = guiobj.ephys_fs;
                    
                    switch guiobj.eventDet1DataType
                        case 1
                            data = guiobj.ephys_data;
                        case 2
                            data = guiobj.ephys_dogged;
                        case 3
                            data = guiobj.ephys_instPowed;
                    end
                    
                case 2
                    ax = guiobj.axesEventDet2;
                    taxis = guiobj.imaging_taxis;
                    fs = guiobj.imaging_fs;
                    
                    switch guiobj.eventDet2DataType
                        case 1
                            data = guiobj.imaging_data;
                        case 2
                            data = guiobj.imaging_smoothed;
                    end
            end
            
            [numDets,numChans,detNum,detInd,detBorders,chan] = extractDetStructs(guiobj,dTyp);
            
            tStamp = taxis(detInd);
            win = guiobj.eventDet1Win/2000;
            win = round(win*fs,0);
            
            if ~isempty(detBorders)
                winStart = detBorders(1)-win;
                winEnd = detBorders(2)+win;
                if (winStart>0) & (winEnd <= length(taxis))
                    tWin = taxis(winStart:winEnd);
                    dataWin = data(chan,winStart:winEnd);
                    winInds = winStart:winEnd;
                elseif winStart <= 0
                    tWin = taxis(1:winEnd);
                    dataWin = data(chan,1:winEnd);
                    winInds = 1:winEnd;
                elseif winEnd > length(taxis)
                    tWin = taxis(winStart:end);
                    dataWin = data(chan,winStart:end);
                    winInds = winStart:length(taxis);
                end
            else
                if (detInd-win > 0) & (detInd+win <= length(taxis))
                    tWin = taxis(detInd-win:detInd+win);
                    dataWin = data(chan,detInd-win:detInd+win);
                elseif detInd-win <= 0
                    tWin = taxis(1:detInd+win);
                    dataWin = data(chan,1:detInd+win);
                elseif detInd+win > length(taxis)
                    tWin = taxis(detInd-win:end);
                    dataWin = data(chan,detInd-win:end);
                end
            end
            
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
            ylim(ax,axYMinMax)
            xlabel(ax,guiobj.xtitle)
            ylabel(ax,yAxLbl);
            title(ax,[plotTitle,num2str(chan),'      Detection#',num2str(detNum),...
                '/',num2str(numDets)])
            
            
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
                            
                            currDetRun = guiobj.ephys_currDetRun;
                            
                            detBorders = guiobj.ephys_detBorders;
                            
                        case 2
                            currChan = guiobj.eventDet2CurrRoi;
                            currDet = guiobj.eventDet2CurrDet;
                            detMat = guiobj.imaging_detections;
                            detInfo = guiobj.imaging_detectionsInfo;
                            detParams = guiobj.imaging_detParams;
                            
                            currDetRun = guiobj.imaging_currDetRun;
                            
                            detBorders = guiobj.imaging_detBorders;
                    end
                    
                    currDetRows = find([detInfo.DetRun]==currDetRun);
                    detMat = detMat(currDetRows,:);
                    detInfo = detInfo(currDetRows);
                    detBorders = detBorders(currDetRows);
                    detParams = detParams(currDetRows);

                    emptyRows = [];
                    for i = 1:length(currDetRows)
                        if isempty(find(~isnan(detMat(i,:)),1))
                            emptyRows = [emptyRows; i];
                        end
                    end
                    detMat(emptyRows,:) = [];
                    currDetRows(emptyRows) = [];
                    detInfo(emptyRows) = [];
                    if ~isempty(detBorders)
                        detBorders(emptyRows,:) = [];
                    end
                    if ~isempty(detParams)
                        detParams(emptyRows) = [];
                    end

                    numDets = length(find(~isnan(detMat(currChan,:))));
                    numChans = length(currDetRows);
                    
                    if nargout == 2
                        return
                    end
                    
                    if dTyp == 1
                        chan = detInfo(currChan).Channel;
                    elseif dTyp == 2
                        chan = detInfo(currChan).Roi;
                    end

                    detNum = currDet;

                    detInd = find(~isnan(detMat(currChan,:)));
                    detInd = detInd(currDet);
                    
                    if ~isempty(detBorders{currChan})
                        detBorders = detBorders{currChan};
                        detBorders = detBorders(currDet,:);
                    else
                        detBorders = [];
                    end
                    if ~isempty(detParams{currChan})
                        detParams = detParams{currChan}(currDet);
%                         detParams = detParams(currDet);
                    else
                        detParams = [];
                    end
                    
                case 1
                    detStruct = guiobj.simult_detections;
                    currDetRun = guiobj.simult_detRunsNum
                    currDetRows = find([detStruct.DetRun]==currDetRun);
                    detStruct = detStruct(currDetRows);
                    
                    detInfo = guiobj.simult_detectionsInfo(currDetRun);
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
                    currDetRows(emptyRows) = []

                    numEphysChans = length(detStruct);
                    currEphysChan = guiobj.eventDetSim1CurrChan
                    detStruct
                    [r,~] = find([detStruct(currEphysChan).DetInds{:}]);
                    r = unique(r);
                    
                    switch dTyp
                        case 1
                            numDets = length(r);
                            numChans = numEphysChans;
                            
                            if nargout == 2
                                return
                            end
                            
                            currChan = guiobj.eventDetSim1CurrChan
                            currDet = guiobj.eventDetSim1CurrDet;
                            
                            detMat = guiobj.ephys_detections;
                            assignin('base','detMat',detMat)
                            detMat = detMat(detInfo.EphysChannels,:);
                            detMat = detMat(currChan,:);
                            
                            detInd = find(~isnan(detMat));
                            detNum = r(currDet);
                            detInd = detInd(detNum);
                            
                            detBorders = guiobj.ephys_detBorders;
                            assignin('base','detBorders',detBorders)
                            detBorders = detBorders{detInfo.EphysChannels(currDetRowsRel(currChan))};
                            if ~isempty(detBorders)
                                detBorders = detBorders(r(currDet),:);
                            end
                            
                            detParams = guiobj.ephys_detParams;
                            detParams = detParams{detInfo.EphysChannels(currDetRowsRel)};
                            if ~isempty(detParams)
                                detParams = detParams(r(currDet));
                            end
                            
                            nonSimDetInfo = guiobj.ephys_detectionsInfo;
                            nonSimDetInfo = nonSimDetInfo(detInfo.EphysChannels(currDetRowsRel));
                            nonSimDetInfo = nonSimDetInfo(currChan);
                            chan = nonSimDetInfo.Channel;
                        case 2
                            currDet = guiobj.eventDetSim2CurrDet;
                            currChan = guiobj.eventDetSim2CurrRoi;
                            
                            ephysDetNum = r(guiobj.eventDetSim1CurrDet);
                            
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
                            
                            detMat = guiobj.imaging_detections;
                            detMat = detMat(currChans,:);
                            detMat = detMat(currChan,:);
                            
                            detInd = find(~isnan(detMat));
                            detNum = c(currDet);
                            detInd = detInd(detNum);
                            
                            detBorders = guiobj.imaging_detBorders{currChans(currChan)};
                            if ~isempty(detBorders)
                                detBorders = detBorders(c(currDet),:);
                            end
                            
                            detParams = guiobj.imaging_detParams{currChans(currChan)};
                            if ~isempty(detParams)
                                detParams = detParams(c(currDet));
                            end
                            
                            nonSimDetInfo = guiobj.imaging_detectionsInfo;
                            nonSimDetInfo = nonSimDetInfo(currChans);
                            nonSimDetInfo = nonSimDetInfo(currChan);
                            chan = nonSimDetInfo.Roi;
                    end
            end
            
        end
        
        %%
        function resetGuiData(guiobj,rhdORgor)

            dtyp = guiobj.datatyp;
            showXtraFigs = guiobj.showXtraDetFigs;
            close(guiobj.mainfig)
            delete(guiobj)
            guiobj = DAS;
            if dtyp(1) == 1
                guiobj.ephysCheckBox.Value = 1;
                ephysCheckBoxValueChanged(guiobj)
                if rhdORgor == 1
                    ImportRHDButtonPushed(guiobj)
                elseif rhdORgor == 2
                    ImportgorobjButtonPushed(guiobj)
                end
            elseif dtyp(2) == 1
                guiobj.imagingCheckBox.Value = 1;
                imagingCheckBoxValueChanged(guiobj)
                ImportgorobjButtonPushed(guiobj)
            elseif dtyp(3) == 1
                guiobj.runCheckBox.Value = 1;
                runCheckBoxValueChanged(guiobj)
                ImportruncsvButtonPushed(guiobj)
            end
            if showXtraFigs
                showXtraDetFigsMenuSel(guiobj)                
            end
        end
        
        %%
%         function DetParamsMiner(guiobj,dtyp,dettype,dets)
%             if isempty(dets) | isnan(dets)
%                 return
%             end
%             
%             if size(dets,1) > size(dets,2)
%                 dets = dets';
%             end
%             
%             detParams = guiobj.ephys_detParams;
%             for i = 1:size(dets,1)
%                 for j = 1:length(find(~isnan(dets(i,:))))
%                     
%                 end
%             end
%             
%         end
    end
    
    %% Callback functions
    methods (Access = private)

%         % Code that executes after component creation
%         function startupFcn(guiobj)
%             axesmaker(guiobj)
%         end

        %% Button pushed function: ImportRHDButton
        function ImportRHDButtonPushed(guiobj, event)
%             %%%test
%             display(event)
%             %%%
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
%                 if strcmp(clrGUI,'Yes')
%                     resetGuiData(guiobj,1)
%                 end
%                 return
            end
            
            [filename,path] = uigetfile('*.rhd');
            if filename == 0
                figure(guiobj.mainfig)
                return
            end
            guiobj.rhdName = filename(1:end-4);
%             drawnow;
            figure(guiobj.mainfig)
            oldpath = cd(path);
            data = read_Intan_RHD2000_file_szb(filename);
            cd(oldpath)
            guiobj.ephys_fs = data.fs;
            t_amp = data.t_amplifier;
            data = data.amplifier_data;
            % Check data dimensions
            if size(data,1) > size(data,2)
                data = data';
            end
            
            % Create and store time axis
            guiobj.ephys_taxis = linspace(t_amp(1),...
                length(data)/guiobj.ephys_fs+t_amp(1),length(data));
                        
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
        end

        %% Button pushed function: ImportgorobjButton
        function ImportgorobjButtonPushed(guiobj, event)
            
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
                elseif ~isempty(find(get(wsgors(i),'yunit')=='V',1))
                    guiobj.ephys_data(ie,:) = get(wsgors(i),'extracty');
                    dtyp(i) = 1;
                    ie = ie+1;
                end
                datanames{i} = get(wsgors(i),'name');
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
                    taxis = get(wsgors(find(dtyp==1,1)),'x')*...
                        (10^-3/guiobj.timedim);
                    guiobj.ephys_fs = 1/taxis(2);
                    guiobj.ephys_taxis = linspace(taxis(1),...
                        length(guiobj.ephys_data)/guiobj.ephys_fs+taxis(1),...
                        length(guiobj.ephys_data));
                elseif guiobj.datatyp(2)
                    guiobj.DatasetListBox.String = datanames(dtyp==2);
                    guiobj.ImagingListBox.String = datanames(dtyp==2);
                    guiobj.imag_datanames = datanames(dtyp==2);
                    taxis = get(wsgors(find(dtyp==2,1)),'x')*...
                        (10^-3/guiobj.timedim);
                    guiobj.imaging_fs = 1/taxis(2);
                    guiobj.imaging_taxis = linspace(taxis(1),...
                        length(guiobj.imaging_data)/guiobj.imaging_fs+taxis(1),...
                        length(guiobj.imaging_data));
                end
            elseif guiobj.datatyp(1) && guiobj.datatyp(2)
%                 guiobj.EphysListBox.String = datanames(dtyp==1);
%                 guiobj.ephys_datanames = datanames(dtyp==1);
%                 guiobj.ImagingListBox.String = datanames(dtyp==2);
%                 guiobj.imag_datanames = datanames(dtyp==2);
                
                if ~isempty(find(dtyp==1, 1))
                    guiobj.EphysListBox.String = datanames(dtyp==1);
                    guiobj.ephys_datanames = datanames(dtyp==1);
                    
                    taxis = get(wsgors(find(dtyp==1,1)),'x')*...
                        (10^-3/guiobj.timedim);
                    guiobj.ephys_fs = 1/taxis(2);
                    guiobj.ephys_taxis = linspace(taxis(1),...
                        length(guiobj.ephys_data)/guiobj.ephys_fs+taxis(1),...
                        length(guiobj.ephys_data));
                end
                
                if ~isempty(find(dtyp==2,1))
                    guiobj.ImagingListBox.String = datanames(dtyp==2);
                    guiobj.imag_datanames = datanames(dtyp==2);
                
                    taxis = get(wsgors(find(dtyp==2,1)),'x')*...
                        (10^-3/guiobj.timedim);
                    guiobj.imaging_fs = 1/taxis(2);
                    guiobj.imaging_taxis = linspace(taxis(1),...
                        length(guiobj.imaging_data)/guiobj.imaging_fs+taxis(1),...
                        length(guiobj.imaging_data));
                end
            end
        end

        %% Value changed function: DatasetListBox
        function DatasetListBoxValueChanged(guiobj, event)
            index = guiobj.DatasetListBox.Value;
%             [~, index] = ismember(value, guiobj.DatasetListBox.String);
            % Check which data mode we are in and plot accordingly
            if guiobj.datatyp(3)
                if guiobj.datatyp(1)
%                     ephysplot(guiobj,guiobj.axes21,index,value)
                    guiobj.ephys_select = index;
                elseif guiobj.datatyp(2)
%                     imagingplot(guiobj,guiobj.axes21,index,value)
                    guiobj.imag_select = index;
                end
            elseif ~guiobj.datatyp(3)
                if guiobj.datatyp(1)
%                     ephysplot(guiobj,guiobj.axes11,index,value)
                    guiobj.ephys_select = index;
                elseif guiobj.datatyp(2)
%                     imagingplot(guiobj,guiobj.axes11,index,value)
                    guiobj.imag_select = index;
                end
            end
            smartplot(guiobj)

            lickplot(guiobj)
            
            ephysDetMarkerPlot(guiobj)
            
            imagingDetMarkerPlot(guiobj)
        end

        %% Menu selected function: timedimChangeMenu
        function timedimChangeMenuSelected(guiobj, event)
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
        function showProcDataMenuSelected(guiobj,event)
            if strcmp(guiobj.showProcDataMenu.Checked,'off')
                if guiobj.datatyp(1) && guiobj.datatyp(2)
                    ephys_names = [guiobj.ephys_datanames';...
                        guiobj.ephysProcListBox2.String];
                    guiobj.EphysListBox.String = ephys_names;

                    imag_names = [guiobj.imag_datanames';...
                        guiobj.imagingProcListBox2.String];
                    guiobj.ImagingListBox.String = imag_names;
                elseif guiobj.datatyp(1)
                    names = [guiobj.ephys_datanames';...
                        guiobj.ephysProcListBox2.String];
                    guiobj.DatasetListBox.String = names;
                elseif guiobj.datatyp(2)
                    names = [guiobj.imag_datanames';...
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

                    imag_names = guiobj.imag_datanames(1:size(guiobj.imaging_data,1))';
                    guiobj.ImagingListBox.String = imag_names;
                    guiobj.ImagingListBox.Value = 1;
                    guiobj.imag_select = 1;
                elseif guiobj.datatyp(1)
                    names = guiobj.ephys_datanames(1:size(guiobj.ephys_data,1))';
                    guiobj.DatasetListBox.String = names;
                    guiobj.DatasetListBox.Value = 1;
                    guiobj.ephys_select = 1;
                elseif guiobj.datatyp(2)
                    names = guiobj.imag_datanames(1:size(guiobj.imaging_data,1))';
                    guiobj.DatasetListBox.String = names;
                    guiobj.DatasetListBox.Value = 1;
                    guiobj.imag_select = 1;
                end
                
                guiobj.showProcDataMenu.Checked = 'off';
                smartplot(guiobj)
            end
            
        end
        
        %%
        function showEphysDetMarkers(guiobj,event)
            if isempty(guiobj.ephys_detections)
                return
            end
            
            if strcmp(guiobj.showEphysDetMarkersMenu.Checked,'off')
                detList = [];
                detInfo = guiobj.ephys_detectionsInfo;
%                 for i = 1:size(guiobj.ephys_detectionsInfo,1)
                for i = 1:length(detInfo)
%                     detList{i} = strcat(guiobj.ephys_dettypes(...
%                         guiobj.ephys_detectionsInfo(i,2)),'| Channel #',...
%                         num2str(guiobj.ephys_detectionsInfo(i,1)),'| Det#',...
%                         num2str(guiobj.ephys_detectionsInfo(i,3)));
%                     temprows = [];
                    temp = [];
                    pnames = fieldnames(detInfo(i).Params);
                    vals = struct2cell(detInfo(i).Params);
                    for k = 1:length(fieldnames(detInfo(i).Params))
                        temp = [temp, pnames{k},':',num2str(vals{k}),' '];
                    end
%                     temprows = [temprows; strcat(detInfo(i).DetType,' | ',temp,...
%                         ' | Channel#',num2str(detInfo(i).Channel),' | ',...
%                         'Det#',num2str(i))];
%                     detList = [detList; temprows];
                    detList = [detList; strcat(detInfo(i).DetType,' | ',temp,...
                        ' | Channel#',num2str(detInfo(i).Channel),' | ',...
                        'Run#',num2str(detInfo(i).DetRun))];
                end
                [indx,tf] = listdlg('ListString',detList,'ListSize',[500,200]);
                if ~tf
                    return
                end
                guiobj.ephys_detMarkerSelection = indx;
                guiobj.showEphysDetMarkersMenu.Checked = 'on';
            elseif strcmp(guiobj.showEphysDetMarkersMenu.Checked,'on')
                guiobj.showEphysDetMarkersMenu.Checked = 'off';
                guiobj.ephys_detMarkerSelection = [];
            end
            
            ephysDetMarkerPlot(guiobj,1)
        end
        
        %%
        function showEphysDetLegend(guiobj,~,~) 
            if strcmp(guiobj.showEphysDetLegendMenu.Checked,'on')
                guiobj.showEphysDetLegendMenu.Checked = 'off';
            elseif strcmp(guiobj.showEphysDetLegendMenu.Checked,'off')
                guiobj.showEphysDetLegendMenu.Checked = 'on';
            end
            ephysDetMarkerPlot(guiobj)
        end
        
        %%
        function showImagingDetMarkers(guiobj,event)
            if isempty(guiobj.imaging_detections)
                return
            end
            
            if strcmp(guiobj.showImagingDetMarkersMenu.Checked,'off')
%                 detList = {};
%                 for i = 1:size(guiobj.Imaging_detectionsInfo,1)
%                     detList{i} = guiobj.imaging_dettypes(...
%                         guiobj.imaging_detectionsInfo(i,2));
%                 end
%                 [indx,tf] = listdlg('ListString',detList);
%                 if ~tf
%                     return
%                 end
%                 guiobj.imaging_detMarkerSelection = indx;
                guiobj.showImagingDetMarkersMenu.Checked = 'on';
            elseif strcmp(guiobj.showImagingDetMarkersMenu.Checked,'on')
                guiobj.showImagingDetMarkersMenu.Checked = 'off';
%                 guiobj.imaging_detMarkerSelection = [];
            end
            
            imagingDetMarkerPlot(guiobj,1)
        end
        
        %%
        function showSimultDetMarkers(guiobj,event)
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
        function showXtraDetFigsMenuSel(guiobj,~,~)
            if strcmp(guiobj.showXtraDetFigsMenu.Checked,'on')
                guiobj.showXtraDetFigsMenu.Checked = 'off';
                guiobj.showXtraDetFigs = 0;
                
            else
                guiobj.showXtraDetFigsMenu.Checked = 'on';
                guiobj.showXtraDetFigs = 1;
            end
        end
        
        %% Button pushed function: ImportruncsvButton
        function ImportruncsvButtonPushed(guiobj, event)
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
                    guiobj.run_pos = rundata(1:end-1,2);
                    guiobj.run_veloc = diff(rundata(:,2))./diff(rundata(:,1));
                    guiobj.run_taxis = rundata(1:end-1,1)*(10^-3)/guiobj.timedim;
                    guiobj.run_fs = mean(gradient(rundata(:,1)));
                case 'Gramophone'
                    guiobj.run_veloc = rundata(:,2);
                    guiobj.run_taxis = rundata(:,1)*(10^-3)/guiobj.timedim;
                    guiobj.run_pos = zeros(length(rundata),1);
                case 'Cancel'
                    return
            end
            
            runposplot(guiobj)
            runvelocplot(guiobj)
            lickplot(guiobj)
        end

        %% Value changed function: ephysCheckBox
        function ephysCheckBoxValueChanged(guiobj, event)
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
                guiobj.ImagingListBox.String = guiobj.imag_datanames;
                guiobj.Dataselection2Panel.Visible = 'on';
            elseif value && ~guiobj.imagingCheckBox.Value
                guiobj.Dataselection2Panel.Visible = 'off';
                guiobj.DatasetListBox.String = guiobj.ephys_datanames;
                guiobj.Dataselection1Panel.Visible = 'on';                
            elseif ~value && guiobj.imagingCheckBox.Value
                guiobj.Dataselection1Panel.Visible = 'on';
                guiobj.DatasetListBox.String = guiobj.imag_datanames;
                guiobj.Dataselection2Panel.Visible = 'off';
            elseif ~value && ~guiobj.imagingCheckBox.Value
                guiobj.Dataselection1Panel.Visible = 'on';
                guiobj.Dataselection2Panel.Visible = 'off';
            end
        end

        %% Value changed function: imagingCheckBox
        function imagingCheckBoxValueChanged(guiobj, event)
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
                guiobj.ImagingListBox.String = guiobj.imag_datanames;
                guiobj.Dataselection1Panel.Visible = 'off';
            elseif value && ~guiobj.ephysCheckBox.Value
                guiobj.Dataselection1Panel.Visible = 'on';
                guiobj.DatasetListBox.String = guiobj.imag_datanames;
                guiobj.Dataselection2Panel.Visible = 'off';
            elseif ~value && guiobj.ephysCheckBox.Value
                guiobj.Dataselection1Panel.Visible = 'on';
                guiobj.DatasetListBox.String = guiobj.ephys_datanames;
                guiobj.Dataselection2Panel.Visible = 'off';
            elseif ~value && ~guiobj.ephysCheckBox.Value
                guiobj.Dataselection1Panel.Visible = 'on';
                guiobj.Dataselection2Panel.Visible = 'off';
            end
        end

        %% Value changed function: runCheckBox
        function runCheckBoxValueChanged(guiobj, event)
            % Determining whether running data modules are needed
            value = guiobj.runCheckBox.Value;
            
            % Import buttons
            if value 
                guiobj.ImportruncsvButton.Enable = 'on';
                guiobj.runParamsPanel.Visible = 'on';
            elseif ~value
                guiobj.ImportruncsvButton.Enable = 'off';
                guiobj.runParamsPanel.Visible = 'off';
            end
            
            % Plot panel switching
            guiobj.datatyp = [guiobj.ephysCheckBox.Value,...
                guiobj.imagingCheckBox.Value, guiobj.runCheckBox.Value];
            plotpanelswitch(guiobj)
        end

        %% Value changed function: EphysListBox
        function EphysListBoxValueChanged(guiobj, event)
            index = guiobj.EphysListBox.Value;
            names = guiobj.EphysListBox.String;
%             [~, index] = ismember(value, guiobj.EphysListBox.Items);
            guiobj.ephys_select = index;
            if sum(guiobj.datatyp) == 2
                ephysplot(guiobj,guiobj.axes21,index,names(index))
            elseif sum(guiobj.datatyp) == 3
                ephysplot(guiobj,guiobj.axes31,index,names(index))
            end
            
            lickplot(guiobj)
            
            ephysDetMarkerPlot(guiobj)
            
            simultDetMarkerPlot(guiobj)
        end

        %% Value changed function: ImagingListBox
        function ImagingListBoxValueChanged(guiobj, event)
            index = guiobj.ImagingListBox.Value;
            names = guiobj.ImagingListBox.String;
%             [~, index] = ismember(value, guiobj.ImagingListBox.Items);
            guiobj.imag_select = index;
            if sum(guiobj.datatyp) == 2
                imagingplot(guiobj,guiobj.axes22,index,names(index))
            elseif sum(guiobj.datatyp) == 3
                imagingplot(guiobj,guiobj.axes32,index,names(index))
            end
            
            lickplot(guiobj)
            
            imagingDetMarkerPlot(guiobj)
            
            simultDetMarkerPlot(guiobj)
        end

        %% Value changed function: InputLickEditField
        function InputLickEditFieldValueChanged(guiobj, event)
            value = guiobj.InputLickEditField.String;
            temp = guiobj.LickTimesListBox.String;
            if isempty(temp)
                temp = {value};
            else
                temp = cat(1,temp,{value});
            end
            guiobj.LickTimesListBox.String = temp;
            lickplot(guiobj)
            guiobj.InputLickEditField.String = '';
        end

        %% Value changed function: LickTimesListBox
        function LickTimesListBoxValueChanged(guiobj, event)
            if ~isscalar(guiobj.LickTimesListBox.Value)
                guiobj.LickTimesListBox.Value = 1;
                return
            end
            idx = guiobj.LickTimesListBox.Value;
            value = guiobj.LickTimesListBox.String{idx};
            numvalue = str2double(value);
            del = questdlg('Delete selected lick time?');
            if strcmp(del,'Yes')
                temp = findobj(guiobj.mainfig,'Type','line');
                for i = 1:length(temp)
                    if (length(temp(i).XData)==2) &...
                            (temp(i).XData == [numvalue numvalue])
                        delete(temp(i))
                    end
                end
                guiobj.LickTimesListBox.String(idx) = [];
            end
            
            lickplot(guiobj)
            
            % Set listbox to have no selection (otherwise might be unable
            % to delete 1 remaining lick)
            guiobj.LickTimesListBox.Value = 1;
        end

         %% Menu selected function: MakewindowlargerMenu
%         function MakewindowlargerMenuSelected(guiobj, event)
%             pos = guiobj.mainfig.Position;
%             monitor = get(0,'screensize');
%             currsize = find(guiobj.winsizes == pos(3));
%             if (currsize+1 <= length(guiobj.winsizes))
%                 if guiobj.winsizes(currsize+1) <= monitor(3)
%                     pos(1:2) = [0,0];
%                     pos(3:4) = guiobj.winsizes(currsize+1,:); 
%                     guiobj.mainfig.Position = pos;
%                     plotpanelswitch(guiobj)
%                 end
%             end
%         end
% 
        %% Menu selected function: MakewindowsmallerMenu
%         function MakewindowsmallerMenuSelected(guiobj, event)
%             pos = guiobj.mainfig.Position;
%             currsize = find(guiobj.winsizes == pos(3));
%             if (currsize-1 > 0)
%                 pos(1:2) = [0,0];
%                 pos(3:4) = guiobj.winsizes(currsize-1,:); 
%                 guiobj.mainfig.Position = pos;
%                 plotpanelswitch(guiobj)
%             end
%         end
        
        %%    
        function tabSelected(guiobj,h,e)
            if e.NewValue == guiobj.tabs.Children(2)...
                    & isempty(guiobj.ephys_data)
                guiobj.tabs.SelectedTab = e.OldValue;
                errordlg('No electrophysiology data loaded!')
            end
            if e.NewValue == guiobj.tabs.Children(3)...
                    & isempty(guiobj.imaging_data)
                guiobj.tabs.SelectedTab = e.OldValue;
                errordlg('No imaging data loaded!')
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
                        guiobj.imagingProcListBox.String = guiobj.imag_datanames;
                        if guiobj.imag_select...
                                <= size(guiobj.imaging_data,1)
                            guiobj.imagingProcListBox.Value = guiobj.imag_select;
                        else
                            guiobj.imag_select = 1;
                            guiobj.imagingProcListBox.Value = 1;
                        end
                        
                    case guiobj.tabs.Children(4)
                        if ~isempty(guiobj.ephys_data)
                            temp = 1:size(guiobj.ephys_data,1);
                            temp = {num2str(temp');'all'};
                            guiobj.ephysDetChSelPopMenu.String = temp;
                        end
                end
                smartplot(guiobj)
%             end
        end
        
        %%
        function ephysProcPopMenuSelected(guiobj,event)
            procType = guiobj.ephysProcPopMenu.Value;
            
            switch procType
                case 2
                    guiobj.ephysFiltParamPanel.Visible = 'on';
                    guiobj.ephysArtSuppPanel.Visible = 'off';
                case 3
                    guiobj.ephysArtSuppPanel.Visible = 'on';
                    guiobj.ephysFiltParamPanel.Visible = 'off';
            end
        end
        
        %%
        function ephysProcListBoxValueChanged(guiobj,event)
            idx = guiobj.ephysProcListBox.Value;
            if isempty(idx)
                return
            end
            figtitle = guiobj.ephysProcListBox.String(idx);
            ephysplot(guiobj,guiobj.axesEphysProc1,idx,figtitle)
        end
        
        %%
        function ephysProcListBox2ValueChanged(guiobj,event)
            idx = guiobj.ephysProcListBox2.Value;
            if isempty(idx)
                return
            end
            ephysplot(guiobj,guiobj.axesEphysProc2,idx)
%             figtitle = guiobj.ephysProcListBox2.String(idx);
%             proctypes = guiobj.ephys_proccedInfo(idx,2);
%             ephysprocplot(guiobj,guiobj.axesEphysProc2,idx,figtitle,proctypes)
        end
        
%         function pushEphysProcData(guiobj,event)
%             
%         end
        
        %%
        function fiterTypePopMenuCallback(guiobj,event)
            selIdx = guiobj.filterTypePopMenu.Value;
            
            switch selIdx
                case 1  %Standby
                    guiobj.w1Edit.Visible = 'off';
                    guiobj.w2Edit.Visible = 'off';
                    guiobj.cutoffLabel.Visible = 'off';
                    guiobj.fmaxLabel.Visible = 'off';
                    guiobj.fmaxEdit.Visible = 'off';
                    guiobj.ffundEdit.Visible = 'off';
                    guiobj.ffundLabel.Visible = 'off';
                    guiobj.stopbandwidthEdit.Visible = 'off';
                    guiobj.stopbandwidthLabel.Visible = 'off';
                
                case 2  % DoG
                    guiobj.w1Edit.Visible = 'on';
                    guiobj.w2Edit.Visible = 'on';
                    guiobj.cutoffLabel.Visible = 'on';
                    guiobj.fmaxLabel.Visible = 'off';
                    guiobj.fmaxEdit.Visible = 'off';
                    guiobj.ffundEdit.Visible = 'off';
                    guiobj.ffundLabel.Visible = 'off';
                    guiobj.stopbandwidthEdit.Visible = 'off';
                    guiobj.stopbandwidthLabel.Visible = 'off';
                case 3  % PeriodicNoise
                    guiobj.w1Edit.Visible = 'off';
                    guiobj.w2Edit.Visible = 'off';
                    guiobj.cutoffLabel.Visible = 'off';
                    guiobj.fmaxLabel.Visible = 'on';
                    guiobj.fmaxEdit.Visible = 'on';
                    guiobj.ffundEdit.Visible = 'on';
                    guiobj.ffundLabel.Visible = 'on';
                    guiobj.stopbandwidthEdit.Visible = 'on';
                    guiobj.stopbandwidthLabel.Visible = 'on';
            end
        end
        
        %%
        function runFilt(guiobj,event)
            guiobj.runFiltButton.BackgroundColor = 'r';
            
            selectedButt = guiobj.ephysProcSrcButtGroup.SelectedObject;
            selectedButt = selectedButt.String;
            
            filtype = guiobj.filterTypePopMenu.Value;
            filtype = guiobj.filterTypePopMenu.String{filtype};

            switch selectedButt
                case 'Raw data'
                    data_idx = guiobj.ephysProcListBox.Value;
                    data = guiobj.ephys_data(data_idx,:);
                case 'Processed data'
                    data_idx = guiobj.ephysProcListBox2.Value;
                    data = guiobj.ephys_procced(data_idx,:);
            end
            w1 = str2double(guiobj.w1Edit.String);
            w2 = str2double(guiobj.w2Edit.String);
            
            datanames = guiobj.ephys_datanames;
            procDatanames = guiobj.ephys_procdatanames;
            switch filtype
                case 'DoG'
                    if isnan(w1) || isnan(w2)
                        errordlg('DoG needs both upper and lower cutoff!')
                        guiobj.runFiltButton.BackgroundColor = 'g';
                        return
                    end
                    procced = DoG(data,guiobj.ephys_fs,w1,w2);
                    guiobj.ephys_proccedInfo = [guiobj.ephys_proccedInfo;...
                        [data_idx', 1*ones(size(data_idx'))]];
                    
                    for i = 1:length(data_idx)
                        if isempty(procDatanames)
                            procDatanames = {['DoG(',num2str(w1),'-',num2str(w2),')| ',...
                                datanames{data_idx(i)}]};
                        elseif ~isempty(procDatanames)
                            switch selectedButt
                                case 'Raw data'
                                    procDatanames = [procDatanames,...
                                        ['DoG(',num2str(w1),'-',num2str(w2),')| ',...
                                        datanames{data_idx(i)}]];
                                case 'Processed data'
                                    procDatanames = [procDatanames,...
                                        ['DoG(',num2str(w1),'-',num2str(w2),')| ',...
                                        procDatanames{data_idx(i)}]];
                            end
                            
                        end
                    end
                    
                case 'Periodic'
                    fmax = str2double(guiobj.fmaxEdit.String);
                    ffund = str2double(guiobj.ffundEdit.String);
                    stopbandwidth = str2double(guiobj.stopbandwidthEdit.String)/2;
                    procced = periodicNoise(data,guiobj.ephys_fs,fmax,ffund,stopbandwidth);
                    guiobj.ephys_proccedInfo = [guiobj.ephys_proccedInfo;...
                        [data_idx', 2*ones(size(data_idx'))]];
                    
                    for i = 1:length(data_idx)
                        if isempty(procDatanames)
                            procDatanames = {['Periodic| ',...
                                datanames{data_idx(i)}]};
                        elseif ~isempty(procDatanames)
                            switch selectedButt
                                case 'Raw data'    
                                    procDatanames = [procDatanames,...
                                            ['Periodic| ',datanames{data_idx(i)}]];
                                case 'Processed data'
                                    procDatanames = [procDatanames,...
                                            ['Periodic| ',procDatanames{data_idx(i)}]];
                            end
                        end
                    end
            end
            
            guiobj.ephys_procced = [guiobj.ephys_procced; procced];
            guiobj.ephys_procdatanames = procDatanames;
            guiobj.ephysProcListBox2.String = procDatanames;
            
            guiobj.runFiltButton.BackgroundColor = 'g';
        end
        
        %%
        function runArtSupp(guiobj,event)
            guiobj.ephysArtSuppRunButt.BackgroundColor = 'r';
            
            artSuppType = guiobj.ephysArtSuppTypePopMenu.Value;
            artSuppName = guiobj.ephysArtSuppTypePopMenu.String{artSuppType};
            
            datanames = guiobj.ephys_datanames;
            procDatanames = guiobj.ephys_procdatanames;
            
            selectedButt = guiobj.ephysProcSrcButtGroup.SelectedObject;
            selectedButt = selectedButt.String;
            
            refChan = str2double(guiobj.ephysArtSuppRefChanEdit.String);
            
            switch selectedButt
                case 'Raw data'
                    data_idx = guiobj.ephysProcListBox.Value;
                    data = guiobj.ephys_data(data_idx,:);
                case 'Processed data'
                    data_idx = guiobj.ephysProcListBox2.Value;
                    data = guiobj.ephys_procced(data_idx,:);
            end
            
            fs = guiobj.ephys_fs;
            data_cl = ArtSupp(data,fs,artSuppType,refChan);
            
            
            for i = 1:length(data_idx)
                if isempty(procDatanames)
                    procDatanames = {[artSuppName,'| ',...
                        datanames{data_idx(i)}]};
                elseif ~isempty(procDatanames)
                    switch selectedButt
                        case 'Raw data'
                            procDatanames = [procDatanames,...
                                [artSuppName,'| ',datanames{data_idx(i)}]];
                        case 'Processed data'
                            procDatanames = [procDatanames,...
                                [artSuppName,'| ',procDatanames{data_idx(i)}]];
                    end
                end
            end
            
            guiobj.ephys_procced = [guiobj.ephys_procced; data_cl];
            guiobj.ephys_procdatanames = procDatanames;
            guiobj.ephysProcListBox2.String = procDatanames;
            
            guiobj.ephysArtSuppRunButt.BackgroundColor = 'g';
        end
        
        %% Callback to monitor radiobutton press
        function ephysProcProcdRadioButtPushed(guiobj,event)
            if isempty(guiobj.ephys_procced)
                errordlg('No processed data!')
                guiobj.ephysProcSrcButtGroup.SelectedObject = ...
                    guiobj.ephysProcRawRadioButt;
                return
            end
        end
        
        %%
        function imagingProcListBoxValueChanged(guiobj,event)
            idx = guiobj.imagingProcListBox.Value;
            if idx == 0 | isnan(idx) | isempty(idx)
               return
            end
            imagingplot(guiobj,guiobj.axesImagingProc1,idx)
        end
        
        %%
        function imagingProcListBox2ValueChanged(guiobj,event)
            idx = guiobj.imagingProcListBox2.Value;
            if idx == 0 | isnan(idx) | isempty(idx)
               return
            end
            imagingplot(guiobj,guiobj.axesImagingProc2,idx) 
        end
        
        %%
        function imagingProcPopMenuSelected(guiobj,event)
            procType = guiobj.imagingProcPopMenu.Value;
            
            switch procType
                case 2
                    guiobj.imagingFiltParamPanel.Visible = 'on';
                otherwise
                    guiobj.imagingFiltParamPanel.Visible = 'off';
            end
        end
        
        %%
        function imagingFilterTypePopMenuSelected(guiobj,event)
            sel = guiobj.imagingFilterTypePopMenu.Value;
            
            switch sel
                case 2
                    guiobj.imagingFiltWinSizeEdit.Visible = 'on';
                    guiobj.imagingFiltWinSizeText.Visible = 'on';
                otherwise
                    guiobj.imagingFiltWinSizeEdit.Visible = 'off';
                    guiobj.imagingFiltWinSizeText.Visible = 'off';
            end
                    
        end
        
        %%
        function imagingRunProc(guiobj,event)
            selectedButt = guiobj.imagingProcSrcButtGroup.SelectedObject;
            selectedButt = selectedButt.String;
            
            switch selectedButt
                case 'Raw data'
                    data_idx = guiobj.imagingProcListBox.Value;
                    data = guiobj.imaging_data(data_idx,:);
                case 'Processed data'
                    data_idx = guiobj.imagingProcListBox2.Value;
                    data = guiobj.imaging_procced(data_idx,:);
            end
            
            proctype = guiobj.imagingProcPopMenu.Value;
            proctype = guiobj.imagingProcPopMenu.String{proctype};
            
            winsize = str2double(guiobj.imagingFiltWinSizeEdit.String);
            
            datanames = guiobj.imag_datanames;
            procDatanames = guiobj.imag_proc_datanames;
            switch proctype
                case 'Filtering'
                    filtype = guiobj.imagingFilterTypePopMenu.Value;
                    filtype = guiobj.imagingFilterTypePopMenu.String{filtype};
                    switch filtype
                        case 'Gauss average'
                            if isnan(winsize)
                                errordlg('Specify window size!')
                                return
                            end
                            procc = smoothdata(data,2,'gaussian',winsize);
                            guiobj.imaging_proccedInfo = [guiobj.ephys_proccedInfo;...
                                [data_idx', 1*ones(size(data_idx'))]];
                            
                            for i = 1:length(data_idx)
                                if isempty(procDatanames)
                                    procDatanames = {['GaussAvg(win:',num2str(winsize),')| ',...
                                        datanames{data_idx(i)}]};
                                elseif ~isempty(procDatanames)
                                    switch selectedButt
                                        case 'Raw data'
                                            procDatanames = [procDatanames,...
                                                ['GaussAvg(win:',num2str(winsize),')| ',...
                                                datanames{data_idx(i)}]];
                                        case 'Processed data'
                                            procDatanames = [procDatanames,...
                                                ['GaussAvg(win:',num2str(winsize),')| ',...
                                                procDatanames{data_idx(i)}]];
                                    end
                                end
                            end
                    end
            end
            
            guiobj.imaging_procced = [guiobj.imaging_procced; procc];
            guiobj.imag_proc_datanames = [guiobj.imag_proc_datanames,...
                procDatanames];
            guiobj.imagingProcListBox2.String = procDatanames;
        end
        
        %% Callback to monitor radiobutton press
        function imagingProcProcdRadioButtPushed(guiobj,event)
            if isempty(guiobj.imaging_procced)
                errordlg('No processed data!')
                guiobj.imagingProcSrcButtGroup.SelectedObject = ...
                    guiobj.imagingProcRawRadioButt;
                return
            end
        end
        
        %%
        function ephysDetPopMenuSelected(guiobj,event)
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
        function ephysDetRun(guiobj,event)
            guiobj.ephysDetStatusLabel.String = 'Detection running';
            guiobj.ephysDetStatusLabel.BackgroundColor = 'r';
            drawnow
            
            dettype = guiobj.ephysDetPopMenu.Value;
            dettype = guiobj.ephysDetPopMenu.String{dettype};
            if strcmp(dettype,'--Ephys detection methods--')
                errordlg('Select detection method first!')
                guiobj.ephysDetStatusLabel.String = '--IDLE--';
                guiobj.ephysDetStatusLabel.BackgroundColor = 'g';
                return
            end
                        
%             guiobj.ephys_detRunsNum = guiobj.ephys_detRunsNum +1;
            
            numofdetchans = size(guiobj.ephys_detections,1);
            
            chan = guiobj.ephysDetChSelPopMenu.Value;
            if chan < min(size(guiobj.ephys_data))
                data = guiobj.ephys_data(chan,:);
            else
                data = guiobj.ephys_data;
            end
            fs = guiobj.ephys_fs;
            tAxis = guiobj.ephys_taxis;
            showFigs = guiobj.showXtraDetFigs;
            
            switch dettype
                case 'CWT based'
                    minLen = str2double(guiobj.ephysCwtDetMinlenEdit.String);
                    sdmult = str2double(guiobj.ephysCwtDetSdMultEdit.String);
                    w1 = str2double(guiobj.ephysCwtDetW1Edit.String);
                    w2 = str2double(guiobj.ephysCwtDetW2Edit.String);
                    refVal = guiobj.ephysCwtDetRefValCheck.Value;
                    
                    % Handling no input cases
                    if (isempty(minLen)||isnan(minLen)) || (isempty(sdmult)||isnan(sdmult))...
                            || (isempty(w1)||isnan(w1)) || (isempty(w2)||isnan(w2))
                        errordlg('Missing parameters!')
                        guiobj.ephysDetStatusLabel.String = '--IDLE--';
                        guiobj.ephysDetStatusLabel.BackgroundColor = 'g';
                        return
                    end
                    
                    refch = str2double(guiobj.ephysCwtDetRefChanEdit.String);
                    
                    % Handling no input case when artsupp is enabled
                    if (guiobj.ephysCwtDetArtSuppPopMenu.Value~=1) && (isempty(refch)||isnan(refch))
                        errordlg('No reference channel specified!')
                        guiobj.ephysDetStatusLabel.String = '--IDLE--';
                        guiobj.ephysDetStatusLabel.BackgroundColor = 'g';
                        return
                    end
                    
                    if refVal && (isempty(refch)||isnan(refch))
                        errordlg('No reference channel specified!')
                        guiobj.ephysDetStatusLabel.String = '--IDLE--';
                        guiobj.ephysDetStatusLabel.BackgroundColor = 'g';
                        return
                    end
                    
                    switch guiobj.ephysCwtDetArtSuppPopMenu.Value 
                        case 2 % wICA
                            data_cl = ArtSupp(guiobj.ephys_data,fs,1,refch);
                            if chan < min(size(guiobj.ephys_data))
                                data = data_cl(chan,:);
                            else
                                data = data_cl;
                            end
%                             data = data_cl(chan,:);
                        case 3 % ref chan subtract
                            data_cl = ArtSupp(guiobj.ephys_data,fs,2,refch);
                            if chan < min(size(guiobj.ephys_data))
                                data = data_cl(chan,:);
                            else
                                data = data_cl;
                            end
%                             data = data_cl(chan,:);
                    end
                    
                    if ~refVal
                        [dets,detBorders,detParams] = wavyDet(data,tAxis,fs,minLen/1000,sdmult,w1,w2,0,showFigs);
                    elseif refVal & (chan > min(size(guiobj.ephys_data)))
                        [dets,detBorders,detParams] = wavyDet(data,tAxis,fs,minLen/1000,sdmult,w1,w2,refch,showFigs);
                    elseif refVal & (chan < min(size(guiobj.ephys_data)))
                        [dets,detBorders,detParams] = wavyDet(data,tAxis,fs,minLen/1000,sdmult,w1,w2,guiobj.ephys_data(refch,:),showFigs);
                    end
                    guiobj.ephys_detRunsNum = guiobj.ephys_detRunsNum +1;                    
                    
                    if chan < min(size(guiobj.ephys_data))
%                         detinfo = [chan, 1, guiobj.ephys_detRunsNum];
                        detinfo.Channel = chan;
                        detinfo.DetType = "CWT";
                        detinfo.DetRun = guiobj.ephys_detRunsNum;
                        detinfo.Params.W1 = w1;
                        detinfo.Params.W2 = w2;
                        detinfo.Params.MinLen = minLen*1000;
                        detinfo.Params.SdMult = sdmult;
                        detinfo.Params.RefVal = refVal;
                        detinfo.Params.RefCh = refch;
                    else
%                         detinfo = [(1:min(size(guiobj.ephys_data)))',...
%                             1*ones(min(size(guiobj.ephys_data)),1),...
%                             guiobj.ephys_detRunsNum*ones(min(size(guiobj.ephys_data)),1)];
                        for i = 1:min(size(dets))
                            detinfo(i).Channel = i;
                            detinfo(i).DetType = "CWT";
                            detinfo(i).DetRun = guiobj.ephys_detRunsNum;
                            detinfo(i).Params.W1 = w1;
                            detinfo(i).Params.W2 = w2;
                            detinfo(i).Params.MinLen = minLen*1000;
                            detinfo(i).Params.SdMult = sdmult;
                            detinfo(i).Params.RefVal = refVal;
                            detinfo(i).Params.RefCh = refch;
                        end
                    end
                    
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
                    
                    dets = adaptive_thresh(data,tAxis,fs,step,minLen,mindist,ratio,showFigs);
                    detBorders = cell(min(size(data)),1);
                    detParams = cell(min(size(data)),1);
                    guiobj.ephys_detRunsNum = guiobj.ephys_detRunsNum +1;
                    
%                     detinfo = [chan, 2];
%                     detinfo.DetType = "Adapt";
%                     detinfo.Params.Step = step*1000;
%                     detinfo.Params.MinLen = minlen*1000;
%                     detinfo.Params.MinDist = mindist*1000;
%                     detinfo.Params.Ratio = ratio;
                    
                    if chan < min(size(guiobj.ephys_data))
                        detinfo.Channel = chan;
                        detinfo.DetType = "Adapt";
                        detinfo.DetRun = guiobj.ephys_detRunsNum;
                        detinfo.Params.Step = step*1000;
                        detinfo.Params.MinLen = minLen*1000;
                        detinfo.Params.MinDist = mindist*1000;
                        detinfo.Params.Ratio = ratio;
                        
%                         detinfo = [chan, 2, guiobj.ephys_detRunsNum];
                    else
                        for i = 1:min(size(dets))
                            detinfo(i).Channel = i;
                            detinfo(i).DetType = "Adapt";
                            detinfo(i).DetRun = guiobj.ephys_detRunsNum;
                            detinfo(i).Params.Step = step*1000;
                            detinfo(i).Params.MinLen = minLen*1000;
                            detinfo(i).Params.MinDist = mindist*1000;
                            detinfo(i).Params.Ratio = ratio;
                        end
%                         detinfo = [(1:min(size(guiobj.ephys_data)))',...
%                             2*ones(min(size(guiobj.ephys_data)),1),...
%                             guiobj.ephys_detRunsNum*ones(min(size(guiobj.ephys_data)),1)];
                    end
                    
                case 'DoG+InstPow'
                    w1 = str2double(guiobj.ephysDoGInstPowDetW1Edit.String);
                    w2 = str2double(guiobj.ephysDoGInstPowDetW2Edit.String);
                    sdmult = str2double(guiobj.ephysDoGInstPowDetSdMultEdit.String);
                    minLen = str2double(guiobj.ephysDoGInstPowDetMinLenEdit.String)/1000;
                    refVal = guiobj.ephysDogInstPowDetRefValChBox.Value;
                    
                    % Handling no input cases
                    if (isempty(w1)||isnan(w1)) || (isempty(w2)||isnan(w2))...
                            || (isempty(sdmult)||isnan(sdmult)) || (isempty(minLen)||isnan(minLen))
                        errordlg('Missing parameters!')
                        guiobj.ephysDetStatusLabel.String = '--IDLE--';
                        guiobj.ephysDetStatusLabel.BackgroundColor = 'g';
                        return
                    end
                    
                    refch = str2double(guiobj.ephysDoGInstPowDetRefChanEdit.String);
                    
                    % Handling no input case when artsupp is enabled
                    if (guiobj.ephysDoGInstPowDetArtSuppPopMenu.Value~=1) && (isempty(refch)||isnan(refch))
                        errordlg('No reference channel specified!')
                        guiobj.ephysDetStatusLabel.String = '--IDLE--';
                        guiobj.ephysDetStatusLabel.BackgroundColor = 'g';
                        return
                    end
                    
                    if refVal && (isempty(refch)||isnan(refch))
                        errordlg('No reference channel specified!')
                        guiobj.ephysDetStatusLabel.String = '--IDLE--';
                        guiobj.ephysDetStatusLabel.BackgroundColor = 'g';
                        return
                    end
                    
                    switch guiobj.ephysDoGInstPowDetArtSuppPopMenu.Value 
                        case 2 % wICA
                            data_cl = ArtSupp(guiobj.ephys_data,fs,1,refch);
                            if chan < min(size(guiobj.ephys_data))
                                data = data_cl(chan,:);
                            else
                                data = data_cl;
                            end
%                             data = data_cl(chan,:);
                        case 3 % ref chan subtract
                            data_cl = ArtSupp(guiobj.ephys_data,fs,2,refch);
                            if chan < min(size(guiobj.ephys_data))
                                data = data_cl(chan,:);
                            else
                                data = data_cl;
                            end
%                             data = data_cl(chan,:);
                    end
                    
                    if ~refVal
                        [dets,detBorders,detParams] = DoGInstPowDet(data,tAxis,fs,w1,w2,sdmult,minLen,0,showFigs);
                    elseif refVal && (size(data,1)>1)
                        [dets,detBorders,detParams] = DoGInstPowDet(data,tAxis,fs,w1,w2,sdmult,minLen,refch,showFigs);
                    elseif refVal && (size(data,1)==1)
                        [dets,detBorders,detParams] = DoGInstPowDet(data,tAxis,fs,w1,w2,sdmult,minLen,guiobj.ephys_data(refch,:),showFigs);
                    end
                    guiobj.ephys_detRunsNum = guiobj.ephys_detRunsNum +1;
                    
%                     detinfo = [chan, 3];
                    
                    if chan < min(size(guiobj.ephys_data))
                        detinfo.Channel = chan;
                        detinfo.DetType = "DoGInstPow";
                        detinfo.DetRun = guiobj.ephys_detRunsNum;
                        detinfo.Params.W1 = w1;
                        detinfo.Params.W2 = w2;
                        detinfo.Params.MinLen = minLen*1000;
                        detinfo.Params.SdMult = sdmult;
                        detinfo.Params.RefVal = refVal;
                        detinfo.Params.RefCh = refch;
%                         detinfo = [chan, 3, guiobj.ephys_detRunsNum];
                    else
                        for i = 1:min(size(dets))
                            detinfo(i).Channel = i;
                            detinfo(i).DetType = "DoGInstPow";
                            detinfo(i).DetRun = guiobj.ephys_detRunsNum;
                            detinfo(i).Params.W1 = w1;
                            detinfo(i).Params.W2 = w2;
                            detinfo(i).Params.MinLen = minLen*1000;
                            detinfo(i).Params.SdMult = sdmult;
                            detinfo(i).Params.RefVal = refVal;
                            detinfo(i).Params.RefCh = refch;
                        end
%                         detinfo = [(1:min(size(guiobj.ephys_data)))',...
%                             3*ones(min(size(guiobj.ephys_data)),1),...
%                             guiobj.ephys_detRunsNum*ones(min(size(guiobj.ephys_data)),1)];
                    end
            end
            
            if isempty(dets) | isnan(dets) | (isempty(find(~isnan(dets), 1)))
                errordlg('No events were found!')
                guiobj.ephysDetStatusLabel.String = '--IDLE--';
                guiobj.ephysDetStatusLabel.BackgroundColor = 'g';
                guiobj.ephys_detRunsNum = guiobj.ephys_detRunsNum - 1;
                return                
            end
            
%             for i = 1:min(size(dets))
%                 DetParamsMiner(dets(i,:),detBorders,fs,data(i,:),)
%             end
            
            guiobj.ephys_detections = [guiobj.ephys_detections; dets];
            
            if ~isempty(guiobj.ephys_detBorders)
                guiobj.ephys_detBorders = [guiobj.ephys_detBorders; detBorders];
            else
                guiobj.ephys_detBorders = detBorders;
            end
            
            if ~isempty(guiobj.ephys_detParams)
                guiobj.ephys_detParams = [guiobj.ephys_detParams; detParams];
            else
                guiobj.ephys_detParams = detParams;
            end
            
%             guiobj.ephys_detectionsInfo = [guiobj.ephys_detectionsInfo;...
%                 detinfo];
            if isempty(guiobj.ephys_detectionsInfo(1).DetType)
                guiobj.ephys_detectionsInfo = detinfo;
            else
                guiobj.ephys_detectionsInfo = [guiobj.ephys_detectionsInfo, detinfo];
            end
            
%             guiobj.eventDet1CurrIdx = size(guiobj.ephys_detections,1);
            guiobj.eventDet1CurrIdx = numofdetchans + 1;
            
            guiobj.evDetTabSimultMode = 0;
            
            guiobj.ephysDetStatusLabel.String = '--IDLE--';
            guiobj.ephysDetStatusLabel.BackgroundColor = 'g';
            
            guiobj.ephys_currDetRun = guiobj.ephys_detRunsNum;
            
%             assignin('base','ephysDets',guiobj.ephys_detections)
%             assignin('base','ephysDetInfo',guiobj.ephys_detectionsInfo)
%             assignin('base','ephysDetParams',guiobj.ephys_detParams)
            
            eventDetAxesButtFcn(guiobj,1,0,0);
        end
        
        %%
        function imagingDetPopMenuSelected(guiobj,event)
            dettype = guiobj.imagingDetPopMenu.Value;
            dettype = guiobj.imagingDetPopMenu.String{dettype};
            
            switch dettype
                case 'Mean+SD'
                    guiobj.imagingMeanSdDetPanel.Visible = 'on';
                otherwise
                    guiobj.imagingMeanSdDetPanel.Visible = 'off';
                
            end
        end
        
        %%
        function simultDetPopMenuSelected(guiobj,event)
            dettype = guiobj.simultDetPopMenu.Value;
            dettype = guiobj.simultDetPopMenu.String{dettype};
            
            switch dettype
                case 'Standard'
                    guiobj.simultDetStandardPanel.Visible = 'on';
                
            end
        end
        
        %%
        function imagingDetRun(guiobj,event)
            guiobj.imagingDetStatusLabel.String = 'Detection running';
            guiobj.imagingDetStatusLabel.BackgroundColor = 'r';
            drawnow
            
            dettype = guiobj.imagingDetPopMenu.Value;
            dettype = guiobj.imagingDetPopMenu.String{dettype};
            
            data = guiobj.imaging_data;
            fs = guiobj.imaging_fs;
            sdmult = str2double(guiobj.imagingMeanSdDetSdmultEdit.String);
            
            dets = nan(size(data));
            detBorders = cell(min(size(data)),1);
            detParams = cell(min(size(data)),1);
            switch dettype
                case 'Mean+SD'
                    
                    guiobj.imaging_detRunsNum = guiobj.imaging_detRunsNum + 1;
                    for i = 1:size(data,1)
                        smoothd = smoothdata(data(i,:),'gaussian',10);
                        thr = mean(smoothd) + sdmult*std(smoothd);
%                         aboveThrInds = smoothd(smoothd > thr);
%                         aboveThrInd_diff = diff(aboveThrInds);
%                         [~,locs,~,~] = findpeaks(smoothd,'MinPeakHeight',thr);
                        [validDets,validDetBorders] = commDetAlg(data(i,:),smoothd,...
                            [],0,[],[],fs,thr,0,0.025);
                        dets(i,:) = validDets;
                        detBorders{i} = validDetBorders;
                        detParams{i} = detParamMiner(2,dets(i,:),detBorders{i},fs,...
                            data(i,:),smoothd,[]);
                        
                        detinfo(i).Roi = i;
                        detinfo(i).DetType = 'Mean+SD';
                        detinfo(i).DetRun = guiobj.imaging_detRunsNum;
                        detinfo(i).Params.WinType = 'Gaussian';
                        detinfo(i).Params.WinLen = 10;
                        detinfo(i).Params.SdMult = sdmult;
                    end
                    
            end
            
            if isempty(dets)
                warndlg('No detections!')
                guiobj.imaging_detRunsNum = guiobj.imaging_detRunsNum - 1;
                guiobj.imagingDetStatusLabel.String = '--IDLE--';
                guiobj.imagingDetStatusLabel.BackgroundColor = 'g';
                return
            end
            
            guiobj.imaging_detections = [guiobj.imaging_detections; dets];
            if isempty(guiobj.imaging_detectionsInfo(1).DetType)
                guiobj.imaging_detectionsInfo = detinfo;
            else
                guiobj.imaging_detectionsInfo = [guiobj.imaging_detectionsInfo,...
                    detinfo];
            end
            
            if isempty(guiobj.imaging_detBorders)
                guiobj.imaging_detBorders = detBorders;
            else
                guiobj.imaging_detBorders = [guiobj.imaging_detBorders; detBorders];
            end
            
            if isempty(guiobj.imaging_detParams)
                guiobj.imaging_detParams = detParams;
            else
                guiobj.imaging_detParams = [guiobj.imaging_detParams; detParams];
            end
            
            guiobj.imaging_currDetRun = guiobj.imaging_detRunsNum;
            
            guiobj.evDetTabSimultMode = 0;
            
%             assignin('base','imDets',guiobj.imaging_detections)
%             assignin('base','imDetInfo',guiobj.imaging_detectionsInfo)
%             assignin('base','imDetParams',guiobj.imaging_detParams)
                        
%             guiobj.eventDet2CurrIdx = size(guiobj.imaging_detections,1);
            guiobj.imagingDetStatusLabel.String = '--IDLE--';
            guiobj.imagingDetStatusLabel.BackgroundColor = 'g';
            
            eventDetAxesButtFcn(guiobj,2,0,0)
        end
        
        %%
        function simultDetRun(guiobj,event)
            if (isempty(guiobj.ephys_detections)) | (isempty(guiobj.imaging_detections)) 
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
            
            detList = [];
            detInfo = guiobj.ephys_detectionsInfo;
            for i = 1:length(detInfo)
                temp = [];
                pnames = fieldnames(detInfo(i).Params);
                vals = struct2cell(detInfo(i).Params);
                for k = 1:length(fieldnames(detInfo(i).Params))
                    temp = [temp, pnames{k},':',num2str(vals{k}),' '];
                end
                detList = [detList; string(strcat(detInfo(i).DetType,' | ',temp,...
                    ' | Channel#',num2str(detInfo(i).Channel),' | ',...
                    'Run#',num2str(detInfo(i).DetRun)))];
            end
            currDetRows = find([detInfo.DetRun]==guiobj.ephys_currDetRun);
            [indx,tf] = listdlg('ListString',detList,...
                'PromptString','Select electrophysiology detection!',...
                'ListSize',[500,300],...
                'InitialValue',currDetRows);
            if ~tf
                guiobj.simultDetStatusLabel.String = '--IDLE--';
                guiobj.simultDetStatusLabel.BackgroundColor = 'g';
                return
            elseif length(unique([detInfo(indx).DetRun])) > 1
                errordlg('Please only select from one run!')
                guiobj.simultDetStatusLabel.String = '--IDLE--';
                guiobj.simultDetStatusLabel.BackgroundColor = 'g';
                return
            end
                        
            ephysSelChans = indx;
            ephysDetRun = guiobj.ephys_detectionsInfo(indx).DetRun;
%             ephys_detInds = find(~isnan(guiobj.ephys_detections(indx,:)));
            ephys_tAx = guiobj.ephys_taxis;
            
            detList = [];
            detInfo = guiobj.imaging_detectionsInfo;
            for i = 1:length(detInfo)
                temp = [];
                pnames = fieldnames(detInfo(i).Params);
                vals = struct2cell(detInfo(i).Params);
                for k = 1:length(fieldnames(detInfo(i).Params))
                    temp = [temp, pnames{k},':',num2str(vals{k}),' '];
                end
                detList = [detList; string(strcat(detInfo(i).DetType,' | ',temp,...
                    ' | ROI#',num2str(detInfo(i).Roi),' | ',...
                    'Run#',num2str(detInfo(i).DetRun)))];
            end
            currDetRows = find([detInfo.DetRun]==guiobj.imaging_currDetRun);
            [indx,tf] = listdlg('ListString',detList,...
                'PromptString','Select imaging detection!',...
                'ListSize',[500,300],...
                'InitialValue',currDetRows);
            if ~tf
                guiobj.simultDetStatusLabel.String = '--IDLE--';
                guiobj.simultDetStatusLabel.BackgroundColor = 'g';
                return
            elseif length(unique([detInfo(indx).DetRun])) > 1
                errordlg('Please only select from one run!')
                guiobj.simultDetStatusLabel.String = '--IDLE--';
                guiobj.simultDetStatusLabel.BackgroundColor = 'g';
                return
            end
                        
            imaging_selROIs = indx;
            imagingDetRun = guiobj.imaging_detectionsInfo(indx(1)).DetRun;
            imaging_tAx = guiobj.imaging_taxis;
            
%             simult_dets = cell(length(imaging_selROIs),1);
            simult_dets = struct('DetInds',cell(length(ephysSelChans),1),...
                'Channel',cell(length(ephysSelChans),1),...
                'DetRun',cell(length(ephysSelChans),1));
            
%             detInfo = struct('DetType',cell(length(imaging_selROIs),1),...
%                         'EphysChannel',cell(length(imaging_selROIs),1),...
%                         'EphysDetRun',cell(length(imaging_selROIs),1),...
%                         'ROI',cell(length(imaging_selROIs),1),...
%                         'ImagingDetRun',cell(length(imaging_selROIs),1),...
%                         'Params',cell(length(imaging_selROIs),1),...
%                         'DetRun',cell(length(imaging_selROIs),1));
            detInfo = struct('DetType',[],...
                        'EphysChannels',[],...
                        'EphysDetRun',[],...
                        'ROI',[],...
                        'ImagingDetRun',[],...
                        'Settings',[],...
                        'DetRun',[]);
                    
            currDetRun = guiobj.simult_detRunsNum + 1;
            
            switch dettype
                case 'Standard'
                    delay = str2double(guiobj.simultDetStandardDelayEdit.String)/1000;
                    
                    for ephysRowNum = 1:length(ephysSelChans)
                        ephysDetRow = ephysSelChans(ephysRowNum);
                        chan = guiobj.ephys_detectionsInfo(ephysDetRow).Channel;
                        ephys_detInds = find(~isnan(guiobj.ephys_detections(ephysDetRow,:)));
                        temp = cell(length(imaging_selROIs),1);
                        
                        for imRowNum = 1:length(imaging_selROIs)
                            imDetRow = imaging_selROIs(imRowNum);
                            imaging_detInds = find(~isnan(guiobj.imaging_detections(imDetRow,:)));
                            roi = guiobj.imaging_detectionsInfo(imDetRow).Roi;
                            
                            temp2 = zeros(length(ephys_detInds),length(imaging_detInds));
                            
                            for i = 1:length(ephys_detInds)
                                for j = 1:length(imaging_detInds)
                                    tDiff = imaging_tAx(imaging_detInds(j))...
                                        - ephys_tAx(ephys_detInds(i));
                                    if (tDiff < delay) && (tDiff >= 0)
    %                                     temp = [temp; [j,i]];
                                        temp2(i,j) = 1;
                                    end
                                end
                                
                            end
                            if isempty(find(temp2,1))
                                temp2 = [];
                            end
                            temp{imRowNum} = temp2;
                        end

                        simult_dets(ephysRowNum).DetInds = temp;
                        simult_dets(ephysRowNum).DetRun = currDetRun;
                        simult_dets(ephysRowNum).Channel = chan;
%                         simult_dets{rowNum} = temp;
                        
                        detInfo.DetType = dettype;
                        detInfo.EphysChannels = ephysSelChans;
                        detInfo.EphysDetRun = ephysDetRun;
                        detInfo.ROI = imaging_selROIs;
                        detInfo.ImagingDetRun = imagingDetRun;
                        detInfo.Settings.Delay = delay;
                        detInfo.DetRun = currDetRun;
                    end
            end
            
            if isempty(find(~cellfun('isempty',[simult_dets.DetInds]),1))
                warndlg('No simultaneous events found!')
                guiobj.simultDetStatusLabel.String = '--IDLE--';
                guiobj.simultDetStatusLabel.BackgroundColor = 'g';
                return
            end
            
            
            if isempty(guiobj.simult_detections)
                guiobj.simult_detections = simult_dets;
            else
                guiobj.simult_detections = [guiobj.simult_detections; simult_dets];
            end
            
            if isempty(guiobj.simult_detectionsInfo)
                guiobj.simult_detectionsInfo = detInfo;
            else
                guiobj.simult_detectionsInfo = [guiobj.simult_detectionsInfo;...
                    detInfo];
            end
            
            guiobj.simult_detRunsNum = currDetRun;
            
            assignin('base','simDets',guiobj.simult_detections)
            assignin('base','simDetInfo',guiobj.simult_detectionsInfo)
            
%             eventDetAxesButtFcn(guiobj,3,0,0)
            guiobj.evDetTabSimultMode = 1;

            eventDetAxesButtFcn(guiobj,1,0,0)
            eventDetAxesButtFcn(guiobj,2,0,0)
                        
            guiobj.simultDetStatusLabel.String = '--IDLE--';
            guiobj.simultDetStatusLabel.BackgroundColor = 'g';
        end
        
        %%
        function axesEventDet1UpButtPush(guiobj,event)
            eventDetAxesButtFcn(guiobj,1,1,1)
        end
        
        %%
        function axesEventDet1DownButtPush(guiobj,event)
            eventDetAxesButtFcn(guiobj,1,1,2)
        end
        
        %%
        function axesEventDet1ChanUpButtPush(guiobj,event)
            eventDetAxesButtFcn(guiobj,1,2,1)
        end
        
        %%
        function axesEventDet1ChanDownButtPush(guiobj,event)
            eventDetAxesButtFcn(guiobj,1,2,2)
        end
        
        %%
        function axesEventDet2DetUpButtPush(guiobj,event)
            eventDetAxesButtFcn(guiobj,2,1,1)
        end
        
        %%
        function axesEventDet2DetDownButtPush(guiobj,event)
            eventDetAxesButtFcn(guiobj,2,1,2)
        end
        
        %%
        function axesEventDet2RoiUpButtPush(guiobj,event)
            eventDetAxesButtFcn(guiobj,2,2,1)
        end
        
        %%
        function axesEventDet2RoiDownButtPush(guiobj,event)
            eventDetAxesButtFcn(guiobj,2,2,2)
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
                        'InitialValue',guiobj.eventDet1DataType);
                    if ~tf
                        return
                    end
                    guiobj.eventDet1DataType = idx;
                    switch idx
                        case 2
                            guiobj.ephys_dogged = DoG(guiobj.ephys_data,guiobj.ephys_fs,...
                                guiobj.eventDet1W1,guiobj.eventDet1W2);
                        case 3
                            guiobj.ephys_instPowed = instPow(guiobj.ephys_data,guiobj.ephys_fs,...
                                guiobj.eventDet1W1,guiobj.eventDet1W2);
                    end
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
                                2,'gaussian',10);
                    end
                    eventDetAxesButtFcn(guiobj,2)
            end
        end
        
        %%
        function changeEventDetTabCutoff(guiobj,event)
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
            
            if ~isempty(find(guiobj.eventDet1DataType==2,1))
                    guiobj.ephys_dogged = DoG(guiobj.ephys_data,guiobj.ephys_fs,...
                        guiobj.eventDet1W1,guiobj.eventDet1W2);
            elseif ~isempty(find(guiobj.eventDet1DataType==3,1))
                    guiobj.ephys_instPowed = instPow(guiobj.ephys_data,guiobj.ephys_fs,...
                        guiobj.eventDet1W1,guiobj.eventDet1W2);
            end
            
            eventDetAxesButtFcn(guiobj,1)
        end
        
        %%
        function changeEventDetTabWinSize(guiobj,~,~)
            prompt = {'Window size of graphs [ms]'};
            title = 'Window size';
            dims = [1,15];
            definput = {num2str(guiobj.eventDet1Win)};
            answer = inputdlg(prompt,title,dims,definput);
            if isempty(answer)
                return
            end
            guiobj.eventDet1Win = str2double(answer{1});
            if guiobj.datatyp(1)
                eventDetAxesButtFcn(guiobj,1)
            end
            if guiobj.datatyp(2)
                eventDetAxesButtFcn(guiobj,2)
            end
        end
        
        %%
        function mainFigOpenFcn(guiobj,~,~)
            % Check if logfile exists
            DASlocation = mfilename('fullpath');
            DASlocation = DASlocation(1:end-3);
            fID = fopen([DASlocation,'DAS_LOG.mat']);
            % If it does, load it, if it doesnt create it
            if fID >= 3
                try
                    load([DASlocation,'DAS_LOG.mat'])
                    disp('Log file found and loaded.')

                    temp = DAS_LOG.lastState.eventDetTab.ephys.DoGInstPow;
                    guiobj.ephysDoGInstPowDetW1Edit.String = temp.w1;
                    guiobj.ephysDoGInstPowDetW2Edit.String = temp.w2;
                    guiobj.ephysDoGInstPowDetSdMultEdit.String = temp.sdmult;
                    guiobj.ephysDoGInstPowDetMinLenEdit.String = temp.minLen;
                    guiobj.ephysDoGInstPowDetRefChanEdit.String = temp.refch;
                    guiobj.ephysDogInstPowDetRefValChBox.Value = temp.refVal;
                    clear temp

                    temp = DAS_LOG.lastState.eventDetTab.ephys.CWT; 
                    guiobj.ephysCwtDetMinlenEdit.String = temp.minlen;
                    guiobj.ephysCwtDetSdMultEdit.String = temp.sdmult;
                    guiobj.ephysCwtDetW1Edit.String = temp.w1;
                    guiobj.ephysCwtDetW2Edit.String = temp.w2;
                    guiobj.ephysCwtDetRefChanEdit.String = temp.refch;
                    guiobj.ephysCwtDetRefValCheck.Value = temp.refVal;
                    clear temp
                    
                    temp = DAS_LOG.presets.ephys;
%                     assignin('base','daslogpresetsephys',temp)
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
                catch ME
                    disp('Error in reading logfile! It will be genereted anew upon closing the GUI.')
%                     rethrow(ME)
                    
                end
                fclose(fID);
            else
                disp('No log file found! It will be created when closing the GUI.')
            end
        end
        
        %%
        function mainFigCloseFcn(guiobj,event)
            temp.w1 = guiobj.ephysDoGInstPowDetW1Edit.String;
            temp.w2 = guiobj.ephysDoGInstPowDetW2Edit.String;
            temp.sdmult = guiobj.ephysDoGInstPowDetSdMultEdit.String;
            temp.minLen = guiobj.ephysDoGInstPowDetMinLenEdit.String;
            temp.refch = guiobj.ephysDoGInstPowDetRefChanEdit.String;
            temp.refVal = guiobj.ephysDogInstPowDetRefValChBox.Value;
            
            DAS_LOG.lastState.eventDetTab.ephys.DoGInstPow = temp;
            clear temp
            
            temp.minlen = guiobj.ephysCwtDetMinlenEdit.String;
            temp.sdmult = guiobj.ephysCwtDetSdMultEdit.String;
            temp.w1 = guiobj.ephysCwtDetW1Edit.String;
            temp.w2 = guiobj.ephysCwtDetW2Edit.String;
            temp.refch = guiobj.ephysCwtDetRefChanEdit.String;
            temp.refVal = guiobj.ephysCwtDetRefValCheck.Value;
            
            DAS_LOG.lastState.eventDetTab.ephys.CWT = temp;
            clear temp
            
            DAS_LOG.presets.ephys = guiobj.ephys_presets;
            
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
                            new.refch = guiobj.ephysCwtDetRefChanEdit.String;
                            new.refVal = guiobj.ephysCwtDetRefValCheck.Value;
                            
                            if isempty(guiobj.ephys_presets) || ~isfield(guiobj.ephys_presets.evDetTab,'Cwt')
                                guiobj.ephys_presets.evDetTab.Cwt = [];
                            end
                            
                            guiobj.ephys_presets.evDetTab.Cwt = [...
                                guiobj.ephys_presets.evDetTab.Cwt,...
                                new];
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
                            new.refch = guiobj.ephysDoGInstPowDetRefChanEdit.String;
                            new.refVal = guiobj.ephysDogInstPowDetRefValChBox.Value;
                            
                            if isempty(guiobj.ephys_presets) || ~isfield(guiobj.ephys_presets.evDetTab,'DoGInstPow')
                                guiobj.ephys_presets.evDetTab.DoGInstPow = [];
                            end
                            
                            guiobj.ephys_presets.evDetTab.DoGInstPow = [...
                                guiobj.ephys_presets.evDetTab.DoGInstPow,...
                                new];
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
                            guiobj.ephysCwtDetRefChanEdit.String = temp.refch;
                            guiobj.ephysCwtDetRefValCheck.Value = temp.refVal;
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
                            guiobj.ephysDoGInstPowDetRefChanEdit.String = temp.refch;
                            guiobj.ephysDogInstPowDetRefValChBox.Value = temp.refVal;
                    end
                case 2 % imaging
                    
            end
        end
        
        %%
        function saveDets(guiobj,event)
            [idx,tf] = listdlg('PromptString','Which detection do you want to save?',...
                'Name','Saving detections',...
                'ListString',{'Ephys','Imaging','Simultaneous'},...
                'ListSize',[500, 200]);
            if ~tf
                return
            end
            
%             saveStruct = struct('ephys',[],'imaging',[],'simult',[]);
            
            if ~isempty(find(idx==1,1)) % ephys save
                if isempty(guiobj.ephys_detectionsInfo(1).DetType)
                    warndlg('No detections!')
                    return
                end

                detList = [];
                detInfo = guiobj.ephys_detectionsInfo;
                for i = 1:length(detInfo)
                    temp = [];
                    pnames = fieldnames(detInfo(i).Params);
                    vals = struct2cell(detInfo(i).Params);
                    for k = 1:length(fieldnames(detInfo(i).Params))
                        temp = [temp, pnames{k},':',num2str(vals{k}),' '];
                    end
                    detList = [detList; string(strcat(detInfo(i).DetType,' | ',temp,...
                        ' | Channel#',num2str(detInfo(i).Channel),' | ',...
                        'Run#',num2str(detInfo(i).DetRun)))];
                end
                currDetRows = find([detInfo.DetRun]==guiobj.ephys_currDetRun);
                [indx,tf] = listdlg('ListString',detList,...
                    'PromptString','Select electrophysiology detection(s) to save!',...
                    'ListSize',[500,200],'InitialValue',currDetRows);
                if ~tf
                    return
                end
                
                if ~isempty(find(ismember(indx,currDetRows)==false, 1))
                    warndlg('Please only select from same detection run!')
                    return
                end
                
                ephysSaveData.TAxis = guiobj.ephys_taxis;
                ephysSaveData.YLabel = guiobj.ephys_ylabel;
                ephysSaveData.Fs = guiobj.ephys_fs;
                ephysSaveData.RawData = guiobj.ephys_data;
                ephysSaveData.Dets = guiobj.ephys_detections(indx,:);
                ephysSaveData.DetBorders = guiobj.ephys_detBorders(indx);
                ephysSaveData.DetParams = guiobj.ephys_detParams(indx);
                ephysSaveInfo = guiobj.ephys_detectionsInfo(indx);
                 
            else
                ephysSaveData = [];
                ephysSaveInfo = [];
            end
            
            if ~isempty(find(idx==2,1)) % imaging save
                if isempty(guiobj.imaging_detectionsInfo(1).DetType)
                    warndlg('No detections!')
                    return
                end

                detList = [];
                detInfo = guiobj.imaging_detectionsInfo;
%                 assignin('base','imdetinfo',detInfo)
                for i = 1:length(detInfo)
                    temp = [];
                    pnames = fieldnames(detInfo(i).Params);
                    vals = struct2cell(detInfo(i).Params);
                    for k = 1:length(fieldnames(detInfo(i).Params))
                        temp = [temp, pnames{k},':',num2str(vals{k}),' '];
                    end
                    detList = [detList; string(strcat(detInfo(i).DetType,' | ',temp,...
                        ' | ROI#',num2str(detInfo(i).Roi),' | ',...
                        'Run#',num2str(detInfo(i).DetRun)))];
                end
                currDetRows = find([detInfo.DetRun]==guiobj.imaging_currDetRun);
                [indx,tf] = listdlg('ListString',detList,...
                    'PromptString','Select imaging detection(s) to save!',...
                    'ListSize',[500,200],'InitialValue',currDetRows);
                if ~tf
                    return
                end
                
                if ~isempty(find(ismember(indx,currDetRows)==false,1))
                    warndlg('Please only select from same detection run!')
                    return
                end

                imagingSaveData.TAxis = guiobj.imaging_taxis;
                imagingSaveData.YLabel = guiobj.imaging_ylabel;
                imagingSaveData.Fs = guiobj.imaging_fs;
                imagingSaveData.RawData = guiobj.imaging_data;
                imagingSaveData.Dets = guiobj.imaging_detections(indx,:);
                imagingSaveData.DetBorders = guiobj.imaging_detBorders(indx);
                imagingSaveData.DetParams = guiobj.imaging_detParams(indx);
                imagingSaveInfo = guiobj.imaging_detectionsInfo(indx);
            else
                imagingSaveData = [];
                imagingSaveInfo = [];
            end
            
            if ~isempty(find(idx==3,1)) % simult save
                if isempty(find(idx==1,1)) | isempty(find(idx==2,1))
                    errordlg('You can not save simultan detection without ephys&imaging detections!')
                    return
                end
                
                if isempty(guiobj.simult_detections)
                    errordlg('No simultan detections!')
                    return
                end
                
                detList = [];
                detInfo = guiobj.simult_detectionsInfo;

                for i = 1:length(detInfo)
                    temp = [];
                    pnames = fieldnames(detInfo(i).Settings);
                    vals = struct2cell(detInfo(i).Settings);
                    for k = 1:length(fieldnames(detInfo(i).Settings))
                        temp = [temp, pnames{k},':',num2str(vals{k}),' '];
                    end
                    detList = [detList; string(strcat(detInfo(i).DetType,' | ',temp,...
                        ' | Ephys Run#',num2str(detInfo(i).EphysDetRun),' | ',...
                        'Imaging Run#',num2str(detInfo(i).ImagingDetRun),' | ',...
                        'Run#',num2str(detInfo(i).DetRun)))];
                end
                currDetRows = find([detInfo.DetRun]==guiobj.simult_detRunsNum);
                [indx,tf] = listdlg('ListString',detList,...
                    'PromptString','Select simultan detection(s) to save!',...
                    'ListSize',[500,200],'InitialValue',currDetRows,...
                    'SelectionMode','single');
                if ~tf
                    return
                end
                
                selRows = [guiobj.simult_detections.DetRun]==detInfo(indx).DetRun;
                
                simultSaveData.Dets = guiobj.simult_detections(selRows);
                simultSaveInfo = guiobj.imaging_detectionsInfo(indx);
            else
                simultSaveData = [];
                simultSaveInfo = [];
            end
            
            comments = inputdlg('Enter comment on detection:','Comments',...
                [10,100]);
            
            if isempty(guiobj.rhdName)
                fname = ['DASsave_',char(datetime('now','Format','yyMMdd_HHmmss'))];
            else
                fname = [guiobj.rhdName,'_DASsave'];
            end
            
            [fname,path] = uiputfile('*.mat','Save DAS detections',fname);
            if fname==0
                return
            end
            oldpath = cd(path);
            
            save(fname,'ephysSaveData','ephysSaveInfo','comments',...
                'imagingSaveData','imagingSaveInfo',...
                'simultSaveData','simultSaveInfo')
            cd(oldpath)
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
            end
        end
        
        %%
        function showEventSpectro(guiobj,~,~)
            if isempty(guiobj.ephys_detections)
                return
            end

%             detMat = guiobj.ephys_detections;
% 
%             currDetRun = guiobj.ephys_currDetRun;
%             currDetRows = find([guiobj.ephys_detectionsInfo.DetRun]==currDetRun);
%             currChans = [guiobj.ephys_detectionsInfo(currDetRows).Channel];
%             emptyChans = [];
% 
%             % Filtering out channels with no detections
%             for j = 1:length(currDetRows)
%                 if isempty(find(~isnan(detMat(currDetRows(j),:)),1))
%                     emptyChans = [emptyChans, j];
%                 end
%             end
%             currChans(emptyChans) = [];
%             currDetRows(emptyChans) = [];
            
            eventDetPlotFcn(guiobj,1,1)
        end
        
        %%
        function testcallback(varargin)
            display(varargin)
            assignin('base','testinput',varargin)
            display(varargin{1}.tabs.SelectedTab.Title)
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
                'MenuSelectedFcn',@ guiobj.showEphysDetLegend);
            guiobj.showImagingDetMarkersMenu = uimenu(guiobj.showDetMarkersMenu,...
                'Text','Show imaging detection markers',...
                'MenuSelectedFcn',@(h,e) guiobj.showImagingDetMarkers);
            guiobj.showSimultMarkersMenu = uimenu(guiobj.showDetMarkersMenu,...
                'Text','Show simultaneous detection markers',...
                'MenuSelectedFcn',@(h,e) guiobj.showSimultDetMarkers);
            
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
                'MenuSelectedFcn',@ guiobj.changeEventDetTabWinSize);
            guiobj.imagingEventDetTabDataTypeMenu = uimenu(guiobj.EvDetTabOptionsMenu,...
                'Text','Imaging data type in EventDetTab',...
                'MenuSelectedFcn', @(h,e) guiobj.changeEventDetTabDataType(2));
            guiobj.showXtraDetFigsMenu = uimenu(guiobj.EvDetTabOptionsMenu,...
                'Text','Show extra detection figures',...
                'Checked','off',...
                'MenuSelectedFcn',@ guiobj.showXtraDetFigsMenuSel);
            guiobj.showEventSpectroMenu = uimenu(guiobj.EvDetTabOptionsMenu,...
                'Text','Show event spectrogram',...
                'MenuSelectedFcn',@ guiobj.showEventSpectro);

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
                'SelectionChangedFcn',@guiobj.tabSelected);
            
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

            % Create Dataselection1Panel
            guiobj.Dataselection1Panel = uipanel(guiobj.maintab,...
                'Title','Data selection',...
                'Position',[0, 0.2, 0.4, 0.4]);

%             % Create DatasetListBoxLabel
%             guiobj.DatasetListBoxLabel = uilabel(guiobj.Dataselection1Panel);
%             guiobj.DatasetListBoxLabel.HorizontalAlignment = 'right';
%             guiobj.DatasetListBoxLabel.Position = [1 226 47 22];
%             guiobj.DatasetListBoxLabel.Text = 'Dataset';

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

%             % Create EphysListBoxLabel
%             guiobj.EphysListBoxLabel = uilabel(guiobj.Dataselection2Panel);
%             guiobj.EphysListBoxLabel.HorizontalAlignment = 'right';
%             guiobj.EphysListBoxLabel.Position = [9 286 39 22];
%             guiobj.EphysListBoxLabel.Text = 'Ephys';
% 
            % Create EphysListBox
            guiobj.EphysListBox = uicontrol(guiobj.Dataselection2Panel,...
                'Style','listbox',...
                'Units','normalized',...
                'Position',[0, 0.55, 1, 0.4],...
                'String','Electrophysiology data',...
                'Min',0,...
                'Max',10,...
                'Callback',@(h,e) guiobj.EphysListBoxValueChanged);
% 
%             % Create ImagingListBoxLabel
%             guiobj.ImagingListBoxLabel = uilabel(guiobj.Dataselection2Panel);
%             guiobj.ImagingListBoxLabel.HorizontalAlignment = 'right';
%             guiobj.ImagingListBoxLabel.Position = [0 136 48 22];
%             guiobj.ImagingListBoxLabel.Text = 'Imaging';
% 
            % Create ImagingListBox
            guiobj.ImagingListBox = uicontrol(guiobj.Dataselection2Panel,...
                'Style','listbox',...
                'Units','normalized',...
                'Position',[0, 0.05, 1, 0.4],...
                'String','Imaging data',...
                'Min',0,...
                'Max',10,...
                'Callback',@(h,e) guiobj.ImagingListBoxValueChanged);

            % Create runParamsPanel
            guiobj.runParamsPanel = uipanel(guiobj.maintab,...
                'Visible','off',...
                'Position',[0, 0, 0.4, 0.2]);

            % Create InputlicktimemsEditFieldLabel
            guiobj.InputlicktimemsEditFieldLabel = uicontrol(guiobj.runParamsPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0, 0.7, 0.2, 0.25],...
                'String','Input lick time [ms]');

            % Create InputLickEditField
            guiobj.InputLickEditField = uicontrol(guiobj.runParamsPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.2, 0.7, 0.1, 0.25],...
                'Callback',@(h,e) guiobj.InputLickEditFieldValueChanged);

            % Create LicksmsListBoxLabel
            guiobj.LicksmsListBoxLabel = uicontrol(guiobj.runParamsPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0, 0.5, 0.2, 0.25],...
                'String','Licks [ms]');

            % Create LickTimesListBox
            guiobj.LickTimesListBox = uicontrol(guiobj.runParamsPanel,...
                'Style','listbox',...
                'Units','normalized',...
                'Position',[0.2, 0, 0.8, 0.65],...
                'Callback',@(h,e) guiobj.LickTimesListBoxValueChanged);
            
            guiobj.axes11 = axes(guiobj.Panel1Plot,...
                'Position',[0.1,0.2,0.85,0.6],...
                'NextPlot','replacechildren');
%             axis(guiobj.axes11,'tight')
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
            
            guiobj.axesAbsPos1 = axes(guiobj.Panel1Plot,...
                'Position',[0.1,0.1,0.85,0.1],...
                'Visible','off',...
                'YTick',[],...
                'NextPlot','replacechildren');
            guiobj.axesAbsPos1.Toolbar.Visible = 'on';
            guiobj.axesLapPos1 = axes(guiobj.Panel1Plot,...
                'Position',[0.1,0.3,0.85,0.1],...
                'Visible','off',...
                'YTick',[],...
                'NextPlot','replacechildren');
            guiobj.axesLapPos1.Toolbar.Visible = 'on';
            guiobj.axesveloc1 = axes(guiobj.Panel1Plot,...
                'Position',[0.1,0.6,0.85,0.3],...
                'Visible','off',...
                'NextPlot','replacechildren');
            guiobj.axesveloc1.Toolbar.Visible = 'on';
            
            guiobj.axesAbsPos2 = axes(guiobj.Panel2Plot,...
                'Position',[0.1,0.1,0.85,0.1],...
                'Visible','off',...
                'YTick',[],...
                'NextPlot','replacechildren');
            guiobj.axesAbsPos2.Toolbar.Visible = 'on';
            guiobj.axesLapPos2 = axes(guiobj.Panel2Plot,...
                'Position',[0.1,0.2,0.85,0.1],...
                'Visible','off',...
                'YTick',[],...
                'NextPlot','replacechildren');
            guiobj.axesLapPos2.Toolbar.Visible = 'on';
            guiobj.axesveloc2 = axes(guiobj.Panel2Plot,...
                'Position',[0.1,0.3,0.85,0.2],...
                'Visible','off',...
                'NextPlot','replacechildren');
            guiobj.axesveloc2.Toolbar.Visible = 'on';
            
            guiobj.axesAbsPos3 = axes(guiobj.Panel3Plot,...
                'Position',[0.1,0.05,0.85,0.05],...
                'YTick',[],...
                'NextPlot','replacechildren');
            guiobj.axesAbsPos3.Toolbar.Visible = 'on';
            guiobj.axesLapPos3 = axes(guiobj.Panel3Plot,...
                'Position',[0.1,0.1,0.85,0.05],...
                'YTick',[],...
                'NextPlot','replacechildren');
            guiobj.axesLapPos3.Toolbar.Visible = 'on';
            guiobj.axesveloc3 = axes(guiobj.Panel3Plot,...
                'Position',[0.1,0.2,0.85,0.1],...
                'NextPlot','replacechildren');
            guiobj.axesveloc3.Toolbar.Visible = 'on';
            
            linkaxes([guiobj.axes11,guiobj.axes21,guiobj.axes22,...
                guiobj.axes31,guiobj.axes32,guiobj.axesveloc1,...
                guiobj.axesveloc2,guiobj.axesveloc3],'x')
            
            %% Elements of ephys proc tab %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            % Create ephysProcListBox
            guiobj.ephysProcListBox = uicontrol(guiobj.ephysProcTab,...
                'Style','listbox',...
                'Units','normalized',...
                'Position',[0.01, 0.26, 0.3, 0.2],...
                'Min',1,...
                'Max',10,...
                'Callback',@(h,e) guiobj.ephysProcListBoxValueChanged);
            
            % Create ephysProcListBox2 for processed curves
            guiobj.ephysProcListBox2 = uicontrol(guiobj.ephysProcTab,...
                'Style','listbox',...
                'Units','normalized',...
                'Position',[0.01, 0.06, 0.3, 0.2],...
                'Min',1,...
                'Max',10,...
                'Callback',@(h,e) guiobj.ephysProcListBox2ValueChanged);
            
%             % Create button to push processed data to main tab
%             guiobj.pushEphysProcDataButton = uicontrol(guiobj.ephysProcTab,...
%                 'Style','pushbutton',...
%                 'Units','normalized',...
%                 'Position',[0.01, 0.01, 0.1, 0.1],...
%                 'String','--> Main tab',...
%                 'Callback',@(h,e) guiobj.pushEphysProcData);
            
            % Create ephysProcPopMenu
            guiobj.ephysProcPopMenu = uicontrol(guiobj.ephysProcTab,...
                'Style','popupmenu',...
                'Units','normalized',...
                'Position',[0.01, 0.8, 0.15, 0.15],...
                'String',{'--Choose processing type--','Filtering','Artifact Suppression'},...
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
            
            
            
            % Create ephysFiltParamPanel
            guiobj.ephysFiltParamPanel = uipanel(guiobj.ephysProcTab,...
                'Position',[0.01, 0.5, 0.3, 0.4],...
                'Title','Filtering settings',...
                'Visible','off');
            
            % Create components of FiltParamPanel
            guiobj.filterTypePopMenu = uicontrol(guiobj.ephysFiltParamPanel,...
                'Style','popupmenu',...
                'Units','normalized',...
                'Position',[0.01, 0.85, 0.25, 0.1],...
                'String',{'--Select filter type--','DoG','Periodic'},...
                'Callback',@(h,e) guiobj.fiterTypePopMenuCallback);
            guiobj.cutoffLabel = uicontrol(guiobj.ephysFiltParamPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.3, 0.85, 0.5, 0.1],...
                'String','Lower - Upper cutoff [Hz]',...
                'Visible','off');
            guiobj.w1Edit = uicontrol(guiobj.ephysFiltParamPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.8, 0.85, 0.1, 0.1],...
                'Visible','off');
            guiobj.w2Edit = uicontrol(guiobj.ephysFiltParamPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.9, 0.85, 0.1, 0.1],...
                'Visible','off');
            guiobj.fmaxLabel = uicontrol(guiobj.ephysFiltParamPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.3, 0.85, 0.5, 0.1],...
                'String','Max frequency [Hz]',...
                'Visible','off');
            guiobj.fmaxEdit = uicontrol(guiobj.ephysFiltParamPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.8, 0.85, 0.1, 0.1],...
                'Visible','off');
            guiobj.ffundLabel = uicontrol(guiobj.ephysFiltParamPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.3, 0.75, 0.5, 0.1],...
                'String','Fundamental frequency [Hz]',...
                'Visible','off');
            guiobj.ffundEdit = uicontrol(guiobj.ephysFiltParamPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.8, 0.75, 0.1, 0.1],...
                'Visible','off');
            guiobj.stopbandwidthLabel = uicontrol(guiobj.ephysFiltParamPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.3, 0.65, 0.5, 0.1],...
                'String','Stopband width [Hz]',...
                'Visible','off');
            guiobj.stopbandwidthEdit = uicontrol(guiobj.ephysFiltParamPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.8, 0.65, 0.1, 0.1],...
                'Visible','off');
            
            
%             guiobj.
            guiobj.runFiltButton = uicontrol(guiobj.ephysFiltParamPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.85, 0.01, 0.1, 0.1],...
                'String','Run filter',...
                'Callback',@(h,e) guiobj.runFilt,...
                'BackgroundColor','g');
            
            % Create ephysArtSuppPanel
            guiobj.ephysArtSuppPanel = uipanel(guiobj.ephysProcTab,...
                'Position',[0.01, 0.5, 0.3, 0.4],...
                'Title','Artifact Suppression',...
                'Visible','off');
            
            % Create components of ArtSuppPanel
            guiobj.ephysArtSuppTypePopMenu = uicontrol(guiobj.ephysArtSuppPanel,...
                'Style','popupmenu',...
                'Units','normalized',...
                'Position',[0.01, 0.85, 0.25, 0.1],...
                'String',{'wICA','classic ref subtract'});
            guiobj.ephysArtSuppRefChanLabel = uicontrol(guiobj.ephysArtSuppPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.4, 0.85, 0.3, 0.1],...
                'String','Reference channel');
            guiobj.ephysArtSuppRefChanEdit = uicontrol(guiobj.ephysArtSuppPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.75, 0.85, 0.1, 0.1]);
            guiobj.ephysArtSuppRunButt = uicontrol(guiobj.ephysArtSuppPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.6, 0.01, 0.3, 0.1],...
                'String','Run artifact suppression',...
                'Callback',@(h,e) guiobj.runArtSupp,...
                'BackgroundColor','g');
            
            
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
                'Callback',@(h,e) guiobj.imagingProcListBoxValueChanged);
            
            % Create imagingProcListBox2 for processed curves
            guiobj.imagingProcListBox2 = uicontrol(guiobj.imagingProcTab,...
                'Style','listbox',...
                'Units','normalized',...
                'Position',[0.01, 0.06, 0.3, 0.2],...
                'Min',1,...
                'Max',10,...
                'Callback',@(h,e) guiobj.imagingProcListBox2ValueChanged);
            
%             % Create button to push processed data to main tab
%             guiobj.pushEphysProcDataButton = uicontrol(guiobj.ephysProcTab,...
%                 'Style','pushbutton',...
%                 'Units','normalized',...
%                 'Position',[0.01, 0.01, 0.1, 0.1],...
%                 'String','--> Main tab',...
%                 'Callback',@(h,e) guiobj.pushEphysProcData);
            
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
            
            
            
            % Create imagingFiltParamPanel
            guiobj.imagingFiltParamPanel = uipanel(guiobj.imagingProcTab,...
                'Position',[0.01, 0.5, 0.3, 0.4],...
                'Title','Filtering settings',...
                'Visible','off');
            
            % Create components of FiltParamPanel
            guiobj.imagingFilterTypePopMenu = uicontrol(guiobj.imagingFiltParamPanel,...
                'Style','popupmenu',...
                'Units','normalized',...
                'Position',[0.01, 0.85, 0.25, 0.1],...
                'String',{'--Filter type--','Gauss average'},...
                'Callback',@(h,e) guiobj.imagingFilterTypePopMenuSelected);
            guiobj.imagingFiltWinSizeText = uicontrol(guiobj.imagingFiltParamPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.3, 0.85, 0.15, 0.1],...
                'String','Window size in samples',...
                'Visible','off');
            guiobj.imagingFiltWinSizeEdit = uicontrol(guiobj.imagingFiltParamPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.45, 0.85, 0.1, 0.1],...
                'Visible','off');
            guiobj.imagingRunFiltButton = uicontrol(guiobj.imagingFiltParamPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.85, 0.01, 0.1, 0.1],...
                'String','Run filter',...
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

            guiobj.ephysDetPopMenu = uicontrol(guiobj.eventDetTab,...
                'Style','popupmenu',...
                'Units','normalized',...
                'Position',[0.01, 0.89, 0.1, 0.1],...
                'String',{'--Ephys detection methods--','CWT based',...
                'Adaptive threshold','DoG+InstPow'},...
                'Callback',@(h,e) guiobj.ephysDetPopMenuSelected);
            
            guiobj.ephysDetChSelLabel = uicontrol(guiobj.eventDetTab,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.01, 0.82, 0.1, 0.1],...
                'String','Channel selection');
            guiobj.ephysDetChSelPopMenu = uicontrol(guiobj.eventDetTab,...
                'Style','popupmenu',...
                'Units','normalized',...
                'Position',[0.01, 0.78, 0.1, 0.1],...
                'String',{'--Select channel--'});
            
            guiobj.ephysCwtDetPanel = uipanel(guiobj.eventDetTab,...
                'Position',[0.12, 0.65, 0.2, 0.3],...
                'Title','Settings for CWT based detection',...
                'Visible','off');
            guiobj.ephysCwtDetMinlenLabel = uicontrol(guiobj.ephysCwtDetPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.01, 0.85, 0.35, 0.1],...
                'String','Min event length [ms]');
            guiobj.ephysCwtDetMinlenEdit = uicontrol(guiobj.ephysCwtDetPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.37, 0.85, 0.1, 0.1],...
                'String','10');
            guiobj.ephysCwtDetSdMultLabel = uicontrol(guiobj.ephysCwtDetPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.01, 0.75, 0.3, 0.1],...
                'String','SD multiplier');
            guiobj.ephysCwtDetSdMultEdit = uicontrol(guiobj.ephysCwtDetPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.37, 0.75, 0.1, 0.1],...
                'String','3');
            guiobj.ephysCwtDetCutoffLabel = uicontrol(guiobj.ephysCwtDetPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.01 0.65, 0.35, 0.1],...
                'String','Frequency band [Hz]');
            guiobj.ephysCwtDetW1Edit = uicontrol(guiobj.ephysCwtDetPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.37, 0.65, 0.1, 0.1]);
            guiobj.ephysCwtDetW2Edit = uicontrol(guiobj.ephysCwtDetPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.48, 0.65, 0.1, 0.1]);
            guiobj.ephysCwtDetRefChanLabel = uicontrol(guiobj.ephysCwtDetPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.01, 0.55, 0.35, 0.1],...
                'String','RefChannel');
            guiobj.ephysCwtDetRefChanEdit = uicontrol(guiobj.ephysCwtDetPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.37, 0.55, 0.1, 0.1]);
            guiobj.ephysCwtDetRefValCheck = uicontrol(guiobj.ephysCwtDetPanel,...
                'Style','checkbox',...
                'Units','normalized',...
                'Position',[0.5, 0.55, 0.4, 0.1],...
                'String','RefChan validate');
            guiobj.ephysCwtDetArtSuppPopMenu = uicontrol(guiobj.ephysCwtDetPanel,...
                'Style','popupmenu',...
                'Units','normalized',...
                'Position',[0.01, 0.35, 0.5, 0.1],...
                'String',{'--Select artifact suppression--','wICA','RefSubtract'});
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
                'Position',[0.55, 0.7, 0.1, 0.1]);
            guiobj.ephysDoGInstPowDetMinLenLabel = uicontrol(guiobj.ephysDoGInstPowDetPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.01, 0.55, 0.5, 0.1],...
                'String','Min event length [ms]');
            guiobj.ephysDoGInstPowDetMinLenEdit = uicontrol(guiobj.ephysDoGInstPowDetPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.55, 0.55, 0.1, 0.1]);
            guiobj.ephysDoGInstPowDetRefChanLabel = uicontrol(guiobj.ephysDoGInstPowDetPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.01, 0.4, 0.3, 0.1],...
                'String','Referece channel');
            guiobj.ephysDoGInstPowDetRefChanEdit = uicontrol(guiobj.ephysDoGInstPowDetPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.35, 0.4, 0.1, 0.1]);
            guiobj.ephysDogInstPowDetRefValChBox = uicontrol(guiobj.ephysDoGInstPowDetPanel,...
                'Style','checkbox',...
                'Units','normalized',...
                'Position',[0.5, 0.4, 0.4, 0.1],...
                'String','RefChan validate');
%             guiobj.ephysDoGInstPowDetArtSuppPopMenuLabel = uicontrol(guiobj.ephysDoGInstPowDetPanel,...
%                 'Style','text',...
%                 'Units','normalized',...
%                 'Position',[0.01, 0.25, 0.5, 0.1],...
%                 'String','Select artifact suppression method');
            guiobj.ephysDoGInstPowDetArtSuppPopMenu = uicontrol(guiobj.ephysDoGInstPowDetPanel,...
                'Style','popupmenu',...
                'Units','normalized',...
                'Position',[0.01, 0.25, 0.5, 0.1],...
                'String',{'--Select artifact suppression--','wICA','RefSubtract'});
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
                'ColumnWidth',{100,75});
                          
            guiobj.ephysDetRunButt = uicontrol(guiobj.eventDetTab,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.01, 0.72, 0.1, 0.05],...
                'String','Run ephys detection',...
                'Callback',@(h,e) guiobj.ephysDetRun);
            guiobj.ephysDetStatusLabel = uicontrol(guiobj.eventDetTab,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.01, 0.66, 0.1, 0.05],...
                'String','--IDLE--',...
                'BackgroundColor','g');
            
            
            
            guiobj.imagingDetPopMenu = uicontrol(guiobj.eventDetTab,...
                'Style','popupmenu',...
                'Units','normalized',...
                'Position',[0.01, 0.5, 0.1, 0.1],...
                'String',{'--Imaging detection methods--','Mean+SD'},...
                'Callback',@(h,e) guiobj.imagingDetPopMenuSelected);
            
%             guiobj.imagingDetChSelPopMenu = uicontrol(guiobj.eventDetTab,...
%                 'Style','popupmenu',...
%                 'Units','normalized',...
%                 'Position',[0.35, 0.9, 0.05, 0.1],...
%                 'String',{'--Select ROI--'});
            
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
                'String','3');
            
            guiobj.imagingDetParamsPanel = uipanel(guiobj.eventDetTab,...
                'Position',[0.325, 0.33, 0.125, 0.3],...
                'Title','Event parameters',...
                'Visible','on');
            guiobj.imagingDetParamsTable = uitable(guiobj.imagingDetParamsPanel,...
                'Units','normalized',...
                'Position',[0.01, 0.01, 0.98, 0.98],...
                'ColumnWidth',{100,75});
            
            guiobj.imagingDetRunButt = uicontrol(guiobj.eventDetTab,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.01, 0.44, 0.1, 0.05],...
                'String','Run imaging detection',...
                'Callback',@(h,e) guiobj.imagingDetRun);
            
            guiobj.imagingDetStatusLabel = uicontrol(guiobj.eventDetTab,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.01, 0.38, 0.1, 0.05],...
                'String','--IDLE--',...
                'BackgroundColor','g');
            
            guiobj.simultDetPopMenu = uicontrol(guiobj.eventDetTab,...
                'Style','popupmenu',...
                'Units','normalized',...
                'Position',[0.01, 0.2, 0.1, 0.1],...
                'String',{'--Simultan detection methods--','Standard'},...
                'Callback',@(h,e) guiobj.simultDetPopMenuSelected);
            guiobj.simultDetRunButt = uicontrol(guiobj.eventDetTab,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.01, 0.14, 0.1, 0.05],...
                'String','Run simultan detection',...
                'Callback',@(h,e) guiobj.simultDetRun);
            guiobj.simultDetStatusLabel = uicontrol(guiobj.eventDetTab,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.01, 0.08, 0.1, 0.05],...
                'String','--IDLE--',...
                'BackgroundColor','g');
            
            guiobj.simultDetStandardPanel = uipanel(guiobj.eventDetTab,...
                'Position',[0.12, 0.01, 0.3, 0.3],...
                'Title','Settings for simultan detection',...
                'Visible','off');
            guiobj.simultDetStandardDelayLabel = uicontrol(guiobj.simultDetStandardPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.1, 0.8, 0.6, 0.1],...
                'String','Max delay between LFP and imaging event [ms]',...
                'Tooltip','Positive value means LFP first and vice versa');
            guiobj.simultDetStandardDelayEdit = uicontrol(guiobj.simultDetStandardPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.7, 0.8, 0.1, 0.1],...
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
            guiobj.axesEventDet2 = axes(guiobj.eventDetTab,...
                'Position',[0.5, 0.1, 0.45, 0.35],...
                'NextPlot','replacechildren');
            guiobj.axesEventDet2.Toolbar.Visible = 'on';
            guiobj.axesEventDet2DetUpButt = uicontrol(guiobj.eventDetTab,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.96, 0.35, 0.03, 0.05],...
                'String','<HTML>Det&uarr',...
                'Callback',@(h,e) guiobj.eventDetAxesButtFcn(2,0,1));
            guiobj.axesEventDet2DetDownButt = uicontrol(guiobj.eventDetTab,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.96, 0.3, 0.03, 0.05],...
                'String','<HTML>Det&darr',...
                'Callback',@(h,e) guiobj.eventDetAxesButtFcn(2,0,-1));
            guiobj.axesEventDet2RoiUpButt = uicontrol(guiobj.eventDetTab,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.96, 0.2, 0.03, 0.05],...
                'String','<HTML>ROI&uarr',...
                'Callback',@(h,e) guiobj.eventDetAxesButtFcn(2,1,0));
            guiobj.axesEventDet2RoiDownButt = uicontrol(guiobj.eventDetTab,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.96, 0.15, 0.03, 0.05],...
                'String','<HTML>ROI&darr',...
                'Callback',@(h,e) guiobj.eventDetAxesButtFcn(2,-1,0));
            
        end
    end
    
end