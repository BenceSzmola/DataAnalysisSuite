function varargout = guideTest(varargin)
% GUIDETEST MATLAB code for guideTest.fig
%      GUIDETEST, by itself, creates a new GUIDETEST or raises the existing
%      singleton*.
%
%      H = GUIDETEST returns the handle to a new GUIDETEST or the handle to
%      the existing singleton*.
%
%      GUIDETEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIDETEST.M with the given input arguments.
%
%      GUIDETEST('Property','Value',...) creates a new GUIDETEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guideTest_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guideTest_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guideTest

% Last Modified by GUIDE v2.5 15-Apr-2021 15:58:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guideTest_OpeningFcn, ...
                   'gui_OutputFcn',  @guideTest_OutputFcn, ...
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


% --- Executes just before guideTest is made visible.
function guideTest_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guideTest (see VARARGIN)

% Choose default command line output for guideTest
handles.output = hObject;

linkaxes([handles.axes1,handles.axes2],'x')

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes guideTest wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guideTest_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    [filename,path] = uigetfile('*.rhd');
    if filename == 0
        return
    end
    oldpath = cd(path);
    data = read_Intan_RHD2000_file_szb(filename);
    cd(oldpath)
    data = data.amplifier_data;
    plot(handles.axes1,data(1,:))

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    [filename,path] = uigetfile('*.rhd');
    if filename == 0
        return
    end
    oldpath = cd(path);
    data = read_Intan_RHD2000_file_szb(filename);
    cd(oldpath)
    data = data.amplifier_data;
    plot(handles.axes2,data(2,:))
