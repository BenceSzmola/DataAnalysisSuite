function varargout = annotWindow(varargin)
% ANNOTWINDOW MATLAB code for annotWindow.fig
%      ANNOTWINDOW, by itself, creates a new ANNOTWINDOW or raises the existing
%      singleton*.
%
%      H = ANNOTWINDOW returns the handle to a new ANNOTWINDOW or the handle to
%      the existing singleton*.
%
%      ANNOTWINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANNOTWINDOW.M with the given input arguments.
%
%      ANNOTWINDOW('Property','Value',...) creates a new ANNOTWINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before annotWindow_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to annotWindow_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help annotWindow

% Last Modified by GUIDE v2.5 12-Aug-2019 17:06:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @annotWindow_OpeningFcn, ...
                   'gui_OutputFcn',  @annotWindow_OutputFcn, ...
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


% --- Executes just before annotWindow is made visible.
function annotWindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to annotWindow (see VARARGIN)

% Choose default command line output for annotWindow
handles.output = hObject;

wavelet_hndls = varargin{1};

% copyobj(wavelet_hndls.dogplot,handles.dogaxes);
handles.dogaxes = copyobj(wavelet_hndls.dogaxes,handles.figure1);
handles.instpowaxes = copyobj(wavelet_hndls.instpowaxes,handles.figure1);
handles.caaxes = copyobj(wavelet_hndls.caaxes,handles.figure1);
set(handles.dogaxes,'Position',[0.1 0.75 0.8 0.2]);
set(handles.instpowaxes,'Position',[0.1 0.425 0.8 0.2]);
set(handles.caaxes,'Position',[0.1 0.1 0.8 0.2]);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes annotWindow wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = annotWindow_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function copyfig_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to copyfig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

print('-clipboard','-dmeta');
