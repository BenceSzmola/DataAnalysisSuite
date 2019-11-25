function varargout = eventdetGUI_merged(varargin)
% EVENTDETGUI_MERGED MATLAB code for eventdetGUI_merged.fig
%      EVENTDETGUI_MERGED, by itself, creates a new EVENTDETGUI_MERGED or raises the existing
%      singleton*.
%
%      H = EVENTDETGUI_MERGED returns the handle to a new EVENTDETGUI_MERGED or the handle to
%      the existing singleton*.
%
%      EVENTDETGUI_MERGED('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EVENTDETGUI_MERGED.M with the given input arguments.
%
%      EVENTDETGUI_MERGED('Property','Value',...) creates a new EVENTDETGUI_MERGED or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before eventdetGUI_merged_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to eventdetGUI_merged_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help eventdetGUI_merged

% Last Modified by GUIDE v2.5 17-Sep-2019 15:37:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @eventdetGUI_merged_OpeningFcn, ...
                   'gui_OutputFcn',  @eventdetGUI_merged_OutputFcn, ...
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


% --- Executes just before eventdetGUI_merged is made visible.
function eventdetGUI_merged_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to eventdetGUI_merged (see VARARGIN)

% Choose default command line output for eventdetGUI_merged
handles.output = hObject;

%%% varargin passed on
handles.vargin = varargin;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes eventdetGUI_merged wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = eventdetGUI_merged_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% ingor = handles.vargin;
% [sim_det_gor,doggor,ephys_det_gor,norm_ca_gors,roi_det_gor,handles] = WIP_optimalfilter_withGUI(ingor,hObject,handles);
% varargout = {sim_det_gor,doggor,ephys_det_gor,norm_ca_gors,roi_det_gor};
varargout = handles.out;
assignin('base','vrgout',varargout);
set(handles.progress_tag,'String','Finished! For new detection launch Event Detector again!');
guidata(hObject,handles);


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
ingor = handles.vargin;
[sim_det_gor,doggor,ephys_det_gor,norm_ca_gors,roi_det_gor,handles] = WIP_optimalfilter_withGUI(ingor,hObject,handles);
handles.out = {sim_det_gor,doggor,ephys_det_gor,norm_ca_gors,roi_det_gor,handles};
guidata(hObject,handles);

% eventdetGUI_merged_OutputFcn(hObject,eventdata,handles);
% uiresume(handles.figure1);
% set(handles.progress_tag,'Visible','on');



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

%%% Event detector code
function [sim_det_gor,doggor,ephys_det_gor,norm_ca_gors,roi_det_gor,handles] = WIP_optimalfilter_withGUI(ingor,hObject,handles) 

ingor = ingor{1};
% GUI = hObject;
% varargout{9} = handles;
debug = get(handles.debug_check,'Value');
plots = get(handles.figs_check,'Value');
mode = zeros(1,3);
mode(1) = get(handles.simultan_check,'Value');
mode(2) = str2double(get(handles.numchans,'String'));
mode(3) = str2double(get(handles.ephys_block,'String'));
datatype = get(handles.type_ephys,'Value');
if datatype
    caorephys = 1;
elseif ~datatype
    caorephys = 2;
end
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
ephyvsca_tolerance = str2double(get(handles.ca_delay,'String'));

ephys_param_prompts = {'Sample rate (Hz)','W1 (Hz)','W2 (Hz)','Step size (ms)','Min event distance (ms)',...
            'Event length min (ms)','Event length max (ms)','sd mult','qsd mult','Quietint length (s)', ...
            'Denoise','Reference chan.','1s shift','Disregard based on refchan'};
ca_param_prompts = {'Sample rate (Hz)','Step size (ms)','Min event distance (ms)',...
            'Event length min (ms)','Event length max (ms)','dF/F threshold','sd mult','qsd mult','gauss_avg_num'};
ephys_proclist = {'DoG + InstPow','DoG','InstPow','None'};
ca_proclist = {'Gauss avg then 10x upsample','None'};

%%% gor fogadása
if nargin==0
    [filename, path] = uigetfile('.rhd','Select the RHD');
    cd(path);
    %%% Read RHD
    rhd = read_Intan_RHD2000_file(filename);
    data = rhd.ampdata;
    t_scale = rhd.tdata;
    if debug 
        assignin('base','t_scale',t_scale);
    end
    datatype = questdlg('Ca2+ or Ephys?','Datatype','Ca2+','Ephys','Ca2+');
    switch datatype
        case 'Ca2+'
            caorephys = 2;
            param = ca_param;
        case 'Ephys'
            caorephys = 1;
            param = ephys_param;
    end
    ca_order = []; %%%placeholder
    detettore(data,t_scale,nargin,debug,caorephys,plots,param,ca_order);
    fprintf(1,'Data from console \n');
elseif nargin == 3
%     handles = guidata(hObject); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    set(handles.progress_tag,'String','Reading GORs');
    guidata(hObject,handles);
    if mode(1)==1 && mode(2)>=length(ingor)
        errordlg('It seems you only provided one type of data!');
        close(hObject);
        return
    end
    switch mode(1)
        case 0
            t_scale = get(ingor(1),'x')/1000;
            t_scale(2) = t_scale(1)+t_scale(2);
        case 1
            if mode(3) == 1
                ephys_t_scale = get(ingor(1),'x')/1000;
                ephys_t_scale(2) = ephys_t_scale(1)+ephys_t_scale(2);
                ca_t_scale = get(ingor(mode(2)+1),'x')/1000;
                ca_t_scale(2) = ca_t_scale(1)+ca_t_scale(2);
            elseif mode(3) == 2
                ephys_t_scale = get(ingor(end-mode(2)+1),'x')/1000;
                ephys_t_scale(2) = ephys_t_scale(1)+ephys_t_scale(2);
                ca_t_scale = get(ingor(1),'x')/1000;
                ca_t_scale(2) = ca_t_scale(1)+ca_t_scale(2);    
            end
            if debug
                assignin('base','ephys_t_scale',ephys_t_scale);
                assignin('base','ca_t_scale',ca_t_scale);
            end
    end
    
    if mode(1) == 0
        sim_det_gor = [];
        for i = 1:length(ingor)
            data(i,:) = get(ingor(i), 'extracty');
            if debug
                assignin('base','gorindat',data);
            end
        end
        switch caorephys
            case 1 
                param = ephys_param;
                roi_det_gor = [];
                ca_order = [];
            case 2 
                param = ca_param;
                doggor = [];
                ephys_det_gor = [];
        end
        if caorephys == 2
            names = [];
            for i = 1:length(ingor)
                names = cellstr([names ; get(ingor(i),'name')]);
            end
            if debug 
                assignin('base','gornevek',names);
            end
            ca_order = zeros(length(ingor),1);
            for i = 1:size(names,1)
                thenum = [];
                for j = 1:length(names{i})
                    if ~isnan(str2double(names{i}(j))) && isreal(str2double(names{i}(j)))
                        while ~isnan(str2double(names{i}(j)))
                            thenum = [thenum,names{i}(j)];
                            j = j+1;
                        end
%                         ca_order(i) = str2double(names{i}(j));
                        ca_order(i) = str2double(thenum);
                        break
                    end
                end
            end
            if debug 
                assignin('base','ca_order',ca_order);
            end
            if debug
                assignin('base','ca_before',data);
            end
            cadata_ordered = zeros(size(data));
            ca_order = ca_order+1;
            for i = 1:length(ca_order)
                cadata_ordered(ca_order(i),:) = data(i,:);
            end
            if debug 
                assignin('base','ca_after',cadata_ordered);
            end
            ca_order = min(ca_order):(min(ca_order)+length(ca_order)-1);
            data = cadata_ordered;
            data( ~any(data,2), : ) = [];
        end
        
%         handles = guidata(hObject);
        set(handles.progress_tag,'String','Running detection');
        guidata(hObject,handles);
        
        [det_thresh,quietdata,~,t_scale,consensT,ephysleadch,ephyspower,allpeaksT,dogged,normed_ca,true_srate,allwidths] = detettore(data,t_scale,nargin,debug,caorephys,plots,param,ca_order);
        if debug
            assignin('base','t_scale',t_scale);
        end
        param(1) = true_srate;

%         handles = guidata(hObject);
        set(handles.progress_tag,'String','Creating GORs');
        guidata(hObject,handles);

        norm_ca_gors = [];
        switch caorephys
            case 2
                roi_det_gor = [];
                for i = 1:size(allpeaksT,3)
                    if sum(allpeaksT(:,1,i)) ~= 0
                        newgor = [];
                        temp = unique(allpeaksT(:,1,i));
                        temp(temp==0) = [];
                        newgor.name=['Detections for ROI ',num2str(ca_order(i)-1)];
                        newgor.Marker='*';
                        newgor.MarkerSize=12;
                        newgor.Color='g';
                        newgor.LineStyle='none';
                        newgor.xname = 'Time';
                        newgor.yname = '';
                        newgor.xunit = 'ms';
                        newgor=gorobj('double', temp*1000, 'double', zeros(size(temp)), newgor);
                        roi_det_gor = [roi_det_gor ; newgor];
                    end
                end 
                
                norm_ca_gors = [];
                for i = 1:size(normed_ca,1)
                    newgor = [];
                    newgor.name = ['Normed Ca2+ ROI ',num2str(ca_order(i)-1)];
                    newgor.xname = 'Time';
                    newgor.yname = 'dF/F';
                    newgor.xunit = 'ms';
                    newgor = gorobj('eqsamp',[t_scale(1) t_scale(2)-t_scale(1)]*1000,'double',normed_ca(i,:),newgor);
                    newgor = set(newgor,'vars',1,det_thresh(i,2));
                    newgor = set(newgor,'varnames',1,'Threshold');
                    norm_ca_gors = [norm_ca_gors ; newgor];
                end
            case 1
                doggor_norm = [];
                doggor_norm.name=['Normed Consens channel (Ch',num2str(ephysleadch(1)),') DoG'];
                doggor_norm.Color='r';
                doggor_norm.xname='Time';
                doggor_norm.yname='Voltage';
                doggor_norm.xunit='ms';
                doggor_norm.yunit='\muV';
                doggor_norm.axis=2;
                doggor_norm=gorobj('eqsamp', [t_scale(1) t_scale(2)-t_scale(1)]*1000, 'double', dogged(:,ephysleadch(1)), doggor_norm);
                
                doggor = [];
                doggor.name=['Consens channel (Ch',num2str(ephysleadch(2)),') DoG'];
                doggor.Color='r';
                doggor.xname='Time';
                doggor.yname='Voltage';
                doggor.xunit='ms';
                doggor.yunit='\muV';
                doggor.axis=2;
                doggor=gorobj('eqsamp', [t_scale(1) t_scale(2)-t_scale(1)]*1000, 'double', dogged(:,ephysleadch(2)), doggor);
                
                powgor = [];
                powgor.name=['Consens channel (Ch',num2str(ephysleadch(2)),') InstPow'];
                powgor.Color='r';
                powgor.xname='Time';
                powgor.yname='Power';
                powgor.xunit='ms';
                powgor.yunit='\muV^2';
                powgor.axis=2;
                powgor=gorobj('eqsamp', [t_scale(1) t_scale(2)-t_scale(1)]*1000, 'double', ephyspower(:,ephysleadch(2)), powgor);
                powgor=set(powgor,'vars',1,det_thresh(ephysleadch(2),2));
                powgor=set(powgor,'varnames',1,'Threshold');
                
                powgor_norm = [];
                powgor_norm.name=['Normed Consens channel (Ch',num2str(ephysleadch(1)),') InstPow'];
                powgor_norm.Color='r';
                powgor_norm.xname='Time';
                powgor_norm.yname='Power';
                powgor_norm.xunit='ms';
                powgor_norm.yunit='\muV^2';
                powgor_norm.axis=2;
                powgor_norm=gorobj('eqsamp', [t_scale(1) t_scale(2)-t_scale(1)]*1000, 'double', ephyspower(:,ephysleadch(1)), powgor_norm);
                powgor_norm=set(powgor_norm,'vars',1,det_thresh(ephysleadch(1),2));
                powgor_norm=set(powgor_norm,'varnames',1,'Threshold');
                
                ref_doggor = [];
                ref_doggor_norm = [];
                if ephys_param(11)~=0 || ephys_param(14)~=0
                    ref_doggor.name=['Reference channel (Ch',num2str(param(12)),') DoG'];
                    ref_doggor.Color='r';
                    ref_doggor.xname='Time';
                    ref_doggor.yname='Voltage';
                    ref_doggor.xunit='ms';
                    ref_doggor.yunit='\muV';
                    ref_doggor.axis=2;
                    ref_doggor=gorobj('eqsamp', [t_scale(1) t_scale(2)-t_scale(1)]*1000, 'double', dogged(:,param(12)), ref_doggor);
                end
                
                ref_powgor = [];
                ref_powgor_norm = [];
                if ephys_param(11)~=0 || ephys_param(14)~=0
                    ref_powgor.name=['Reference channel (Ch',num2str(ephys_param(12)),') InstPow'];
                    ref_powgor.Color='r';
                    ref_powgor.xname='Time';
                    ref_powgor.yname='Power';
                    ref_powgor.xunit='ms';
                    ref_powgor.yunit='\muV^2';
                    ref_powgor.axis=2;
                    ref_powgor=gorobj('eqsamp', [t_scale(1) t_scale(2)-t_scale(1)]*1000, 'double', ephyspower(:,param(12)), ref_powgor);
                    ref_powgor=set(ref_powgor,'vars',1,det_thresh(param(12),2));
                    ref_powgor=set(ref_powgor,'varnames',1,'Threshold');
                end
                
                doggor = [doggor_norm; doggor; powgor_norm; powgor; ref_doggor; ref_powgor];
                
                ephyscons_onlyT = consensT(:,1);
                ephyscons_onlyT(ephyscons_onlyT==t_scale(1)) = nan;
                if debug
                    assignin('base','ephyscons_onlyT',ephyscons_onlyT)
                end
                
                ephys_det_gor = [];
                ephys_det_gor.name=['Detections consens channel (Ch',num2str(ephysleadch(2)),')'];
                ephys_det_gor.xname='Time';
                ephys_det_gor.yname='';
                ephys_det_gor.xunit='ms';
                ephys_det_gor.Marker='*';
                ephys_det_gor.MarkerSize=12;
                ephys_det_gor.Color='g';
                ephys_det_gor.LineStyle='none';
                ephys_det_gor=gorobj('double',allpeaksT(:,1,ephysleadch(2))*1000,'double',zeros(size(allpeaksT(:,1,ephysleadch(2)))),ephys_det_gor);
                
                ephys_det_gor_norm = [];
                ephys_det_gor_norm.name=['Detections normed consens channel (Ch',num2str(ephysleadch(1)),')'];
                ephys_det_gor_norm.xname='Time';
                ephys_det_gor_norm.yname='';
                ephys_det_gor_norm.xunit='ms';
                ephys_det_gor_norm.Marker='*';
                ephys_det_gor_norm.MarkerSize=12;
                ephys_det_gor_norm.Color='g';
                ephys_det_gor_norm.LineStyle='none';
                ephys_det_gor_norm=gorobj('double',ephyscons_onlyT*1000,'double',zeros(size(ephyscons_onlyT)),ephys_det_gor_norm);
               
                refchan_det_gor = [];
                if ephys_param(11)~=0 || ephys_param(14)~=0
                    refchan_det_gor.name=['Detections reference channel (Ch',num2str(ephys_param(12)),')'];
                    refchan_det_gor.xname='Time';
                    refchan_det_gor.yname='';
                    refchan_det_gor.xunit='ms';
                    refchan_det_gor.Marker='*';
                    refchan_det_gor.MarkerSize=12;
                    refchan_det_gor.Color='g';
                    refchan_det_gor.LineStyle='none';
                    refchan_det_gor=gorobj('double',allpeaksT(:,1,param(12))*1000,'double',zeros(size(allpeaksT(:,1,param(12)))),refchan_det_gor);
                end
                
                ephys_det_gor = [ephys_det_gor_norm; ephys_det_gor ; refchan_det_gor];
        end
        
%         handles = guidata(hObject);
        set(handles.progress_tag,'String','Writing CSV');
        guidata(hObject,handles);
        
        switch caorephys
            case 1
                handles.ephyssrate = true_srate;
                handles.dog = dogged;
                handles.instpow = ephyspower;
                handles.ephys_t_scale = t_scale;
                handles.ephys_allwidths = allwidths;
                switch ephys_param(16)
                    case 1
                        handles.ephysleadch = ephysleadch(1);
                    case 2
                        handles.ephysleadch = ephysleadch(2);
                end
                handles.ephyscons_onlyT = ephyscons_onlyT(~isnan(ephyscons_onlyT));
                handles.caorephys = 1;
                handles.ephys_quietdata = quietdata;
            case 2
                handles.casrate = true_srate;
                handles.normed_ca = normed_ca;
                handles.ca_t_scale = t_scale;
                handles.ca_allwidths = allwidths;
                handles.caorephys = 2;
                temp = zeros(size(allpeaksT,3),size(allpeaksT,1));
                maxlen = 0;
                for i = 1:size(allpeaksT,3)
                    temp1 = allpeaksT(:,1,i);
                    temp1 = temp1(:);
                    temp1 = temp1(temp1~=0);
                    temp1 = temp1(~isnan(temp1));
                    temp(i,1:length(temp1)) = temp1;
                    if length(temp1) > maxlen 
                        maxlen = length(temp1);
                    end
                end
                temp = temp(:,1:maxlen);
                handles.cacons_onlyT = temp;
        end
        handles.simult = 0;
        guidata(hObject,handles);
        if debug
            assignin('base','guistuff',handles);
        end

        %%% CSV irás
        [csvname,path] = uiputfile('*.csv','Name results CSV!');
        if csvname == 0
            finitodlg = warndlg('Event detection is finished!','Finished');
            pause(0.5);
            if ishandle(finitodlg)
                close(finitodlg);
            end
            return
        end
        cd(path);
        fileID = fopen(string(csvname),'w');
        if fileID == -1
            warndlg('This CSV is already opened! Please close it and then press OK!');
            waitforbuttonpress;
            fileID = fopen(string(csvname),'w');
        end
        switch caorephys
            case 1 
                fprintf(fileID,'Mode: %d\n',get(handles.simultan_check,'Value'));
                fprintf(fileID,'\n \n');
                fprintf(fileID,'Ephys parameters \n');
                for i = 1:length(ephys_param_prompts)
                    fprintf(fileID,'%s: %d \n',string(ephys_param_prompts(i)),param(i));
                end
                
                fprintf(fileID,'Selected processing: %s \n',ephys_proclist{param(15)});
                
                fprintf(fileID,'\n');
               
                fprintf(fileID,'Normed Lead Channel: %d \n',ephysleadch(1));
                fprintf(fileID,'Non-normed Lead Channel: %d \n',ephysleadch(2));             
                
                fprintf(fileID,'\n');
                
                fprintf(fileID,'Detection thresholds per channel \n');
                for i = 1:length(ingor)
                    fprintf(fileID,'#%d ; %5.4f \n',i,det_thresh(i,2));
                end
                
                fprintf(fileID,'\n');
                
                fprintf(fileID,'Events grouped by channel (s) \n');
                for i = 1:size(allpeaksT,3)
                    fprintf(fileID,'#%d;',i);
                    for j = 1:length(allpeaksT(:,1,i))
                        if allpeaksT(j,1,i) ~= t_scale(1)
                            fprintf(fileID,'%5.4f;',allpeaksT(j,1,i));
                        end
                    end
                    fprintf(fileID,'\n');
                end
                fprintf(fileID,'Num of events per channel \n');
                for i = 1:size(allpeaksT,3)
                    temp = allpeaksT(:,1,i);
                    temp = temp(temp ~= t_scale(1));
                    fprintf(fileID,'#%d; %d \n',i,length(temp));
                end
                                
            case 2
                fprintf(fileID,'Mode: %d\n',get(handles.simultan_check,'Value'));
                fprintf(fileID,'Num of ROIs: %d\n',length(ingor));
                fprintf(fileID,'\n');
                fprintf(fileID,'Ca2+ parameters \n');
                for i = 1:length(ca_param_prompts)
                    fprintf(fileID,'%s: %d \n',string(ca_param_prompts(i)),param(i));
                end
                
                fprintf(fileID,'Selected processing: %s \n',ca_proclist{param(10)});
                                               
                fprintf(fileID,'\n');
                
                fprintf(fileID,'Detection thresholds per ROI \n');
                for i = 1:length(ingor)
                    fprintf(fileID,'#%d ; %5.4f \n',ca_order(i)-1,det_thresh(i,2));
                end
                
                fprintf(fileID,'\n');
                
                fprintf(fileID,'Active ROIs for each event\n');
                fprintf(fileID,'Timestamp(s);ROIs\n');
                unipeaks = unique(allpeaksT(:,1,:));
                unipeaks(unipeaks == 0) = [];
                [~,lib] = ismember(allpeaksT,unipeaks);
                inds = lib(:,1,:);
                inds=inds(:);
                for i = 1:length(unipeaks)
                    founds=find(inds == i);
                    rois = ceil(founds/4);
                    fprintf(fileID,'%.4f ; ',unipeaks(i));
                    for j = 1:length(rois)
                        fprintf(fileID,'%d# ',rois(j));
                    end
                    fprintf(fileID,'\n');
                end
                
                fprintf(fileID,'\n');
                
                fprintf(fileID,'Events grouped by ROI(s) \n');
                for i = 1:size(allpeaksT,3)
                    fprintf(fileID,'#%d;',ca_order(i)-1);
                    for j = 1:length(allpeaksT(:,1,i))
                        if allpeaksT(j,1,i) ~= t_scale(1)
                            fprintf(fileID,'%5.4f;',allpeaksT(j,1,i));
                        end
                    end
                    fprintf(fileID,'\n');
                end
                fprintf(fileID,'Num of events per ROI \n');
                for i = 1:size(allpeaksT,3)
                    temp = allpeaksT(:,1,i);
                    temp = temp(temp ~= t_scale(1));
                    fprintf(fileID,'#%d; %d \n',ca_order(i)-1,length(temp));
                end
        end
        fclose(fileID);
        
    end
    if mode(1) == 1
        numcach = length(ingor)-mode(2);
        if mode(3) == 1
            for i = 1:mode(2)
                ephysdata(i,:) = get(ingor(i), 'extracty');
            end
            for i = mode(2)+1:length(ingor)
                cadata(i-mode(2),:) = get(ingor(i),'extracty');
            end
            
            names = [];
            for i = mode(2)+1:length(ingor)
                names = cellstr([names ; get(ingor(i),'name')]);
            end
            if debug 
                assignin('base','gornevek',names);
            end
            ca_order = zeros(numcach,1);
            for i = 1:size(names,1)
                thenum = [];
                for j = 1:length(names{i})
                    while ~isnan(str2double(names{i}(j)))
                        thenum = [thenum,names{i}(j)];
                        j = j+1;
                    end
%                         ca_order(i) = str2double(names{i}(j));
                    ca_order(i) = str2double(thenum);
                    break
                end
            end
            if debug 
                assignin('base','ca_order',ca_order);
            end
            
            cadata_ordered = zeros(size(cadata));
            ca_order = ca_order+1;
            for i = 1:length(ca_order)
                cadata_ordered(ca_order(i),:) = data(i,:);
            end
            if debug 
                assignin('base','ca_after',cadata_ordered);
            end
            ca_order = min(ca_order):(min(ca_order)+length(ca_order)-1);
            cadata = cadata_ordered;
            cadata( ~any(cadata,2), : ) = [];

%             handles = guidata(hObject);
            set(handles.progress_tag,'String','Running detection');
            guidata(hObject,handles);

            [ephys_det_thresh,ephys_quietdata,~,~,ephysconsensT,ephysleadch,ephyspower,ephys_allpeaksT,dogged,~,ephys_true_srate,ephys_allwidths] = detettore(ephysdata,ephys_t_scale,nargin,debug,1,plots,ephys_param,ca_order);
            [ca_det_thresh,ca_quietdata,cadata,ca_t_scale,~,~,~,ca_allpeaksT,~,normed_ca,ca_true_srate,ca_allwidths] = detettore(cadata,ca_t_scale,nargin,debug,2,plots,ca_param,ca_order);
            ca_param(1) = ca_true_srate;
            ephys_param(1) = ephys_true_srate;
            
%             handles = guidata(hObject);
%             handles.normed_ca = normed_ca;
%             handles.dog = dogged;
%             handles.instpow = ephyspower;
%             handles.ca_t_scale = ca_t_scale;
%             handles.ephys_t_scale = ephys_t_scale;
%             guidata(hObject,handles);
%             assignin('base','guistuff',handles);
            
            if debug
                assignin('base','ephysconsensT',ephysconsensT);
                assignin('base','ca_allpeaksT',ca_allpeaksT);                
            end
        elseif mode(3) == 2
            numcach = length(ingor)-mode(2);
            for i = (length(ingor)-mode(2)+1):length(ingor)
                ephysdata(i-numcach,:) = get(ingor(i), 'extracty');
            end
            for i = 1:(length(ingor)-mode(2))
                cadata(i,:) = get(ingor(i),'extracty');
            end
            
            names = [];
            for i = 1:(length(ingor)-mode(2))
                names = cellstr([names ; get(ingor(i),'name')]);
            end
            if debug 
                assignin('base','gornevek',names);
            end
            ca_order = zeros(numcach,1);
            for i = 1:size(names,1)
                thenum = [];
                for j = 1:length(names{i})
                    if ~isnan(str2double(names{i}(j))) && isreal(str2double(names{i}(j)))
                        while ~isnan(str2double(names{i}(j)))
                            thenum = [thenum,names{i}(j)];
                            j = j+1;
                        end
%                         ca_order(i) = str2double(names{i}(j));
                        ca_order(i) = str2double(thenum);
                        break
                    end
                end
            end
            if debug 
                assignin('base','ca_order',ca_order);
                assignin('base','ca_before',cadata);
            end
            
            cadata_ordered = zeros(size(cadata));
            ca_order = ca_order+1;
            for i = 1:length(ca_order)
                cadata_ordered(ca_order(i),:) = cadata(i,:);
            end
            ca_order = min(ca_order):(min(ca_order)+length(ca_order)-1);
            cadata = cadata_ordered;
            cadata( ~any(cadata,2), : ) = [];
            if debug 
                assignin('base','ca_after',cadata);
                assignin('base','ca_order_ordered',ca_order);
            end
            
%             handles = guidata(hObject);
            set(handles.progress_tag,'String','Running detection');
            guidata(hObject,handles);
            
            og_catscale = ca_t_scale;
            og_cadata = cadata;
            [ca_det_thresh,ca_quietdata,cadata,ca_t_scale,~,~,~,ca_allpeaksT,~,normed_ca,ca_true_srate,ca_allwidths] = detettore(cadata,ca_t_scale,nargin,debug,2,plots,ca_param,ca_order);
            [ephys_det_thresh,ephys_quietdata,~,~,ephysconsensT,ephysleadch,ephyspower,ephys_allpeaksT,dogged,~,ephys_true_srate,ephys_allwidths] = detettore(ephysdata,ephys_t_scale,nargin,debug,1,plots,ephys_param,ca_order);
            ca_param(1) = ca_true_srate;
            ephys_param(1) = ephys_true_srate;
            
%             handles = guidata(hObject);
%             handles.normed_ca = normed_ca;
%             handles.dog = dogged;
%             handles.instpow = ephyspower;
%             handles.ca_t_scale = ca_t_scale;
%             handles.ephys_t_scale = ephys_t_scale;
%             guidata(hObject,handles);
%             assignin('base','guistuff',handles);
            
            if debug
                assignin('base','ephysconsensT',ephysconsensT);
                assignin('base','ca_allpeaksT',ca_allpeaksT);                
            end
        end
                
        if ephys_param(13)
            ephys_t_scale = ephys_t_scale +1;
        end
        
        handles.ephyssrate = ephys_true_srate;
        handles.casrate = ca_true_srate;
        handles.normed_ca = normed_ca;
        handles.dog = dogged;
        handles.instpow = ephyspower;
        handles.ca_t_scale = ca_t_scale;
        handles.ephys_t_scale = ephys_t_scale;
        handles.ca_allwidths = ca_allwidths;
        handles.ephys_allwidths = ephys_allwidths;
        switch ephys_param(16)
            case 1
                handles.ephysleadch = ephysleadch(1);
            case 2
                handles.ephysleadch = ephysleadch(2);
        end
        handles.simult = 1;
        handles.caorephys = 0;
        handles.ephys_quietdata = ephys_quietdata;
        guidata(hObject,handles);
        if debug
            assignin('base','guistuff',handles);
        end

        %%% ca & ephys comparison

%         handles = guidata(hObject);
        set(handles.progress_tag,'String','Running simultan detection');
        guidata(hObject,handles);

        caavg = cadata(1,:);
        if size(cadata,2) > 1
            for i = 2:size(cadata,1)
                caavg = cat(3,caavg,cadata(i,:));
            end
        end
        caavg = mean(caavg,3);
        if debug
            assignin('base','caavg',caavg);
        end
        switch ephys_param(16)
            case 2
                ephyscons_onlyT = ephys_allpeaksT(:,1,ephysleadch(2));
                ephyscons_onlyT(ephyscons_onlyT==ephys_t_scale(1)) = nan;
            case 1
                ephyscons_onlyT = ephysconsensT(:,1);
                ephyscons_onlyT(ephyscons_onlyT==ephys_t_scale(1)) = nan;
        end
        if debug
            assignin('base','ephyscons_onlyT',ephyscons_onlyT)
        end
        ca_allpeaksT(ca_allpeaksT==[0 0]) = nan;
        cacons_onlyT = ca_allpeaksT(:,1,:);
        cacons_onlyT = cacons_onlyT(:);
        if debug 
            assignin('base','cacons_onlyT',cacons_onlyT)
        end
        ephysca = [];
        supreme = 0;
        wb = waitbar(0,'Cross-checking Ca2+ and Ephys','Name','Ca2+ vs Ephys');
        for i = 1:max(size(ephyscons_onlyT,1),size(cacons_onlyT,1))
            if size(ephyscons_onlyT,1) > size(cacons_onlyT,1)
                supreme = 2;
                ephysca = [ephysca ; cacons_onlyT((-1*(ephyscons_onlyT(i,1)-cacons_onlyT)<ephyvsca_tolerance) & ...
                    (-1*(ephyscons_onlyT(i,1)-cacons_onlyT)>0))];
            elseif size(ephyscons_onlyT,1) < size(cacons_onlyT,1)
                supreme = 1;
                ephysca = [ephysca ; ephyscons_onlyT(((cacons_onlyT(i,1)-ephyscons_onlyT)<ephyvsca_tolerance) & ...
                    ((cacons_onlyT(i,1)-ephyscons_onlyT)>0))];
            end
            waitbar(i/max(size(ephyscons_onlyT,1),size(cacons_onlyT,1)));
        end
        if debug
            assignin('base','freshlybakedephysca',ephysca)
        end
        ephysca = unique(ephysca);
        
%         handles = guidata(hObject);
        set(handles.progress_tag,'String','Creating GORs');
        handles.ephysca = ephysca;
        handles.cadelay = ephyvsca_tolerance;
        handles.supreme = supreme;
        handles.cacons_onlyT = cacons_onlyT;
        handles.ephyscons_onlyT = ephyscons_onlyT(~isnan(ephyscons_onlyT));
        guidata(hObject,handles);
        
        norm_ca_gors = [];
        for i = 1:size(normed_ca,1)
            newgor = [];
            newgor.name = ['Normed Ca2+ ROI ',num2str(ca_order(i)-1)];
            newgor.xname = 'Time';
            newgor.yname = 'dF/F';
            newgor.xunit = 'ms';
            newgor = gorobj('eqsamp',[ca_t_scale(1) ca_t_scale(2)-ca_t_scale(1)]*1000,'double',normed_ca(i,:),newgor);
            newgor = set(newgor,'vars',1,ca_det_thresh(i,2));
            newgor = set(newgor,'varnames',1,'Threshold');
            norm_ca_gors = [norm_ca_gors ; newgor];
        end

        sim_det_gor = [];
        sim_det_gor.name=['Detected simultan events'];
        sim_det_gor.xname='Time';
        sim_det_gor.yname='';
        sim_det_gor.xunit='ms';
        sim_det_gor.Marker='*';
        sim_det_gor.MarkerSize=12;
        sim_det_gor.Color='g';
        sim_det_gor.LineStyle='none';
        sim_det_gor=gorobj('double',ephysca*1000,'double',zeros(size(ephysca)),sim_det_gor);
        
        doggor_norm = [];
        doggor_norm.name=['Normed Consens channel (Ch',num2str(ephysleadch(1)),') DoG'];
        doggor_norm.Color='r';
        doggor_norm.xname='Time';
        doggor_norm.yname='Voltage';
        doggor_norm.xunit='ms';
        doggor_norm.yunit='\muV';
        doggor_norm.axis=2;
        doggor_norm=gorobj('eqsamp', [ephys_t_scale(1) ephys_t_scale(2)-ephys_t_scale(1)]*1000, 'double', dogged(:,ephysleadch(1)), doggor_norm);
        
        doggor = [];
        doggor.name=['Consens channel (Ch',num2str(ephysleadch(2)),') DoG'];
        doggor.Color='r';
        doggor.xname='Time';
        doggor.yname='Voltage';
        doggor.xunit='ms';
        doggor.yunit='\muV';
        doggor.axis=2;
        doggor=gorobj('eqsamp', [ephys_t_scale(1) ephys_t_scale(2)-ephys_t_scale(1)]*1000, 'double', dogged(:,ephysleadch(2)), doggor);
        
        powgor_norm = [];
        powgor_norm.name=['Normed Consens channel (Ch',num2str(ephysleadch(1)),') InstPow'];
        powgor_norm.Color='r';
        powgor_norm.xname='Time';
        powgor_norm.yname='Power';
        powgor_norm.xunit='ms';
        powgor_norm.yunit='\muV^2';
        powgor_norm.axis=2;
        powgor_norm=gorobj('eqsamp', [ephys_t_scale(1) ephys_t_scale(2)-ephys_t_scale(1)]*1000, 'double', ephyspower(:,ephysleadch(1)), powgor_norm);
        powgor_norm=set(powgor_norm,'vars',1,ephys_det_thresh(ephysleadch(1),2));
        powgor_norm=set(powgor_norm,'varnames',1,'Threshold');
        
        powgor = [];
        powgor.name=['Consens channel (Ch',num2str(ephysleadch(2)),') InstPow'];
        powgor.Color='r';
        powgor.xname='Time';
        powgor.yname='Power';
        powgor.xunit='ms';
        powgor.yunit='\muV^2';
        powgor.axis=2;
        powgor=gorobj('eqsamp', [ephys_t_scale(1) ephys_t_scale(2)-ephys_t_scale(1)]*1000, 'double', ephyspower(:,ephysleadch(2)), powgor);
        powgor=set(powgor,'vars',1,ephys_det_thresh(ephysleadch(2),2));
        powgor=set(powgor,'varnames',1,'Threshold');
        
        ref_doggor = [];
        if ephys_param(11)~=0 || ephys_param(14)~=0 
            ref_doggor.name=['Reference channel (Ch',num2str(ephys_param(12)),') DoG'];
            ref_doggor.Color='r';
            ref_doggor.xname='Time';
            ref_doggor.yname='Voltage';
            ref_doggor.xunit='ms';
            ref_doggor.yunit='\muV';
            ref_doggor.axis=2;
            ref_doggor=gorobj('eqsamp', [ephys_t_scale(1) ephys_t_scale(2)-ephys_t_scale(1)]*1000, 'double', dogged(:,ephys_param(12)), ref_doggor);
        end
        
        ref_powgor = [];
        if ephys_param(11)~=0 || ephys_param(14)~=0
            ref_powgor.name=['Reference channel (Ch',num2str(ephys_param(12)),') InstPow'];
            ref_powgor.Color='r';
            ref_powgor.xname='Time';
            ref_powgor.yname='Power';
            ref_powgor.xunit='ms';
            ref_powgor.yunit='\muV^2';
            ref_powgor.axis=2;
            ref_powgor=gorobj('eqsamp', [ephys_t_scale(1) ephys_t_scale(2)-ephys_t_scale(1)]*1000, 'double', ephyspower(:,ephys_param(12)), ref_powgor);
            ref_powgor=set(ref_powgor,'vars',1,ephys_det_thresh(ephys_param(12),2));
            ref_powgor=set(ref_powgor,'varnames',1,'Threshold');
        end
        
        doggor = [doggor_norm; doggor; powgor_norm; powgor; ref_doggor; ref_powgor];
        
        ephys_det_gor_norm = [];
        ephys_det_gor_norm.name=['Detections normed consens channel (Ch',num2str(ephysleadch(1)),')'];
        ephys_det_gor_norm.xname='Time';
        ephys_det_gor_norm.yname='';
        ephys_det_gor_norm.xunit='ms';
        ephys_det_gor_norm.Marker='*';
        ephys_det_gor_norm.MarkerSize=12;
        ephys_det_gor_norm.Color='g';
        ephys_det_gor_norm.LineStyle='none';
        ephys_det_gor_norm=gorobj('double',ephyscons_onlyT*1000,'double',zeros(size(ephyscons_onlyT)),ephys_det_gor_norm);
        
        ephys_det_gor = [];
        ephys_det_gor.name=['Detections consens channel (Ch',num2str(ephysleadch(2)),')'];
        ephys_det_gor.xname='Time';
        ephys_det_gor.yname='';
        ephys_det_gor.xunit='ms';
        ephys_det_gor.Marker='*';
        ephys_det_gor.MarkerSize=12;
        ephys_det_gor.Color='g';
        ephys_det_gor.LineStyle='none';
        ephys_det_gor=gorobj('double',ephys_allpeaksT(:,1,ephysleadch(2))*1000,'double',zeros(size(ephys_allpeaksT(:,1,ephysleadch(2)))),ephys_det_gor);
        
        refchan_det_gor = [];
        if ephys_param(11)~=0 || ephys_param(14)~=0
            refchan_det_gor.name=['Detections reference channel (Ch',num2str(ephys_param(12)),')'];
            refchan_det_gor.xname='Time';
            refchan_det_gor.yname='';
            refchan_det_gor.xunit='ms';
            refchan_det_gor.Marker='*';
            refchan_det_gor.MarkerSize=12;
            refchan_det_gor.Color='g';
            refchan_det_gor.LineStyle='none';
            refchan_det_gor=gorobj('double',ephys_allpeaksT(:,1,ephys_param(12))*1000,'double',zeros(size(ephys_allpeaksT(:,1,ephys_param(12)))),refchan_det_gor);
        end
        
        ephys_det_gor = [ephys_det_gor_norm; ephys_det_gor; refchan_det_gor];
        
        %%% delay values
        delays = [];
        for i = 1:length(ephysca)
            switch supreme
                case 2
                    tempdelays = ephyscons_onlyT((-1*(ephyscons_onlyT-ephysca(i))<ephyvsca_tolerance) & ...
                        (-1*(ephyscons_onlyT-ephysca(i))>0));
                case 1 
                    tempdelays = cacons_onlyT(((cacons_onlyT-ephysca(i))<ephyvsca_tolerance) & ...
                        ((cacons_onlyT-ephysca(i))>0));
            end
            if ~isempty(tempdelays)
                delays = [delays; tempdelays(1)];
            end
        end
        ephysca_other = delays;
        if ~isempty(delays)
            delays = abs(ephysca-delays);
            avgdelays = mean(delays);
        else
            delays = [];
            avgdelays = [];
        end

        if debug 
            assignin('base','delays',delays);
        end
        
        per_roi_det = zeros(size(ephysca,1),1,size(cadata,1));
        for i = 1:size(ephysca,1)
            switch supreme
                case 1
                    cainds = find(((ca_allpeaksT-ephysca(i))<=ephyvsca_tolerance)...
                        & ((ca_allpeaksT-ephysca(i)) >= 0));
                case 2
                    cainds = find(abs(ca_allpeaksT-ephysca(i))<0.01);                    
            end
            [num,type,roi] = ind2sub(size(ca_allpeaksT),cainds);
            loc = [num,type,roi];
            if debug
                display(loc);
            end
            for j = 1:size(loc,1)
                if loc(j,2)==1
                    ii = length(nonzeros(per_roi_det(:,1,loc(j,3))))+1;
                    per_roi_det(ii,1,loc(j,3)) = ephysca(i);
                end
            end
        end
        
        handles.per_roi_det = per_roi_det;
        guidata(hObject,handles);
        
        close(wb);
        
        figure;
        sp1=subplot(2,1,1);
        exscala = ephys_t_scale(1):(ephys_t_scale(2)-ephys_t_scale(1)):ephys_t_scale(1)+(ephys_t_scale(2)-ephys_t_scale(1))*(length(ephyspower(:,ephysleadch(2)))-1);
        plot(exscala*1000,ephyspower(:,ephysleadch(2)),'r'); hold on;
%       [ephys_t_scale(1)*1000, (ephys_t_scale(2)*1000-ephys_t_scale(1)*1000)*length(ephyspower)]
        for i=1:length(ephysca)
            line([ephysca(i)*1000 ephysca(i)*1000],[min(ephyspower(:,ephysleadch(2))), max(ephyspower(:,ephysleadch(2)))],'Color','g');
        end
        hold off;
        sp2=subplot(2,1,2);
        caxscala = og_catscale(1):(og_catscale(2)-og_catscale(1)):og_catscale(1)+(og_catscale(2)-og_catscale(1))*(length(og_cadata(9,:))-1);
        plot(caxscala*1000,og_cadata(9,:)); hold on;
        prd_extract = per_roi_det(:,:,9);
        for i=1:size(prd_extract,1)
            line([prd_extract(i)*1000 prd_extract(i)*1000],[min(og_cadata(9,:)), max(og_cadata(9,:))],'Color','g');
        end
        linkaxes([sp1,sp2],'x');
        axis tight;
        
        if debug
            assignin('base','ephysca',ephysca);
            assignin('base','per_roi_det',per_roi_det);
        end
        
        %%% Roionként detection gor
        roi_det_gor = [];
        for i = 1:size(per_roi_det,3)
            if sum(per_roi_det(:,:,i)) ~= 0
                newgor = [];
                temp = unique(per_roi_det(:,:,i));
                temp(temp==0) = [];
                newgor.name=['Simultan detections for ROI ',num2str(ca_order(i)-1)];
                newgor.Marker='*';
                newgor.MarkerSize=12;
                newgor.Color='g';
                newgor.LineStyle='none';
                newgor.xname = 'Time';
                newgor.yname = '';
                newgor.xunit = 'ms';
                newgor=gorobj('double', temp*1000, 'double', zeros(size(temp)), newgor);
                roi_det_gor = [roi_det_gor ; newgor];
            end
        end 
        
        %%% CSV irás
%         handles = guidata(hObject);
        set(handles.progress_tag,'String','Writing CSV');
        guidata(hObject,handles);

        [csvname,path] = uiputfile('*.csv','Name results CSV!');
        if csvname == 0
            finitodlg = warndlg('Event detection is finished!','Finished');
            pause(0.5);
            if ishandle(finitodlg)
                close(finitodlg);
            end
            return
        end
        cd(path);
        fileID = fopen(string(csvname),'w');
        if fileID == -1
            warndlg('This csv is already opened! Please close it and then press OK!');
            waitforbuttonpress;
            fileID = fopen(string(csvname),'w');
        end
        fprintf(fileID,'Mode: %d\n',get(handles.simultan_check,'Value'));
        fprintf(fileID,'Num of ROIs: %d\n',size(per_roi_det,3));
        fprintf(fileID,'\n');
        fprintf(fileID,'%s \n','Ephys parameters');
        for i = 1:length(ephys_param_prompts)
            fprintf(fileID,'%s: %d \n',string(ephys_param_prompts(i)),ephys_param(i));
        end
        fprintf(fileID,'Ephys processing: %s \n',ephys_proclist{ephys_param(15)});
        fprintf(fileID,'\n %s \n','Ca2+ parameters');
        for i = 1:length(ca_param_prompts)
            fprintf(fileID,'%s: %d \n',string(ca_param_prompts(i)),ca_param(i));
        end
        fprintf(fileID,'Ca2+ processing: %s \n',ca_proclist{ca_param(10)});
        
        fprintf(fileID,'\n');
        
        fprintf(fileID,'Ca2+ delay vs Ephys (s): %5.4f \n',ephyvsca_tolerance);
        
        fprintf(fileID,'\n');
        
        fprintf(fileID,'Ephys normed leadchannel: %d \n',ephysleadch(1));
        fprintf(fileID,'Ephys non-normed leadchannel: %d \n',ephysleadch(2));
        switch ephys_param(16)
            case 1
                fprintf(fileID,'Selected for simultan detection: %d \n',ephysleadch(1));
            case 2
                fprintf(fileID,'Selected for simultan detection: %d \n',ephysleadch(2));                
        end
        
        fprintf(fileID,'\n');
        
        fprintf(fileID,'Ca2+ detection thresholds per ROI \n');
        for i = 1:size(ca_det_thresh,1)
            fprintf(fileID,'%d# ;',ca_order(i)-1);
        end
        fprintf(fileID,'\n');
        for i = 1:size(ca_det_thresh,1)
            fprintf(fileID,'%5.4f;',ca_det_thresh(i,2));
        end
        fprintf(fileID,'\n');
        fprintf(fileID,'Ephys detection thresholds per channel \n');
        for i = 1:size(ephys_det_thresh,1)
            fprintf(fileID,'%d# ;',i);
        end
        fprintf(fileID,'\n');
        for i = 1:size(ephys_det_thresh,1)
            fprintf(fileID,'%5.4f;',ephys_det_thresh(i,2));
        end
        fprintf(fileID,'\n');
        
        fprintf(fileID,'\n');
        
        if ephys_param(11)~=0 || ephys_param(14)~=0
            fprintf(fileID,'Reference channel detections: (s) \n');
            for i =1:length(ephys_allpeaksT(:,1,ephys_param(12)))
                if ephys_allpeaksT(i,1,ephys_param(12)) ~= ephys_t_scale(1)
                    fprintf(fileID,'%5.4f ;',ephys_allpeaksT(i,1,ephys_param(12)));
                end
            end
            fprintf(fileID,'\n');

            fprintf(fileID,'\n');
        end
        
        switch supreme
            case 1
                fprintf(fileID,'%s %d \n','Ephys simultan events (s) num=',length(ephysca));
            case 2
                fprintf(fileID,'%s %d \n','Ca2+ simultan events (s) num=',length(ephysca));
        end
        for i = 1:length(ephysca)  
            if i == length(ephysca)
                fprintf(fileID,'%5.4f \n',ephysca(i));
            else
                fprintf(fileID,'%5.4f ; ',ephysca(i));            
            end
        end
        switch supreme
            case 2
                fprintf(fileID,'%s %d \n','Ephys simultan events (s) num=',length(ephysca));
            case 1
                fprintf(fileID,'%s %d \n','Ca2+ simultan events (s) num=',length(ephysca));
        end
        for i = 1:length(ephysca_other)  
            if i == length(ephysca_other)
                fprintf(fileID,'%5.4f \n',ephysca_other(i));
            else
                fprintf(fileID,'%5.4f ; ',ephysca_other(i));            
            end
        end
        
        fprintf(fileID,'\n');
        
        fprintf(fileID,'Delays between Ephys and Ca2+ (s) \n');
        for i = 1:length(delays)
            fprintf(fileID,'%5.4f ; ',delays(i));
        end
        fprintf(fileID,'\nAvg delay (s) = %5.4f \n',avgdelays);
        
        fprintf(fileID,'\n');
        
        fprintf(fileID,'Active ROIs during individual events: \n');
        fprintf(fileID,'Timestamp(s) ; ROIs \n');
        for i = 1:length(ephysca)
            fprintf(fileID,'%5.4f ; ',ephysca(i));
            rois = ceil(find(abs(per_roi_det-ephysca(i))<0.01)/size(per_roi_det,1));
            for j = 1:length(rois)
                fprintf(fileID,'%d# ',rois(j));
            end
            fprintf(fileID,'\n');
        end
        
        fprintf(fileID,'\n');
        
        fprintf(fileID,'%s \n','All Ca2+ events grouped by ROI + simultan Ca2+ events(s)');
        for i = 1:size(per_roi_det,3)
            fprintf(fileID,'%d# ; ',ca_order(i)-1);
            for j = 1:size(ca_allpeaksT(:,:,i),1)
                if ~isnan(ca_allpeaksT(j,1,i))
                    fprintf(fileID,'%5.4f ; ',ca_allpeaksT(j,1,i));
                end
            end
            fprintf(fileID,'\n');
            fprintf(fileID,'%d# simult ; ',ca_order(i)-1);
            temp = per_roi_det(:,:,i);
            temp = unique(temp);
            temp(temp==0) = [];
            temp2 = ca_allpeaksT(:,1,i);
            temp2 = unique(temp2);
            temp2(temp2==0) = [];
            temp2(isnan(temp2)) = [];
            temp3 = [];
            for j = 1:length(temp2)
                for k = 1:length(temp)
                    if ((temp2(j)-temp(k)) >= 0) && ((temp2(j)-temp(k)) < ephyvsca_tolerance)
                        temp3 = [temp3 ; temp2(j)];
                    end
                end
            end
            if debug
                assignin('base','temp',temp);
                assignin('base','temp2',temp2);
                assignin('base','temp3',temp3);
            end
%             temp3 = temp2(ismembertol(temp2,temp,ephyvsca_tolerance,'DataScale',1));
%             temp3 = temp3(temp3-temp >=0);
            if isempty(temp3)
                fprintf(fileID,'\n');
                continue
            end
            for j = 1:size(temp3,1)
                fprintf(fileID,'%5.4f ; ',temp3(j));
            end
            if ~isempty(temp3)
                fprintf(fileID,'\n');
            end
        end
        fprintf(fileID,'%s \n','Num of Detected/Simultan Ca2+ events grouped by ROI');
        for i = 1:size(ca_allpeaksT,3)
            fprintf(fileID,'%d# ;',ca_order(i)-1);
        end
        fprintf(fileID,'\n');
        allperdet = zeros(size(ca_allpeaksT,3),2);
        for i = 1:size(ca_allpeaksT,3)
            all = 0;
            for j = 1:size(ca_allpeaksT(:,:,i),1)
                if ~isnan(ca_allpeaksT(j,1,i))
                    all = all + 1;
                end
            end
            temp = per_roi_det(:,:,i);
            temp = unique(temp);
            temp(temp==0) = [];
            temp2 = ca_allpeaksT(:,1,i);
            temp2 = unique(temp2);
            temp2(temp2==0) = [];
            temp2(isnan(temp2)) = [];
            temp3 = temp2(ismembertol(temp2,temp,ephyvsca_tolerance,'DataScale',1));
            det = length(temp3);
            allperdet(i,:) = [all,det];
        end
        for i = 1:size(ca_allpeaksT,3)
            fprintf(fileID,'%d;',allperdet(i,1));
        end
        fprintf(fileID,'\nsum Ca2+: %d \n',sum(allperdet(:,1)));
        for i = 1:size(ca_allpeaksT,3)
            fprintf(fileID,'%d;',allperdet(i,2));
        end
        fprintf(fileID,'\nsum simultan Ca2+: %d \n',sum(allperdet(:,2))); 
        
        fprintf(fileID,'\n');
        
        fprintf(fileID,'%s %d','Ephys events not associated with Ca2+ (s) num =');
        temp = [];
        num = 0;
        for i = 1:size(ephyscons_onlyT,1)
            if (~ismembertol(ephyscons_onlyT(i),ephysca,ephyvsca_tolerance,'DataScale',1)) && (~isnan(ephyscons_onlyT(i)))
                temp = [temp; ephyscons_onlyT(i)];
                num = num + 1;
            end
        end
        fprintf(fileID,'%d \n',num);
        for i = 1:length(temp)
            fprintf(fileID,'%5.4f ; ',temp(i));
        end
        
        fclose(fileID);
        %%% end of CSV write
    end 
    finitodlg = warndlg('Event detection is finished!','Finished');
    pause(0.5);
    if ishandle(finitodlg)
        close(finitodlg);
    end
end

% close(hObject);

function [det_thresh,quietdata,indataFull,t_scale,consensT,leadchan,power,allpeaksT,dogged,normed_ca,true_srate,allwidths] = detettore(indataFull,t_scale,gore,debug,caorephys,plots,param,ca_order)

srate = 1/(t_scale(2)-t_scale(1));
if gore ~= 3
    srate = param(1);
end
switch caorephys
    case 1
        w1 = param(2);
        w2 = param(3);
        denoise = param(11);
        refch = param(12);
        winstepsize = round(param(4)*(srate/1000));
        eventdist = param(5)*(srate/1000);
        sdmult = param(8);
        qsdmult = param(9);
        sec = param(10);
        widthlower = param(6);
        widthupper = param(7);
        selected = param(15);
        offsetcorr = param(13);
        refchan_crosscheck = param(14);
        if denoise==0 && refchan_crosscheck==0
            refch = 0;
        end
    case 2
        offsetcorr = 0;
        refch = 0;
        denoise = 0;
        refchan_crosscheck = 0;
        winstepsize = round(param(2)*(srate/1000));
        eventdist = param(3)*(srate/1000);
        widthlower = param(4);
        widthupper = param(5);
        dFF_thresh = param(6);
        sdmult = param(7);
        qsdmult = param(8);
        selected = param(10);
        gauss_avg_num = param(9);
end

true_srate = srate;

if offsetcorr
    t_scale = t_scale+1;
end

if debug 
    assignin('base','indata',indataFull);
end
if gore == 0
    len = size(indataFull,1)-1;
else
    len = size(indataFull,1);
end
ivec = 1:len;
noref = 1:len;
if refch ~= 0
    ivec([1 refch]) = ivec([refch 1]);
    noref(noref==refch) = [];
end
if debug
    assignin('base','noref',noref);
end
dogged = zeros(size(indataFull,2),len);
if debug
    assignin('base','dog',dogged);
end
power = zeros(size(indataFull,2),len);

%%% Ca kezelés
if gore == 3 && caorephys == 2 && selected == 2 
    power = transpose(indataFull);
elseif gore == 3 && caorephys == 2 && selected == 1
    for i = 1:len
        cagor = [];
        cagor = gorobj('eqsamp', [t_scale(1) t_scale(2)-t_scale(1)]*1000, 'double', indataFull(i,:), cagor);
        filter.type = 'gaavr';
        filter.W1 = 1/gauss_avg_num/2/((t_scale(2)-t_scale(1))*1000);
        filter.ends = 1;
        smoothedCa = FilterUse(cagor,filter);
        filter2.type = 'resample';
        filter2.W1 = 1/0.1/2/((t_scale(2)-t_scale(1))*1000);
        upsampCa = FilterUse(smoothedCa,filter2);
        tempca(:,i) = get(upsampCa,'extracty');  
    end
    t_scale = (get(upsampCa,'x'))/1000;
    srate = 1/t_scale(2);
    true_srate = srate;
    t_scale(2) = t_scale(1)+t_scale(2);
    winstepsize = round(param(2)*(srate/1000));
    eventdist = param(3)*(srate/1000);
    power = tempca;
    indataFull = transpose(tempca);
end
if debug && caorephys == 2
    assignin('base','processedCAinput',power);
    assignin('base','altered_ca_t_scale',t_scale);
end

%%% Filters
if selected == 1 && caorephys == 1
    for i = ivec
        indata = indataFull(i,:);
        if i ~= refch && denoise == 1
            indata = indata - indataFull(refch,:);
        end
        %%% Substract mean from lfp 
    %     indataMS = indata - mean(indata,2);

        %%% Apply DoG (from BuzsakiLab)
        GFw1       = makegausslpfir( w1, srate, 6 );
        GFw2       = makegausslpfir( w2, srate, 6 );
        lfpLow     = firfilt( indata, GFw2 );      % lowpass filter
        eegLo      = firfilt( lfpLow, GFw1 );   % highpass filter
        lfpLow     = lfpLow - eegLo;            % difference of Gaussians

        dogged(:,i) = lfpLow;
        
    end
    if debug
        assignin('base','postdogged',dogged);
    end
elseif selected == 3 && caorephys == 1
    dogged = indataFull(1:5,:);
    dogged = transpose(dogged);
    if debug
        assignin('base','predogged',dogged);
    end
end
if (selected == 1 || selected == 3) && caorephys == 1
    for i = ivec

        %%%% Apply DoG (from BuzsakiLab) with meansubstract
        %GFw1MS       = makegausslpfir( w1, srate, 6 );
        %GFw2MS       = makegausslpfir( w2, srate, 6 );
        %lfpLowMS     = firfilt( indataMS, GFw2MS );      % lowpass filter
        %eegLoMS      = firfilt( lfpLowMS, GFw1MS );   % highpass filter
        %lfpLowMS     = lfpLowMS - eegLoMS;            % difference of Gaussians

        %%% Instantaneous power (from BuzsakiLab)
        ripWindow  = pi / mean( [w1 w2] );
        powerWin   = makegausslpfir( 1 / ripWindow, srate, 4 );

        rip        = dogged(:,i);
        rip        = abs(rip);
        ripPower0  = firfilt( rip, powerWin );
        ripPower0  = max(ripPower0,[],2);

        power(:,i) = ripPower0;

    end
end

if debug
    assignin('base','POWER',power);
end
%%% Alapzaj meghatározása
piccolo = zeros(size(indataFull,2),len);
for i = ivec
    currpow = power(:,i);
    %%% Közös intervallumot keres változat
    quietthresh(i) = (mean(currpow) + qsdmult*std(currpow));
    piccolo(1:length(find(currpow < (mean(currpow) + qsdmult*std(currpow)))),i) = find(currpow < (mean(currpow) + qsdmult*std(currpow)));
end
if debug
    assignin('base','quietthresh',quietthresh);
    assignin('base','piccolo',piccolo);
end
switch length(ivec)
    case 0
        warndlg('Not enough channels');
        return;
    case 1
        sect = piccolo;
    case 2
        sect = intersect(piccolo(:,ivec(1)),piccolo(:,ivec(2)));
    otherwise
        sect = intersect(piccolo(:,ivec(1)),piccolo(:,ivec(2)));
        for i = ivec(3):ivec(end)
            sect = intersect(piccolo(:,i),sect);
        end
end

if debug
    assignin('base','runsect',sect);
end
qsect = diff(sect);
louds = qsect(qsect>1);
if debug
    assignin('base','runlouds',louds);
end
[~, inds] = ismember(qsect,louds);
goodinds = find(inds~=0);
goodinds = goodinds + 1;
if(goodinds(1) ~= 1)
    goodinds = cat(1,1,goodinds);
end
if debug
    assignin('base','runginds',goodinds);
end
[quietivlen, ind] = max(diff(goodinds));
quietiv = [sect(goodinds(ind)), sect(goodinds(ind))+quietivlen];
quietivs = zeros(size(indataFull,2),2,len);
quietivs(1,:,1) = quietiv;
if debug
    assignin('base','intervals',quietiv);
end
quietivT = (quietiv/srate)+t_scale(1);
if debug
    assignin('base','intervalsT',quietivT);
end

extendedivs = 0;
%%% Ha tul rovid az interval, vagy eleve nincs közös, akkor csatornankent hozzarakok 
if caorephys == 2
    sec = inf;
end
if ((quietiv(2)-quietiv(1)) < sec*srate)
    extendedivs = 1;
    maxnum = 0;
    for i = ivec
        extquiets = piccolo(:,i);
        diffquiets = diff(extquiets);
        extlouds = diffquiets(diffquiets>1);
        [~, inds] = ismember(diffquiets,extlouds);
        extgoodinds = find(inds~=0);
        if(extgoodinds(1) ~= 1)
            extgoodinds = cat(1,1,extgoodinds);
        end
        goodies = diff(extgoodinds);
        if debug
            assignin('base',['goodies',num2str(i)],goodies);
        end
        tempivs = zeros(length(goodies),2);
        tempivs(1,:) = quietiv;
        indx = 1;
        while (sum(tempivs(:,2)-tempivs(:,1))) < (sec*srate+(quietiv(2)-quietiv(1)))
            indx = indx + 1;
            [goodielen, ind] = max(goodies);
            if goodielen == 0 && caorephys == 1
                warn = warndlg('Couldnt reach specified quietlenght');
                pause(0.25);
                close(warn);
                break
            elseif goodielen == 0 && caorephys == 2
                break
            end
            tempivs(indx,:) = [extquiets(extgoodinds(ind)) , extquiets(extgoodinds(ind))+goodielen];
            goodies(ind) = 0;
        end
        if debug
            assignin('base',['fulltempivs',num2str(i)],tempivs);
        end
        tempivs = tempivs(any(tempivs,2),:);
        tempivs2 = tempivs;
        if debug
            assignin('base',['tempivs',num2str(i)],tempivs);
            assignin('base',['extgoodies',num2str(i)],goodies);  
        end
        for j = 2:size(tempivs,1)
            overlap = intersect(tempivs(j,1):tempivs(j,2),tempivs(1,1):tempivs(1,2));
            if length(overlap) > 1
                tempivs2(j,:) = [];
                tempivs2 = cat(1,tempivs2,[tempivs(j,1) overlap(1)]);
                tempivs2 = cat(1,tempivs2,[overlap(end) tempivs(j,2)]);
            end
        end
        if size(tempivs2,1) > maxnum
            maxnum = size(tempivs2,1);
        end
        quietivs(1:size(tempivs2,1),:,i) = tempivs2;
        if debug
            assignin('base','quietivs',quietivs);
            assignin('base',['tempivs2',num2str(i)],tempivs2);
        end
    end
    for i = 1:size(quietivs,3)
        quietivs(maxnum+1:end,:,:) = [];
    end
    if debug
        assignin('base','quietivs',quietivs);
    end
    quietivsT = quietivs;
    quietivsT(:,:,:) = (quietivsT(:,:,:)/srate)+t_scale(1);
    if debug
        assignin('base','quietivsT',quietivsT);
    end
end

%%% Ca adatok normálása, baselineolása
% norm_ca_gors = [];
normed_ca = [];
if caorephys == 2
    for i = 1:size(indataFull,1)
        quiet = indataFull(i,quietiv(1)+1:quietiv(2)+1);
        for q = 2:size(quietivs,1)
            quiet = cat(2,quiet,indataFull(i,quietivs(q,1,i)+1:quietivs(q,2,i)+1));
        end
        avg = mean(quiet);
        indataFull(i,:) = indataFull(i,:)/avg;
        quiet = indataFull(i,quietiv(1)+1:quietiv(2)+1);
        for q = 2:size(quietivs,1)
            quiet = cat(2,quiet,indataFull(i,quietivs(q,1,i)+1:quietivs(q,2,i)+1));
        end
        avg = mean(quiet);
        indataFull(i,:) = indataFull(i,:)-avg;
%         newgor = [];
%         newgor.name = ['Normed_Ca_Roi_',num2str(ca_order(i)-1)];
%         newgor.xname = 'Time';
%         newgor.yname = 'dF/F';
%         newgor.xunit = 'ms';
%         newgor = gorobj('eqsamp',[t_scale(1) t_scale(2)-t_scale(1)]*1000,'double',indataFull(i,:),newgor);
%         newgor = set(newgor,'vars',1,det_thresh(i));
%         norm_ca_gors = [norm_ca_gors ; newgor];
    end
    normed_ca = indataFull;
    power = transpose(indataFull);
end

allpeaksDP = zeros(size(indataFull,2),2,length(noref));
if debug
    assignin('base','INITallpeaksDP',allpeaksDP);
end
%%%%%%%%%%%%%%
%%% SWR detect
%%%%%%%%%%%%%%
det_thresh = zeros(length(ivec),2);
allwidths = zeros(size(indataFull,2),2,length(ivec));
for i = ivec
    currpow = power(:,i);
    if debug
        assignin('base',['currpow',num2str(i)],currpow);
    end
    %%% +1 hogy ne 0-tol indexeljen
    quiet = currpow(quietiv(1)+1:quietiv(2)+1);
    if extendedivs == 1
        for q = 2:size(quietivs,1)
            quiet = cat(1,quiet,(currpow(quietivs(q,1,i)+1:quietivs(q,2,i)+1)));
        end
    end
    if debug
        assignin('base',['quiet',num2str(i)],quiet);
    end
    quietdata{i} = quiet;
    peaks = zeros(round(length(currpow)/winstepsize),2);
    peaknum = 2;
    ripsd = mean(quiet) + sdmult*std(quiet);
    if i == refch
        ripsd = mean(currpow) + sdmult*std(currpow);
    end
    det_thresh(i,:) = [i,ripsd];
    if (caorephys == 2) && (dFF_thresh ~= 0)
        ripsd = dFF_thresh;
    end
    if debug
        display(caorephys)
        display(ripsd)
    end
    if plots
        if caorephys == 0
            figure('Name',['Channel',num2str(i)],'NumberTitle','off');
        elseif caorephys == 1
            figure('Name',['Ephys_Channel',num2str(i)],'NumberTitle','off');
        elseif caorephys == 2
            figure('Name',['Ca_Channel',num2str(i)],'NumberTitle','off');
        end
    end
    xscala = t_scale(1):(t_scale(2)-t_scale(1)):t_scale(1)+(t_scale(2)-t_scale(1))*(size(indataFull,2)-1);
    if plots
        if (caorephys == 0) || (caorephys == 1)
            ax1=subplot(2,1,1);
            plot(xscala*1000,dogged(:,i));
            grid on;
            title('DoG');
            ax2=subplot(2,1,2);
            plot(xscala*1000,currpow); hold on;
            title('Instantaneous power');
            grid on;
            linkaxes([ax1 ax2],'x');
        elseif caorephys == 2
            plot(xscala*1000,currpow); hold on;
            title('Calcium signal');
            grid on;
        end
    end
    
    for j = 1:winstepsize:(length(currpow)-winstepsize*2)
        [peak, index] = max(currpow(j:j+(winstepsize*2)));
        index = j+index-1;
        if (peak > ripsd) %&& ((index-peaks(peaknum-1,1)) > 500)
            peaks(peaknum,:) = [index, peak];
        end
        peaks(peaknum,1) = index;
        peaknum = peaknum + 1;
    end
    if debug
        assignin('base','peaksvol1',peaks);
    end
    peaks = unique(peaks,'stable','rows');
    peaks = peaks(find(peaks(:,2)),:);
    ppeaks = peaks;
    if debug
        assignin('base','upeaksvol1',ppeaks);
    end
    for k = 2:size(peaks,1)-1
        if (((peaks(k,1) - peaks(k-1,1)) < eventdist) && (peaks(k,2) < peaks(k-1,2))) || ...
                (((peaks(k+1,1) - peaks(k,1)) < eventdist) && (peaks(k,2) < peaks(k+1,2)))
            ppeaks(k,2) = 0;
        end        
    end
    if size(ppeaks,1)>1
        if ((peaks(2,1)-peaks(1,1)) < eventdist) && (peaks(1,2) < peaks(2,2))
            ppeaks(1,2) = 0;
        end
        if ((peaks(end,1)-peaks(end-1,1)) < eventdist) && (peaks(end,2) < peaks(end-1,2))
            ppeaks(end,2) = 0;
        end
    end
    if debug
        assignin('base','peaksvol2',ppeaks);
    end
    ppeaks = ppeaks(find(ppeaks(:,2)),:);
    if debug
        assignin('base','rips',currpow);
    end
    
    %%% Hossz alapján kiszûrés
    widths = zeros(size(ppeaks,1),1);
    preallwidths = [];
    for ii = 1:size(ppeaks,1)
        iii = ppeaks(ii,1);
        while currpow(iii) > ripsd
            if (iii-1)<1
                break
            end
            iii = iii - 1;
        end
        lowedge = iii;
        if debug
            assignin('base','lowedge',lowedge);
        end
        iii = ppeaks(ii,1);
        while (currpow(iii) > ripsd) && (iii < size(currpow,1))
            iii = iii + 1;
        end
        highedge = iii;
        if debug
            assignin('base','highedge',highedge);
        end
        widths(ii) = (highedge - lowedge)/(srate/1000);
%         allwidths(ii,1,i) = ppeaks(ii,1);
%         allwidths(ii,2,i) = widths(ii);
        if (widths(ii) < widthlower) || (widths(ii) > widthupper)
            ppeaks(ii,2) = 0;
        else 
%             preallwidths(ii,1) = ppeaks(ii,1);
%             preallwidths(ii,2) = widths(ii);
            preallwidths = cat(1,preallwidths,[ppeaks(ii,1),widths(ii)]);
        end
        if debug
            assignin('base','widths',widths);
        end
    end
    
    if debug
        assignin('base','preallwidths',preallwidths);
    end
        
%     widths = widths((widths>=widthlower) & (widths<=widthupper));
    ppeaks = ppeaks(find(ppeaks(:,2)),:);
    
    if ~isempty(preallwidths)
        leng = length(preallwidths(find(preallwidths(:,2))));
        allwidths(1:leng,:,i) = preallwidths(find(preallwidths(:,2)),:);
    end
    
    %%% refcsatorna peakjei
    if i == refch
        refppeaks = ppeaks;
    end
    
    %%% refchan-hoz hasonlítás
    if i ~= refch && refchan_crosscheck == 1
        for jj = 1:size(ppeaks,1)
            for kk = 1:size(refppeaks,1)
                if (abs(refppeaks(kk,1)-ppeaks(jj,1))<eventdist) && (refppeaks(kk,2) ~=0)
                    ppeaks(jj,2) = 0;
                    continue
                end
            end    
        end    
    end
    ppeaks = ppeaks(find(ppeaks(:,2)),:);
    
    %%% all peaks in one (((except refch)))
%     if i ~= refch 
        allpeaksDP(1:size(ppeaks,1),:,i) = ppeaks;
%     end
    %%% Átírás idõskálára 
    for ii = 1:size(ppeaks,1)
        ppeaks(ii,1) = ((ppeaks(ii,1)-1)/srate)+t_scale(1);
    end
    for ii = 1:size(allwidths,1)
        allwidths(ii,1,i) = ((allwidths(ii,1,i)-1)/srate)+t_scale(1);
    end
    if debug
        assignin('base',['peaks', num2str(i)],ppeaks);
    end
    if plots
        plot(ppeaks(:,1)*1000,ppeaks(:,2),'o'); hold on;
        line([t_scale(1)*1000, (t_scale(2)-t_scale(1))*length(currpow)*1000],[ripsd ripsd],'Color','r'); hold off;
    end
  
end

maxlen = 0;
for i = 1:size(allwidths,3)
    if length(nonzeros(allwidths(:,2,i))) > maxlen
        maxlen = length(nonzeros(allwidths(:,2,i)));
    end
end
allwidths(maxlen+1:end,:,:) = [];

if debug && caorephys == 1
    assignin('base','ephysallwidths',allwidths);
elseif debug && caorephys == 2
    assignin('base','caallwidths',allwidths);
end

maxsize = 0;
for ii = 1:size(allpeaksDP,3)
    if max(find(allpeaksDP(:,1,ii))) > maxsize
        maxsize = max(find(allpeaksDP(:,1,ii)));
    end
end
allpeaksDP(maxsize+1:end,:,:) = [];
if debug
    assignin('base','allpeaksDP',allpeaksDP);
end
%%% valid channel crosscheck
if (size(allpeaksDP,1) > 1) && (caorephys ~= 2)
    consens = zeros(size(allpeaksDP,1),2);
    maxpownorm = 0;
    maxpow = 0;
    leadchan = zeros(1,2);
    for i = noref
        if ((mean(allpeaksDP(:,2,i))/length(find(allpeaksDP(:,2,i)))) > maxpownorm)
            maxpownorm = mean(allpeaksDP(:,2,i))/length(find(allpeaksDP(:,2,i)));
            leadchan(1) = i;
        end
        if ((mean(allpeaksDP(:,2,i))) > maxpow)
            maxpow = mean(allpeaksDP(:,2,i));
            leadchan(2) = i;
        end
    end
    consens = cat(2,allpeaksDP(:,1,leadchan(1)),ones(size(allpeaksDP,1),1));
    consens = cat(2,consens,zeros(size(consens,1),len));
    if debug
        display(leadchan);
    end
    for i = 1:size(allpeaksDP,3)
        if i ~= leadchan(1)
            [lia,locb] = ismembertol(allpeaksDP(:,1,i),allpeaksDP(:,1,leadchan(1)),1000,'DataScale',1);
            ulocb = unique(locb);
            ulocb = ulocb(find(ulocb));
            for j = 1:size(ulocb)
                consens(ulocb(j),2) = consens(ulocb(j),2) + 1;
                consens(ulocb(j),2+i) = 1;
            end
        end
    end
    if debug
        assignin('base','consens',consens);
    end
    consensT = consens;
    consensT(:,1) = ((consensT(:,1))/srate)+t_scale(1);
    
    if debug
        assignin('base','consensT',consensT);
    end
    
    allpeaksT = allpeaksDP;
    allpeaksT(:,1,:) = ((allpeaksT(:,1,:))/srate)+t_scale(1);
    if debug
        assignin('base','allpeaksT',allpeaksT);
    end
    if plots
        switch caorephys
            case 0
                figtitle = 'Consenus peaks';
            case 1
                figtitle = 'Ephys consensus peaks';
            case 2
                figtitle = 'Ca2+ consensus peaks';
        end
        figure('Name',figtitle,'NumberTitle','off');
        plot(xscala,power(:,leadchan(1))); hold on;
        plot(allpeaksT(:,1,leadchan(1)),allpeaksT(:,2,leadchan(1)),'or');
        for i = 1:size(consensT,1)
            for j = 1:len
                if consensT(i,j+2) == 1
                    currsel = allpeaksT(:,1,j);
                    currsel = currsel(find(currsel));
                    thex = find(abs(currsel-consensT(i,1))<0.05);
                    if size(thex,1) == 0
                        continue
                    elseif size(thex,1) > 1
                        thex = thex(1);
                    end
                end
            end
        end
    end
else 
    %%% Hogy ne akadjon ki amikor ezek nem kellenek
    consensT = 0;
    leadchan = zeros(1,2);
    allpeaksT = allpeaksDP;
    allpeaksT(:,1,:) = ((allpeaksT(:,1,:))/srate)+t_scale(1);
    if debug
        assignin('base','allpeaksT',allpeaksT)
    end
end

return
%%%%%%%%%%%%%%%%%%
%%% SWR detect end ----------------------------------------------------
%%%%%%%%%%%%%%%%%%

%%% Taken from Buzsakilab
function gwin = makegausslpfir( Fc, Fs, s )

nargs = nargin;
if nargs < 1 || isempty( Fc ), Fc = 100; end
if nargs < 2 || isempty( Fs ), Fs = 1000; end
if nargs < 3 || isempty( s ), s = 4; end
s = max( s, 3 );

sd = Fs / ( 2 * pi * Fc ); 
x = -ceil( s * sd ) : ceil( s * sd ); 
gwin = 1/( 2 * pi * sd ) * exp( -( x.^2/2/sd.^2 ) ); 
gwin = gwin / sum( gwin );

return

%%% Taken from BuzsakiLab
function Y = firfilt(x,W)

if all(size(W)>=2), error('window must be a vector'), end
if numel(x)==max(size(x)), x=x(:); end

C = length(W);
if C > size( x, 1 )
    Y = NaN * ones( size( x ) );
    return
end
D = ceil(C/2) - 1;
Y = filter(W,1,[flipud(x(1:C,:)); x; flipud(x(end-C+1:end,:))]);
clear x
Y = Y(1+C+D:end-C+D,:);

return


% --------------------------------------------------------------------
function tools_menu_Callback(hObject, eventdata, handles)
% hObject    handle to tools_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function wavebrowse_Callback(hObject, eventdata, handles)
% hObject    handle to wavebrowse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

assignin('base','theout',handles);
waveletBrowser(handles);


% --- Executes on button press in gotVRdata.
function gotVRdata_Callback(hObject, eventdata, handles)
% hObject    handle to gotVRdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of gotVRdata


% --- Executes on button press in importVRcsv.
function importVRcsv_Callback(hObject, eventdata, handles)
% hObject    handle to importVRcsv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[vrdata_fname,vrpath] = uigetfile('*.csv','Select the CSV with the VR data!');
if vrdata_fname ~= 0
    cd(vrpath)
    opts = detectImportOptions(vrdata_fname);
    opts.ImportErrorRule = 'omitvar';
    opts.MissingRule = 'omitvar';
    vrdata = readtable(vrdata_fname,opts);
    assignin('base','vrdata',vrdata)
    vrtime = vrdata.Time;
    if any(contains(vrtime,','))
        vrtime = str2double(strrep(vrtime,',','.'));
    else
        vrtime = str2double(vrtime);
    end
    vrpos = vrdata.Position;
    if any(contains(vrpos,','))
        vrpos = str2double(strrep(vrpos,',','.'));
    else
        vrpos = str2double(vrpos);
    end
    
    gradi = gradient(vrpos);
    artepos = find(abs(gradi)>abs(mean(gradi)+5*std(gradi)));
    vrtime = vrtime(1:artepos(1)-1);
    vrpos = vrpos(1:artepos(1)-1);
    vrpos = vrpos - min(vrpos);
    
    handles.vrtime = vrtime;
    handles.vrpos = vrpos;
    guidata(hObject,handles);
    
    set(handles.gotVRdata,'Value',1);
end