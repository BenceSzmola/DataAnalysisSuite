classdef DAS < handle
    
    properties (Access = public)
        
    end
    
    %% Initializing components
    properties (Access = private)
        mainfig
        OptionsMenu
        timedimChangeMenu
        showProcDataMenu
        showDetMarkersMenu
        showEphysDetMarkersMenu
        showImagingDetMarkersMenu
        showSimultMarkersMenu
        MakewindowlargerMenu
        MakewindowsmallerMenu
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
        ephysCwtDetArtSuppPopMenu
        ephysCwtDetRefChanLabel
        ephysCwtDetRefChanEdit
        
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
        ephysDoGInstPowDetArtSuppPopMenuLabel
        ephysDoGInstPowDetArtSuppPopMenu
        
        ephysDetRunButt
        ephysDetStatusLabel
        
        imagingDetPopMenu
        imagingDetChSelPopMenu
        
        imagingMeanSdDetPanel
        imagingMeanSdDetSdmultLabel
        imagingMeanSdDetSdmultEdit
        
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
        
        xtitle = 'Time [s]';
        
        ephys_data                          % Currently imported electrophysiology data
        % For storing processed electrophysiology data
        ephys_procced
        % Info on processed data: 2 column array, [channel, type of
        % processing]
        ephys_proccedInfo
        % Stores which proc type is which 
        ephys_procTypes = ["DoG"; "Periodic"];
        ephys_detections                    % Location of detections on time axis
        ephys_detectionsInfo
        ephys_detMarkerSelection
        ephys_detRunsNum = 0;               % Number of detection runs
        ephys_currdet                       % Detection run currently active in detection tab
        ephys_dettypes = ["CWT based"; "Adaptive threshold"; "DoG+InstPow"];
        ephys_taxis                         % Time axis for electrophysiology data
        ephys_fs                            % Sampling frequency of electrophysiology data
        ephys_ylabel = 'Voltage [\muV]';
        ephys_select                        % Currently selected channel
        ephys_datanames = {};             % Names of the imported electrophysiology data
        ephys_procdatanames = {};
        
        imaging_data                        % Currently imported imaging data
        imaging_procced
        imaging_proccedInfo
        imaging_procTypes = ["GaussAvg"];
        imaging_detections
        imaging_detectionsInfo
        imaging_detMarkerSelection
        imaging_detRunsNum = 0;             % Number of detection runs
        imaging_dettypes = ["Mean+SD"];
        imaging_taxis                       % Time axis for imaging data
        imaging_fs                          % Sampling frequency of imaging data
        imaging_ylabel = '\DeltaF/F';
        imag_select                         % Currently selected ROI
        imag_datanames = {};              % Names of the imported imaging data
        imag_proc_datanames = {};
        
        run_pos                             % Currently imported running data
        run_veloc                           % Running velocity
        run_taxis                           % Time axis for running data
        run_fs                              % Sampling frequency of running data
        run_pos_ylabel = 'Pos [%]';
        run_veloc_ylabel = 'Velocity [cm/s]';
        
        simult_detections
        
        eventDet1CurrIdx = 1;
        eventDet1CurrDet = 1;
        eventDet1CurrChan = 1;
        eventDet2CurrIdx = 1;
        eventDet2CurrDet = 1;
        eventDet2CurrRoi = 1;
        
%         winsizes = [1280,780;1600,900;1920,1080;2560,1440;3840,2160];
    end
    
    %%
    methods (Access = public)
        % Constructor function
        function guiobj = DAS
            createComponents(guiobj)
            if nargout == 0
                clear guiobj
            end
        end
    end
    
    %% Helper functions
    methods (Access = private)
        
        function ephysplot(guiobj,ax,index,value)
            if isempty(index) | index == 0
                return
            end
            
            if isempty(guiobj.ephys_data)
                return
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
                    hold(ax,'off')
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

            axis(ax,'tight')
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
        
        function ephysprocplot(guiobj,ax,index,value,proctype)
            if isempty(index) | index == 0
                return
            end
            plot(ax,guiobj.ephys_taxis,guiobj.ephys_procced(index,:))
            axis(ax,'tight')
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
        
        function imagingplot(guiobj,ax,index,value)
            if isempty(index) | index == 0
                return
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
                    hold(ax,'off')

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
            
            axis(ax,'tight')
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
        
        function plotpanelswitch(guiobj)
            if guiobj.runCheckBox.Value
                switch sum(guiobj.datatyp)
                    case 1
                        guiobj.Panel1Plot.Visible = 'on';
                        guiobj.Panel2Plot.Visible = 'off';
                        guiobj.Panel3Plot.Visible = 'off';
                        cla(guiobj.axes11)
                        guiobj.axes11.Visible = 'off';
                        guiobj.axesAbsPos1.Visible = 'on';
                        guiobj.axesLapPos1.Visible = 'on'
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
                
        end
        
        function lickplot(guiobj)
            licks = guiobj.LickTimesListBox.String;
            licks = str2double(licks);
            allaxes = findobj(guiobj.mainfig,'Type','axes');
            for i = 1:length(allaxes)
                for j = 1:length(licks)
                    yminmax = allaxes(i).YLim;
                    line(allaxes(i),[licks(j),licks(j)],yminmax,'Color','r')
                end
            end
        end
        
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
                hold(ephysAxes,'on')
                for i = 1:length(detSel)
                    plot(ephysAxes,guiobj.ephys_taxis,...
                        guiobj.ephys_detections(detSel(i),:),'r*','MarkerSize',12)
                end
                hold(ephysAxes,'off')
            end
        end
        
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
                hold(imagingAxes,'off')
            end
            
        end
        
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
                    hold(ax(i),'off')
                end
            end
            
        end
        
        
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
        
        function eventDetAxesButtFcn(guiobj,axNum,detRoi,upDwn)
            switch axNum
                case 1 %ephys axes
                    currDetRun = guiobj.ephys_currdet;
                    temp = find(guiobj.ephys_detectionsInfo(:,3)==currDetRun);
                    currChans = guiobj.ephys_detectionsInfo(temp,1);
                    
                    if isempty(guiobj.ephys_detections)
                        return
                    end
                    
                    ax = guiobj.axesEventDet1;
                    switch detRoi
                        case 0
                            guiobj.eventDet1CurrDet = 1;
                            guiobj.eventDet1CurrChan = 1;
                        case 1
                            switch upDwn
                                case 1
                                    if guiobj.eventDet1CurrDet < length(find(~isnan(guiobj.ephys_detections(guiobj.eventDet1CurrIdx,:))))
                                        guiobj.eventDet1CurrDet = ...
                                            guiobj.eventDet1CurrDet + 1;
                                    end
                                case 2
                                    if guiobj.eventDet1CurrDet > 1
                                        guiobj.eventDet1CurrDet = ...
                                            guiobj.eventDet1CurrDet - 1;
                                    end
                            end
                        case 2
                            guiobj.eventDet1CurrDet = 1;
