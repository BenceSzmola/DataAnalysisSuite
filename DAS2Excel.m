function DAS2Excel(forInfoTab,eParams,iParams,defFname)

% mode: 1 == for DASsave files; 2 == for DASeventDB files

if isempty(eParams) && isempty(iParams)
    errordlg('No parameters to make excel out of!')
    return
end

if nargin < 4
    defFname = '';
end
[saveFn,saveP] = uiputfile('*.xlsx','Choose location and filename!',defFname);
if saveFn == 0
    return    
end

exc = actxserver('Excel.Application');

exc.Visible = 1;

eWorkbook = exc.Workbooks.Add(-4167);
if ~isempty(eParams) && ~isempty(iParams)
    eWorkbook.WorkSheets.Add;
    eSheets = eWorkbook.WorkSheets;
    eSheets.Item(1).Name = 'ephysEvents';
    eSheets.Item(2).Name = 'imagingEvents';
elseif ~isempty(eParams) && isempty(iParams)
    eSheets = eWorkbook.WorkSheets;
    eSheets.Item(1).Name = 'ephysEvents';
elseif isempty(eParams) && ~isempty(iParams)
    eSheets = eWorkbook.WorkSheets;
    eSheets.Item(1).Name = 'imagingEvents';
end

eWorkbook.WorkSheets.Add([],eSheets.Item(eWorkbook.WorkSheets.Count));
numSheets = eWorkbook.WorkSheets.Count;
eSheets = eWorkbook.WorkSheets;
eSheets.Item(numSheets).Name = 'info';

eSheetInfo = eSheets.get('Item','info');
eSheetInfo.Activate;
cellsRange1 = get(eSheetInfo,'Cells',1,1);
if any(size(forInfoTab))
    cellsRange2 = get(eSheetInfo,'Cells',size(forInfoTab, 1),size(forInfoTab, 2));
else
    cellsRange2 = get(eSheetInfo,'Cells',1,1);
end
range = get(eSheetInfo,'Range',cellsRange1,cellsRange2);
range.Value = forInfoTab;
range.EntireColumn.AutoFit;

if ~isempty(eParams)
    eSheetEphys = eSheets.get('Item','ephysEvents');
    eSheetEphys.Activate;
    
    eParamNames = fieldnames(eParams);
    eParamsCell = squeeze(struct2cell(eParams));
    
    numVars = length(eParamNames);
    numEvs = length(eParams);
    
    eParamNames = eParamNames';
    
    eParamsCell = eParamsCell';
    
    cellsRange1 = get(eSheetEphys,'Cells',1,1);
    cellsRange2 = get(eSheetEphys,'Cells',1,numVars);
    range = get(eSheetEphys,'Range',cellsRange1,cellsRange2);
    range.Value = eParamNames;
    
    cellsRange1 = get(eSheetEphys,'Cells',2,1);
    cellsRange2 = get(eSheetEphys,'Cells',numEvs + 1,numVars);
    range = get(eSheetEphys,'Range',cellsRange1,cellsRange2);
    range.Value = eParamsCell;
    range.EntireColumn.AutoFit;
end

if ~isempty(iParams)
    eSheetImaging = eSheets.get('Item','imagingEvents');
    eSheetImaging.Activate;
    
    iParamNames = fieldnames(iParams);
    iParamsCell = squeeze(struct2cell(iParams));
        
    numVars = length(iParamNames);
    numEvs = length(iParams);
    
    iParamNames = iParamNames';
    
    iParamsCell = iParamsCell';
    
    cellsRange1 = get(eSheetImaging,'Cells',1,1);
    cellsRange2 = get(eSheetImaging,'Cells',1,numVars);
    range = get(eSheetImaging,'Range',cellsRange1,cellsRange2);
    range.Value = iParamNames;

    cellsRange1 = get(eSheetImaging,'Cells',2,1);
    cellsRange2 = get(eSheetImaging,'Cells',numEvs + 1,numVars);
    range = get(eSheetImaging,'Range',cellsRange1,cellsRange2);
    range.Value = iParamsCell;
    range.EntireColumn.AutoFit;
end

exc.DisplayAlerts = false;
eWorkbook.SaveAs([saveP,saveFn])
exc.DisplayAlerts = true;

eWorkbook.Saved = 1;
Close(eWorkbook)

Quit(exc)
delete(exc)
