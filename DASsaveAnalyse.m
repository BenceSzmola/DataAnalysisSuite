function [ephysStats, imagingStats] = DASsaveAnalyse(path,saveFnames,makeExcel)

if nargin < 3
    makeExcel = false;
end

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
            
        case {btn3, ''}
            return
            
    end
end
numSaves = length(saveFnames);
hasEphys = false(numSaves, 1);
hasImaging = false(numSaves, 1);

ephysStatsFields = {'Filename'; 'NumAllEvents'; 'NumBestChEvents'; 'BestChEventFrequency'; 'NumEventComplexes';...
    'NumBestChEventComplexes'; 'BestChEventComplexFrequency'};
ephysParamNames = {};
tempEphysCell = cell(numSaves, 1);

imagingStatsFields = {'Filename'; 'NumAllEvents'; 'NumEventComplexes'};
imagingParamNames = {};
tempImagingCell = cell(numSaves, 1);

for i = 1:numSaves
    load([path,saveFnames{i}], 'ephysSaveData', 'imagingSaveData', 'simultSaveData')
    
    if ~isempty(ephysSaveData)
        hasEphys(i) = true;
        tLen = ephysSaveData.TAxis(end) - ephysSaveData.TAxis(1);
        
        tempEphysCell{i,1} = saveFnames{i};
        
        numDets = cellfun(@ length, ephysSaveData.Dets);
        tempEphysCell{i,2} = sum(numDets);
        [tempEphysCell{i,3}, bestChInd] = max(numDets);

        tempEphysCell{i,4} = numDets(bestChInd) / tLen;
        
        numEvComplex = cellfun(@ length, ephysSaveData.EventComplexes);
        tempEphysCell{i,5} = sum(numEvComplex);
        tempEphysCell{i,6} = numEvComplex(bestChInd);
        
        tempEphysCell{i,7} = numEvComplex(bestChInd) / tLen;
        
        ephysParamNames = fieldnames(ephysSaveData.DetParams{bestChInd});
        numParams = length(ephysParamNames);
        paramsCell = squeeze(struct2cell([ephysSaveData.DetParams{bestChInd}]));
        paramsCell(cellfun('isempty', paramsCell)) = {nan};
        tempEphysCell(i,8:(8 + numParams - 1)) = mat2cell(mean(cell2mat(paramsCell), 2, 'omitnan'), ones(numParams, 1))';
        
    end
    
    if ~isempty(imagingSaveData)
        hasImaging(i) = true;
        
        tempImagingCell{i,1} = saveFnames{i};
        
        numDets = cellfun(@ length, imagingSaveData.Dets);
        tempImagingCell{i,2} = sum(numDets);
        
        numEvComplex = cellfun(@ length, imagingSaveData.EventComplexes);
        tempImagingCell{i,3} = sum(numEvComplex);
        
        imagingParamNames = fieldnames(imagingSaveData.DetParams{1});
        numParams = length(imagingParamNames);
        paramsCell = squeeze(struct2cell([imagingSaveData.DetParams{1}]));
        paramsCell(cellfun('isempty', paramsCell)) = {nan};
        tempImagingCell(i,4:(4 + numParams - 1)) = mat2cell(mean(cell2mat(paramsCell), 2, 'omitnan'), ones(numParams, 1))';
        
    end
    
    if ~isempty(simultSaveData)
        
    end
end

tempEphysCell(~hasEphys,:) = [];
tempImagingCell(~hasImaging,:) = [];

if any(hasEphys)
    ephysStats = cell2struct(tempEphysCell', [ephysStatsFields; ephysParamNames], 1);
else
    ephysStats = [];
end
if any(hasImaging)
    imagingStats = cell2struct(tempImagingCell', [imagingStatsFields; imagingParamNames], 1);
else
    imagingStats = [];
end

if makeExcel
    cutInd = find(path=='\');
    DAS2Excel(1,path(cutInd(end-1)+1:end-1),ephysStats,imagingStats)
end

if nargout == 0
    clear ephysStats imagingStats
end