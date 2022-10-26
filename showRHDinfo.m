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

colNames1 = {'Parameters','Values'};
colNames2 = {'#','Channel names','Impedance magnitudes'};
cellwTtl{1} = [colNames1; rhdInfoCell{1}];
cellwTtl{2} = [colNames2; rhdInfoCell{2}];

[~,maxLenInds1] = max(cellfun(@length, cellwTtl{1}));
wid1(1) = getTxtPixelSize(cellwTtl{1}{maxLenInds1(1),1});
wid1(2) = getTxtPixelSize(cellwTtl{1}{maxLenInds1(2),2});
wid1 = ceil(wid1);
wid1(maxLenInds1 == 1) = wid1(maxLenInds1 == 1)*1.25;

[~,maxLenInds2] = max(cellfun(@length, cellwTtl{2}));
wid2(1) = getTxtPixelSize(cellwTtl{2}{maxLenInds2(1),1});
wid2(2) = getTxtPixelSize(cellwTtl{2}{maxLenInds2(2),2});
wid2(3) = getTxtPixelSize(cellwTtl{2}{maxLenInds2(3),3});
wid2 = ceil(wid2);
wid2(maxLenInds2 == 1) = wid2(maxLenInds2 == 1)*1.25;

if sum(wid1) > sum(wid2)
    wid2 = wid2*(sum(wid1)/sum(wid2));
elseif sum(wid2) > sum(wid1)
    wid1 = wid1*(sum(wid2)/sum(wid1));
end

colWidths1 = {wid1(1), wid1(2)};
infoTabl1 = uitable(rhdInfoFig,...
                    'Units', 'normalized',...
                    'Position', [0, 0.7, 1, 0.3],...
                    'Data', rhdInfoCell{1},...
                    'ColumnName', colNames1,...
                    'ColumnWidth', colWidths1,...
                    'RowName',[]);
                
colWidths2 = {wid2(1), wid2(2), wid2(3)};
infoTabl2 = uitable(rhdInfoFig,...
                    'Units', 'normalized',...
                    'Position', [0, 0, 1, 0.7],...
                    'Data', rhdInfoCell{2},...
                    'ColumnName', colNames2,...
                    'ColumnWidth', colWidths2,...
                    'RowName',[]);

tablesExtent(1) = max(infoTabl1.Extent(3), infoTabl2.Extent(3));
tablesExtent(2) = infoTabl1.Extent(4) + infoTabl2.Extent(4);
rhdInfoFig.Position(3) = min([rhdInfoFig.Position(3)*tablesExtent(1), .9]);
rhdInfoFig.Position(4) = min([rhdInfoFig.Position(4)*tablesExtent(2), .9]);
if sum(rhdInfoFig.Position([1,3])) > .95
    rhdInfoFig.Position(1) = 0.05;
end
if sum(rhdInfoFig.Position([2,4])) > .95
    rhdInfoFig.Position(2) = 0.05;
end
infoTabl1.Position(4) = infoTabl1.Extent(4);
infoTabl1.Position(2) = infoTabl2.Extent(4);
infoTabl2.Position(4) = infoTabl2.Extent(4);

rhdInfoFig.Visible = 'on';
end