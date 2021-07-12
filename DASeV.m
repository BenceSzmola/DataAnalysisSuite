classdef DASeV < handle
    %% Initializing components
    properties (Access = private)
        mainFig
        
        %% menus
        optMenu
        ephysTypMenu
        
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
        ephysDetTypeLabel
        ephysDetTypeTxt
        ephysChanLabel
        ephysChanTxt
        ephysParamTable
        
        
        loadDASSaveButt
        
        %% viewerTab members
        statPanel
        
        plotPanel
        
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
        
        %% ephys stuff
        ephysTypSelected = [1,0,0]; % raw-dog-instpow
        ephysData
        ephysDoGGed
        ephysInstPow
        ephysFs
        ephysTaxis
        ephysParams
        ephysStats
        ephysDets
        ephysYlabel
        ephysDetInfo
        
        %% imaging
        imagingData
        imagingFs
        imagingTaxis
        imagingYlabel
    end
    
    %% Constructor part
    methods (Access = public)
        %% Constructor function
        function gO = DASeV
            createComponents(gO)
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
            drawnow
        end
        
        %%
        function ephysPlot(gO,ax,typ,plotFull,chan,detNum)
            
        end
        
        %% 
        function smartplot(gO,plotFull,chan,detNum)
            axVisSwitch(gO,sum(gO.loaded)+(sum(gO.ephysTypSelected)-1))