%                             temp = find(guiobj.ephys_detectionsInfo(:,3)==currDetRun);
%                             currChans = guiobj.ephys_detectionsInfo(temp,1);
                            switch upDwn
                                case 1
                                    if guiobj.eventDet1CurrChan < size(guiobj.ephys_data,1)
                                        guiobj.eventDet1CurrChan = ...
                                            guiobj.eventDet1CurrChan + 1;
                                    end
                                case 2
                                    if guiobj.eventDet1CurrChan > 1
                                        guiobj.eventDet1CurrChan = ...
                                            guiobj.eventDet1CurrChan - 1;
                                    end
                                    
                            end
                    end
                    
%                     chan = guiobj.ephysDetChSelPopMenu.Value;
                    chan = guiobj.eventDet1CurrChan;
                    currDet = guiobj.eventDet1CurrIdx;
                    detInd = guiobj.eventDet1CurrDet;
                    tInd = find(~isnan(guiobj.ephys_detections(currDet,:)));
                    tInd = tInd(detInd);
                    tStamp = guiobj.ephys_taxis(tInd);
                    win = round(0.25 * guiobj.ephys_fs,4);
                    tWin = guiobj.ephys_taxis(tInd-win:tInd+win);
                    dataWin = guiobj.ephys_data(chan,tInd-win:tInd+win);
                    plot(ax,tWin,dataWin)
                    hold(ax,'on')
                    line(ax,[tStamp tStamp],[min(dataWin), max(dataWin)],...
                        'Color','r')
                    hold(ax,'off')
                    axis(ax,'tight')
                    xlabel(ax,guiobj.xtitle)
                    ylabel(ax,guiobj.ephys_ylabel);
                    title(ax,['Channel#',num2str(chan),' Detection#',num2str(detInd)])
                    
                case 2
                    if isempty(guiobj.imaging_detections)
                        return
                    end
                    
                    ax = guiobj.axesEventDet2;
                    switch detRoi
                        case 0
                            guiobj.eventDet2CurrDet = 1;
                        case 1
                            switch upDwn
                                case 1
                                    if guiobj.eventDet2CurrDet < length(find(~isnan(guiobj.imaging_detections(guiobj.eventDet2CurrRoi,:))))
                                        guiobj.eventDet2CurrDet = ...
                                            guiobj.eventDet2CurrDet + 1;
                                    end
                                case 2
                                    if guiobj.eventDet2CurrDet > 1
                                        guiobj.eventDet2CurrDet = ...
                                            guiobj.eventDet2CurrDet - 1;
                                    end
                            end
                        case 2
                            guiobj.eventDet2CurrDet = 1;
                            switch upDwn
                                case 1
                                    if guiobj.eventDet2CurrRoi < size(guiobj.imaging_data,1)
                                        guiobj.eventDet2CurrRoi = ...
                                            guiobj.eventDet2CurrRoi + 1;
                                    end
                                case 2
                                    if guiobj.eventDet2CurrRoi > 1
                                        guiobj.eventDet2CurrRoi = ...
                                            guiobj.eventDet2CurrRoi - 1;
                                    end
                            end
                    end
                    
                    roi = guiobj.eventDet2CurrRoi;
%                     currDet = guiobj.eventDet2CurrIdx;
                    detInd = guiobj.eventDet2CurrDet;
                    tInd = find(~isnan(guiobj.imaging_detections(roi,:)));
                    tInd = tInd(detInd);
                    tStamp = guiobj.imaging_taxis(tInd);
                    win = round(1 * guiobj.imaging_fs);
                    tWin = guiobj.imaging_taxis(tInd-win:tInd+win);
                    dataWin = guiobj.imaging_data(roi,tInd-win:tInd+win);
                    plot(ax,tWin,dataWin)
                    hold(ax,'on')
                    line(ax,[tStamp tStamp],[min(dataWin), max(dataWin)],...
                        'Color','r')
                    hold(ax,'off')
                    axis(ax,'tight')
                    xlabel(ax,guiobj.xtitle)
                    ylabel(ax,guiobj.imaging_ylabel);
                    title(ax,['ROI#',num2str(roi),' Detection#',num2str(detInd)])
            end
        end
        
        function resetGuiData(guiobj,rhdORgor)
