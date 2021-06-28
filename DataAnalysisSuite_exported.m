classdef DataAnalysisSuite_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        DataAnalysisSuiteUIFigure      matlab.ui.Figure
        OptionsMenu                    matlab.ui.container.Menu
        timedimChangeMenu              matlab.ui.container.Menu
        MakewindowlargerMenu           matlab.ui.container.Menu
        MakewindowsmallerMenu          matlab.ui.container.Menu
        Panel1Plot                     matlab.ui.container.Panel
        Panel2Plot                     matlab.ui.container.Panel
        Panel3Plot                     matlab.ui.container.Panel
        ModeselectionPanel             matlab.ui.container.Panel
        ephysCheckBox                  matlab.ui.control.CheckBox
        imagingCheckBox                matlab.ui.control.CheckBox
        runCheckBox                    matlab.ui.control.CheckBox
        importPanel                    matlab.ui.container.Panel
        ImportRHDButton                matlab.ui.control.Button
        ImportgorobjButton             matlab.ui.control.Button
        ImportruncsvButton             matlab.ui.control.Button
        Dataselection1Panel            matlab.ui.container.Panel
        DatasetListBoxLabel            matlab.ui.control.Label
        DatasetListBox                 matlab.ui.control.ListBox
        Dataselection2Panel            matlab.ui.container.Panel
        EphysListBoxLabel              matlab.ui.control.Label
        EphysListBox                   matlab.ui.control.ListBox
        ImagingListBoxLabel            matlab.ui.control.Label
        ImagingListBox                 matlab.ui.control.ListBox
        runParamsPanel                 matlab.ui.container.Panel
        InputlicktimemsEditFieldLabel  matlab.ui.control.Label
        InputLickEditField             matlab.ui.control.NumericEditField
        LicksmsListBoxLabel            matlab.ui.control.Label
        LickTimesListBox               matlab.ui.control.ListBox
    end

    
    properties (Access = private)
        timedim = 1;                        % Determines whether the app uses seconds or milliseconds
        datatyp = [0, 0, 0];                % datatypes currently handled (ephys,imaging,running)
        
        xtitle = 'Time [s]';
        
        ephys_data                          % Currently imported electrophysiology data
        ephys_taxis                         % Time axis for electrophysiology data
        ephys_fs                            % Sampling frequency of electrophysiology data
        ephys_ylabel = 'Voltage [\muV]';
        ephys_select                        % Currently selected channel
        ephys_datanames = {''};             % Names of the imported electrophysiology data
        
        imaging_data                        % Currently imported imaging data
        imaging_taxis                       % Time axis for imaging data
        imaging_fs                          % Sampling frequency of imaging data
        imaging_ylabel = '\DeltaF/F';
        imag_select                         % Currently selected ROI
        imag_datanames = {''};              % Names of the imported imaging data
        
        run_pos                             % Currently imported running data
        run_veloc                           % Running velocity
        run_taxis                           % Time axis for running data
        run_fs                              % Sampling frequency of running data
        run_pos_ylabel = 'Pos [%]';
        run_veloc_ylabel = 'Velocity [cm/s]';
        
        winsizes = [1280,780;1600,900;1920,1080;2560,1440;3840,2160];
        
        % The required axes
        axes11
        axes21
        axes22
        axes31
        axes32
        axespos1
        axespos2
        axespos3
        axesveloc1
        axesveloc2
        axesveloc3
    end
    
    methods (Access = private)
        
        function ephysplot(app,ax,index,value)
            if isempty(index) | index == 0
                return
            end
            plot(ax,app.ephys_taxis,app.ephys_data(index,:))
            axis(ax,'tight')
            if length(index) == 1
                title(ax,value,'Interpreter','none')
            elseif length(index) > 1
                multitle = sprintf(' #%d',sort(index));
                title(ax,['Channels:',multitle])
            end
            xlabel(ax,app.xtitle)
            ylabel(ax,app.ephys_ylabel);
            xlimLink(app)
        end
        
        function imagingplot(app,ax,index,value)
            if isempty(index) | index == 0
                return
            end
            plot(ax,app.imaging_taxis,app.imaging_data(index,:))
            axis(ax,'tight')
            if length(index) == 1
                title(ax,value,'Interpreter','none')
            elseif length(index) > 1
                multitle = sprintf(' #%d',sort(index));
                title(ax,['ROIs:',multitle])
            end
            xlabel(ax,app.xtitle)
            ylabel(ax,app.imaging_ylabel);
            xlimLink(app)
        end
        
        function runposplot(app)
            switch sum(app.datatyp)
                case 1
                    ax = app.axespos1;
                case 2
                    ax = app.axespos2;
                case 3 
                    ax = app.axespos3;
            end
            plot(ax,app.run_taxis,app.run_pos)
            axis(ax,'tight')
            title(ax,'Position on treadmill','Interpreter','none')
            xlabel(ax,app.xtitle)
            ylabel(ax,app.run_pos_ylabel)
            xlimLink(app)
        end
    
        function runvelocplot(app)
            switch sum(app.datatyp)
                case 1
                    ax = app.axesveloc1;
                case 2
                    ax = app.axesveloc2;
                case 3 
                    ax = app.axesveloc3;
            end
            plot(ax,app.run_taxis,app.run_veloc)
            axis(ax,'tight')
            title(ax,'Running velocity','Interpreter','none')
            xlabel(ax,app.xtitle)
            ylabel(ax,app.run_veloc_ylabel)
            xlimLink(app)
        end
        
        function plotpanelswitch(app)
            if app.runCheckBox.Value
                switch sum(app.datatyp)
                    case 1
                        app.Panel1Plot.Visible = 'on';
                        app.Panel2Plot.Visible = 'off';
                        app.Panel3Plot.Visible = 'off';
                        cla(app.axes11)
                        app.axes11.Visible = 'off';
                        app.axespos1.Visible = 'on';
                        app.axesveloc1.Visible = 'on';
                        
                        runposplot(app)
                        runvelocplot(app)
                    case 2
                        app.Panel1Plot.Visible = 'off';
                        cla(app.axes22)
                        app.axes22.Visible = 'off';
                        app.axespos2.Visible = 'on';
                        app.axesveloc2.Visible = 'on';
                        app.Panel2Plot.Visible = 'on';
                        app.Panel3Plot.Visible = 'off';
                        
                        runposplot(app)
                        runvelocplot(app)
                        
                        % Plotting previously selected data
                        if app.datatyp(1)
                            ephysplot(app,app.axes21,app.ephys_select,app.ephys_datanames(app.ephys_select))
                        elseif app.datatyp(2)
                            imagingplot(app,app.axes21,app.imag_select,app.imag_datanames(app.imag_select))
                        end
                    case 3
                        app.Panel1Plot.Visible = 'off';
                        app.Panel2Plot.Visible = 'off';
                        app.Panel3Plot.Visible = 'on';
                        
                        runposplot(app)
                        runvelocplot(app)
                        
                        ephysplot(app,app.axes31,app.ephys_select,app.ephys_datanames(app.ephys_select))
                        imagingplot(app,app.axes32,app.imag_select,app.imag_datanames(app.imag_select))
                end
            elseif ~app.runCheckBox.Value
                switch sum(app.datatyp)
                    case 1
                        app.Panel1Plot.Visible = 'on';
                        app.Panel2Plot.Visible = 'off';
                        app.Panel3Plot.Visible = 'off';
                        cla(app.axespos1)
                        app.axespos1.Visible = 'off';
                        cla(app.axesveloc1)
                        app.axesveloc1.Visible = 'off';
                        app.axes11.Visible = 'on';
                        
                        if app.datatyp(1)
                            ephysplot(app,app.axes11,app.ephys_select,app.ephys_datanames(app.ephys_select))
                        elseif app.datatyp(2)
                            imagingplot(app,app.axes11,app.imag_select,app.imag_datanames(app.imag_select))
                        end
                    case 2
                        app.Panel1Plot.Visible = 'off';
                        cla(app.axespos2)
                        app.axespos2.Visible = 'off';
                        cla(app.axesveloc2)
                        app.axesveloc2.Visible = 'off';
                        app.axes22.Visible = 'on';
                        app.Panel2Plot.Visible = 'on';
                        app.Panel3Plot.Visible = 'off';
                        
                        ephysplot(app,app.axes21,app.ephys_select,app.ephys_datanames(app.ephys_select))
                        imagingplot(app,app.axes22,app.imag_select,app.imag_datanames(app.imag_select))
                    case 3
                        warndlg('Something isn''t right')
                end
            end
                
        end
        
        function lickplot(app)
            licks = app.LickTimesListBox.Items;
            licks = str2double(licks);
            allaxes = findobj(app.DataAnalysisSuiteUIFigure,'Type','axes');
            for i = 1:length(allaxes)
                for j = 1:length(licks)
                    yminmax = allaxes(i).YLim;
                    line(allaxes(i),[licks(j),licks(j)],yminmax,'Color','r')
                end
            end
        end
        
        function axesmaker(app)
            app.axes11 = axes(app.Panel1Plot,'Position',[0.1,0.2,0.85,0.6]);
            
            app.axes21 = axes(app.Panel2Plot,'Position',[0.1,0.6,0.85,0.35]);
            app.axes22 = axes(app.Panel2Plot,'Position',[0.1,0.1,0.85,0.35]);
            
            app.axes31 = axes(app.Panel3Plot,'Position',[0.1,0.7,0.85,0.25]);
            app.axes32 = axes(app.Panel3Plot,'Position',[0.1,0.38,0.85,0.25]);
            
            app.axespos1 = axes(app.Panel1Plot,'Position',[0.1,0.2,0.85,0.15]);
            app.axespos1.Visible = 'off';
            app.axesveloc1 = axes(app.Panel1Plot,'Position',[0.1,0.45,0.85,0.3]);
            app.axesveloc1.Visible = 'off';
            
            app.axespos2 = axes(app.Panel2Plot,'Position',[0.1,0.1,0.85,0.1]);
            app.axespos2.Visible = 'off';
            app.axesveloc2 = axes(app.Panel2Plot,'Position',[0.1,0.3,0.85,0.2]);
            app.axesveloc2.Visible = 'off';
            
            app.axespos3 = axes(app.Panel3Plot,'Position',[0.1,0.05,0.85,0.05]);
            app.axesveloc3 = axes(app.Panel3Plot,'Position',[0.1,0.2,0.85,0.1]);
            
            linkaxes([app.axes11,app.axes21,app.axes22,app.axes31,app.axes32,app.axespos1,app.axespos2,app.axespos3,app.axesveloc1,app.axesveloc2,...
                app.axesveloc3],'x')
        end
        
        function xlimLink(app)