%             axVisSwitch(gO,4)
            
            switch sum(gO.loaded)
                case 1
                    if gO.loaded(1)
                        switch sum(gO.ephysTypSelected)
                            case 1
                                
                            case 2
                                
                            case 3
                                
                        end
                    elseif gO.loaded(2)
                        
                    elseif gO.loaded(3)
                        
                    end
                case 2
                    
                case 3
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
            newdir = [newdir,'\DASsave*.mat'];
            newlist = dir(newdir);
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
            
            try
                load(fname,'ephysSaveData','ephysSaveInfo')

                gO.ephysData = ephysSaveData.RawData;
                gO.ephysFs = ephysSaveData.Fs;
                gO.ephysTaxis = ephysSaveData.TAxis;
                gO.ephysYlabel = ephysSaveData.YLabel;
                gO.ephysDets = ephysSaveData.Dets;
                gO.ephysDetInfo = ephysSaveInfo;

            catch
                gO.loaded(1) = 0;
            end
            
            if exist('ephysSaveData','var')
                gO.loaded(1) = 1;
                gO.ephysDoGGed = DoG(gO.ephysData,gO.ephysFs,150,250);
                gO.ephysInstPow = instPow(gO.ephysData,gO.ephysFs,150,250);
            end
            
            try 
                load(fname,'imagingSaveData','imagingSaveInfo')
                
            catch
                gO.loaded(2) = 0;
            end
            
            if exist('imagingSaveData','var')
                gO.loaded(2) = 1;
            end
            
            if ~isempty(find(gO.loaded, 1))
                gO.tabgrp.SelectedTab = gO.tabgrp.Children(2);

                smartplot(gO)
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
            load(fname,'ephysSaveInfo')
            
            gO.fnameTxt.String = fname;
            gO.ephysDetTypeTxt.String = ephysSaveInfo.DetType;
            gO.ephysChanTxt.String = num2str([ephysSaveInfo.Channel]);
            gO.ephysParamTable.Data = squeeze(struct2cell([ephysSaveInfo.Params]))';
            gO.ephysParamTable.ColumnName = fieldnames([ephysSaveInfo.Params]);
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
                'MenuBar','none');
            
            %% Menus
            gO.optMenu = uimenu(gO.mainFig,...
                'Text','Options');
            gO.ephysTypMenu = uimenu(gO.optMenu,...
                'Text','Ephys data type selection',...
                'MenuSelectedFcn',@ gO.ephysTypMenuSel);
            
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
                'Position',[0.05, 0.85, 0.1, 0.05],...
                'String','Change directory',...
                'Callback',@ gO.selDirButtPress);
            gO.loadDASSaveButt = uicontrol(gO.loadTab,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.05, 0.65, 0.1, 0.05],...
                'String','Load selected save',...
                'Callback',@ gO.loadSaveButtPress);
            initFileList = dir('DASsave*.mat');
            initFileList = {initFileList.name};
            gO.fileList = uicontrol(gO.loadTab,...
                'Style','listbox',...
                'Units','normalized',...
                'Position',[0.37,0.1,0.3,0.9],...
                'String',initFileList,...
                'Callback',@ gO.fileListSel);
            gO.fileInfoPanel = uipanel(gO.loadTab,...
                'Position',[0.69,0.1,0.3,0.9]);
            gO.fnameLabel = uicontrol(gO.fileInfoPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.01, 0.89, 0.45, 0.1],...
                'String','File name:');
            gO.fnameTxt = uicontrol(gO.fileInfoPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.54, 0.89, 0.45, 0.1]);
            gO.ephysDetTypeLabel = uicontrol(gO.fileInfoPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.01, 0.77, 0.45, 0.1],...
                'String','Detection type:');
            gO.ephysDetTypeTxt = uicontrol(gO.fileInfoPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.54, 0.77, 0.45, 0.1]);
            gO.ephysChanLabel = uicontrol(gO.fileInfoPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.01, 0.65, 0.45, 0.1],...
                'String','Channel #:');
            gO.ephysChanTxt = uicontrol(gO.fileInfoPanel,...
                'Style','text',...
                'Units','normalized',...
                'Position',[0.54, 0.65, 0.45, 0.1]);
            gO.ephysParamTable = uitable(gO.fileInfoPanel,...
                'Units','normalized',...
                'Position',[0.2, 0.4, 0.6, 0.2]);
            
            %% viewerTab members
            gO.statPanel = uipanel(gO.viewerTab,...
                'Position',[0, 0, 0.3, 1]);
            
            gO.plotPanel = uipanel(gO.viewerTab,...
                'Position',[0.3, 0, 0.7, 1]);
            

            gO.ax11 = axes(gO.plotPanel,'Position',[0.05, 0.2, 0.9, 0.6],...
                'Visible','off');
            gO.ax21 = axes(gO.plotPanel,'Position',[0.05, 0.5, 0.9, 0.4],...
                'Visible','off');
            gO.ax22 = axes(gO.plotPanel,'Position',[0.05, 0.05, 0.9, 0.4],...
                'Visible','off');
            align([gO.ax21,gO.ax22],'Distribute','Distribute')
            gO.ax31 = axes(gO.plotPanel,'Position',[0.05, 0.7, 0.9, 0.25],...
                'Visible','off');
            gO.ax32 = axes(gO.plotPanel,'Position',[0.05, 0.4, 0.9, 0.25],...
                'Visible','off');
            gO.ax33 = axes(gO.plotPanel,'Position',[0.05, 0.05, 0.9, 0.25],...
                'Visible','off');
            align([gO.ax31,gO.ax32,gO.ax33],'Distribute','Distribute')
            gO.ax41 = axes(gO.plotPanel,'Position',[0.05, 0.75, 0.9, 0.2],...
                'Visible','off');
            gO.ax42 = axes(gO.plotPanel,'Position',[0.05, 0.55, 0.9, 0.2],...
                'Visible','off');
            gO.ax43 = axes(gO.plotPanel,'Position',[0.05, 0.35, 0.9, 0.2],...
                'Visible','off');
            gO.ax44 = axes(gO.plotPanel,'Position',[0.05, 0.05, 0.9, 0.2],...
                'Visible','off');
            align([gO.ax41,gO.ax42,gO.ax43,gO.ax44],'Distribute','Distribute')
            gO.ax51 = axes(gO.plotPanel,'Position',[0.05, 0.8, 0.9, 0.18],...
                'Visible','off');
            gO.ax52 = axes(gO.plotPanel,'Position',[0.05, 0.6, 0.9, 0.18],...
                'Visible','off');
            gO.ax53 = axes(gO.plotPanel,'Position',[0.05, 0.4, 0.9, 0.18],...
                'Visible','off');
            gO.ax54 = axes(gO.plotPanel,'Position',[0.05, 0.2, 0.9, 0.18],...
                'Visible','off');
            gO.ax55 = axes(gO.plotPanel,'Position',[0.05, 0.05, 0.9, 0.18],...
                'Visible','off');
            align([gO.ax51,gO.ax52,gO.ax53,gO.ax54,gO.ax55],'Distribute','Distribute')
        end
    end
end