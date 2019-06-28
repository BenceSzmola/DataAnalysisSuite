function varargout = eventdetGUI(varargin)
% EVENTDETGUI MATLAB code for eventdetGUI.fig
%      EVENTDETGUI, by itself, creates a new EVENTDETGUI or raises the existing
%      singleton*.
%
%      H = EVENTDETGUI returns the handle to a new EVENTDETGUI or the handle to
%      the existing singleton*.
%
%      EVENTDETGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EVENTDETGUI.M with the given input arguments.
%
%      EVENTDETGUI('Property','Value',...) creates a new EVENTDETGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before eventdetGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to eventdetGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help eventdetGUI

% Last Modified by GUIDE v2.5 27-Jun-2019 18:57:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @eventdetGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @eventdetGUI_OutputFcn, ...
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


% --- Executes just before eventdetGUI is made visible.
function eventdetGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to eventdetGUI (see VARARGIN)

% Choose default command line output for eventdetGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes eventdetGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = eventdetGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in simultan_check.
function simultan_check_Callback(hObject, eventdata, handles)
% hObject    handle to simultan_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of simultan_check
simult = get(hObject,'Value');
if simult
    set(handles.datatype,'Visible','off');
    set(handles.ephys_struct,'Visible','on');
    set(handles.delay_panel,'Visible','on');
    set(handles.ca_panel,'Visible','on');
    set(handles.ca_proc,'Visible','on');
    set(handles.ca_proc_txt,'Visible','on');
    set(handles.ephys_panel,'Visible','on');
    set(handles.ephys_proc,'Visible','on');
    set(handles.ephys_proc_txt,'Visible','on');
elseif ~simult
    type_state = get(handles.type_ephys,'Value');
    set(handles.datatype,'Visible','on');
    set(handles.ephys_struct,'Visible','off');
    set(handles.delay_panel,'Visible','off');
    if type_state
        set(handles.ca_panel,'Visible','off');
        set(handles.ca_proc,'Visible','off');
        set(handles.ca_proc_txt,'Visible','off');
        set(handles.ephys_panel,'Visible','on');
        set(handles.ephys_proc,'Visible','on');
        set(handles.ephys_proc_txt,'Visible','on');
    elseif ~type_state
        set(handles.ca_panel,'Visible','on');
        set(handles.ca_proc,'Visible','on');
        set(handles.ca_proc_txt,'Visible','on');
        set(handles.ephys_panel,'Visible','off');
        set(handles.ephys_proc,'Visible','off');
        set(handles.ephys_proc_txt,'Visible','off');
    end
end



% --- Executes on button press in debug_check.
function debug_check_Callback(hObject, eventdata, handles)
% hObject    handle to debug_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of debug_check


% --- Executes on button press in figs_check.
function figs_check_Callback(hObject, eventdata, handles)
% hObject    handle to figs_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of figs_check


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in ca_proc.
function ca_proc_Callback(hObject, eventdata, handles)
% hObject    handle to ca_proc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ca_proc contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ca_proc


% --- Executes during object creation, after setting all properties.
function ca_proc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ca_proc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
list = {'Gauss avg (1.2) then 10x upsample','None'};
set(hObject,'string',list);


% --- Executes on selection change in ephys_proc.
function ephys_proc_Callback(hObject, eventdata, handles)
% hObject    handle to ephys_proc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ephys_proc contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ephys_proc


% --- Executes during object creation, after setting all properties.
function ephys_proc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ephys_proc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
list = {'DoG + InstPow','DoG','InstPow','None'};
set(hObject,'string',list);



function numchans_Callback(hObject, eventdata, handles)
% hObject    handle to numchans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numchans as text
%        str2double(get(hObject,'String')) returns contents of numchans as a double