%             allaxes = findobj(app.DataAnalysisSuiteUIFigure,'Type','axes');
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
        
        function smartplot(app)
            dtyp = app.datatyp;
            display(dtyp)
            switch sum(dtyp)
                case 1
                    if dtyp(1)
                        ephysplot(app,app.axes11,app.ephys_select,app.ephys_datanames(app.ephys_select))
                    elseif dtyp(2)
                        imagingplot(app,app.axes11,app.imag_select,app.imag_datanames(app.imag_select))
                    elseif dtyp(3)
                        runposplot(app)
                        runvelocplot(app)
                    end
                case 2
                    if dtyp(1)
                        ephysplot(app,app.axes21,app.ephys_select,app.ephys_datanames(app.ephys_select))
                    end
                    if dtyp(2)
                        imagingplot(app,app.axes22,app.imag_select,app.imag_datanames(app.imag_select))
                    end
                    if dtyp(3)
                        runposplot(app)
                        runvelocplot(app)
                    end
                case 3
                    ephysplot(app,app.axes31,app.ephys_select,app.ephys_datanames(app.ephys_select))
                    imagingplot(app,app.axes32,app.imag_select,app.imag_datanames(app.imag_select))
                    runposplot(app)
                    runvelocplot(app)
            end
            xlimLink(app)
        end
    end
 

    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            axesmaker(app)
        end

        % Button pushed function: ImportRHDButton
        function ImportRHDButtonPushed(app, event)
            [filename,path] = uigetfile('*.rhd');
            if filename == 0
                figure(app.DataAnalysisSuiteUIFigure)
                return
            end
