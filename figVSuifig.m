%https://www.mathworks.com/matlabcentral/answers/509249-app-designer-updates-much-20x-slower-than-guide

close all hidden
clear
clc

%% app designer example
figure1 = uifigure('Name','UIFigure 1');
figure1.Position = [100 100 500 400];
axes1 = uiaxes(figure1);
axes1.Position = [50 50 400 300];
im1 = imagesc(axes1,rand([1280 1024]));
button1 = uibutton(figure1,'push');
button1.Position = [20 370 150 22];
button1.Text = 'push to refresh!';
button1.ButtonPushedFcn = {@buttonpushed,im1};

%% guide example
figure2 = figure(2);
figure2.MenuBar = 'none';
figure2.Position = [700 100 500 400];
axes2 = axes(figure2,'Units','pixels');
axes2.Position = [50 50 400 300];
im2 = imagesc(axes2,rand([1280 1024]));
button2 = uicontrol(figure2,'Style','pushbutton');
button2.Position = [20 370 150 22];
button2.String = 'push to refresh!';
button2.Callback = {@buttonpushed,im2};

%% callback function
function buttonpushed(~,~,h)
    tic
    im = rand([1280 1024]);
    h.CData = im;
    drawnow;
    toc    
end