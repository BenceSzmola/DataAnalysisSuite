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

% Last Modified by GUIDE v2.5 15-Jul-2019 15:10:06

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
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = eventdetGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% varargout{8} = handles.output;
varargout{8} = hObject;
% varargout{9} = handles;
varargout{1} = get(handles.debug_check,'Value');
varargout{2} = get(handles.figs_check,'Value');
mode = zeros(1,3);
mode(1) = get(handles.simultan_check,'Value');
mode(2) = str2double(get(handles.numchans,'String'));
mode(3) = str2double(get(handles.ephys_block,'String'));
varargout{3} = mode;
datatype = get(handles.type_ephys,'Value');
if datatype
    caorephys = 1;
elseif ~datatype
    caorephys = 2;
end
varargout{4} = caorephys;
ca_param = zeros(1,9);
ca_param(1) = str2double(get(handles.ca_srate,'String'));
ca_param(2) = str2double(get(handles.ca_stepsize,'String'));
ca_param(3) = str2double(get(handles.ca_mindist,'String'));
ca_param(4) = str2double(get(handles.ca_minlen,'String'));
ca_param(5) = str2double(get(handles.ca_maxlen,'String'));
ca_param(6) = str2double(get(handles.dF_thresh,'String'));
ca_param(7) = str2double(get(handles.ca_sd,'String'));
ca_param(8) = str2double(get(handles.ca_qsd,'String'));
% ca_param(9) = get(handles.ca_proc,'Value');
ca_param(9) = str2double(get(handles.gauss_avg_num,'String'));
ca_param(10) = get(handles.ca_proc,'Value');
thresh_type = get(handles.sd_toggle,'Value');
if thresh_type
    ca_param(6) = 0;
elseif ~thresh_type
    
end
varargout{5} = ca_param;
ephys_param = zeros(1,14);
ephys_param(1) = str2double(get(handles.ephys_srate,'String'));
ephys_param(2) = str2double(get(handles.w1,'String'));
ephys_param(3) = str2double(get(handles.w2,'String'));
ephys_param(4) = str2double(get(handles.ephys_stepsize,'String'));
ephys_param(5) = str2double(get(handles.ephys_mindist,'String'));
ephys_param(6) = str2double(get(handles.ephys_minlen,'String'));
ephys_param(7) = str2double(get(handles.ephys_maxlen,'String'));
ephys_param(8) = str2double(get(handles.ephys_sd,'String'));
ephys_param(9) = str2double(get(handles.ephys_qsd,'String'));
ephys_param(10) = str2double(get(handles.qint_len,'String'));
ephys_param(11) = get(handles.denoise_check,'Value');
ephys_param(12) = str2double(get(handles.ephys_refchan,'String'));
ephys_param(13) = get(handles.shift_check,'Value');
ephys_param(14) = get(handles.refchan_crosscheck,'Value');
ephys_param(15) = get(handles.ephys_proc,'Value');
switch get(handles.norm_tgle,'Value')
    case 1
        ephys_param(16) = 1;
    case 0
        ephys_param(16) = 2;
end
varargout{6} = ephys_param;
varargout{7} = str2double(get(handles.ca_delay,'String'));


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
list = {'Gauss avg then 10x upsample'};
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
list = {'DoG + InstPow'};
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



function dF_thresh_Callback(hObject, eventdata, handles)
% hObject    handle to dF_thresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dF_thresh as text
%        str2double(get(hObject,'String')) returns contents of dF_thresh as a double


% --- Executes during object creation, after setting all properties.
function dF_thresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dF_thresh (see GCBO)
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
    set(handles.dF_panel,'Visible','off');
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
    set(handles.dF_panel,'Visible','on');
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


% --- Executes on button press in startbut.
function startbut_Callback(hObject, eventdata, handles)
% hObject    handle to startbut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

uiresume(handles.figure1);
set(handles.progress_tag,'Visible','on');



function qint_len_Callback(hObject, eventdata, handles)
% hObject    handle to qint_len (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of qint_len as text
%        str2double(get(hObject,'String')) returns contents of qint_len as a double


% --- Executes during object creation, after setting all properties.
function qint_len_CreateFcn(hObject, eventdata, handles)
% hObject    handle to qint_len (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gauss_avg_num_Callback(hObject, eventdata, handles)
% hObject    handle to gauss_avg_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gauss_avg_num as text
%        str2double(get(hObject,'String')) returns contents of gauss_avg_num as a double


% --- Executes during object creation, after setting all properties.
function gauss_avg_num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gauss_avg_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in refchan_crosscheck.
function refchan_crosscheck_Callback(hObject, eventdata, handles)
% hObject    handle to refchan_crosscheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of refchan_crosscheck


% --------------------------------------------------------------------
function helpmenu_Callback(hObject, eventdata, handles)
% hObject    handle to helpmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
open EventDetectorHelp.pdf;


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
uiresume(handles.figure1);
delete(hObject);


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
