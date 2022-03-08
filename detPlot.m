function detPlot(ax,detInds,detBorders,tAxis,method,color,yMinMax)

switch method
    case 'stars'
        x2plot = tAxis(detInds);
        y2plot = zeros(size(detInds));
        plot(ax,x2plot,y2plot,[color,'*'])
    case 'shade'
        for i = 1:length(detInds)
            x2plot = [detBorders(i,1),detBorders(i,1),detBorders(i,2),detBorders(i,2)];
            y2plot = [yMinMax(1),yMinMax(2),yMinMax(2),yMinMax(1)];
            patch(x2plot,y2plot,color,'FaceAlpha',0.2)
        end
    case 'lines'
        for i = 1:length(detInds)
            xline(ax,tAxis(detInds(i)),'Color','g','LineWidth',1);
            xline(ax,tAxis(detBorders(i,1)),'--b','LineWidth',1);
            xline(ax,tAxis(detBorders(i,2)),'--b','LineWidth',1);
        end
end