%             drawnow;
            figure(app.DataAnalysisSuiteUIFigure)
            oldpath = cd(path);
            data = read_Intan_RHD2000_file_szb(filename);
            cd(oldpath)
            app.ephys_fs = data.fs;
            t_amp = data.t_amplifier;
            data = data.amplifier_data;
            % Check data dimensions
            if size(data,1) > size(data,2)
                data = data';
            end
            
            % Create and store time axis
            app.ephys_taxis = linspace(t_amp(1),length(data)/app.ephys_fs+t_amp(1),length(data));
                        
            % Store imported data in app
            app.ephys_data = data;
            datanames = cell(1,size(data,1));
            for i = 1:size(data,1)
                datanames{i} = [filename,' channel#',num2str(i)]; 
            end
            app.ephys_datanames = datanames;
            
            % Populate selection list with data names
%             if app.datatyp(2) == 0
                app.DatasetListBox.Items = datanames;
%             elseif app.datatyp(2) == 1
                app.EphysListBox.Items = datanames;
%             end
        end

        % Button pushed function: ImportgorobjButton
        function ImportgorobjButtonPushed(app, event)
            % Getting variables from base workspace
            wsvars = evalin('base','whos');
            % Finding gorobj variables
            wsgorinds = strcmp({wsvars.class},'gorobj');
            wsgors = wsvars(wsgorinds);
            % Checking how many gorobjs were detected & if its more than 1, user has to choose
            if length(wsgors)>1
                ind = listdlg('PromptString','Choose which dataset to load!','ListString',{wsgors.name},'SelectionMode','single');
                % Ensuring focus goes back to GUI
                drawnow;
                figure(app.DataAnalysisSuiteUIFigure)
                wsgors = wsgors(ind);
            elseif isempty(wsgors)
                errordlg('There are no gorobj variables in the base workspace (MES Curveanalysis: export -> curves to variable)! Please add them or import data using the other methods!')
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
                    app.imaging_data(ica,:) = get(wsgors(i),'extracty');
                    dtyp(i) = 2;
                    ica = ica+1;
                else
                    app.ephys_data(ie,:) = get(wsgors(i),'extracty');
                    dtyp(i) = 1;
                    ie = ie+1;
                end
                datanames{i} = get(wsgors(i),'name');
            end

            % Insert data names into selection list and extract time axis, while differentiating between ephys and imaging
            if sum(app.datatyp) == 1 || (sum(app.datatyp)==2 && app.datatyp(3)==1)
                if app.datatyp(1)
                    app.DatasetListBox.Items = datanames(dtyp==1);
                    app.EphysListBox.Items = datanames(dtyp==1);
                    app.ephys_datanames = datanames(dtyp==1);
                    taxis = get(wsgors(find(dtyp==1,1)),'x')*(10^-3/app.timedim);
                    app.ephys_fs = 1/taxis(2);
                    app.ephys_taxis = linspace(taxis(1),length(app.ephys_data)/app.ephys_fs+taxis(1),length(app.ephys_data));
                elseif app.datatyp(2)
                    app.DatasetListBox.Items = datanames(dtyp==2);
                    app.ImagingListBox.Items = datanames(dtyp==2);
                    app.imag_datanames = datanames(dtyp==2);
                    taxis = get(wsgors(find(dtyp==2,1)),'x')*(10^-3/app.timedim);
                    app.imaging_fs = 1/taxis(2);
                    app.imaging_taxis = linspace(taxis(1),length(app.imaging_data)/app.imaging_fs+taxis(1),length(app.imaging_data));
                end
            elseif app.datatyp(1) && app.datatyp(2)
                app.EphysListBox.Items = datanames(dtyp==1);
                app.ephys_datanames = datanames(dtyp==1);
                app.ImagingListBox.Items = datanames(dtyp==2);
                app.imag_datanames = datanames(dtyp==2);
                
                if ~isempty(find(dtyp==1, 1))
                    taxis = get(wsgors(find(dtyp==1,1)),'x')*(10^-3/app.timedim);
                    app.ephys_fs = 1/taxis(2);
                    app.ephys_taxis = linspace(taxis(1),length(app.ephys_data)/app.ephys_fs+taxis(1),length(app.ephys_data));
                end
                
                if ~isempty(find(dtyp==2,1))
                    taxis = get(wsgors(find(dtyp==2,1)),'x')*(10^-3/app.timedim);
                    app.imaging_fs = 1/taxis(2);
                    app.imaging_taxis = linspace(taxis(1),length(app.imaging_data)/app.imaging_fs+taxis(1),length(app.imaging_data));
                end
            end
        end

        % Value changed function: DatasetListBox
        function DatasetListBoxValueChanged(app, event)
            value = app.DatasetListBox.Value;
            [~, index] = ismember(value, app.DatasetListBox.Items);
            % Check which data mode we are in and plot accordingly
            if app.datatyp(3)
                if app.datatyp(1)
