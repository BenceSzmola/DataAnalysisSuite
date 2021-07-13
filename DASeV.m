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
        ephysDetTypeLabel
        ephysDetTypeTxt
        ephysChanLabel
        ephysChanTxt
        ephysParamTable
        
        
        loadDASSaveButt
        
        %% viewerTab members
        statPanel
        
        plotPanel
        ephysDetUpButt
        ephysDetDwnButt
        ephysChanUpButt
        ephysChanDwnButt
        imagingDetUpButt
        imagingDetDwnButt
        imagingRoiUpButt
        imagingRoiDwnButt
        
        
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
        
        %% ephys stuff
        highPassRawEphys = 0;
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
        ephysCurrDetNum = 1;
        ephysCurrDetRow = 1;
        
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
            allAx = findobj(allAx,'Visible','off');
            for i = 1:length(allAx)
                cla(allAx(i))
            end
            
            drawnow
        end
        
        %%
        function ephysPlot(gO,ax)
            currDetNum = gO.ephysCurrDetNum;
            currDetRow = gO.ephysCurrDetRow;
            numDets = length(find(~isnan(gO.ephysDets(currDetRow,:))));
            chan = gO.ephysDetInfo(currDetRow).Channel;
            
            if ~gO.plotFull
                gO.ephysDetUpButt.Enable = 'on';
                gO.ephysDetDwnButt.Enable = 'on';
                
                detIdx = gO.ephysDets(currDetRow,:);
                detIdx = find(~isnan(detIdx));
                detIdx = detIdx(currDetNum);
                tDetInds = gO.ephysTaxis(detIdx);

                win = 0.5;
                win = round(win*gO.ephysFs,4);
                
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
                axTitle = ['Channel #',num2str(chan),'      Detection #',...
                                num2str(currDetNum),'/',num2str(numDets)];
            elseif gO.plotFull
                gO.ephysDetUpButt.Enable = 'off';
                gO.ephysDetDwnButt.Enable = 'off';
                gO.ephysCurrDetNum = 1;
                
                detInds = gO.ephysDets(currDetRow,:);
                detInds = find(~isnan(detInds));
                tDetInds = gO.ephysTaxis(detInds);
                
                winIdx = 1:length(gO.ephysTaxis);
                tWin = gO.ephysTaxis;
                
                axTitle = ['Channel #',num2str(chan),'      #Detections = ',...
                    num2str(numDets)];
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
                            axLims = [tWin(1), tWin(end), min(temp), max(temp)];
                        elseif gO.highPassRawEphys == 0
                            data = gO.ephysData(chan,winIdx);
                            axLims = [tWin(1), tWin(end),...
                                min(gO.ephysData(chan,:)), max(gO.ephysData(chan,:))];
                        end
                        yLabels = string(gO.ephysYlabel);
                    elseif gO.ephysTypSelected(2)
                        data = gO.ephysDoGGed(chan,winIdx);
                        axLims = [tWin(1), tWin(end),...
                            min(gO.ephysDoGGed(chan,:)), max(gO.ephysDoGGed(chan,:))];
                        yLabels = string(gO.ephysYlabel);
                    elseif gO.ephysTypSelected(3)
                        data = gO.ephysInstPow(chan,winIdx);
                        axLims = [tWin(1), tWin(end),...
                            min(gO.ephysInstPow(chan,:)), max(gO.ephysInstPow(chan,:))];
                        temp = find(gO.ephysYlabel=='[');
                        yLabels = string(['Power ',gO.ephysYlabel(temp:end-1),...
                                '^2]']);
                    end
                case 2
                    if gO.ephysTypSelected(1)
                        if gO.highPassRawEphys == 1
                            tempfull = filtfilt(b,a,gO.ephysData(chan,:));
                            temp = tempfull(winIdx);
                            axLims = [axLims; tWin(1), tWin(end),...
                                min(tempfull), max(tempfull)];
                        elseif gO.highPassRawEphys == 0
                            temp = gO.ephysData(chan,winIdx);
                            axLims = [axLims; tWin(1), tWin(end),...
                                min(gO.ephysData(chan,:)), max(gO.ephysData(chan,:))];
                        end
                        data = [data; temp];
                        yLabels = [string(yLabels); string(gO.ephysYlabel)];
                    end
                    if gO.ephysTypSelected(2)
                        data = [data; gO.ephysDoGGed(chan,winIdx)];
                        axLims = [axLims; tWin(1), tWin(end),...
                            min(gO.ephysDoGGed(chan,:)), max(gO.ephysDoGGed(chan,:))];
                        yLabels = [string(yLabels); string(gO.ephysYlabel)];
                    end
                    if gO.ephysTypSelected(3)
                        data = [data; gO.ephysInstPow(chan,winIdx)];
                        axLims = [axLims; tWin(1), tWin(end),...
                            min(gO.ephysInstPow(chan,:)), max(gO.ephysInstPow(chan,:))];
                        temp = find(gO.ephysYlabel=='[');
                        yLabels = [string(yLabels); string(['Power ',gO.ephysYlabel(temp:end-1),...
                                '^2]'])];
                    end
                case 3
                    if gO.highPassRawEphys == 1
                        tempfull = filtfilt(b,a,gO.ephysData(chan,:));
                        temp = tempfull(winIdx);
                        axLims = [tWin(1), tWin(end),...
                            min(tempfull), max(tempfull)];
                    elseif gO.highPassRawEphys == 0
                        temp = gO.ephysData(chan,winIdx);
                        axLims = [tWin(1), tWin(end),...
                            min(gO.ephysData(chan,:)), max(gO.ephysData(chan,:))];
                    end
                    data = [temp;...
                        gO.ephysDoGGed(chan,winIdx);...
                        gO.ephysInstPow(chan,winIdx)];
                    axLims = [axLims; axLims(1:2), ...
                        min(gO.ephysDoGGed(chan,:)), max(gO.ephysDoGGed(chan,:));
                        axLims(1:2), min(gO.ephysInstPow(chan,:)), max(gO.ephysInstPow(chan,:))];
                    temp = find(gO.ephysYlabel=='[');
                    yLabels = [string(gO.ephysYlabel); string(gO.ephysYlabel);...
                        string(['Power ',gO.ephysYlabel(temp:end-1),...
                                '^2]'])];
            end
            
            for i = 1:min(size(data))
                linia=plot(ax(i),tWin,data(i,:));
                assignin('base','linia',linia)
                hold(ax(i),'on')
                for j = 1:length(tDetInds)
                    line(ax(i),[tDetInds(j), tDetInds(j)],axLims(i,3:4),...
                        'Color','r')
                end
                hold(ax(i),'off')
                xlabel(ax(i),gO.xLabel)
                ylabel(ax(i),yLabels(i,:))
                axis(ax(i),axLims(i,:))
                title(ax(i),axTitle)
                