%             guiobj.timedim = 1;
%             guiobj.datatyp = [0, 0, 0];
%         
%             guiobj.xtitle = 'Time [s]';
%         
%             guiobj.ephys_data = [];
%             guiobj.ephys_procced = [];
%             guiobj.ephys_proccedInfo = [];
%             guiobj.ephys_procTypes = ["DoG"; "Periodic"];
%             guiobj.ephys_detections = [];
%             guiobj.ephys_detectionsInfo = [];
%             guiobj.ephys_detMarkerSelection = [];
%             guiobj.ephys_dettypes = ["CWT based"; "Adaptive threshold"; "DoG+InstPow"];
%             guiobj.ephys_taxis = [];
%             guiobj.ephys_fs = [];
%             guiobj.ephys_ylabel = 'Voltage [\muV]';
%             guiobj.ephys_select = [];
%             guiobj.ephys_datanames = {};
%             guiobj.ephys_procdatanames = {};
% 
%             guiobj.imaging_data = [];
%             guiobj.imaging_procced = [];
%             guiobj.imaging_proccedInfo = [];
%             guiobj.imaging_procTypes = ["GaussAvg"];
%             guiobj.imaging_detections = [];
%             guiobj.imaging_detectionsInfo = [];
%             guiobj.imaging_detMarkerSelection = [];
%             guiobj.imaging_dettypes = ["Mean+SD"];
%             guiobj.imaging_taxis = [];
%             guiobj.imaging_fs = [];
%             guiobj.imaging_ylabel = '\DeltaF/F';
%             guiobj.imag_select = [];
%             guiobj.imag_datanames = {};
%             guiobj.imag_proc_datanames = {};
% 
%             guiobj.run_pos = [];
%             guiobj.run_veloc = [];
%             guiobj.run_taxis = [];
%             guiobj.run_fs = [];
%             guiobj.run_pos_ylabel = 'Pos [%]';
%             guiobj.run_veloc_ylabel = 'Velocity [cm/s]';
% 
%             guiobj.simult_detections = [];
% 
%             guiobj.eventDet1CurrIdx = 1;
%             guiobj.eventDet1CurrDet = 1;
%             guiobj.eventDet1CurrRoi = 1;
%             guiobj.eventDet2CurrIdx = 1;
%             guiobj.eventDet2CurrDet = 1;
%             guiobj.eventDet2CurrRoi = 1;
            dtyp = guiobj.datatyp;
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
        end
    end
    
    %% Callback functions
    methods (Access = private)

%         % Code that executes after component creation
%         function startupFcn(guiobj)
%             axesmaker(guiobj)
%         end

        % Button pushed function: ImportRHDButton
        function ImportRHDButtonPushed(guiobj, event)
%             %%%test
%             display(event)
%             %%%
            if ~isempty(guiobj.ephys_data)
                clrGUI = questdlg('Reset GUI?');
                if strcmp(clrGUI,'Yes')
                    resetGuiData(guiobj,1)
                end
                return
            end
            
            [filename,path] = uigetfile('*.rhd');
            if filename == 0
                figure(guiobj.mainfig)
                return
            end
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

        % Button pushed function: ImportgorobjButton
        function ImportgorobjButtonPushed(guiobj, event)
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
                    'workspace (MES Curveanalysis: export -> curves to'...
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
                if strcmp(get(wsgors(i),'yunit'),'scalar')
                    guiobj.imaging_data(ica,:) = get(wsgors(i),'extracty');
                    dtyp(i) = 2;
                    ica = ica+1;
                else
                    guiobj.ephys_data(ie,:) = get(wsgors(i),'extracty');
                    dtyp(i) = 1;
                    ie = ie+1;
                end
                datanames{i} = get(wsgors(i),'name');
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
                guiobj.EphysListBox.String = datanames(dtyp==1);
                guiobj.ephys_datanames = datanames(dtyp==1);
                guiobj.ImagingListBox.String = datanames(dtyp==2);
                guiobj.imag_datanames = datanames(dtyp==2);
                
                if ~isempty(find(dtyp==1, 1))
                    taxis = get(wsgors(find(dtyp==1,1)),'x')*...
                        (10^-3/guiobj.timedim);
                    guiobj.ephys_fs = 1/taxis(2);
                    guiobj.ephys_taxis = linspace(taxis(1),...
                        length(guiobj.ephys_data)/guiobj.ephys_fs+taxis(1),...
                        length(guiobj.ephys_data));
                end
                
                if ~isempty(find(dtyp==2,1))
                    taxis = get(wsgors(find(dtyp==2,1)),'x')*...
                        (10^-3/guiobj.timedim);
                    guiobj.imaging_fs = 1/taxis(2);
                    guiobj.imaging_taxis = linspace(taxis(1),...
                        length(guiobj.imaging_data)/guiobj.imaging_fs+taxis(1),...
                        length(guiobj.imaging_data));
                end
            end
        end

        % Value changed function: DatasetListBox
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

        % Menu selected function: timedimChangeMenu
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
        
        function showEphysDetMarkers(guiobj,event)
            if isempty(guiobj.ephys_detections)
                return
            end
            
            if strcmp(guiobj.showEphysDetMarkersMenu.Checked,'off')
                detList = {};
                for i = 1:size(guiobj.ephys_detectionsInfo,1)
                    detList{i} = strcat(guiobj.ephys_dettypes(...
                        guiobj.ephys_detectionsInfo(i,2)),'| Channel #',...
                        num2str(guiobj.ephys_detectionsInfo(i,1)));
                end
                [indx,tf] = listdlg('ListString',detList);
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
        
        % Button pushed function: ImportruncsvButton
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

        % Value changed function: ephysCheckBox
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

        % Value changed function: imagingCheckBox
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

        % Value changed function: runCheckBox
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

        % Value changed function: EphysListBox
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

        % Value changed function: ImagingListBox
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

        % Value changed function: InputLickEditField
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

        % Value changed function: LickTimesListBox
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

