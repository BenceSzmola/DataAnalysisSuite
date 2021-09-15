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
        
        ephysTypeSelected
        ephysEvents
        ephysParams
        
        imagingTypeSelected
        imagingEvents
        imagingParams
        
        runTypeSelected
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
            
            set(actAxes,'Visible','on')
            set(inactAxes,'Visible','off')
            
            setAllowAxesZoom(zum,actAxes,true)
            setAllowAxesZoom(zum,inactAxes,false)
            setAllowAxesPan(panobj,actAxes,true)
            setAllowAxesPan(panobj,inactAxes,false)
            for i = 1:length(inactAx)
                cla(inactAx(i))
            end
            
            drawnow
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
        function ephysPlot(gO)
            
        end
        
        %%
        function imagingPlot(gO)
            
        end
        
        %%
        function runPlot(gO)
            
        end
    end
    
    %% Callback functions
    methods (Access = private)
        %%
        function keyboardPressFcn(gO,~,kD)
            
        end
        
        %%
        function loadEntryButtonPress(gO,~,~)
            selInd = gO.entryListBox.Value;
            
            DASloc = mfilename('fullpath');
            file2load = [DASloc(1:end-7),'DASeventDBdir\',gO.dbFileNames{selInd}];
            load(file2load,'saveStruct');
            
            temp = {'ephysTaxis';'ephysDataWin';'ephysParams'};
            if sum(strcmp(fieldnames(saveStruct),temp)) == 3
                
            end
            
%             temp = 
        end
    end
    
    %% gui component initialization and construction
    methods (Access = private)
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
                'Text','Change displayed ephys data');
            gO.imagingTypeChangeMenu = uimenu(gO.optionsMenu,...
                'Text','Change displayed imaging data');
            gO.runTypeChangeMenu = uimenu(gO.optionsMenu,...
                'Text','Change displayed running data');
                
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
            
            %% plot panel
            gO.plotPanel = uipanel(gO.mainFig,...
                'Position',[0.22, 0.01, 0.775, 0.98],...
                'BorderType','beveledout',...
                'TItle','Graphs');
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