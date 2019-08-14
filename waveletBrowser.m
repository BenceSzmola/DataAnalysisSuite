function varargout = waveletBrowser(varargin)
% WAVELETBROWSER MATLAB code for waveletBrowser.fig
%      WAVELETBROWSER, by itself, creates a new WAVELETBROWSER or raises the existing
%      singleton*.
%
%      H = WAVELETBROWSER returns the handle to a new WAVELETBROWSER or the handle to
%      the existing singleton*.
%
%      WAVELETBROWSER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WAVELETBROWSER.M with the given input arguments.
%
%      WAVELETBROWSER('Property','Value',...) creates a new WAVELETBROWSER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before waveletBrowser_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to waveletBrowser_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help waveletBrowser

% Last Modified by GUIDE v2.5 14-Aug-2019 11:02:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @waveletBrowser_OpeningFcn, ...
                   'gui_OutputFcn',  @waveletBrowser_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before waveletBrowser is made visible.
function waveletBrowser_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to waveletBrowser (see VARARGIN)

% Choose default command line output for waveletBrowser
handles.output = hObject;

% % % initial plotting
handles.evdet_hdls = varargin{1};
eventdet_handles = varargin{1};
handles.wavenum = 0;
handles.canum = 1;

set(handles.cadelay,'String',num2str(eventdet_handles.cadelay*1000));

dog = eventdet_handles.dog;
instpow = eventdet_handles.instpow;
normed_ca = eventdet_handles.normed_ca;
ephys_t_scale = eventdet_handles.ephys_t_scale;
ca_t_scale = eventdet_handles.ca_t_scale;
ephysleadch = eventdet_handles.ephysleadch;

leaddog = dog(:,ephysleadch);
leadinstpow = instpow(:,ephysleadch);

ephysxscala = ephys_t_scale(1):(ephys_t_scale(2)-ephys_t_scale(1)):...
    (ephys_t_scale(2)-ephys_t_scale(1))*(size(dog,1)-1)+ephys_t_scale(1);
caxscala = ca_t_scale(1):(ca_t_scale(2)-ca_t_scale(1)):...
    (ca_t_scale(2)-ca_t_scale(1))*(size(normed_ca,2)-1)+ca_t_scale(1);

linkaxes([handles.dogaxes,handles.caaxes,handles.instpowaxes],'x');
plot(handles.dogaxes,ephysxscala*1000,leaddog);
plot(handles.instpowaxes,ephysxscala*1000,leadinstpow);
plot(handles.caaxes,caxscala*1000,normed_ca(1,:));
xlabel(handles.dogaxes,'Time(ms)');
ylabel(handles.dogaxes,'Voltage(\muV)');
xlabel(handles.instpowaxes,'Time(ms)');
ylabel(handles.instpowaxes,'Power(\muV^2)');
xlabel(handles.caaxes,'Time(ms)');
ylabel(handles.caaxes,'dF/F');
title(handles.dogaxes,'Difference of Gaussians');
title(handles.instpowaxes,'Instantaneous Power');
title(handles.caaxes,['Normed Ca2+ ROI #',num2str(handles.canum-1)]);
axis(handles.dogaxes,[-inf inf -inf inf]);
axis(handles.instpowaxes,[-inf inf -inf inf]);
axis(handles.caaxes,[-inf inf -inf inf]);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes waveletBrowser wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = waveletBrowser_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in nextwave.
function nextwave_Callback(hObject, eventdata, handles)
% hObject    handle to nextwave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

eventdet_handles = handles.evdet_hdls;
ephysca = eventdet_handles.ephysca;

if handles.wavenum+1 <= length(ephysca)
    handles.wavenum = handles.wavenum+1;
else
    handles.wavenum = 1;
end

% Update handles structure
guidata(hObject, handles);

showave(hObject,handles);



% --- Executes on button press in prevwave.
function prevwave_Callback(hObject, eventdata, handles)
% hObject    handle to prevwave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

eventdet_handles = handles.evdet_hdls;
ephysca = eventdet_handles.ephysca;

if handles.wavenum-1 >= 1
    handles.wavenum = handles.wavenum-1;
else
    handles.wavenum = length(ephysca);
end

% Update handles structure
guidata(hObject, handles);

showave(hObject,handles);


