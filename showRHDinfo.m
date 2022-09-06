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


[~,maxLenInds] = max(cellfun(@length, rhdInfoCell));
wid1 = getTxtPixelSize(rhdInfoCell{maxLenInds(1),1});
wid2 = getTxtPixelSize(rhdInfoCell{maxLenInds(2),2});

colNames = {'Parameters','Values'};
colWidths = {ceil(wid1)+30, ceil(wid2)+10};
infoTab = uitable(rhdInfoFig,...
                    'Units', 'normalized',...
                    'Position', [0, 0, 1, 1],...
                    'Data', rhdInfoCell,...
                    'ColumnName', colNames,...
                    'ColumnWidth', colWidths);
rhdInfoFig.Position(3:4) = rhdInfoFig.Position(3:4).*infoTab.Extent(3:4);
rhdInfoFig.Visible = 'on';

end