%         % Menu selected function: MakewindowlargerMenu
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
%         % Menu selected function: MakewindowsmallerMenu
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
        
        function ephysProcListBoxValueChanged(guiobj,event)
            idx = guiobj.ephysProcListBox.Value;
            if isempty(idx)
                return
            end
            figtitle = guiobj.ephysProcListBox.String(idx);
            ephysplot(guiobj,guiobj.axesEphysProc1,idx,figtitle)
        end
        
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
                        return
                    end
                    procced = DoG(data,guiobj.ephys_fs,w1,w2);
                    guiobj.ephys_proccedInfo = [guiobj.ephys_proccedInfo;...
                        [data_idx', 1*ones(size(data_idx'))]];
                    
                    for i = 1:length(data_idx)
                        if isempty(procDatanames)
                            procDatanames = {['DoG| ',...
                                datanames{data_idx(i)}]};
                        elseif ~isempty(procDatanames)
                            switch selectedButt
                                case 'Raw data'
                                    procDatanames = [procDatanames,...
                                        ['DoG| ',datanames{data_idx(i)}]];
                                case 'Processed data'
                                    procDatanames = [procDatanames,...
                                        ['DoG| ',procDatanames{data_idx(i)}]];
                            end
                            
                        end
                    end
                    
                case 'Periodic'
                    fmax = str2double(guiobj.fmaxEdit.String);
                    ffund = str2double(guiobj.ffundEdit.String);
                    stopbandwidth = str2double(guiobj.stopbandwidthEdit.String);
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
        
        function runArtSupp(guiobj,event)
            guiobj.ephysArtSuppRunButt.BackgroundColor = 'r';
            
            artSuppType = guiobj.ephysArtSuppTypePopMenu.Value;
            artSuppName = guiobj.ephysArtSuppTypePopMenu.String{artSuppType};
            
            datanames = guiobj.ephys_datanames;
            procDatanames = guiobj.ephys_procdatanames;
            
            selectedButt = guiobj.ephysProcSrcButtGroup.SelectedObject;
            selectedButt = selectedButt.String;
            
            switch selectedButt
                case 'Raw data'
                    data_idx = guiobj.ephysProcListBox.Value;
                    data = guiobj.ephys_data(data_idx,:);
                case 'Processed data'
                    data_idx = guiobj.ephysProcListBox2.Value;
                    data = guiobj.ephys_procced(data_idx,:);
            end
            
            fs = guiobj.ephys_fs;
            data_cl = ArtSupp(data,fs,artSuppType);
            
            
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
        
        % Callback to monitor radiobutton press
        function ephysProcProcdRadioButtPushed(guiobj,event)
            if isempty(guiobj.ephys_procced)
                errordlg('No processed data!')
                guiobj.ephysProcSrcButtGroup.SelectedObject = ...
                    guiobj.ephysProcRawRadioButt;
                return
            end
        end
        
        function imagingProcListBoxValueChanged(guiobj,event)
            idx = guiobj.imagingProcListBox.Value;
            if idx == 0 | isnan(idx) | isempty(idx)
               return
            end
            imagingplot(guiobj,guiobj.axesImagingProc1,idx)
        end
        
        function imagingProcListBox2ValueChanged(guiobj,event)
            idx = guiobj.imagingProcListBox2.Value;
            if idx == 0 | isnan(idx) | isempty(idx)
               return
            end
            imagingplot(guiobj,guiobj.axesImagingProc2,idx) 
        end
        
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
                                    procDatanames = {['GaussAvg| ',...
                                        datanames{data_idx(i)}]};
                                elseif ~isempty(procDatanames)
                                    switch selectedButt
                                        case 'Raw data'
                                            procDatanames = [procDatanames,...
                                                ['GaussAvg| ',datanames{data_idx(i)}]];
                                        case 'Processed data'
                                            procDatanames = [procDatanames,...
                                                ['GaussAvg] ',procDatanames{data_idx(i)}]];
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
        
        % Callback to monitor radiobutton press
        function imagingProcProcdRadioButtPushed(guiobj,event)
            if isempty(guiobj.imaging_procced)
                errordlg('No processed data!')
                guiobj.imagingProcSrcButtGroup.SelectedObject = ...
                    guiobj.imagingProcRawRadioButt;
                return
            end
        end
        
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
            end
        end
        
        function ephysDetRun(guiobj,event)
            guiobj.ephysDetStatusLabel.String = 'Detection running';
            guiobj.ephysDetStatusLabel.BackgroundColor = 'r';
            drawnow
            dettype = guiobj.ephysDetPopMenu.Value;
            dettype = guiobj.ephysDetPopMenu.String{dettype};
            guiobj.ephys_detRunsNum = guiobj.ephys_detRunsNum +1;
            
            chan = guiobj.ephysDetChSelPopMenu.Value;
            if chan < min(size(guiobj.ephys_data))
                data = guiobj.ephys_data(chan,:);
            else
                data = guiobj.ephys_data;
            end
            fs = guiobj.ephys_fs;
                        
            switch dettype
                case 'CWT based'
                    minlen = str2double(guiobj.ephysCwtDetMinlenEdit.String);
                    sdmult = str2double(guiobj.ephysCwtDetSdMultEdit.String);
                    w1 = str2double(guiobj.ephysCwtDetW1Edit.String);
                    w2 = str2double(guiobj.ephysCwtDetW2Edit.String);
                    refch = str2double(guiobj.ephysCwtDetRefChanEdit.String);
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
                    
                    dets = wavyDet(data,fs,minlen/1000,sdmult,w1,w2);
                    if chan < min(size(guiobj.ephys_data))
                        detinfo = [chan, 1, guiobj.ephys_detRunsNum];
                    else
                        detinfo = [(1:min(size(guiobj.ephys_data)))',...
                            1*ones(min(size(guiobj.ephys_data)),1),...
                            guiobj.ephys_detRunsNum*ones(min(size(guiobj.ephys_data)),1)];
                    end
                    
                case 'Adaptive threshold'
                    step = eval(guiobj.ephysAdaptDetStepEdit.String)/1000;
                    mindist = eval(guiobj.ephysAdaptDetMindistEdit.String)/1000;
                    minlen = eval(guiobj.ephysAdaptDetMinwidthEdit.String)/1000;
                    ratio = eval(guiobj.ephysAdaptDetRatioEdit.String)/100;
                    dets = adaptive_thresh(data,fs,step,minlen,mindist,ratio);