% --- Executes on button press in prevca.
function prevca_Callback(hObject, eventdata, handles)
% hObject    handle to prevca (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

normed_ca = handles.evdet_hdls.normed_ca;
per_roi_det = handles.evdet_hdls.per_roi_det;
supreme = handles.evdet_hdls.supreme;
cadelay = handles.evdet_hdls.cadelay;
ephysca = handles.evdet_hdls.ephysca;
wavenum = handles.wavenum;
canum = handles.canum;

onlysim = get(handles.onlysim_but,'Value');

switch onlysim
    case 1
        switch supreme
            case 1
                validcanums = ceil(find(((per_roi_det-ephysca(wavenum)) < cadelay) ...
                & ((per_roi_det-ephysca(wavenum)) >= 0))/size(per_roi_det,1));
            case 2
                validcanums = ceil(find(abs(per_roi_det-ephysca(wavenum)) < 0.01)...
                    /size(per_roi_det,1));
        end
    case 0
        validcanums = 1:size(normed_ca,1);
end

validpos = find(validcanums==canum);

if ismember(canum-1,validcanums)
    canum = canum-1;
elseif onlysim == 0
    canum = size(normed_ca,1);
elseif onlysim == 1 && (validpos-1 > 0)
    canum = validcanums(validpos-1);
elseif onlysim == 1 && (validpos-1 <= 0)
    canum = validcanums(end);
end

handles.canum = canum;

guidata(hObject,handles);

showave(hObject,handles);


% --- Executes on button press in nextca.
function nextca_Callback(hObject, eventdata, handles)
% hObject    handle to nextca (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% normed_ca = handles.evdet_hdls.normed_ca;
% 
% if handles.canum+1 <= size(normed_ca,1)
%     handles.canum = handles.canum+1;
% else
%     handles.canum = 1;
% end
% 
% guidata(hObject,handles);
% 
% showave(hObject,handles);

normed_ca = handles.evdet_hdls.normed_ca;
per_roi_det = handles.evdet_hdls.per_roi_det;
supreme = handles.evdet_hdls.supreme;
cadelay = handles.evdet_hdls.cadelay;
ephysca = handles.evdet_hdls.ephysca;
wavenum = handles.wavenum;
canum = handles.canum;

onlysim = get(handles.onlysim_but,'Value');

switch onlysim
    case 1
        switch supreme
            case 1
                validcanums = ceil(find(((per_roi_det-ephysca(wavenum)) < cadelay) ...
                & ((per_roi_det-ephysca(wavenum)) >= 0))/size(per_roi_det,1));
            case 2
                validcanums = ceil(find(abs(per_roi_det-ephysca(wavenum)) < 0.01)...
                    /size(per_roi_det,1));
        end
    case 0
        validcanums = 1:size(normed_ca,1);
end

validpos = find(validcanums==canum);

if ismember(canum+1,validcanums)
    canum = canum+1;
elseif onlysim == 0
    canum = validcanums(1);
elseif onlysim == 1 && (validpos+1 <= length(validcanums))
    canum = validcanums(validpos+1);
elseif onlysim == 1 && (validpos+1 > length(validcanums))
    canum = validcanums(1);
end

handles.canum = canum;

guidata(hObject,handles);

showave(hObject,handles);


% % % --------------- wavelet plotter
function showave(hObject,handles)

eventdet_handles = handles.evdet_hdls;

dog = eventdet_handles.dog;
instpow = eventdet_handles.instpow;
normed_ca = eventdet_handles.normed_ca;
ephys_t_scale = eventdet_handles.ephys_t_scale;
ca_t_scale = eventdet_handles.ca_t_scale;
ephysca = eventdet_handles.ephysca;
ephysleadch = eventdet_handles.ephysleadch;
ephyssrate = eventdet_handles.ephyssrate;
casrate = eventdet_handles.casrate;
ephysaw = eventdet_handles.ephys_allwidths;
caaw = eventdet_handles.ca_allwidths;
supreme = eventdet_handles.supreme;
cadelay = eventdet_handles.cadelay;

wavenum = handles.wavenum;
canum = handles.canum;

leaddog = dog(:,ephysleadch);
leadinstpow = instpow(:,ephysleadch);
currca = normed_ca(canum,:);

ephysxscala = ephys_t_scale(1):(ephys_t_scale(2)-ephys_t_scale(1)):...
    (ephys_t_scale(2)-ephys_t_scale(1))*(size(dog,1)-1)+ephys_t_scale(1);
caxscala = ca_t_scale(1):(ca_t_scale(2)-ca_t_scale(1)):...
    (ca_t_scale(2)-ca_t_scale(1))*(size(normed_ca,2)-1)+ca_t_scale(1);

if wavenum ~= 0
    ephyscurrev_pos = find(abs(ephysxscala-ephysca(wavenum))<=(1/ephyssrate));
    cacurrev_pos = find(abs(caxscala-ephysca(wavenum))<=(1/casrate));
    ephyssurround = round(0.5*ephyssrate);
    casurround = round(0.5*casrate);

    leaddog = leaddog(ephyscurrev_pos-ephyssurround:ephyscurrev_pos+ephyssurround);
    leadinstpow = leadinstpow(ephyscurrev_pos-ephyssurround:ephyscurrev_pos+ephyssurround);
    currca = currca(cacurrev_pos-casurround:cacurrev_pos+casurround);

    ephysxscala = ephysxscala(ephyscurrev_pos-ephyssurround:ephyscurrev_pos+ephyssurround);
    caxscala = caxscala(cacurrev_pos-casurround:cacurrev_pos+casurround);
    
    set(handles.evtstamp,'String',num2str(ephysca(wavenum)*1000));
    
    switch supreme
        case 1
            ephyspos = find(abs(ephysaw(:,1,ephysleadch)-ephysca(wavenum)) < 0.01);
            if ~isempty(ephyspos)
                ephyspos = ephyspos(1);
            end
            capos = find(((caaw(:,1,canum)-ephysca(wavenum)) < cadelay) ...
                & ((caaw(:,1,canum)-ephysca(wavenum)) >= 0));
            if ~isempty(capos)
                capos = capos(1);
            end
        case 2
            ephyspos = find(((ephysaw(:,1,ephysleadch)-ephysca(wavenum)) >= -cadelay) ...
                & ((ephysaw(:,1,ephysleadch)-ephysca(wavenum)) <= 0 ));
            if ~isempty(ephyspos)
                ephyspos = ephyspos(1);
            end
            capos = find(abs(caaw(:,1,canum)-ephysca(wavenum)) < 0.01);
            if ~isempty(capos)
                capos = capos(1);
            end
    end

    set(handles.ephysevlen,'String',num2str(ephysaw(ephyspos,2,ephysleadch)));
    set(handles.caevlen,'String',num2str(caaw(capos,2,canum)));
end

linkaxes([handles.dogaxes,handles.caaxes,handles.instpowaxes],'x');
dogplot = plot(handles.dogaxes,ephysxscala*1000,leaddog);
instpowplot = plot(handles.instpowaxes,ephysxscala*1000,leadinstpow);
caplot = plot(handles.caaxes,caxscala*1000,currca);
if wavenum ~= 0
    dogline = line(handles.dogaxes,[ephysca(wavenum)*1000 ephysca(wavenum)*1000],...
        [min(leaddog) max(leaddog)],'Color','r');
    instpowline = line(handles.instpowaxes,[ephysca(wavenum)*1000 ephysca(wavenum)*1000],...
        [min(leadinstpow) max(leadinstpow)],'Color','r');
    try
        caline = line(handles.caaxes,[caaw(capos,1,canum)*1000 caaw(capos,1,canum)*1000],...
            [min(currca) max(currca)],'Color','r');
    catch
        caline = 0;
    end
end
xlabel(handles.dogaxes,'Time(ms)');
ylabel(handles.dogaxes,'Voltage(\muV)');
xlabel(handles.instpowaxes,'Time(ms)');
ylabel(handles.instpowaxes,'Power(\muV^2)');
xlabel(handles.caaxes,'Time(ms)');
ylabel(handles.caaxes,'dF/F');
title(handles.dogaxes,'Difference of Gaussians');
title(handles.instpowaxes,'Instantaneous Power');
title(handles.caaxes,['Normed Ca2+ ROI #',num2str(canum-1)]);
axis(handles.dogaxes,[-inf inf -inf inf]);
axis(handles.instpowaxes,[-inf inf -inf inf]);
axis(handles.caaxes,[-inf inf -inf inf]);

if wavenum ~= 0
    handles.dogplot = dogplot;
    handles.dogline = dogline;
    handles.instpowplot = instpowplot;
    handles.instpowline = instpowline;
    handles.caplot = caplot;
    handles.caline = caline;
end

guidata(hObject,handles);


% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

switch eventdata.Key
    case 'w'
        prevca_Callback(hObject,eventdata,handles);
    case 's'
        nextca_Callback(hObject,eventdata,handles);
    case 'a'
        prevwave_Callback(hObject,eventdata,handles);
    case 'd'
        nextwave_Callback(hObject,eventdata,handles);
end


% --------------------------------------------------------------------
function restoreview_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to restoreview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

showave(hObject,handles);


% --------------------------------------------------------------------
function annowin_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to annowin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% annotWindow(handles);

opts.Interpreter = 'tex';
scalebarspecs = inputdlg({'Time bar size(ms)','DoG bar size(\muV)','Instpow bar size(\muV^2)',...
    'Ca2+ bar size(dF/F)'},'Scalebar settings',[1 15],{'50','10','2','0.1'},opts);

annowin = figure('Name','Annotation Window','NumberTitle','off');
annowin.ToolBar = 'figure';
annowin.Units = 'normalized';

tb = findall(annowin,'Type','uitoolbar');

copy_button = uipushtool(tb,'TooltipString','Copy figure',...
                 'ClickedCallback','print(''-clipboard'',''-dmeta'')',...
                 'Separator','on');
             
[img,map] = imread(fullfile(matlabroot,...
'toolbox','matlab','icons','pagesicon.gif'));
icon = ind2rgb(img,map);

copy_button.CData = icon;

% annot_dogaxes = copyobj(handles.dogaxes,annowin);
% annot_instpowaxes = copyobj(handles.instpowaxes,annowin);
% annot_caaxes = copyobj(handles.caaxes,annowin);
% set(annot_dogaxes,'Position',[0.1 0.75 0.8 0.2]);
% set(annot_instpowaxes,'Position',[0.1 0.425 0.8 0.2]);
% set(annot_caaxes,'Position',[0.1 0.1 0.8 0.2]);

dogsub = subplot(3,1,1);
dogx = get(handles.dogplot,'XData');
dogy = get(handles.dogplot,'YData');
annot_dog = plot(dogx,dogy);
line(dogsub,handles.dogline.XData,handles.dogline.YData,'Color','r');
drawscalebar(dogsub,dogx,dogy,1,scalebarspecs);

instpowsub = subplot(3,1,2);
instpowx = get(handles.instpowplot,'XData');
instpowy = get(handles.instpowplot,'YData');
annot_instpow = plot(instpowx,instpowy);
line(instpowsub,handles.instpowline.XData,handles.instpowline.YData,'Color','r');
drawscalebar(instpowsub,instpowx,instpowy,2,scalebarspecs);

casub = subplot(3,1,3);
cax = get(handles.caplot,'XData');
cay = get(handles.caplot,'YData');
annot_ca = plot(cax,cay);
if handles.caline ~= 0
    line(casub,handles.caline.XData,handles.caline.YData,'Color','r');
end
drawscalebar(casub,cax,cay,3,scalebarspecs);

xlabel(dogsub,'Time(ms)');
ylabel(dogsub,'Voltage(\muV)');
xlabel(instpowsub,'Time(ms)');
ylabel(instpowsub,'Power(\muV^2)');
xlabel(casub,'Time(ms)');
ylabel(casub,'dF/F');
title(dogsub,'Difference of Gaussians');
title(instpowsub,'Instantaneous Power');
title(casub,['Normed Ca2+ ROI #',num2str(handles.canum-1)]);
axis(dogsub,[-inf inf -inf inf]);
axis(instpowsub,[-inf inf -inf inf]);
axis(casub,[-inf inf -inf inf]);

dogsub.Toolbar.Visible = 'off';
instpowsub.Toolbar.Visible = 'off';
casub.Toolbar.Visible = 'off';


% % % -------------- Scalebar maker
function drawscalebar(axes,xdata,ydata,datatype,scalebarspecs)

xlen = xdata(end) - xdata(1);
ylen = max(ydata) - min(ydata);

hbar_orig = xdata(1) + xlen*0.85;
hbar_end = hbar_orig + str2double(scalebarspecs{1});

vbar_orig = min(ydata) + ylen*0.15;

switch datatype
    case 1
        vbar_end = vbar_orig + str2double(scalebarspecs{2});
        yunit = ' \muV';
    case 2
        yunit = ' \muV^2';
        vbar_end = vbar_orig + str2double(scalebarspecs{3});
    case 3
        yunit = ' dF/F';
        vbar_end = vbar_orig + str2double(scalebarspecs{4});
end

line(axes,[hbar_orig hbar_end],[vbar_orig vbar_orig],'Color','k','LineWidth',1.5);
line(axes,[hbar_end hbar_end],[vbar_orig vbar_end],'Color','k','LineWidth',1.5);
text(hbar_orig,vbar_orig-ylen*0.1,[scalebarspecs{1},' ms'],'FontSize',8);
text(hbar_end+10,vbar_orig+(vbar_end-vbar_orig)*0.5,[scalebarspecs{datatype+1},yunit],'FontSize',8);


% --- Executes on button press in onlysim_but.
function onlysim_but_Callback(hObject, eventdata, handles)
% hObject    handle to onlysim_but (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of onlysim_but

state = get(hObject,'Value');

wavenum = handles.wavenum;
per_roi_det = handles.evdet_hdls.per_roi_det;
cadelay = handles.evdet_hdls.cadelay;
ephysca = handles.evdet_hdls.ephysca;
supreme = handles.evdet_hdls.supreme;

if state
    switch supreme
        case 1
            validcanums = ceil(find(((per_roi_det-ephysca(wavenum)) < cadelay) ...
            & ((per_roi_det-ephysca(wavenum)) >= 0))/size(per_roi_det,1));
        case 2
            validcanums = ceil(find(abs(per_roi_det-ephysca(wavenum)) < 0.01)...
                /size(per_roi_det,1));
    end

    handles.canum = validcanums(1);
    guidata(hObject,handles);

    showave(hObject,handles);
end