% --- Executes during object creation, after setting all properties.
function numchans_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numchans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ephys_block_Callback(hObject, eventdata, handles)
% hObject    handle to ephys_block (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ephys_block as text
%        str2double(get(hObject,'String')) returns contents of ephys_block as a double


% --- Executes during object creation, after setting all properties.
function ephys_block_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ephys_block (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ca_srate_Callback(hObject, eventdata, handles)
% hObject    handle to ca_srate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ca_srate as text
%        str2double(get(hObject,'String')) returns contents of ca_srate as a double


% --- Executes during object creation, after setting all properties.
function ca_srate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ca_srate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ca_stepsize_Callback(hObject, eventdata, handles)
% hObject    handle to ca_stepsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ca_stepsize as text
%        str2double(get(hObject,'String')) returns contents of ca_stepsize as a double


% --- Executes during object creation, after setting all properties.
function ca_stepsize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ca_stepsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ca_mindist_Callback(hObject, eventdata, handles)
% hObject    handle to ca_mindist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ca_mindist as text
%        str2double(get(hObject,'String')) returns contents of ca_mindist as a double


% --- Executes during object creation, after setting all properties.
function ca_mindist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ca_mindist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ca_minlen_Callback(hObject, eventdata, handles)
% hObject    handle to ca_minlen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ca_minlen as text
%        str2double(get(hObject,'String')) returns contents of ca_minlen as a double


% --- Executes during object creation, after setting all properties.
function ca_minlen_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ca_minlen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ca_sd_Callback(hObject, eventdata, handles)
% hObject    handle to ca_sd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ca_sd as text
%        str2double(get(hObject,'String')) returns contents of ca_sd as a double


% --- Executes during object creation, after setting all properties.
function ca_sd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ca_sd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ca_qsd_Callback(hObject, eventdata, handles)
% hObject    handle to ca_qsd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ca_qsd as text
%        str2double(get(hObject,'String')) returns contents of ca_qsd as a double


% --- Executes during object creation, after setting all properties.
function ca_qsd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ca_qsd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ca_maxlen_Callback(hObject, eventdata, handles)
% hObject    handle to ca_maxlen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ca_maxlen as text
%        str2double(get(hObject,'String')) returns contents of ca_maxlen as a double


% --- Executes during object creation, after setting all properties.
function ca_maxlen_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ca_maxlen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit33_Callback(hObject, eventdata, handles)
% hObject    handle to edit33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit33 as text
%        str2double(get(hObject,'String')) returns contents of edit33 as a double


% --- Executes during object creation, after setting all properties.
function edit33_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ephys_srate_Callback(hObject, eventdata, handles)
% hObject    handle to ephys_srate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ephys_srate as text
%        str2double(get(hObject,'String')) returns contents of ephys_srate as a double


% --- Executes during object creation, after setting all properties.
function ephys_srate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ephys_srate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function w1_Callback(hObject, eventdata, handles)
% hObject    handle to w1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of w1 as text
%        str2double(get(hObject,'String')) returns contents of w1 as a double


% --- Executes during object creation, after setting all properties.
function w1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to w1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function w2_Callback(hObject, eventdata, handles)
% hObject    handle to w2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of w2 as text
%        str2double(get(hObject,'String')) returns contents of w2 as a double


% --- Executes during object creation, after setting all properties.
function w2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to w2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ephys_stepsize_Callback(hObject, eventdata, handles)
% hObject    handle to ephys_stepsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ephys_stepsize as text
%        str2double(get(hObject,'String')) returns contents of ephys_stepsize as a double


% --- Executes during object creation, after setting all properties.
function ephys_stepsize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ephys_stepsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ephys_mindist_Callback(hObject, eventdata, handles)
% hObject    handle to ephys_mindist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ephys_mindist as text
%        str2double(get(hObject,'String')) returns contents of ephys_mindist as a double


% --- Executes during object creation, after setting all properties.
function ephys_mindist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ephys_mindist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ephys_minlen_Callback(hObject, eventdata, handles)
% hObject    handle to ephys_minlen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ephys_minlen as text
%        str2double(get(hObject,'String')) returns contents of ephys_minlen as a double


% --- Executes during object creation, after setting all properties.
function ephys_minlen_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ephys_minlen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ephys_sd_Callback(hObject, eventdata, handles)
% hObject    handle to ephys_sd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ephys_sd as text
%        str2double(get(hObject,'String')) returns contents of ephys_sd as a double


% --- Executes during object creation, after setting all properties.
function ephys_sd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ephys_sd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ephys_qsd_Callback(hObject, eventdata, handles)
% hObject    handle to ephys_qsd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ephys_qsd as text
%        str2double(get(hObject,'String')) returns contents of ephys_qsd as a double


% --- Executes during object creation, after setting all properties.
function ephys_qsd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ephys_qsd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ephys_maxlen_Callback(hObject, eventdata, handles)
% hObject    handle to ephys_maxlen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ephys_maxlen as text
%        str2double(get(hObject,'String')) returns contents of ephys_maxlen as a double


% --- Executes during object creation, after setting all properties.
function ephys_maxlen_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ephys_maxlen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in denoise_check.
function denoise_check_Callback(hObject, eventdata, handles)
% hObject    handle to denoise_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of denoise_check



% --- Executes on button press in shift_check.
function shift_check_Callback(hObject, eventdata, handles)
% hObject    handle to shift_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of shift_check



function ca_delay_Callback(hObject, eventdata, handles)
% hObject    handle to ca_delay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ca_delay as text
%        str2double(get(hObject,'String')) returns contents of ca_delay as a double


% --- Executes during object creation, after setting all properties.
function ca_delay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ca_delay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dF_Callback(hObject, eventdata, handles)
% hObject    handle to dF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dF as text
%        str2double(get(hObject,'String')) returns contents of dF as a double


% --- Executes during object creation, after setting all properties.
function dF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in sd_toggle.
function sd_toggle_Callback(hObject, eventdata, handles)
% hObject    handle to sd_toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sd_toggle
state = get(hObject,'Value');
if state
    set(handles.dF_thresh,'Visible','off');
    set(handles.sd_thresh,'Visible','on');
end


% --- Executes on button press in dF_toggle.
function dF_toggle_Callback(hObject, eventdata, handles)
% hObject    handle to dF_toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dF_toggle
state = get(hObject,'Value');
if state
    set(handles.dF_thresh,'Visible','on');
    set(handles.sd_thresh,'Visible','off');
end



function ephys_refchan_Callback(hObject, eventdata, handles)
% hObject    handle to ephys_refchan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ephys_refchan as text
%        str2double(get(hObject,'String')) returns contents of ephys_refchan as a double


% --- Executes during object creation, after setting all properties.
function ephys_refchan_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ephys_refchan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in type_ephys.
function type_ephys_Callback(hObject, eventdata, handles)
% hObject    handle to type_ephys (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of type_ephys
state = get(hObject,'Value');
if state
    set(handles.ca_panel,'Visible','off');
    set(handles.ca_proc,'Visible','off');
    set(handles.ca_proc_txt,'Visible','off');
    set(handles.ephys_panel,'Visible','on');
    set(handles.ephys_proc,'Visible','on');
    set(handles.ephys_proc_txt,'Visible','on');
end


% --- Executes on button press in type_ca.
function type_ca_Callback(hObject, eventdata, handles)
% hObject    handle to type_ca (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of type_ca
state = get(hObject,'Value');
if state
    set(handles.ca_panel,'Visible','on');
    set(handles.ca_proc,'Visible','on');
    set(handles.ca_proc_txt,'Visible','on');
    set(handles.ephys_panel,'Visible','off');
    set(handles.ephys_proc,'Visible','off');
    set(handles.ephys_proc_txt,'Visible','off');
end
