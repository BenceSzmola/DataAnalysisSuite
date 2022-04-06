function DAS2Excel(eParams,iParams)

[saveFn,saveP] = uiputfile('*.xlsx');
if saveFn == 0
    return    
end

exc = actxserver('Excel.Application');

exc.Visible = 1;

eWorkbook = exc.Workbooks.Add(-4167);
if ~isempty(eParams) && ~isempty(iParams)
    eWorkbook.WorkSheets.Add;
    eSheets = eWorkbook.Sheets;
    eSheets.Item(1).Name = 'ephysEvents';
    eSheets.Item(2).Name = 'imagingEvents';
elseif ~isempty(eParams) && isempty(iParams)
    eSheets = eWorkbook.Sheets;
    eSheets.Item(1).Name = 'ephysEvents';
elseif isempty(eParams) && ~isempty(iParams)
    eSheets = eWorkbook.Sheets;
    eSheets.Item(1).Name = 'imagingEvents';
end

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
end

exc.DisplayAlerts = false;
eWorkbook.SaveAs([saveP,saveFn])
exc.DisplayAlerts = true;

eWorkbook.Saved = 1;
Close(eWorkbook)

Quit(exc)
delete(exc)