%                     detinfo = [chan, 2];
                    if chan < min(size(guiobj.ephys_data))
                        detinfo = [chan, 2, guiobj.ephys_detRunsNum];
                    else
                        detinfo = [(1:min(size(guiobj.ephys_data)))',...
                            2*ones(min(size(guiobj.ephys_data)),1),...
                            guiobj.ephys_detRunsNum*ones(min(size(guiobj.ephys_data)),1)];
                    end
                    
                case 'DoG+InstPow'
                    w1 = str2double(guiobj.ephysDoGInstPowDetW1Edit.String);
                    w2 = str2double(guiobj.ephysDoGInstPowDetW2Edit.String);
                    sdmult = str2double(guiobj.ephysDoGInstPowDetSdMultEdit.String);
                    minLen = str2double(guiobj.ephysDoGInstPowDetMinLenEdit.String)/1000;
                    refch = str2double(guiobj.ephysDoGInstPowDetRefChanEdit.String);
                    
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
                    
                    dets = DoGInstPowDet(data,fs,w1,w2,sdmult,minLen);
%                     detinfo = [chan, 3];
                    if chan < min(size(guiobj.ephys_data))
                        detinfo = [chan, 3, guiobj.ephys_detRunsNum];
                    else
                        detinfo = [(1:min(size(guiobj.ephys_data)))',...
                            3*ones(min(size(guiobj.ephys_data)),1),...
                            guiobj.ephys_detRunsNum*ones(min(size(guiobj.ephys_data)),1)];
                    end
            end
            
            guiobj.ephys_detections = [guiobj.ephys_detections; dets];
            guiobj.ephys_detectionsInfo = [guiobj.ephys_detectionsInfo;...
                detinfo];
            guiobj.eventDet1CurrIdx = size(guiobj.ephys_detections,1);
            
            
            guiobj.ephysDetStatusLabel.String = '--IDLE--';
            guiobj.ephysDetStatusLabel.BackgroundColor = 'g';
            
            guiobj.ephys_currdet = guiobj.ephys_detRunsNum;
            
            eventDetAxesButtFcn(guiobj,1,0,0);
        end
        
        function imagingDetPopMenuSelected(guiobj,event)
            dettype = guiobj.imagingDetPopMenu.Value;
            dettype = guiobj.imagingDetPopMenu.String{dettype};
            
            switch dettype
                case 'Mean+SD'
                    guiobj.imagingMeanSdDetPanel.Visible = 'on';
                
            end
        end
        
        function simultDetPopMenuSelected(guiobj,event)
            dettype = guiobj.simultDetPopMenu.Value;
            dettype = guiobj.simultDetPopMenu.String{dettype};
            
            switch dettype
                case 'Standard'
                    guiobj.simultDetStandardPanel.Visible = 'on';
                
            end
        end
        
        function imagingDetRun(guiobj,event)
            guiobj.imagingDetStatusLabel.String = 'Detection running';
            guiobj.imagingDetStatusLabel.BackgroundColor = 'r';
            drawnow
            
            dettype = guiobj.imagingDetPopMenu.Value;
            dettype = guiobj.imagingDetPopMenu.String{dettype};
            
            data = guiobj.imaging_data;
%             fs = guiobj.imaging_fs;
            sdmult = str2double(guiobj.imagingMeanSdDetSdmultEdit.String);
            
            dets = nan(size(data));
            switch dettype
                case 'Mean+SD'
                    for i = 1:size(data,1)
                        smoothd = smoothdata(data(i,:),'gaussian',10);
                        thr = mean(smoothd) + sdmult*std(smoothd);
%                         aboveThrInds = smoothd(smoothd > thr);
%                         aboveThrInd_diff = diff(aboveThrInds);
                        [~,locs,~,~] = findpeaks(smoothd,'MinPeakHeight',thr);
                        dets(i,locs) = 0;
                    end
            end
            
            guiobj.imaging_detections = dets;
