classdef detAlgSettingGUI < handle

    %%
    properties 
        %% data
        detAlg
        algSett
        fields2conv = {'winLen','envWinLen','clustGapFillLen','clustGapMinLen','clustIvLen','envThrCrossMinLen'};
        fs

        %% UI components
        mainFig
        inputPanels
    end

    %%
    methods (Access = public)
        %%
        function gO = detAlgSettingGUI(detAlg,fs,justSett)
            if nargin < 2
                errordlg('To call this GUI 2 inputs are needed! (Algorithm name, sampling rate)')
                clear gO
                return
            elseif nargin >= 2
                gO.detAlg = detAlg;
                
                if nargin < 3
                    gO.fs     = fs;
                    loadPrevSetts(gO)
    
                    initializeComps(gO)
                    gO.mainFig.Visible =  'on';
                else
                    switch justSett
                        case 'def'
                            loadDefSetts(gO)
                        case 'prev'
                            loadPrevSetts(gO)
                    end
                end
            end
            
            if nargout == 0
                clear gO
            end
        end
    end

    %%
    methods (Access = protected)
        %%
        function initializeComps(gO)
            %%
            gO.mainFig = figure('Visible','off',...
                'Units','normalized',...
                'Position',[0.1, 0.1, 0.8, 0.7],...
                'NumberTitle','off',...
                'Name',['Settings input for detection algorithm - ',gO.detAlg],...
                'MenuBar','none',...
                'IntegerHandle','off',...
                'HandleVisibility','Callback',...
                'DeleteFcn',@(h,e) gO.closeFigSaveSetts);

            %%
            loadMenu = uimenu(gO.mainFig,...
                'Text','Load settings');
            uimenu(loadMenu,...
                'Text','Load default settings',...
                'MenuSelectedFcn',@(h,e) gO.fillInSetts('def'))
            uimenu(loadMenu,...
                'Text','Load previous settings',...
                'MenuSelectedFcn',@(h,e) gO.fillInSetts('prev'))

            %%
            settNames = fieldnames(gO.algSett);
            settVals  = struct2cell(gO.algSett);

            rowLen = 10;
            gO.inputPanels = gobjects(length(settVals), 1);
            panelH = 1 / rowLen;
            panelW = 1 / ceil(length(settVals) / rowLen);
    
            for i = 1:length(settVals)
                row = mod(i,rowLen);
                if row == 0
                    row = rowLen;
                end
                col = ceil(i / rowLen);
                gO.inputPanels(i) = uipanel(gO.mainFig,...
                    'Units','normalized',...
                    'Position',[(col-1)*panelW, 1 - row*panelH, panelW, panelH],...
                    'Title',settNames{i});
    
                if islogical(settVals{i})
                    uicontrol(gO.inputPanels(i),...
                        'Style','checkbox',...
                        'Units','normalized',...
                        'Position',[0,0,1,1],...
                        'Value',settVals{i},...
                        'Callback',@(h,e) gO.valChanged(h,'bool',settNames{i},1))
                elseif isstruct(settVals{i})
                    uicontrol(gO.inputPanels(i),...
                        'Style','popupmenu',...
                        'Units','normalized',...
                        'Position',[0,0,1,1],...
                        'String',settVals{i}.list,...
                        'Value',settVals{i}.sel,...
                        'Callback',@(h,e) gO.valChanged(h,'list',settNames{i},1))
                
                else
                    numVals = length(settVals{i});
                    doConv = ismember(settNames{i}, gO.fields2conv);
                    uicW = 1 / numVals;
                    for j = 1:numVals
                        if doConv
                            uicVal = settVals{i}(j) / gO.fs;
                        else
                            uicVal = settVals{i}(j);
                        end
                        uicontrol(gO.inputPanels(i),...
                            'Style','edit',...
                            'Units','normalized',...
                            'Position',[(j-1)*uicW,0,uicW,1],...
                            'String',num2str(uicVal),...
                            'Callback',@(h,e) gO.valChanged(h,'num',settNames{i},j))
                    end
                end
            end
        end

        function valChanged(gO,h,valType,field,pos)
            switch valType
                case 'bool'
                    gO.algSett.(field) = h.Value;

                case 'list'
                    gO.algSett.(field).sel = h.Value;

                case 'num'
                    if ismember(field,gO.fields2conv)
                        newVal = str2double(h.String) * gO.fs;
                    else
                        newVal = str2double(h.String);
                    end
                    gO.algSett.(field)(pos) = newVal;

            end
        end

        %%
        function loadPrevSetts(gO)
            prevExists = false;
            fLoc = mfilename("fullpath");
            fLoc = fLoc(1:end-length(mfilename));
            if exist([fLoc,'savedDetSetts.mat'],'file') == 2
                load([fLoc,'savedDetSetts.mat'],'detSetts')
                if isfield(detSetts,gO.detAlg)
                    prevExists = true;
                end
            end

            if ~prevExists
                loadDefSetts(gO)
            else
                gO.algSett = detSetts.(gO.detAlg);
            end
        end

        %%
        function loadDefSetts(gO)
            switch gO.detAlg
                case 'gmmAutoCorrDet'
                    s.debugPlots           = false;
                    s.winLen               = round(1*gO.fs);
                    s.goodBand             = [80,250];
                    s.badBand              = [300,500];
                    s.envWinLen            = round((1/500)*gO.fs);
                    s.maxCompNum           = 4;
                    s.compNumSelMode.sel   = 1;
                    s.compNumSelMode.list  = {'AICelbow','AICmin','BICelbow','BICmin','silh'};
                    s.minCritValDrop       = .1;
                    s.minCritValDrop2      = .075;
                    s.envHigh2Low          = 3;
                    s.instEHigh2Low        = 10;
                    s.envThrSdMult         = 2;
                    s.clustGapFillLen      = round(.015*gO.fs);
                    s.clustGapMinLen       = round(.01*gO.fs);
                    s.clustIvLen           = [round(.02*gO.fs), round(.3*gO.fs)];
                    s.clustIvFitRsqMin     = .6;
                    s.clustIvFitCycMin     = 1.5;
                    s.clustIvFitTMin       = .008;
                    s.clustIvFitTheta      = [80,250];
                    s.clustIvSdRatioMin    = 1;
                    s.clustIvAvgRatioMin   = 2;
                    s.clustIvGoodRatioMin  = .25;
                    s.envThrCrossMode.sel  = 1;
                    s.envThrCrossMode.list = {'&','|'};
                    s.envThrCrossMinLen    = round(.01*gO.fs);
                    s.upEnv2Baseline       = 2;
                    s.lowEnv2Baseline      = 2;
                    s.instPow2Baseline     = 3;
                    s.instE2Baseline       = 5;
                    s.evFitRsqMin          = .85;
                    s.evFitCycMin          = 2;
                    s.evFitT               = [.008, .08];
                    s.evFitTheta           = [100, 200];

            end

            gO.algSett = s;
        end

        function fillInSetts(gO,loadFrom)
            if strcmp(loadFrom,'def')
                loadDefSetts(gO)
            elseif strcmp(loadFrom,'prev')
                loadPrevSetts(gO)
            end

            fields   = fieldnames(gO.algSett);
            settVals = struct2cell(gO.algSett);

            for i = 1:length(gO.inputPanels)
                panelChildren = gO.inputPanels(i).Children(end:-1:1);

                if islogical(settVals{i})
                    panelChildren.Value = settVals{i};
                elseif isstruct(settVals{i})
                    panelChildren.String = settVals{i}.list;
                    panelChildren.Value  = settVals{i}.sel;
                else
                    if ismember(fields{i},gO.fields2conv)
                        vals2fill = settVals{i} / gO.fs;
                    else
                        vals2fill = settVals{i};
                    end
                    for j = 1:length(panelChildren)
                        panelChildren(j).String = num2str(vals2fill(j));
                    end
                end

            end

        end

        function closeFigSaveSetts(gO)
            fLoc = mfilename("fullpath");
            fLoc = fLoc(1:end-length(mfilename));
            if exist([fLoc,'savedDetSetts.mat'],'file') == 2
                load([fLoc,'savedDetSetts.mat'],'detSetts')
            end
            
            detSetts.(gO.detAlg) = gO.algSett;
            
            save([fLoc,'savedDetSetts.mat'],'detSetts')
            
            delete(gO.mainFig)
        end

    end

end