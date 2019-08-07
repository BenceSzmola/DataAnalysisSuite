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

% Last Modified by GUIDE v2.5 07-Aug-2019 14:03:18

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

%%% initial plotting
handles.evdet_hdls = varargin{1};
eventdet_handles = varargin{1};
handles.wavenum = 0;
handles.canum = 1;

dog = eventdet_handles.dog;
instpow = eventdet_handles.instpow;
normed_ca = eventdet_handles.normed_ca;
ephys_t_scale = eventdet_handles.ephys_t_scale;
ca_t_scale = eventdet_handles.ca_t_scale;
ephysca = eventdet_handles.ephysca;
ephysleadch = eventdet_handles.ephysleadch;

leaddog = dog(:,ephysleadch);
leadinstpow = instpow(:,ephysleadch);

ephysxscala = ephys_t_scale(1):(ephys_t_scale(2)-ephys_t_scale(1)):(ephys_t_scale(2)-ephys_t_scale(1))*(size(dog,1)-1)+ephys_t_scale(1);
caxscala = ca_t_scale(1):(ca_t_scale(2)-ca_t_scale(1)):(ca_t_scale(2)-ca_t_scale(1))*(size(normed_ca,2)-1)+ca_t_scale(1);

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

if handles.canum-1 >= 1
    handles.canum = handles.canum-1;
else
    handles.canum = size(normed_ca,1);
end

guidata(hObject,handles);

showave(hObject,handles);


% --- Executes on button press in nextca.
function nextca_Callback(hObject, eventdata, handles)
% hObject    handle to nextca (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

normed_ca = handles.evdet_hdls.normed_ca;

if handles.canum+1 <= size(normed_ca,1)
    handles.canum = handles.canum+1;
else
    handles.canum = 1;
end

guidata(hObject,handles);

showave(hObject,handles);


%%% ---------------- wavelet plotter
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

wavenum = handles.wavenum;
canum = handles.canum;

leaddog = dog(:,ephysleadch);
leadinstpow = instpow(:,ephysleadch);
currca = normed_ca(canum,:);

ephysxscala = ephys_t_scale(1):(ephys_t_scale(2)-ephys_t_scale(1)):(ephys_t_scale(2)-ephys_t_scale(1))*(size(dog,1)-1)+ephys_t_scale(1);
caxscala = ca_t_scale(1):(ca_t_scale(2)-ca_t_scale(1)):(ca_t_scale(2)-ca_t_scale(1))*(size(normed_ca,2)-1)+ca_t_scale(1);

if wavenum ~= 0
    ephyscurrev_pos = find(abs(ephysxscala-ephysca(wavenum))<=(1/ephyssrate));
    cacurrev_pos = find(abs(caxscala-ephysca(wavenum))<=(1/casrate));
    ephyssurround = round(0.25*ephyssrate);
    casurround = round(0.25*casrate);

    leaddog = leaddog(ephyscurrev_pos-ephyssurround:ephyscurrev_pos+ephyssurround);
    leadinstpow = leadinstpow(ephyscurrev_pos-ephyssurround:ephyscurrev_pos+ephyssurround);
    currca = currca(cacurrev_pos-casurround:cacurrev_pos+casurround);

    ephysxscala = ephysxscala(ephyscurrev_pos-ephyssurround:ephyscurrev_pos+ephyssurround);
    caxscala = caxscala(cacurrev_pos-casurround:cacurrev_pos+casurround);
end

linkaxes([handles.dogaxes,handles.caaxes,handles.instpowaxes],'x');
plot(handles.dogaxes,ephysxscala*1000,leaddog);
plot(handles.instpowaxes,ephysxscala*1000,leadinstpow);
plot(handles.caaxes,caxscala*1000,currca);
if wavenum ~= 0
    line(handles.dogaxes,[ephysca(wavenum)*1000 ephysca(wavenum)*1000],[min(leaddog) max(leaddog)],'Color','r');
    line(handles.instpowaxes,[ephysca(wavenum)*1000 ephysca(wavenum)*1000],[min(leadinstpow) max(leadinstpow)],'Color','r');
    try
        line(handles.caaxes,[ephysca(wavenum)*1000 ephysca(wavenum)*1000],[min(currca) max(currca)],'Color','r');
    catch

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

