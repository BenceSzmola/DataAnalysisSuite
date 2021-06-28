close all 
clear

times = zeros(3,10);
%% Create figure with axes
for i = 1:10
    t = tic;
    fig1 = figure;
    % fig1.MenuBar = 'none';
    ax1 = axes(fig1);
    plot(ax1,sin(0:2*pi))
    drawnow
    times(1,i) = toc(t);
    close(fig1)
end
%% Create uifigure with axes
for i = 1:10
    t = tic;
    fig2 = uifigure;
    ax2 = axes(fig2);
    plot(ax2,sin(0:2*pi))
    drawnow
    times(2,i) = toc(t);
    close(fig2)
end
%% Create uifigure with axes
for i = 1:10
    t = tic;
    fig3 = uifigure;
    ax3 = uiaxes(fig3);
    plot(ax3,sin(0:2*pi))
    drawnow
    times(3,i) = toc(t);
    close(fig3)
end

%% plotting times
figure
% cats = categorical({'figure&axes','uifigure&axes','uifigure&uiaxes'});
hold on
b = bar(mean(times,2),'FaceColor','flat');
set(gca,'XTick',1:3,'XTickLabel',{'figure&axes','uifigure&axes','uifigure&uiaxes'})
b.CData(1,:) = [1 0 0];
b.CData(2,:) = [0 1 0];
b.CData(3,:) = [0 0 1];
title('Figure/UIFigure & Axes/UIAxes speed comparison (average of 10 runs)')
ylabel('Seconds elapsed for plotting a sine wave')
errorbar(mean(times,2),std(times,0,2),'.')