%             guiobj.eventDet2CurrIdx = size(guiobj.imaging_detections,1);
            pause(1)
            guiobj.imagingDetStatusLabel.String = '--IDLE--';
            guiobj.imagingDetStatusLabel.BackgroundColor = 'g';
            
            eventDetAxesButtFcn(guiobj,2,0,0)
        end
        
        function simultDetRun(guiobj,event)
            guiobj.simultDetStatusLabel.String = 'Detection running';
            guiobj.simultDetStatusLabel.BackgroundColor = 'r';
            
            dettype = guiobj.simultDetPopMenu.Value;
            dettype = guiobj.simultDetPopMenu.String{dettype};
            
            detList = {};
            for i = 1:size(guiobj.ephys_detectionsInfo,1)
                detList{i} = strcat(guiobj.ephys_dettypes(...
                    guiobj.ephys_detectionsInfo(i,2)),'| Channel #',...
                    num2str(guiobj.ephys_detectionsInfo(i,1)));
            end
            [indx,tf] = listdlg('ListString',detList,...
                'PromptString','Select electrophysiology detection!',...
                'SelectionMode','single');
            if ~tf
                return
            end
            
            ephys_detInds = find(~isnan(guiobj.ephys_detections(indx,:)));
            ephys_tAx = guiobj.ephys_taxis;
            
            imaging_tAx = guiobj.imaging_taxis;
            
            simult_dets = nan(size(guiobj.imaging_data,1),length(guiobj.ephys_taxis));
            switch dettype
                case 'Standard'
                    delay = str2double(guiobj.simultDetStandardDelayEdit.String)/1000;
                    for roi = 1:size(guiobj.imaging_data,1)
                        imaging_detInds = find(~isnan(guiobj.imaging_detections(roi,:)));
%                         temp = [];
                        for i = 1:length(imaging_detInds)
                            for j = 1:length(ephys_detInds)
                                tDiff = imaging_tAx(imaging_detInds(i))...
                                    - ephys_tAx(ephys_detInds(j));
                                if (tDiff < delay) && (tDiff >= 0)