%                     ephysplot(app,app.axes21,index,value)
                    app.ephys_select = index;
                elseif app.datatyp(2)
%                     imagingplot(app,app.axes21,index,value)
                    app.imag_select = index;
                end
            elseif ~app.datatyp(3)
                if app.datatyp(1)
%                     ephysplot(app,app.axes11,index,value)
                    app.ephys_select = index;
                elseif app.datatyp(2)
%                     imagingplot(app,app.axes11,index,value)
                    app.imag_select = index;
                end
            end
            smartplot(app)

            lickplot(app)
        end

        % Menu selected function: timedimChangeMenu
        function timedimChangeMenuSelected(app, event)
            if app.timedim == 1
                app.xtitle = 'Time [ms]';
                
                app.ephys_taxis = app.ephys_taxis*10^3;
                
                app.imaging_taxis = app.imaging_taxis*10^3;
                
                app.run_taxis = app.run_taxis*10^3;
                
                app.timedim = 10^-3;
            elseif app.timedim == 10^-3
                app.xtitle = 'Time [s]';
                
                app.ephys_taxis = app.ephys_taxis/10^3;
                
                app.imaging_taxis = app.imaging_taxis/10^3;

                app.run_taxis = app.run_taxis/10^3;
                
                app.timedim = 1;
            end
            
