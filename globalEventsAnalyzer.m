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

ephysStatsFields1 = {'Filename'; 'OnChannels'};
ephysStatsFields2 = {'PeakTimeDiffs [ms]'}; 
ephysStatsFields3 = {'RawAmplitudeRatios'};
ephysStatsFields4 = {'BandpassAmplitudeRatios'};
ephysParamNames = {};
tempEphysCell1 = cell(0, 1);
tempEphysCell2 = cell(0, 1);
tempEphysCell3 = cell(0, 1);
tempEphysCell4 = cell(0, 1);
tempEphysCell5 = cell(0, 1);

imagingStatsFields1 = {'Filename'; 'OnROIs'};
imagingStatsFields2 = {'PeakTimeDiffs [ms]'};
imagingStatsFields3 = {'RawAmplitudeRatios'};
imagingParamNames = {};
tempImagingCell1 = cell(0, 1);
tempImagingCell2 = cell(0, 1);
tempImagingCell3 = cell(0, 1);
tempImagingCell4 = cell(0, 1);

for i = 1:numSaves
    load([path,saveFnames{i}], 'ephysSaveData', 'ephysSaveInfo', 'imagingSaveData', 'simultSaveData')
    
    if ~isempty(ephysSaveData)
        if ~isfield(ephysSaveData, 'GlobalDets') || isempty(ephysSaveData.GlobalDets)
            continue
        end
        
        tAxis = ephysSaveData.TAxis;
        
        globDets = ephysSaveData.GlobalDets;
        
        tempCell1 = cell(size(globDets, 1), 1);
        tempCell2 = cell(size(globDets, 1), 1);
        tempCell3 = cell(size(globDets, 1), 1);
        tempCell4 = cell(size(globDets, 1), 1);
        tempCell5 = cell(size(globDets, 1), 1);
        
        for gEv = 1:size(globDets, 1)
            tempCell1{gEv,1} = saveFnames{i};
            
            notNanCols = find(~isnan(globDets(gEv,:)));
            tempCell1{gEv,2} = num2str(ephysSaveInfo.DetChannel(notNanCols));
            
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
            tempCell2(gEv,1:length(tStamps)) = num2cell(tStamps);
            
            if ~isempty(ephysSaveData.DetParams)
                rawAmps = [params.RawAmplitudeP2P];
                rawAmps = rawAmps / max(rawAmps);
                tempCell3(gEv,1:length(rawAmps)) = num2cell(rawAmps);
                
                bpAmps = [params.BpAmplitudeP2P];
                bpAmps = bpAmps / max(bpAmps);
                tempCell4(gEv,1:length(bpAmps)) = num2cell(bpAmps);
                
                ephysParamNames = fieldnames(params);
                numParams = length(ephysParamNames);
                paramsCell = squeeze(struct2cell(params));
                paramsCell(cellfun('isempty', paramsCell)) = {nan};
                tempCell5(gEv,1:numParams) = mat2cell(mean(cell2mat(paramsCell), 2, 'omitnan'), ones(numParams, 1))';
                
                clear params
            end
            
        end
        tempEphysCell1(end + 1:end + size(tempCell1, 1), 1:size(tempCell1, 2)) = tempCell1;
        tempEphysCell2(end + 1:end + size(tempCell2, 1), 1:size(tempCell2, 2)) = tempCell2;
        tempEphysCell3(end + 1:end + size(tempCell3, 1), 1:size(tempCell3, 2)) = tempCell3;
        tempEphysCell4(end + 1:end + size(tempCell4, 1), 1:size(tempCell4, 2)) = tempCell4;
        tempEphysCell5(end + 1:end + size(tempCell5, 1), 1:size(tempCell5, 2)) = tempCell5;
        
    end
    
    if ~isempty(imagingSaveData)
        if ~isfield(imagingSaveData, 'GlobalDets') || isempty(imagingSaveData.GlobalDets)
            continue
        end
        
        tAxis = imagingSaveData.TAxis;
        
        globDets = imagingSaveData.GlobalDets;
        
        tempCell1 = cell(size(globDets, 1), 1);
        tempCell2 = cell(size(globDets, 1), 1);
        tempCell3 = cell(size(globDets, 1), 1);
        tempCell4 = cell(size(globDets, 1), 1);
        
        for gEv = 1:size(globDets, 1)
            tempCell1{gEv,1} = saveFnames{i};
            
            notNanCols = find(~isnan(globDets(gEv,:)));
            tempCell1{gEv,2} = num2str(imagingSaveInfo.DetROI(notNanCols));
            
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
            tempCell2(gEv,1:length(tStamps)) = num2cell(tStamps);
            
            if ~isempty(imagingSaveData.DetParams)
                rawAmps = [params.RawAmplitudeP2P];
                rawAmps = rawAmps / max(rawAmps);
                tempCell3(gEv,1:length(rawAmps)) = num2cell(rawAmps);
            
                imagingParamNames = fieldnames(params);
                numParams = length(imagingParamNames);
                paramsCell = squeeze(struct2cell(params));
                paramsCell(cellfun('isempty', paramsCell)) = {nan};
                tempCell4(gEv,1:numParams) = mat2cell(mean(cell2mat(paramsCell), 2, 'omitnan'), ones(numParams, 1))';
                
                clear params
            end
            
        end
        tempImagingCell1(end + 1:end + size(tempCell1, 1),1:size(tempCell1, 2)) = tempCell1;
        tempImagingCell2(end + 1:end + size(tempCell2, 1),1:size(tempCell2, 2)) = tempCell2;
        tempImagingCell3(end + 1:end + size(tempCell3, 1),1:size(tempCell3, 2)) = tempCell3;
        tempImagingCell4(end + 1:end + size(tempCell4, 1),1:size(tempCell4, 2)) = tempCell4;
        
    end
    
    if ~isempty(simultSaveData)
        
    end
end
tempEphysCell = [tempEphysCell1, tempEphysCell2, tempEphysCell3, tempEphysCell4, tempEphysCell5];
ephysStatsFields2 = [ephysStatsFields2; repmat({''}, size(tempEphysCell2, 2) - 1, 1)];
ephysStatsFields3 = [ephysStatsFields3; repmat({''}, size(tempEphysCell3, 2) - 1, 1)];
ephysStatsFields4 = [ephysStatsFields4; repmat({''}, size(tempEphysCell4, 2) - 1, 1)];
ephysStatsFields = [ephysStatsFields1; ephysStatsFields2; ephysStatsFields3; ephysStatsFields4];

tempImagingCell = [tempImagingCell1, tempImagingCell2, tempImagingCell3, tempImagingCell4];
imagingStatsFields2 = [imagingStatsFields2; repmat({''}, size(tempImagingCell2, 2) - 1, 1)];
imagingStatsFields3 = [imagingStatsFields3; repmat({''}, size(tempImagingCell3, 2) - 1, 1)];
imagingStatsFields = [imagingStatsFields1; imagingStatsFields2; imagingStatsFields3];

if ~isempty(tempEphysCell)
    ephysStats = [{tempEphysCell}, {[ephysStatsFields; ephysParamNames]}];
else
    ephysStats = [];
end

if ~isempty(tempImagingCell)
    imagingStats = [{tempImagingCell}, {[imagingStatsFields; imagingParamNames]}];
else
    imagingStats = [];
end

cutInd = find(path=='\');

forInfoTab = cell(3,2);
forInfoTab(1,:) = {'Directory name', path(cutInd(end-1)+1:end-1)};

DAS2Excel(forInfoTab,ephysStats,imagingStats,[path(cutInd(end-1)+1:end-1),'_globEvAnalysis'])
end