%                 z = zoom(gO.mainFig);
%                 setAllowAxesZoom(z,ax(i),1)
%                 getAxesZoomConstraint(z,ax(i))
            end
            
        end
        
        %% 
        function smartplot(gO)
            axVisSwitch(gO,sum(gO.loaded)+(sum(gO.ephysTypSelected)-1))
%             axVisSwitch(gO,4)
            
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
                        ephysPlot(gO,ax)
                    elseif gO.loaded(2)
                        
                    elseif gO.loaded(3)
                        
                    end
                case 2
                    if gO.loaded(1)
                        switch sum(gO.ephysTypSelected)
                            case 1
                                ax = [gO.ax21];
                            case 2
                                ax = [gO.ax31, gO.ax32];
                            case 3
                                ax = [gO.ax41, gO.ax42, gO.ax43];
                        end
                        ephysPlot(gO,ax)
                    end
                case 3
                    if gO.loaded(1)
                        switch sum(gO.ephysTypSelected)
                            case 1
                                ax = [gO.ax31];
                            case 2
                                ax = [gO.ax41, gO.ax42];
                            case 3
                                ax = [gO.ax51, gO.ax52, gO.ax53];
                        end
                        ephysPlot(gO,ax)
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
            
            smartplot(gO,0)
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
            
            gO.ephysCurrDetNum = 1;
            gO.ephysCurrDetRow = 1;
            
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
        
        function axButtPress(gO,dTyp,detUpDwn,chanUpDwn)
            switch dTyp
                case 1
                    if chanUpDwn ~= 0
                        gO.ephysCurrDetNum = 1;
                    end
                    
                    switch detUpDwn
                        case 1
                            if gO.ephysCurrDetNum < length(find(~isnan(gO.ephysDets(gO.ephysCurrDetRow,:))))
                                gO.ephysCurrDetNum = gO.ephysCurrDetNum + 1;
                            end
                        case -1
                            if gO.ephysCurrDetNum > 1
                                gO.ephysCurrDetNum = gO.ephysCurrDetNum - 1;
                            end
                    end
                    switch chanUpDwn
                        case 1
                            if gO.ephysCurrDetRow < min(size(gO.ephysDets))
                                gO.ephysCurrDetRow = gO.ephysCurrDetRow + 1;
                            end
                        case -1
                            if gO.ephysCurrDetRow > 1
                                gO.ephysCurrDetRow = gO.ephysCurrDetRow -1;
                            end
                    end
                case 2
                    
                case 3
            end
            smartplot(gO)
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
            gO.ephysDetUpButt = uicontrol(gO.plotPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.965, 0.95, 0.035, 0.05],...
                'String','<HTML>Det&uarr',...
                'Callback',@(h,e) gO.axButtPress(1,1,0));
            gO.ephysDetDwnButt = uicontrol(gO.plotPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.965, 0.9, 0.035, 0.05],...
                'String','<HTML>Det&darr',...
                'Callback',@(h,e) gO.axButtPress(1,-1,0));
            gO.ephysChanUpButt = uicontrol(gO.plotPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.965, 0.85, 0.035, 0.05],...
                'String','<HTML>Chan&uarr',...
                'Callback',@(h,e) gO.axButtPress(1,0,1));
            gO.ephysChanDwnButt = uicontrol(gO.plotPanel,...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[0.965, 0.8, 0.035, 0.05],...
                'String','<HTML>Chan&darr',...
                'Callback',@(h,e) gO.axButtPress(1,0,-1));

            gO.ax11 = axes(gO.plotPanel,'Position',[0.1, 0.2, 0.85, 0.6],...
                'Visible','off');
            gO.ax11.Toolbar.Visible = 'on';
            gO.ax21 = axes(gO.plotPanel,'Position',[0.1, 0.5, 0.85, 0.4],...
                'Visible','off');
            gO.ax21.Toolbar.Visible = 'on';
            gO.ax22 = axes(gO.plotPanel,'Position',[0.1, 0.05, 0.85, 0.4],...
                'Visible','off');
            gO.ax22.Toolbar.Visible = 'on';
            align([gO.ax21,gO.ax22],'Distribute','Distribute')
            linkaxes([gO.ax21,gO.ax22],'x')
            gO.ax31 = axes(gO.plotPanel,'Position',[0.1, 0.7, 0.85, 0.25],...
                'Visible','off');
            gO.ax31.Toolbar.Visible = 'on';
            gO.ax32 = axes(gO.plotPanel,'Position',[0.1, 0.4, 0.85, 0.25],...
                'Visible','off');
            gO.ax32.Toolbar.Visible = 'on';
            gO.ax33 = axes(gO.plotPanel,'Position',[0.1, 0.05, 0.85, 0.25],...
                'Visible','off');
            gO.ax33.Toolbar.Visible = 'on';
            align([gO.ax31,gO.ax32,gO.ax33],'Distribute','Distribute')
            linkaxes([gO.ax31,gO.ax32,gO.ax33],'x')
            gO.ax41 = axes(gO.plotPanel,'Position',[0.1, 0.75, 0.85, 0.2],...
                'Visible','off');
            gO.ax41.Toolbar.Visible = 'on';
            gO.ax42 = axes(gO.plotPanel,'Position',[0.1, 0.55, 0.85, 0.2],...
                'Visible','off');
            gO.ax42.Toolbar.Visible = 'on';
            gO.ax43 = axes(gO.plotPanel,'Position',[0.1, 0.35, 0.85, 0.2],...
                'Visible','off');
            gO.ax43.Toolbar.Visible = 'on';
            gO.ax44 = axes(gO.plotPanel,'Position',[0.1, 0.05, 0.85, 0.2],...
                'Visible','off');
            gO.ax44.Toolbar.Visible = 'on';
            align([gO.ax41,gO.ax42,gO.ax43,gO.ax44],'Distribute','Distribute')
            linkaxes([gO.ax41,gO.ax42,gO.ax43,gO.ax44],'x')
            gO.ax51 = axes(gO.plotPanel,'Position',[0.1, 0.8, 0.85, 0.18],...
                'Visible','off');
            gO.ax51.Toolbar.Visible = 'on';
            gO.ax52 = axes(gO.plotPanel,'Position',[0.1, 0.6, 0.85, 0.18],...
                'Visible','off');
            gO.ax52.Toolbar.Visible = 'on';
            gO.ax53 = axes(gO.plotPanel,'Position',[0.1, 0.4, 0.85, 0.18],...
                'Visible','off');
            gO.ax53.Toolbar.Visible = 'on';
            gO.ax54 = axes(gO.plotPanel,'Position',[0.1, 0.2, 0.85, 0.18],...
                'Visible','off');
            gO.ax54.Toolbar.Visible = 'on';
            gO.ax55 = axes(gO.plotPanel,'Position',[0.1, 0.05, 0.85, 0.18],...
                'Visible','off');
            gO.ax55.Toolbar.Visible = 'on';
            align([gO.ax51,gO.ax52,gO.ax53,gO.ax54,gO.ax55],'Distribute','Distribute')
            linkaxes([gO.ax51,gO.ax52,gO.ax53,gO.ax54,gO.ax55],'x')
        end
    end
end