%             if app.datatyp(3)
%                 runposplot(app)
%                 runvelocplot(app)
%             end
%             if strcmp(app.Dataselection1Panel.Visible,'on')
%                 DatasetListBoxValueChanged(app,event);
%             elseif strcmp(app.Dataselection2Panel.Visible,'on')           
%                 EphysListBoxValueChanged(app,event);
%                 ImagingListBoxValueChanged(app,event);
%             end

            smartplot(app)
        end

        % Button pushed function: ImportruncsvButton
        function ImportruncsvButtonPushed(app, event)
            % Reading the running data from the csv
            [filename,path] = uigetfile('*.csv');
            if filename == 0
                figure(app.DataAnalysisSuiteUIFigure)
                return
            end
%             drawnow;
            figure(app.DataAnalysisSuiteUIFigure)
            oldpath = cd(path);
            % csvread shouldnt be used starting 2019a !!!
            rundata = csvread(filename,1,0);
            cd(oldpath)
            app.run_pos = rundata(1:end-1,2);
            app.run_veloc = diff(rundata(:,2))./diff(rundata(:,1));
            app.run_taxis = rundata(1:end-1,1)*(10^-3)/app.timedim;
            app.run_fs = mean(gradient(rundata(:,1)));
            
            runposplot(app)
            runvelocplot(app)
            lickplot(app)
        end

        % Value changed function: ephysCheckBox
        function ephysCheckBoxValueChanged(app, event)
            % Determining whether ephys modules are needed
            value = app.ephysCheckBox.Value;
            % Import buttons
            if value
                app.ImportRHDButton.Enable = 'on';
                app.ImportgorobjButton.Enable = 'on';
            elseif ~value
                app.ImportRHDButton.Enable = 'off';
                if ~app.imagingCheckBox.Value
                    app.ImportgorobjButton.Enable = 'off';                    
                end
            end
            
            % Plot panel switching
            app.datatyp = [app.ephysCheckBox.Value, app.imagingCheckBox.Value, app.runCheckBox.Value];
            plotpanelswitch(app)
            
            % Data set panel swithcing
            if value && app.imagingCheckBox.Value
                app.Dataselection1Panel.Visible = 'off';
                app.EphysListBox.Items = app.ephys_datanames;
                app.ImagingListBox.Items = app.imag_datanames;
                app.Dataselection2Panel.Visible = 'on';
            elseif value && ~app.imagingCheckBox.Value
                app.Dataselection2Panel.Visible = 'off';
                app.DatasetListBox.Items = app.ephys_datanames;
                app.Dataselection1Panel.Visible = 'on';                
            elseif ~value && app.imagingCheckBox.Value
                app.Dataselection1Panel.Visible = 'on';
                app.DatasetListBox.Items = app.imag_datanames;
                app.Dataselection2Panel.Visible = 'off';
            elseif ~value && ~app.imagingCheckBox.Value
                app.Dataselection1Panel.Visible = 'on';
                app.Dataselection2Panel.Visible = 'off';
            end
        end

        % Value changed function: imagingCheckBox
        function imagingCheckBoxValueChanged(app, event)
            % Determining whether imaging data modules are needed
            value = app.imagingCheckBox.Value;
            
            % Import buttons
            if value 
                app.ImportgorobjButton.Enable = 'on';
            elseif ~value && ~app.ephysCheckBox.Value
                app.ImportgorobjButton.Enable = 'off';
            end
            
            % Plot panel switching
            app.datatyp = [app.ephysCheckBox.Value, app.imagingCheckBox.Value, app.runCheckBox.Value];
            plotpanelswitch(app)
            
            % Data set panel swithcing
            if value && app.ephysCheckBox.Value
                app.Dataselection2Panel.Visible = 'on';
                app.EphysListBox.Items = app.ephys_datanames;
                app.ImagingListBox.Items = app.imag_datanames;
                app.Dataselection1Panel.Visible = 'off';
            elseif value && ~app.ephysCheckBox.Value
                app.Dataselection1Panel.Visible = 'on';
                app.DatasetListBox.Items = app.imag_datanames;
                app.Dataselection2Panel.Visible = 'off';
            elseif ~value && app.ephysCheckBox.Value
                app.Dataselection1Panel.Visible = 'on';
                app.DatasetListBox.Items = app.ephys_datanames;
                app.Dataselection2Panel.Visible = 'off';
            elseif ~value && ~app.ephysCheckBox.Value
                app.Dataselection1Panel.Visible = 'on';
                app.Dataselection2Panel.Visible = 'off';
            end
        end

        % Value changed function: runCheckBox
        function runCheckBoxValueChanged(app, event)
            % Determining whether running data modules are needed
            value = app.runCheckBox.Value;
            
            % Import buttons
            if value 
                app.ImportruncsvButton.Enable = 'on';
                app.runParamsPanel.Visible = 'on';
            elseif ~value
                app.ImportruncsvButton.Enable = 'off';
                app.runParamsPanel.Visible = 'off';
            end
            
            % Plot panel switching
            app.datatyp = [app.ephysCheckBox.Value, app.imagingCheckBox.Value, app.runCheckBox.Value];
            plotpanelswitch(app)
        end

        % Value changed function: EphysListBox
        function EphysListBoxValueChanged(app, event)
            value = app.EphysListBox.Value;
            [~, index] = ismember(value, app.EphysListBox.Items);
            app.ephys_select = index;
            if sum(app.datatyp) == 2
                ephysplot(app,app.axes21,index,value)
            elseif sum(app.datatyp) == 3
                ephysplot(app,app.axes31,index,value)
            end
            
            lickplot(app)
        end

        % Value changed function: ImagingListBox
        function ImagingListBoxValueChanged(app, event)
            value = app.ImagingListBox.Value;
            [~, index] = ismember(value, app.ImagingListBox.Items);
            app.imag_select = index;
            if sum(app.datatyp) == 2
                imagingplot(app,app.axes22,index,value)
            elseif sum(app.datatyp) == 3
                imagingplot(app,app.axes32,index,value)
            end
            
            lickplot(app)
        end

        % Value changed function: InputLickEditField
        function InputLickEditFieldValueChanged(app, event)
            value = app.InputLickEditField.Value;
            temp = app.LickTimesListBox.Items;
            if isempty(temp)
                temp = {num2str(value)};
            else
                temp = cat(2,temp,num2str(value));
            end
            app.LickTimesListBox.Items = temp;
            lickplot(app)
        end

        % Value changed function: LickTimesListBox
        function LickTimesListBoxValueChanged(app, event)
            value = app.LickTimesListBox.Value;
            numvalue = str2double(value);
            del = questdlg('Delete selected lick time?');
            if strcmp(del,'Yes')
                temp = findobj(app.DataAnalysisSuiteUIFigure,'Type','line');
                for i = 1:length(temp)
                    if (length(temp(i).XData)==2) & (temp(i).XData == [numvalue numvalue])
                        delete(temp(i))
                    end
                end
                [~,idx] = ismember(value,app.LickTimesListBox.Items);
                app.LickTimesListBox.Items(idx) = [];
            end
            
            lickplot(app)
            
            % Set listbox to have no selection (otherwise might be unable to delete 1 remaining lick)
            app.LickTimesListBox.Value = {};
        end

        % Menu selected function: MakewindowlargerMenu
        function MakewindowlargerMenuSelected(app, event)
            pos = app.DataAnalysisSuiteUIFigure.Position;
            monitor = get(0,'screensize');
            currsize = find(app.winsizes == pos(3));
            if (currsize+1 <= length(app.winsizes))
                if app.winsizes(currsize+1) <= monitor(3)
                    pos(1:2) = [0,0];
                    pos(3:4) = app.winsizes(currsize+1,:); 
                    app.DataAnalysisSuiteUIFigure.Position = pos;
                    plotpanelswitch(app)
                end
            end
        end

        % Menu selected function: MakewindowsmallerMenu
        function MakewindowsmallerMenuSelected(app, event)
            pos = app.DataAnalysisSuiteUIFigure.Position;
            currsize = find(app.winsizes == pos(3));
            if (currsize-1 > 0)
                pos(1:2) = [0,0];
                pos(3:4) = app.winsizes(currsize-1,:); 
                app.DataAnalysisSuiteUIFigure.Position = pos;
                plotpanelswitch(app)
            end
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create DataAnalysisSuiteUIFigure
            app.DataAnalysisSuiteUIFigure = uifigure;
            app.DataAnalysisSuiteUIFigure.Position = [1 1 1280 720];
            app.DataAnalysisSuiteUIFigure.Name = 'Data Analysis Suite';
            app.DataAnalysisSuiteUIFigure.Resize = 'off';

            % Create OptionsMenu
            app.OptionsMenu = uimenu(app.DataAnalysisSuiteUIFigure);
            app.OptionsMenu.Text = 'Options';

            % Create timedimChangeMenu
            app.timedimChangeMenu = uimenu(app.OptionsMenu);
            app.timedimChangeMenu.MenuSelectedFcn = createCallbackFcn(app, @timedimChangeMenuSelected, true);
            app.timedimChangeMenu.Text = 'Change between [s]/[ms]';

            % Create MakewindowlargerMenu
            app.MakewindowlargerMenu = uimenu(app.OptionsMenu);
            app.MakewindowlargerMenu.MenuSelectedFcn = createCallbackFcn(app, @MakewindowlargerMenuSelected, true);
            app.MakewindowlargerMenu.Text = 'Make window larger';

            % Create MakewindowsmallerMenu
            app.MakewindowsmallerMenu = uimenu(app.OptionsMenu);
            app.MakewindowsmallerMenu.MenuSelectedFcn = createCallbackFcn(app, @MakewindowsmallerMenuSelected, true);
            app.MakewindowsmallerMenu.Text = 'Make window smaller';

            % Create Panel1Plot
            app.Panel1Plot = uipanel(app.DataAnalysisSuiteUIFigure);
            app.Panel1Plot.Position = [420 1 861 719];

            % Create Panel2Plot
            app.Panel2Plot = uipanel(app.DataAnalysisSuiteUIFigure);
            app.Panel2Plot.Visible = 'off';
            app.Panel2Plot.Position = [420 1 861 719];

            % Create Panel3Plot
            app.Panel3Plot = uipanel(app.DataAnalysisSuiteUIFigure);
            app.Panel3Plot.Visible = 'off';
            app.Panel3Plot.Position = [420 1 861 719];

            % Create ModeselectionPanel
            app.ModeselectionPanel = uipanel(app.DataAnalysisSuiteUIFigure);
            app.ModeselectionPanel.Title = 'Mode selection';
            app.ModeselectionPanel.Position = [11 655 401 56];

            % Create ephysCheckBox
            app.ephysCheckBox = uicheckbox(app.ModeselectionPanel);
            app.ephysCheckBox.ValueChangedFcn = createCallbackFcn(app, @ephysCheckBoxValueChanged, true);
            app.ephysCheckBox.Text = 'Electrophysiology';
            app.ephysCheckBox.Position = [5 9 116 22];

            % Create imagingCheckBox
            app.imagingCheckBox = uicheckbox(app.ModeselectionPanel);
            app.imagingCheckBox.ValueChangedFcn = createCallbackFcn(app, @imagingCheckBoxValueChanged, true);
            app.imagingCheckBox.Text = 'Imaging data (Ca2+)';
            app.imagingCheckBox.Position = [152 9 132 22];

            % Create runCheckBox
            app.runCheckBox = uicheckbox(app.ModeselectionPanel);
            app.runCheckBox.ValueChangedFcn = createCallbackFcn(app, @runCheckBoxValueChanged, true);
            app.runCheckBox.Text = 'Running data';
            app.runCheckBox.Position = [306 9 94 22];

            % Create importPanel
            app.importPanel = uipanel(app.DataAnalysisSuiteUIFigure);
            app.importPanel.Title = 'Import data';
            app.importPanel.Position = [11 577 400 64];

            % Create ImportRHDButton
            app.ImportRHDButton = uibutton(app.importPanel, 'push');
            app.ImportRHDButton.ButtonPushedFcn = createCallbackFcn(app, @ImportRHDButtonPushed, true);
            app.ImportRHDButton.Enable = 'off';
            app.ImportRHDButton.Position = [21 12 100 22];
            app.ImportRHDButton.Text = 'Import RHD';

            % Create ImportgorobjButton
            app.ImportgorobjButton = uibutton(app.importPanel, 'push');
            app.ImportgorobjButton.ButtonPushedFcn = createCallbackFcn(app, @ImportgorobjButtonPushed, true);
            app.ImportgorobjButton.Enable = 'off';
            app.ImportgorobjButton.Position = [151 12 100 22];
            app.ImportgorobjButton.Text = 'Import gorobj';

            % Create ImportruncsvButton
            app.ImportruncsvButton = uibutton(app.importPanel, 'push');
            app.ImportruncsvButton.ButtonPushedFcn = createCallbackFcn(app, @ImportruncsvButtonPushed, true);
            app.ImportruncsvButton.Enable = 'off';
            app.ImportruncsvButton.Position = [281 12 100 22];
            app.ImportruncsvButton.Text = 'Import run csv';

            % Create Dataselection1Panel
            app.Dataselection1Panel = uipanel(app.DataAnalysisSuiteUIFigure);
            app.Dataselection1Panel.Title = 'Data selection';
            app.Dataselection1Panel.Position = [11 231 400 330];

            % Create DatasetListBoxLabel
            app.DatasetListBoxLabel = uilabel(app.Dataselection1Panel);
            app.DatasetListBoxLabel.HorizontalAlignment = 'right';
            app.DatasetListBoxLabel.Position = [1 226 47 22];
            app.DatasetListBoxLabel.Text = 'Dataset';

            % Create DatasetListBox
            app.DatasetListBox = uilistbox(app.Dataselection1Panel);
            app.DatasetListBox.Items = {};
            app.DatasetListBox.Multiselect = 'on';
            app.DatasetListBox.ValueChangedFcn = createCallbackFcn(app, @DatasetListBoxValueChanged, true);
            app.DatasetListBox.Position = [63 80 329 170];
            app.DatasetListBox.Value = {};

            % Create Dataselection2Panel
            app.Dataselection2Panel = uipanel(app.DataAnalysisSuiteUIFigure);
            app.Dataselection2Panel.Title = 'Data selection';
            app.Dataselection2Panel.Visible = 'off';
            app.Dataselection2Panel.Position = [11 231 400 330];

            % Create EphysListBoxLabel
            app.EphysListBoxLabel = uilabel(app.Dataselection2Panel);
            app.EphysListBoxLabel.HorizontalAlignment = 'right';
            app.EphysListBoxLabel.Position = [9 286 39 22];
            app.EphysListBoxLabel.Text = 'Ephys';

            % Create EphysListBox
            app.EphysListBox = uilistbox(app.Dataselection2Panel);
            app.EphysListBox.Items = {};
            app.EphysListBox.Multiselect = 'on';
            app.EphysListBox.ValueChangedFcn = createCallbackFcn(app, @EphysListBoxValueChanged, true);
            app.EphysListBox.Position = [63 170 329 140];
            app.EphysListBox.Value = {};

            % Create ImagingListBoxLabel
            app.ImagingListBoxLabel = uilabel(app.Dataselection2Panel);
            app.ImagingListBoxLabel.HorizontalAlignment = 'right';
            app.ImagingListBoxLabel.Position = [0 136 48 22];
            app.ImagingListBoxLabel.Text = 'Imaging';

            % Create ImagingListBox
            app.ImagingListBox = uilistbox(app.Dataselection2Panel);
            app.ImagingListBox.Items = {};
            app.ImagingListBox.Multiselect = 'on';
            app.ImagingListBox.ValueChangedFcn = createCallbackFcn(app, @ImagingListBoxValueChanged, true);
            app.ImagingListBox.Position = [63 10 329 150];
            app.ImagingListBox.Value = {};

            % Create runParamsPanel
            app.runParamsPanel = uipanel(app.DataAnalysisSuiteUIFigure);
            app.runParamsPanel.Visible = 'off';
            app.runParamsPanel.Position = [12 55 399 158];

            % Create InputlicktimemsEditFieldLabel
            app.InputlicktimemsEditFieldLabel = uilabel(app.runParamsPanel);
            app.InputlicktimemsEditFieldLabel.HorizontalAlignment = 'right';
            app.InputlicktimemsEditFieldLabel.Position = [8 125 105 22];
            app.InputlicktimemsEditFieldLabel.Text = 'Input lick time [ms]';

            % Create InputLickEditField
            app.InputLickEditField = uieditfield(app.runParamsPanel, 'numeric');
            app.InputLickEditField.ValueChangedFcn = createCallbackFcn(app, @InputLickEditFieldValueChanged, true);
            app.InputLickEditField.Position = [128 125 68 22];

            % Create LicksmsListBoxLabel
            app.LicksmsListBoxLabel = uilabel(app.runParamsPanel);
            app.LicksmsListBoxLabel.HorizontalAlignment = 'right';
            app.LicksmsListBoxLabel.Position = [8 75 59 22];
            app.LicksmsListBoxLabel.Text = 'Licks [ms]';

            % Create LickTimesListBox
            app.LickTimesListBox = uilistbox(app.runParamsPanel);
            app.LickTimesListBox.Items = {};
            app.LickTimesListBox.ValueChangedFcn = createCallbackFcn(app, @LickTimesListBoxValueChanged, true);
            app.LickTimesListBox.Position = [112 25 84 74];
            app.LickTimesListBox.Value = {};
        end
    end

    methods (Access = public)

        % Construct app
        function app = DataAnalysisSuite_exported

            % Create and configure components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.DataAnalysisSuiteUIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.DataAnalysisSuiteUIFigure)
        end
    end
end