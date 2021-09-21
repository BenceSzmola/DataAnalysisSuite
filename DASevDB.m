classdef DASevDB < handle
    %% Initializing components
    properties (Access = private)
        mainFig
        
        %% menus
        optionsMenu
        ephysTypeChangeMenu
        imagingTypeChangeMenu
        runTypeChangeMenu
        
        %% loadPanel
        loadEntryPanel
        entryListBox
        loadEntryButton
        
        %% paramPanel
        paramPanel
        ephysParamTable
        imagingParamTable
        runParamTable
        
        %% plotPanel
        plotPanel
        eventUpButton
        eventDwnButton
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
        loaded = [0,0,0];
        dbFileNames
        currEvent = 1;
        numEvents = 0;
        source
        
        ephysTypeSelected = [1,0,0]; %1==Raw; 2==Bandpass(DoG); 3==Power(InstPow)
        ephysEvents
        
        imagingTypeSelected = [1,0]; %1==Raw; 2==Smoothed
        imagingEvents
        
        runTypeSelected = [1,0,0]; % 1==Velocity; 2==AbsPos; 3==RelPos
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
        function smartplot(gO)
            axVisSwitch(gO,sum(gO.loaded)+(sum(gO.ephysTypeSelected)-1))
            
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
        function ephysPlot(gO,ax)
            type = gO.ephysTypeSelected;
            currEv = gO.currEvent;
            axTag = cell(length(ax),1);
            for i = 1:length(ax)
                axTag{i} = ax.Tag;
            end
            
            dataWin = [];
            yLabels = [];
            plotTitle = [];
            if type(1)
                dataWin = [dataWin; gO.ephysEvents(currEv).DataWin.Raw];
                yLabels = [yLabels; "Voltage [\muV]"];
                plotTitle = [plotTitle; "Raw data"];
            end
            if type(2)
                dataWin = [dataWin; gO.ephysEvents(currEv).DataWin.BP];
                yLabels = [yLabels; "Voltage [\muV]"];
                plotTitle = [plotTitle; "Bandpass filtered data"];
            end
            if type(3)
                dataWin = [dataWin; gO.ephysEvents(currEv).DataWin.Power];
                yLabels = [yLabels; "Power [\muV^2]"];
                plotTitle = [plotTitle; "Instantaneous power of data"];
            end
            taxisWin = gO.ephysEvents(currEv).Taxis;
            
            for i = 1:length(ax)
                plot(ax(i),taxisWin,dataWin(i,:))
                ylabel(ax(i),yLabels(i))
                title(ax(i),plotTitle(i))
                xlabel(ax(i),'Time [s]')
                axis(ax(i),'tight')
                ax(i).Tag = axTag{i};
            end
            
            
            temp = [fieldnames([gO.ephysEvents(currEv).Params]),...
                squeeze(struct2cell([gO.ephysEvents(currEv).Params]))];
            gO.ephysParamTable.Data = temp;
        end
        
        %%
        function imagingPlot(gO,ax)
            type = gO.imagingTypeSelected;
            currEv = gO.currEvent;
            axTag = ax.Tag;
            
            if type(1)
                dataWin = gO.imagingEvents(currEv).DataWin.Raw;
                yLabels = '\DeltaF/F';
                plotTitle = 'Raw imaging data';
            end
            if type(2)
                dataWin = gO.imagingEvents(currEv).DataWin.Smoothed;
                yLabels = '\DeltaF/F';
                plotTitle = 'Smoothed imaging data';
            end
            
            taxisWin = gO.imagingEvents(currEv).Taxis;
            
            plot(ax,taxisWin,dataWin)
            ylabel(ax,yLabels)
            title(ax,plotTitle)
            xlabel(ax,'Time [s]')
            axis(ax,'tight')
            ax.Tag = axTag;
            
            temp = [fieldnames([gO.imagingEvents(currEv).Params]),...
                squeeze(struct2cell([gO.imagingEvents(currEv).Params]))];
            gO.imagingParamTable.Data = temp;
        end
        
        %%
        function runPlot(gO,ax)
            type = gO.runTypeSelected;
            currEv = gO.currEvent;
            axTag = ax.Tag;
            
            if type(1)
                dataWin = gO.runData(currEv).DataWin.Velocity;
                yLabels = 'Velocity [cm/s]';
                plotTitle = 'Velocity on treadmill';
            elseif type(2)
                dataWin = gO.runData(currEv).DataWin.AbsPos;
                yLabels = 'Absolute position [cm]';
                plotTitle = 'Absolute position on treadmill';
            elseif type(3)
                dataWin = gO.runData(currEv).DataWin.RelPos;
                yLabels = 'Relative position [%]';
                plotTitle = 'Relative position on treadmill';
            end
            
            plot(ax,gO.runData(currEv).Taxis,dataWin)
            xlabel(ax,'Time [s]')
            ylabel(ax,yLabels)
            title(ax,plotTitle)
            axis(ax,'tight')
            ax.Tag = axTag;
        end
        
        %%
        function changeCurrEv(gO,upDwn) 
            numEvs = gO.numEvents;
            currEv = gO.currEvent;
            switch upDwn
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
            smartplot(gO)
        end
    end
    
    %% Callback functions
    methods (Access = private)
        %%
        function keyboardPressFcn(gO,~,kD)
            switch kD.Key
                case 'rightarrow'
                    upDwn = 1;
                case 'leftarrow'
                    upDwn = -1;
                case 'uparrow'
                    upDwn = 1;
                case 'downarrow'
                    upDwn = -1;
            end
            changeCurrEv(gO,upDwn)
        end
        
        %%
        function loadEntryButtonPress(gO,~,~)
            selInd = gO.entryListBox.Value;
            gO.currEvent = 1;
            gO.ephysEvents = [];
            gO.imagingEvents = [];
            gO.loaded = [0,0,0];
            gO.ephysParamTable.Data = {};
            gO.ephysParamTable.Visible = 'off';
            gO.imagingParamTable.Data = {};
            gO.imagingParamTable.Visible = 'off';
            
            DASloc = mfilename('fullpath');
            file2load = [DASloc(1:end-7),'DASeventDBdir\',gO.dbFileNames{selInd}];
            load(file2load,'saveStruct');
            if isempty(saveStruct)
                errordlg('Selected entry is empty!')
                return
            end
            
            gO.source = vertcat(saveStruct.source);
            if size(gO.source,1) ~= length(saveStruct)
                gO.source = horzcat(saveStruct.source);
            end
            
%             temp = {'ephysTaxis';'ephysDataWin';'ephysParams';'imagingTaxis';...
%                 'imagingDataWin';'imagingParams';'simultEphysTaxis';...
%                 'simultEphysDataWin';'simultEphysParams';...
%                 'simultImagingTaxis';'simultImagingDataWin';'simultImagingParams'};
%             nameMatch = ismember(temp,string(fieldnames(saveStruct)))
            if isempty(find([saveStruct.simult],1)) && ...
                    ismember('ephysEvents',string(fieldnames(saveStruct)))
                gO.numEvents = length(saveStruct);
                gO.loaded(1) = 1;
                gO.ephysEvents = [saveStruct.ephysEvents];
                gO.ephysParamTable.Visible = 'on';
            end
            
            if isempty(find([saveStruct.simult],1)) && ...
                    ismember('imagingEvents',string(fieldnames(saveStruct)))
                
                gO.numEvents = length(saveStruct);
                gO.loaded(2) = 1;
                gO.imagingEvents = [saveStruct.imagingEvents];
                gO.imagingParamTable.Visible = 'on';
            end
            
            if ~isempty(find([saveStruct.simult],1))
                gO.numEvents = length(saveStruct);
                gO.loaded(1:2) = 1;
                gO.ephysEvents = [saveStruct.ephysEvents];
                gO.imagingEvents = [saveStruct.imagingEvents];
                gO.ephysParamTable.Visible = 'on';
                gO.imagingParamTable.Visible = 'on';
            end
            
            if ismember('runData',string(fieldnames(saveStruct)))
                gO.loaded(3) = 1;
                gO.runData = saveStruct.runData;
            end
            
            smartplot(gO)
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
            
            smartplot(gO)
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
            
            smartplot(gO)
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
            
            smartplot(gO)
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
            gO.ephysTypeChangeMenu = uimenu(gO.optionsMenu,...
                'Text','Change displayed ephys data',...
                'Callback',@ gO.ephysTypeMenuSel);
            gO.imagingTypeChangeMenu = uimenu(gO.optionsMenu,...
                'Text','Change displayed imaging data',...
                'Callback',@ gO.imagingTypeMenuSel);
            gO.runTypeChangeMenu = uimenu(gO.optionsMenu,...
                'Text','Change displayed running data',...
                'Callback',@ gO.runTypeMenuSel);
                
            %% load panel
            gO.loadEntryPanel = uipanel(gO.mainFig,...
                'Position',[0.01, 0.7, 0.2, 0.29],...
                'BorderType','beveledout',...
                'Title','Database entries:');
            
            DASloc = mfilename('fullpath');
            if ~exist([DASloc(1:end-7),'DASeventDBdir\'],'dir')
                DBentryList = {'No DB entries! First create them in DASeV!'};
            else
                DBentryList = dir([DASloc(1:end-7),'DASeventDBdir\','DASeventDB*.mat']);
                if isempty(DBentryList)
                    DBentryList = {'No DB entries! First create them in DASeV!'};
                    gO.loadEntryButton.Enable = 'off';
                else
                    DBentryList = {DBentryList.name};
                    gO.dbFileNames = DBentryList;
                    gO.loadEntryButton.Enable = 'on';
                end
            end
            gO.entryListBox = uicontrol(gO.loadEntryPanel,...
                'Style','listbox',...
                'Units','normalized',...
                'Position',[0.01, 0.15, 0.98, 0.84],...
                'String',DBentryList);
            gO.loadEntryButton = uicontrol(gO.loadEntryPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.75, 0.01, 0.24, 0.1],...
                'String','Load',...
                'Callback',@ gO.loadEntryButtonPress);
            
            %% param panel
            gO.paramPanel = uipanel(gO.mainFig,...
                'Position',[0.01, 0.01, 0.2, 0.65],...
                'BorderType','beveledout',...
                'Title','Event parameters');
            gO.ephysParamTable = uitable(gO.paramPanel,...
                'Units','normalized',...
                'Position',[0.01, 0.7, 0.98, 0.3],...
                'ColumnWidth',{150,75},...
                'ColumnName',{'Electrophysiology','Values'},...
                'RowName',{});
            gO.imagingParamTable = uitable(gO.paramPanel,...
                'Units','normalized',...
                'Position',[0.01, 0.35, 0.98, 0.3],...
                'ColumnWidth',{150,75},...
                'ColumnName',{'Imaging','Values'},...
                'RowName',{});
            
            %% plot panel
            gO.plotPanel = uipanel(gO.mainFig,...
                'Position',[0.22, 0.01, 0.775, 0.98],...
                'BorderType','beveledout',...
                'TItle','Graphs');
            gO.eventUpButton = uicontrol(gO.plotPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.96, 0.95, 0.035, 0.035],...
                'String','<HTML>Event&uarr',...
                'Callback',@(h,e) gO.changeCurrEv(1));
            gO.eventDwnButton = uicontrol(gO.plotPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.96, 0.9, 0.035, 0.035],...
                'String','<HTML>Event&darr',...
                'Callback',@(h,e) gO.changeCurrEv(-1));
            gO.ax11 = axes(gO.plotPanel,'Position',[0.1, 0.2, 0.85, 0.6],...
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
            gO.ax31 = axes(gO.plotPanel,'Position',[0.1, 0.71, 0.85, 0.25],...
                'Visible','off',...
                'Tag','axGroup3');
            gO.ax31.Toolbar.Visible = 'on';
            gO.ax32 = axes(gO.plotPanel,'Position',[0.1, 0.38, 0.85, 0.25],...
                'Visible','off',...
                'Tag','axGroup3');
            gO.ax32.Toolbar.Visible = 'on';
            gO.ax33 = axes(gO.plotPanel,'Position',[0.1, 0.05, 0.85, 0.25],...
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
        end
        
    end
end