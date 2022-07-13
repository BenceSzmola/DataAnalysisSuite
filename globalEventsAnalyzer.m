function globalEventsAnalyzer(path,saveFnames)

if (nargin == 0) || (isempty(path) || isempty(saveFnames))
    btn1 = 'Directory';
    btn2 = 'Files';
    btn3 = 'Cancel';
    dirOrFile = questdlg('Select directory or files?', 'Selection method', btn1, btn2, btn3, btn1);
    switch dirOrFile
        case btn1
            path = uigetdir(cd, 'Select directory to analyse!');
            path = [path,'\'];
            saveFnames = dir([path,'DASsave*.mat']);
            saveFnames = {saveFnames.name};
            
        case btn2
            [saveFnames, path] = uigetfile('DASsave*.mat', 'MultiSelect', 'on');
            if ~iscell(saveFnames)
                saveFnames = {saveFnames};
            end
                        
        case {btn3, ''}
            return
            
    end
end
numSaves = length(saveFnames);

ephysStatsFields = {'Filename'; 'OnChannels'; 'PeakTimeDiffs'; 'RawAmplitudeRatios';...
    'BandpassAmplitudeRatios'};
ephysParamNames = {};
tempEphysCell = cell(0, 1);

imagingStatsFields = {'Filename'; 'OnROIs'; 'PeakTimeDiffs'; 'RawAmplitudeRatios'};
imagingParamNames = {};
tempImagingCell = cell(0, 1);

for i = 1:numSaves
    load([path,saveFnames{i}], 'ephysSaveData', 'ephysSaveInfo', 'imagingSaveData', 'simultSaveData')
    
    if ~isempty(ephysSaveData)
        if isempty(ephysSaveData.GlobalDets)
            continue
        end
        
        tAxis = ephysSaveData.TAxis;
        
        if ~isfield(ephysSaveData, 'GlobalDets')
            continue
        end
        globDets = ephysSaveData.GlobalDets;
        tempCell = cell(size(globDets, 1), 1);
        for gEv = 1:size(globDets, 1)
            tempCell{gEv,1} = saveFnames{i};
            
            notNanCols = find(~isnan(globDets(gEv,:)));
            tempCell{gEv,2} = num2str(ephysSaveInfo.DetChannel(notNanCols));
            
            tStamps = zeros(length(notNanCols), 1);
            for col = 1:length(notNanCols)
                currCol = notNanCols(col);
                tStamps(col) = ephysSaveData.Dets{currCol}(globDets(gEv,currCol));
                if ~isempty(ephysSaveData.DetParams)
                    params(col) = ephysSaveData.DetParams{currCol}(globDets(gEv,currCol));
                end
            end
            
            tStamps = tAxis(tStamps);
            tStamps = tStamps - max(tStamps);
            tStamps = tStamps * 1000;
            tempCell{gEv,3} = num2str(tStamps);
            
            if ~isempty(ephysSaveData.DetParams)
                rawAmps = [params.RawAmplitudeP2P];
                rawAmps = rawAmps / max(rawAmps);
                tempCell{gEv,4} = num2str(rawAmps);
                
                bpAmps = [params.BpAmplitudeP2P];
                bpAmps = bpAmps / max(bpAmps);
                tempCell{gEv,5} = num2str(bpAmps);
                
                ephysParamNames = fieldnames(params);
                numParams = length(ephysParamNames);
                paramsCell = squeeze(struct2cell(params));
                paramsCell(cellfun('isempty', paramsCell)) = {nan};
                tempCell(gEv,6:(6 + numParams - 1)) = mat2cell(mean(cell2mat(paramsCell), 2, 'omitnan'), ones(numParams, 1))';
                
                clear params
            end
            
        end
        tempEphysCell = [tempEphysCell; tempCell];
        
    end
    
    if ~isempty(imagingSaveData)
        if isempty(imagingSaveData.GlobalDets)
            continue
        end
        
        tAxis = imagingSaveData.TAxis;
        
        if ~isfield(imagingSaveData, 'GlobalDets')
            continue
        end
        globDets = imagingSaveData.GlobalDets;
        tempCell = cell(size(globDets, 1), 1);
        for gEv = 1:size(globDets, 1)
            tempCell{gEv,1} = saveFnames{i};
            
            notNanCols = find(~isnan(globDets(gEv,:)));
            tempCell{gEv,2} = num2str(imagingSaveInfo.DetROI(notNanCols));
            
            tStamps = zeros(length(notNanCols), 1);
            for col = 1:length(notNanCols)
                currCol = notNanCols(col);
                tStamps(col) = imagingSaveData.Dets{currCol}(globDets(gEv,currCol));
                if ~isempty(imagingSaveData.DetParams)
                    params(col) = imagingSaveData.DetParams{currCol}(globDets(gEv,currCol));
                end
            end
            
            tStamps = tAxis(tStamps);
            tStamps = tStamps - max(tStamps);
            tStamps = tStamps * 1000;
            tempCell{gEv,3} = num2str(tStamps);
            
            if ~isempty(imagingSaveData.DetParams)
                rawAmps = [params.RawAmplitudeP2P];
                rawAmps = rawAmps / max(rawAmps);
                tempCell{gEv,4} = num2str(rawAmps);
            
                imagingParamNames = fieldnames(params);
                numParams = length(imagingParamNames);
                paramsCell = squeeze(struct2cell(params));
                paramsCell(cellfun('isempty', paramsCell)) = {nan};
                tempCell(gEv,5:(5 + numParams - 1)) = mat2cell(mean(cell2mat(paramsCell), 2, 'omitnan'), ones(numParams, 1))';
                
                clear params
            end
            
        end
        
        tempImagingCell = [tempImagingCell; tempCell];
        
    end
    
    if ~isempty(simultSaveData)
        
    end
end

if ~isempty(tempEphysCell)
    ephysStats = cell2struct(tempEphysCell', [ephysStatsFields; ephysParamNames], 1);
else
    ephysStats = [];
end

if ~isempty(tempImagingCell)
    imagingStats = cell2struct(tempImagingCell', [imagingStatsFields; imagingParamNames], 1);
else
    imagingStats = [];
end

cutInd = find(path=='\');

forInfoTab = cell(3,2);
forInfoTab(1,:) = {'Directory name', path(cutInd(end-1)+1:end-1)};

DAS2Excel(forInfoTab,ephysStats,imagingStats,[path(cutInd(end-1)+1:end-1),'_globEvAnalysis'])
end