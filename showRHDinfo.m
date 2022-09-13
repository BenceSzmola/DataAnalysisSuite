function showRHDinfo(varargin)

if (nargin == 1) && iscell(varargin{1})
    rhdInfoCell = varargin{1};
elseif (nargin == 2) && (ischar(varargin{1}) && ischar(varargin{2}))
    rhdStruct = read_Intan_RHD2000_file_szb([varargin{1},varargin{2}]);
    rhdInfoCell = extractRHDstructInfo(rhdStruct);
else
    eD = errordlg('Bad input, either feed in the cell array with the info, or the path and filename!');
    pause(1)
    if ishandle(eD)
        close(eD)
    end
    return
end
    
rhdInfoFig = figure('Name', 'RHD information',...
                    'NumberTitle', 'off',...
                    'MenuBar', 'none',...
                    'Units', 'normalized',...
                    'Position', [0.3, 0.3, 0.5, 0.2],...
                    'Visible', 'off',...
                    'Resize', 'off');


[maxLen1,maxLenInds1] = max(cellfun(@length, rhdInfoCell{1}));
[maxLen2,maxLenInds2] = max(cellfun(@length, rhdInfoCell{2}));
if maxLen1(1) > maxLen2(1)
    wid1 = getTxtPixelSize(rhdInfoCell{1}{maxLenInds1(1),1});
else
    wid1 = getTxtPixelSize(rhdInfoCell{2}{maxLenInds2(1),1});
end
if maxLen1(2) > maxLen2(2)
    wid2 = getTxtPixelSize(rhdInfoCell{1}{maxLenInds1(2),2});
else
    wid2 = getTxtPixelSize(rhdInfoCell{2}{maxLenInds2(2),2});
end

colNames1 = {'Parameters','Values'};
colWidths1 = {ceil(wid1)+30, ceil(wid2)+10};
infoTabl1 = uitable(rhdInfoFig,...
                    'Units', 'normalized',...
                    'Position', [0, 0.7, 1, 0.3],...
                    'Data', rhdInfoCell{1},...
                    'ColumnName', colNames1,...
                    'ColumnWidth', colWidths1);
                
colNames2 = {'Channel names','Impedance magnitudes'};
colWidths2 = {ceil(wid1)+30, ceil(wid2)+10};
infoTabl2 = uitable(rhdInfoFig,...
                    'Units', 'normalized',...
                    'Position', [0, 0, 1, 0.7],...
                    'Data', rhdInfoCell{2},...
                    'ColumnName', colNames2,...
                    'ColumnWidth', colWidths2);
                
                
tablesExtent(1) = infoTabl1.Extent(3);
tablesExtent(2) = infoTabl1.Extent(4) + infoTabl2.Extent(4);
rhdInfoFig.Position(3:4) = rhdInfoFig.Position(3:4).*tablesExtent;
rhdInfoFig.Visible = 'on';

end