%                                     temp = [temp, ephys_tAx(ephys_detInds(i))'];
                                    simult_dets(roi,ephys_detInds(j)) = 0;
                                end
                            end
                        end
%                         temp
%                         if isempty(simult_dets)
%                             simult_dets = temp;
%                         else
%                             simult_dets = [simult_dets; temp];
%                         end
                    end
            end

            if isempty(find(~isnan(simult_dets)))
                warndlg('No simultaneous events found!')
            else
                guiobj.simult_detections = simult_dets;
            end
            
            guiobj.simultDetStatusLabel.String = '--IDLE--';
            guiobj.simultDetStatusLabel.BackgroundColor = 'g';
        end
        
        function axesEventDet1UpButtPush(guiobj,event)
            eventDetAxesButtFcn(guiobj,1,1,1)
        end
        
        function axesEventDet1DownButtPush(guiobj,event)
            eventDetAxesButtFcn(guiobj,1,1,2)
        end
        
        function axesEventDet1ChanUpButtPush(guiobj,event)
            eventDetAxesButtFcn(guiobj,1,2,1)
        end
        
        function axesEventDet1ChanDownButtPush(guiobj,event)
            eventDetAxesButtFcn(guiobj,1,2,2)
        end
        
        function axesEventDet2DetUpButtPush(guiobj,event)
            eventDetAxesButtFcn(guiobj,2,1,1)
        end
        
        function axesEventDet2DetDownButtPush(guiobj,event)
            eventDetAxesButtFcn(guiobj,2,1,2)
        end
        
        function axesEventDet2RoiUpButtPush(guiobj,event)
            eventDetAxesButtFcn(guiobj,2,2,1)
        end
        
        function axesEventDet2RoiDownButtPush(guiobj,event)
            eventDetAxesButtFcn(guiobj,2,2,2)
        end
        
        function testcallback(varargin)
            display(varargin)
            assignin('base','testinput',varargin)
            display(varargin{1}.tabs.SelectedTab.Title)
        end
        
    end
    
    %% guiobj initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(guiobj)

            % Create figure
            guiobj.mainfig = figure('Units','normalized',...
                'Position',[0.1, 0.1, 0.8, 0.7],...
                'NumberTitle','off',...
                'Name','Data Analysis Suite',...
                'MenuBar','none');

            % Create OptionsMenu
            guiobj.OptionsMenu = uimenu(guiobj.mainfig,...
                'Text', 'Options');

            % Create timedimChangeMenu
            guiobj.timedimChangeMenu = uimenu(guiobj.OptionsMenu,...
                'MenuSelectedFcn',@(h,e) guiobj.timedimChangeMenuSelected,...
                'Text','Change between [s]/[ms]');
            
            % Create menu to display or hide processed data in main tab
            % listboxes
            guiobj.showProcDataMenu = uimenu(guiobj.OptionsMenu,...
                'Checked','off',...
                'Text','Show processed data in main tab',...
                'MenuSelectedFcn',@(h,e) guiobj.showProcDataMenuSelected);
            
            % Create display markers topmenu
            guiobj.showDetMarkersMenu = uimenu(guiobj.OptionsMenu,...
                'Text','Show detection markers');
            
            % Create menu to display detection markers
            guiobj.showEphysDetMarkersMenu = uimenu(guiobj.showDetMarkersMenu,...
                'Text','Show ephys detection markers',...
                'MenuSelectedFcn',@(h,e) guiobj.showEphysDetMarkers);
            guiobj.showImagingDetMarkersMenu = uimenu(guiobj.showDetMarkersMenu,...
                'Text','Show imaging detection markers',...
                'MenuSelectedFcn',@(h,e) guiobj.showImagingDetMarkers);
            guiobj.showSimultMarkersMenu = uimenu(guiobj.showDetMarkersMenu,...
                'Text','Show simultaneous detection markers',...
                'MenuSelectedFcn',@(h,e) guiobj.showSimultDetMarkers);

%             % Create MakewindowlargerMenu
%             guiobj.MakewindowlargerMenu = uimenu(guiobj.OptionsMenu,...
%                 'MenuSelectedFcn',@(h,e) guiobj.MakewindowlargerMenuSelected,...
%                 'Text','Make window larger');
% 
%             % Create MakewindowsmallerMenu
%             guiobj.MakewindowsmallerMenu = uimenu(guiobj.OptionsMenu,...
%                 'MenuSelectedFcn',@(h,e) guiobj.MakewindowsmallerMenuSelected,...
%                 'Text','Make window smaller');

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
                'Position',[0.1,0.2,0.85,0.6]);
            guiobj.axes11.Toolbar.Visible = 'on';
            
            guiobj.axes21 = axes(guiobj.Panel2Plot,...
                'Position',[0.1,0.6,0.85,0.35]);
            guiobj.axes21.Toolbar.Visible = 'on';
            guiobj.axes22 = axes(guiobj.Panel2Plot,...
                'Position',[0.1,0.1,0.85,0.35]);
            guiobj.axes22.Toolbar.Visible = 'on';
            
            guiobj.axes31 = axes(guiobj.Panel3Plot,...
                'Position',[0.1,0.7,0.85,0.25]);
            guiobj.axes31.Toolbar.Visible = 'on';
            guiobj.axes32 = axes(guiobj.Panel3Plot,...
                'Position',[0.1,0.38,0.85,0.25]);
            guiobj.axes32.Toolbar.Visible = 'on';
            
            guiobj.axesAbsPos1 = axes(guiobj.Panel1Plot,...
                'Position',[0.1,0.1,0.85,0.1],...
                'Visible','off',...
                'YTick',[]);
            guiobj.axesAbsPos1.Toolbar.Visible = 'on';
            guiobj.axesLapPos1 = axes(guiobj.Panel1Plot,...
                'Position',[0.1,0.3,0.85,0.1],...
                'Visible','off',...
                'YTick',[]);
            guiobj.axesLapPos1.Toolbar.Visible = 'on';
            guiobj.axesveloc1 = axes(guiobj.Panel1Plot,...
                'Position',[0.1,0.6,0.85,0.3],...
                'Visible','off');
            guiobj.axesveloc1.Toolbar.Visible = 'on';
            
            guiobj.axesAbsPos2 = axes(guiobj.Panel2Plot,...
                'Position',[0.1,0.1,0.85,0.1],...
                'Visible','off',...
                'YTick',[]);
            guiobj.axesAbsPos2.Toolbar.Visible = 'on';
            guiobj.axesLapPos2 = axes(guiobj.Panel2Plot,...
                'Position',[0.1,0.2,0.85,0.1],...
                'Visible','off',...
                'YTick',[]);
            guiobj.axesLapPos2.Toolbar.Visible = 'on';
            guiobj.axesveloc2 = axes(guiobj.Panel2Plot,...
                'Position',[0.1,0.3,0.85,0.2],...
                'Visible','off');
            guiobj.axesveloc2.Toolbar.Visible = 'on';
            
            guiobj.axesAbsPos3 = axes(guiobj.Panel3Plot,...
                'Position',[0.1,0.05,0.85,0.05],...
                'YTick',[]);
            guiobj.axesAbsPos3.Toolbar.Visible = 'on';
            guiobj.axesLapPos3 = axes(guiobj.Panel3Plot,...
                'Position',[0.1,0.1,0.85,0.05],...
                'YTick',[]);
            guiobj.axesLapPos3.Toolbar.Visible = 'on';
            guiobj.axesveloc3 = axes(guiobj.Panel3Plot,...
                'Position',[0.1,0.2,0.85,0.1]);
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
                'Title','Filtering parameters',...
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
            guiobj.ephysArtSuppRunButt = uicontrol(guiobj.ephysArtSuppPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.6, 0.01, 0.3, 0.1],...
                'String','Run artifact suppression',...
                'Callback',@(h,e) guiobj.runArtSupp,...
                'BackgroundColor','g');
            
            
            % Create axes
            guiobj.axesEphysProc1 = axes(guiobj.ephysProcTab,...
                'Position',[0.4, 0.6, 0.55, 0.35]);
            guiobj.axesEphysProc1.Toolbar.Visible = 'on';
            guiobj.axesEphysProc2 = axes(guiobj.ephysProcTab,...
                'Position',[0.4, 0.1, 0.55, 0.35]);
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
                'String',{'Filtering',''});
            
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
                'Title','Filtering parameters',...
                'Visible','on');
            
            % Create components of FiltParamPanel
            guiobj.imagingFilterTypePopMenu = uicontrol(guiobj.imagingFiltParamPanel,...
                'Style','popupmenu',...
                'Units','normalized',...
                'Position',[0.01, 0.85, 0.25, 0.1],...
                'String',{'Gauss average',''});
            guiobj.imagingFiltWinSizeText = uicontrol(guiobj.imagingFiltParamPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.3, 0.85, 0.15, 0.1],...
                'String','Window size in samples');
            guiobj.imagingFiltWinSizeEdit = uicontrol(guiobj.imagingFiltParamPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.45, 0.85, 0.1, 0.1]);
            guiobj.imagingRunFiltButton = uicontrol(guiobj.imagingFiltParamPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.85, 0.01, 0.1, 0.1],...
                'String','Run filter',...
                'Callback',@(h,e) guiobj.imagingRunProc);
            
            
            % Create axes
            guiobj.axesImagingProc1 = axes(guiobj.imagingProcTab,...
                'Position',[0.4, 0.6, 0.55, 0.35]);
            guiobj.axesImagingProc1.Toolbar.Visible = 'on';
            guiobj.axesImagingProc2 = axes(guiobj.imagingProcTab,...
                'Position',[0.4, 0.1, 0.55, 0.35]);
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
                'Position',[0.12, 0.65, 0.3, 0.3],...
                'Title','Parameters for CWT based detection',...
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
                'String','20');
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
            guiobj.ephysCwtDetArtSuppPopMenu = uicontrol(guiobj.ephysCwtDetPanel,...
                'Style','popupmenu',...
                'Units','normalized',...
                'Position',[0.01, 0.35, 0.5, 0.1],...
                'String',{'--Select artifact suppression--','wICA','RefSubtract'});
            
            guiobj.ephysAdaptDetPanel = uipanel(guiobj.eventDetTab,...
                'Position',[0.12, 0.65, 0.3, 0.3],...
                'Title','Parameters for adaptive threshold detection',...
                'Visible','off');
            guiobj.ephysAdaptDetStepLabel = uicontrol(guiobj.ephysAdaptDetPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.01, 0.85, 0.5, 0.1],...
                'String','Step size [ms]');
            guiobj.ephysAdaptDetStepEdit = uicontrol(guiobj.ephysAdaptDetPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.52, 0.85, 0.1, 0.1],...
                'String','50');
            guiobj.ephysAdaptDetMinwidthLabel = uicontrol(guiobj.ephysAdaptDetPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.01, 0.7, 0.5, 0.1],...
                'String','Minimal event length [ms]');
            guiobj.ephysAdaptDetMinwidthEdit = uicontrol(guiobj.ephysAdaptDetPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.52, 0.7, 0.1, 0.1],...
                'String','10');
            guiobj.ephysAdaptDetMindistLabel = uicontrol(guiobj.ephysAdaptDetPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.01, 0.55, 0.5, 0.1],...
                'String','Minimal distance between events [ms]');
            guiobj.ephysAdaptDetMindistEdit = uicontrol(guiobj.ephysAdaptDetPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.52, 0.55, 0.1, 0.1],...
                'String','30');
            guiobj.ephysAdaptDetRatioLabel = uicontrol(guiobj.ephysAdaptDetPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.01, 0.4, 0.5, 0.1],...
                'String','Target ratio [%]');
            guiobj.ephysAdaptDetRatioEdit = uicontrol(guiobj.ephysAdaptDetPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.52, 0.4, 0.1, 0.1],...
                'String','99');
            
            guiobj.ephysDoGInstPowDetPanel = uipanel(guiobj.eventDetTab,...
                'Position',[0.12, 0.65, 0.3, 0.3],...
                'Title','Parameters for DoG+InstPow based detection',...
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
                'Position',[0.01, 0.4, 0.5, 0.1],...
                'String','Referece channel');
            guiobj.ephysDoGInstPowDetRefChanEdit = uicontrol(guiobj.ephysDoGInstPowDetPanel,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[0.55, 0.4, 0.1, 0.1]);
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
                'Position',[0.12, 0.33, 0.3, 0.3],...
                'Title','Parameters for mean+sd based detection',...
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
                'Title','Parameters for simultan detection',...
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
                'Position',[0.5, 0.6, 0.45, 0.35]);
            guiobj.axesEventDet1UpButt = uicontrol(guiobj.eventDetTab,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.96, 0.9, 0.03, 0.05],...
                'String','<HTML>Det&uarr',...
                'Callback',@(h,e) guiobj.axesEventDet1UpButtPush);
            guiobj.axesEventDet1DownButt = uicontrol(guiobj.eventDetTab,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.96, 0.85, 0.03, 0.05],...
                'String','<HTML>Det&darr',...
                'Callback',@(h,e) guiobj.axesEventDet1DownButtPush);
            guiobj.axesEventDet1ChanUpButt = uicontrol(guiobj.eventDetTab,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.96, 0.75, 0.03, 0.05],...
                'String','<HTML>Chan&uarr',...
                'Callback',@(h,e) guiobj.axesEventDet1ChanUpButtPush);
            guiobj.axesEventDet1ChanDownButt = uicontrol(guiobj.eventDetTab,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.96, 0.7, 0.03, 0.05],...
                'String','<HTML>Chan&darr',...
                'Callback',@(h,e) guiobj.axesEventDet1ChanDownButtPush);
            guiobj.axesEventDet2 = axes(guiobj.eventDetTab,...
                'Position',[0.5, 0.1, 0.45, 0.35]);
            guiobj.axesEventDet2DetUpButt = uicontrol(guiobj.eventDetTab,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.96, 0.35, 0.03, 0.05],...
                'String','<HTML>Det&uarr',...
                'Callback',@(h,e) guiobj.axesEventDet2DetUpButtPush);
            guiobj.axesEventDet2DetDownButt = uicontrol(guiobj.eventDetTab,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.96, 0.3, 0.03, 0.05],...
                'String','<HTML>Det&darr',...
                'Callback',@(h,e) guiobj.axesEventDet2DetDownButtPush);
            guiobj.axesEventDet2RoiUpButt = uicontrol(guiobj.eventDetTab,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.96, 0.2, 0.03, 0.05],...
                'String','<HTML>ROI&uarr',...
                'Callback',@(h,e) guiobj.axesEventDet2RoiUpButtPush);
            guiobj.axesEventDet2RoiDownButt = uicontrol(guiobj.eventDetTab,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.96, 0.15, 0.03, 0.05],...
                'String','<HTML>ROI&darr',...
                'Callback',@(h,e) guiobj.axesEventDet2RoiDownButtPush);
            
        end
    end
    
end