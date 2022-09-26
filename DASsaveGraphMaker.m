function DASsaveGraphMaker(statCell,colName,ylab,titleStr)

if nargin == 0
    errordlg('Need at least 2 inputs, a cell array with stats and column name which should be plotted!')
    return
end

% get number of column where the filename resides
fNameCol = cellfun(@(x) strcmp(x,'Filename'),statCell{2});
fnames = statCell{1}(:,fNameCol);

% extract date from the filename
dates = cellfun(@(x) regexp(x,'(\d{6}_\d{6})','match'), fnames);

% extract the data to plot
dataCol = cellfun(@(x) strcmp(x,colName), statCell{2});
data2plot = statCell{1}(:,dataCol);
% replace empty cells (savefiles with no detections)
emptyFiles = cellfun('isempty', data2plot);
data2plot(emptyFiles) = {0};
data2plot = cell2mat(data2plot);

% make the graph
figure;
plot(data2plot,'o-')
hold on
xrange = 1:length(emptyFiles);
emptyLine = plot(xrange(emptyFiles),data2plot(emptyFiles),'ro','MarkerFaceColor','r');
hold off
if any(emptyFiles)
    legend(emptyLine,'Empty files')
end
xticks(xrange)
xticklabels(dates)
xlim([0,length(xrange)+1])
currAx = gca;
currYlim = currAx.YLim;
yrange = currYlim(2)-currYlim(1);
currYlim(1) = currYlim(1) - yrange*.1;
currYlim(2) = currYlim(2) + yrange*.1;
currAx.YLim = currYlim;
currAx.TickLabelInterpreter = 'none';
currAx.XTickLabelRotation = 45;
xlabel('Recording date [yymmdd_hhmmss]','Interpreter','none')
if nargin < 3 || isempty(ylab)
    ylabel(colName)
else
    ylabel(ylab)
end
if nargin < 4 || isempty(titleStr)
    title(colName)
else
    title(titleStr)
end