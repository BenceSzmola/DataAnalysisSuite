function foilDistrFig = foilSpatialDistrPlotter(tAxis, fs, rawData, globDet, dets, detChans, detBorders)
% required input: (? could just input whole DASsave and extract in script)
%   -global event
%
% output:
%   -colormap in formation of electrode

%% site --> chan matrix
siteChanNums = [12, 9;...
    11, 10;...
    9, 11;...
    7, 12;...
    14, 13;...
    16, 14;...
    18, 15;...
    32, 16;...
    19, 17;...
    17, 18;...
    15, 19;...
    13, 20;...
    21, 21;...
    23, 22;...
    25, 23;...
    26, 24;...
    10, 8;...
     8, 7;...
     6, 6;...
     2, 5;...
     4, 4;...
     5, 3;...
     3, 2;...
     1, 1;...
    27, 32;...
    29, 31;...
    31, 30;...
    30, 29;...
    28, 28;...
    20, 27;...
    22, 26;...
    24, 25];

electrodeGrid = nan(5,7);
electrodeGrid(1,2:6) = 27:31;
electrodeGrid(2,:) = 20:26;
electrodeGrid(3,:) = 13:19;
electrodeGrid(4,:) = 6:12;
electrodeGrid(5,2:6) = 1:5;

%% main code

notNanCols = find(~isnan(globDet));
if isempty(notNanCols)
    errordlg('Empty row!')
    return
end

chanNums = detChans(notNanCols);

tStamps = zeros(length(notNanCols), 1);
for col = 1:length(notNanCols)
    currCol = notNanCols(col);
    tStamps(col) = dets{currCol}(globDet(currCol));
end

tStamps = tAxis(tStamps);
timeShifts = tStamps - max(tStamps);
timeShifts = timeShifts * 1000;

timeShiftTopo = nan(5,7);
for ch = 1:length(chanNums)
    siteNum = chan2siteNum(chanNums(ch));
    [r,c] = find(electrodeGrid == siteNum);
    timeShiftTopo(r,c) = timeShifts(ch);
end

foilDistrFig = figure('Name', 'Time shift of global event on electrode grid',...
    'NumberTitle', 'off',...
    'WindowState', 'maximized');
imagesc(timeShiftTopo, 'AlphaData', ~isnan(timeShiftTopo))
hold on
colormap('autumn')
cb = colorbar;
cb.Label.String = 'Time shift between events [ms]';
axis(gca, 'off')
for i = 1:length(notNanCols)
    siteNum = chan2siteNum(chanNums(i));
    [r,c] = find(electrodeGrid == siteNum);
    
    text(c - 0.5, r - 0.4, sprintf('Site#%d',siteNum), 'FontSize', 8)
    text(c - 0.5, r + 0.4, sprintf('Chan#%d',chanNums(i)), 'FontSize', 8)
    if any(ismember(timeShifts(i), [min(timeShifts), max(timeShifts)]))
        text(c + 0.1, r + 0.4, sprintf('Shift: %.1f ms', timeShifts(i)), 'FontSize', 8, 'FontWeight', 'bold')
    else
        text(c + 0.1, r + 0.4, sprintf('Shift: %.1f ms', timeShifts(i)), 'FontSize', 8)
    end
    
    row2use = notNanCols(i);
    
    currDetBords = detBorders{row2use}(globDet(row2use),:);
    dataLen = length(tAxis);
    doggo = DoG(rawData(row2use,:), fs, 150, 250);

    dataWin = doggo(max(1, currDetBords(1) - round(0.1*fs)):min(dataLen, currDetBords(2) + round(0.1*fs)));
    dataWin = dataWin - mean(dataWin);
    dataWin = (dataWin / max(abs(dataWin))) / 2;
    
    squishedX = linspace(0, 1, length(dataWin));
    plot(squishedX + (c - 0.5), dataWin + r, '-k')
    
end
for r = 1:size(electrodeGrid, 1)
    for c = 1:size(electrodeGrid, 2)
        siteNum = electrodeGrid(r,c);
        if isnan(siteNum)
            continue
        end
        chNum = site2chanNum(siteNum);
        if ismember(chNum, chanNums)
            continue
        end

        text(c - 0.33, r - 0.15, sprintf('Site#%d',siteNum), 'FontSize', 8)
        text(c - 0.33, r + 0.15, sprintf('Chan#%d',chNum), 'FontSize', 8)
    end
end
hold off

%% helper functions
    function chanNum = site2chanNum(siteNum)
        chanNum = siteChanNums(siteChanNums(:,1) == siteNum, 2);
    end

    function siteNum = chan2siteNum(chanNum)
        siteNum = siteChanNums(siteChanNums(:,2) == chanNum, 1);
    end
end