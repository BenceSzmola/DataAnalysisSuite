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

% Last Modified by GUIDE v2.5 17-Sep-2019 13:30:35

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

% % % state check for wavelettrans
handles.cwtpressed = 0;

% % % initial plotting

handles.evdet_hdls = varargin{1};
eventdet_handles = varargin{1};

if handles.evdet_hdls.gotVRdata.Value
    vrpos = handles.evdet_hdls.vrpos;
    vrtime = handles.evdet_hdls.vrtime;
    vrvelo = handles.evdet_hdls.vrvelo;
%     [vrpicfname,path] = uigetfile({'*.png';'*.jpg';'*.jpeg'},'Choose the VR track!');
%     oldpath = cd(path);
%     vrpicnumeric = imread(vrpicfname);
% % % % ide még maybe aspect ratio check
%     cd(oldpath);
    vrpicnumeric = eventdet_handles.vrpicnumeric;
    vrpicnumeric = imresize(vrpicnumeric,[length(vrpicnumeric),100]);
    [vrpic]=imshow(vrpicnumeric,'Parent',handles.vrposaxes); 
    hold(handles.vrposaxes,'on');
    handles.vrpic_size = size(vrpic.CData);
    posdots = plot(handles.vrposaxes,0,0,'ro','MarkerFaceColor','r');
    handles.posdots = posdots;
    title(handles.vrposaxes,'Position in VR');
%     ylabel(handles.vrposaxes,'Position');
    handles.vrposaxes.XTick = []; 
    hold(handles.vrposaxes,'off');
    plot(handles.vrspeedaxes,vrtime*1000,vrvelo);
    hold(handles.vrspeedaxes,'on');
    axis(handles.vrspeedaxes,'tight');
    title(handles.vrspeedaxes,'Speed in VR');
    xlabel(handles.vrspeedaxes,'Time [ms]');
    ylabel(handles.vrspeedaxes,'Velocity [cm/s]');
    hold(handles.vrspeedaxes,'off');
else
    handles.vrposaxes.Visible = 'off';
    handles.vrspeedaxes.Visible = 'off';
end
    
handles.wavenum = 0;
simult = eventdet_handles.simult;
caorephys = eventdet_handles.caorephys;
linkaxes([handles.dogaxes,handles.caaxes,handles.instpowaxes],'x');

handles.ephyswinsize = 0.2;
handles.cawinsize = 0.25;

cm1 = uicontextmenu(hObject);
cm2 = uicontextmenu(hObject);
cm3 = uicontextmenu(hObject);
handles.dogaxes.UIContextMenu = cm1;
handles.instpowaxes.UIContextMenu = cm2;
handles.caaxes.UIContextMenu = cm3;
subm1 = uimenu(cm1,'Label','Set axis limits','Callback',{@modaxlim,handles.dogaxes});
subm2 = uimenu(cm2,'Label','Set axis limits','Callback',{@modaxlim,handles.instpowaxes});
subm3 = uimenu(cm3,'Label','Set axis limits','Callback',{@modaxlim,handles.caaxes});

switch simult
    case 0
        switch caorephys
            case 1
                set(handles.ca_stats,'Visible','off');
                set(handles.caaxes,'Visible','off');
                set(handles.roibutpanel,'Visible','off');
                set(handles.onlysim_but,'Visible','off');
                dog = eventdet_handles.dog;
                instpow = eventdet_handles.instpow;
                ephys_t_scale = eventdet_handles.ephys_t_scale;
                ephysleadch = eventdet_handles.ephysleadch;
                
                set(handles.evnumtxt2,'String',['/ ',num2str(length(eventdet_handles.ephyscons_onlyT))]);
                
                leaddog = dog(:,ephysleadch);
                leadinstpow = instpow(:,ephysleadch);

                ephysxscala = ephys_t_scale(1):(ephys_t_scale(2)-ephys_t_scale(1)):...
                    (ephys_t_scale(2)-ephys_t_scale(1))*(size(dog,1)-1)+ephys_t_scale(1);
                
                plot(handles.dogaxes,ephysxscala*1000,leaddog);
                plot(handles.instpowaxes,ephysxscala*1000,leadinstpow);
            case 2
                set(handles.ephys_stats,'Visible','off');
                set(handles.dogaxes,'Visible','off');
                set(handles.instpowaxes,'Visible','off');
                set(handles.onlysim_but,'Visible','off');
                set(handles.evnumtxt2,'String',['/ ',num2str(size(eventdet_handles.cacons_onlyT,2))]);
                handles.canum = 1;
                normed_ca = eventdet_handles.normed_ca;
                ca_t_scale = eventdet_handles.ca_t_scale;
                caxscala = ca_t_scale(1):(ca_t_scale(2)-ca_t_scale(1)):...
                    (ca_t_scale(2)-ca_t_scale(1))*(size(normed_ca,2)-1)+ca_t_scale(1);
                plot(handles.caaxes,caxscala*1000,normed_ca(1,:));
        end
    case 1
        handles.canum = 1;
        dog = eventdet_handles.dog;
        instpow = eventdet_handles.instpow;
        normed_ca = eventdet_handles.normed_ca;
        ephys_t_scale = eventdet_handles.ephys_t_scale;
        ca_t_scale = eventdet_handles.ca_t_scale;
        ephysleadch = eventdet_handles.ephysleadch;
        
        set(handles.evnumtxt2,'String',['/ ',num2str(length(eventdet_handles.ephysca))]);
        
        leaddog = dog(:,ephysleadch);
        leadinstpow = instpow(:,ephysleadch);

        ephysxscala = ephys_t_scale(1):(ephys_t_scale(2)-ephys_t_scale(1)):...
            (ephys_t_scale(2)-ephys_t_scale(1))*(size(dog,1)-1)+ephys_t_scale(1);
        caxscala = ca_t_scale(1):(ca_t_scale(2)-ca_t_scale(1)):...
            (ca_t_scale(2)-ca_t_scale(1))*(size(normed_ca,2)-1)+ca_t_scale(1);
        
        plot(handles.dogaxes,ephysxscala*1000,leaddog);
        plot(handles.instpowaxes,ephysxscala*1000,leadinstpow);
        plot(handles.caaxes,caxscala*1000,normed_ca(1,:));
end

xlabel(handles.dogaxes,'Time [ms]');
ylabel(handles.dogaxes,'Voltage [\muV]');
xlabel(handles.instpowaxes,'Time [ms]');
ylabel(handles.instpowaxes,'Power [\muV^2]');
xlabel(handles.caaxes,'Time [ms]');
ylabel(handles.caaxes,'dF/F');
title(handles.dogaxes,'Difference of Gaussians');
title(handles.instpowaxes,'Instantaneous Power');
try
    title(handles.caaxes,['Normed Ca2+ ROI #',num2str(handles.canum-1)]);
catch
    title(handles.caaxes,['Normed Ca2+']);
end
axis(handles.dogaxes,[-inf inf -inf inf]);
axis(handles.instpowaxes,[-inf inf -inf inf]);
axis(handles.caaxes,[-inf inf -inf inf]);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes waveletBrowser wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% % % - - - - - - - - - - - - - - 
function modaxlim(~,~,axe)

inp = inputdlg({'x min','x max','y min','y max'},'Set axis limits',[1 10],...
    {num2str(axe.XLim(1)),num2str(axe.XLim(2)),num2str(axe.YLim(1)),num2str(axe.YLim(2))});
if isempty(inp)
    return
end
inp_num = str2double(inp);
axe.XLim = [inp_num(1) inp_num(2)];
axe.YLim = [inp_num(3) inp_num(4)];


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

switch eventdet_handles.simult
    case 0
        switch eventdet_handles.caorephys
            case 1
                if handles.wavenum+1 <= length(eventdet_handles.ephyscons_onlyT)
                    handles.wavenum = handles.wavenum+1;
                else
                    handles.wavenum = 1;
                end
                set(handles.evnumtxt,'String',num2str(handles.wavenum));
            case 2
                if handles.wavenum+1 <= size(eventdet_handles.cacons_onlyT,2)
                    handles.wavenum = handles.wavenum+1;
                else
                    handles.wavenum = 1;
                end
                set(handles.evnumtxt,'String',num2str(handles.wavenum));
        end
    case 1
        ephysca = eventdet_handles.ephysca;

        if handles.wavenum+1 <= length(ephysca)
            handles.wavenum = handles.wavenum+1;
        else
            handles.wavenum = 1;
        end
        
        set(handles.evnumtxt,'String',num2str(handles.wavenum));
end

% Update handles structure
guidata(hObject, handles);

if get(handles.onlysim_but,'Value')
    onlysim_but_Callback(handles.onlysim_but,eventdata,handles);
%     handles = guidata(hObject);
else
    showave(hObject,handles);
end

% showave(hObject,handles);



% --- Executes on button press in prevwave.
function prevwave_Callback(hObject, eventdata, handles)
% hObject    handle to prevwave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

eventdet_handles = handles.evdet_hdls;

switch eventdet_handles.simult
    case 0
        switch eventdet_handles.caorephys
            case 1
                if handles.wavenum-1 >= 1
                    handles.wavenum = handles.wavenum-1;
                else
                    handles.wavenum = length(eventdet_handles.ephyscons_onlyT);
                end
                set(handles.evnumtxt,'String',num2str(handles.wavenum));
            case 2
                if handles.wavenum-1 >= 1
                    handles.wavenum = handles.wavenum-1;
                else
                    handles.wavenum = size(eventdet_handles.cacons_onlyT,2);
                end
                set(handles.evnumtxt,'String',num2str(handles.wavenum));
        end
    case 1
        ephysca = eventdet_handles.ephysca;

        if handles.wavenum-1 >= 1
            handles.wavenum = handles.wavenum-1;
        else
            handles.wavenum = length(ephysca);
        end
        
        set(handles.evnumtxt,'String',num2str(handles.wavenum));
end

% Update handles structure
guidata(hObject, handles);

if get(handles.onlysim_but,'Value')
    onlysim_but_Callback(handles.onlysim_but,eventdata,handles);
%     handles = guidata(hObject);
else
    showave(hObject,handles);
end

% showave(hObject,handles);


% --- Executes on button press in prevca.
function prevca_Callback(hObject, eventdata, handles)
% hObject    handle to prevca (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

simult = handles.evdet_hdls.simult;
normed_ca = handles.evdet_hdls.normed_ca;
wavenum = handles.wavenum;
canum = handles.canum;

onlysim = get(handles.onlysim_but,'Value');

if simult
    per_roi_det = handles.evdet_hdls.per_roi_det;
    ephysca = handles.evdet_hdls.ephysca;
    switch onlysim
        case 1
            validcanums = ceil(find(abs(per_roi_det-ephysca(wavenum)) < 0.01)...
                /size(per_roi_det,1));
        case 0
            validcanums = 1:size(normed_ca,1);
    end
else
    validcanums = 1:size(normed_ca,1);
end

validcanums = unique(validcanums);
validpos = find(validcanums==canum);
if ~isempty(validpos)
    validpos = validpos(1);
end

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

simult = handles.evdet_hdls.simult;
normed_ca = handles.evdet_hdls.normed_ca;
wavenum = handles.wavenum;
canum = handles.canum;

onlysim = get(handles.onlysim_but,'Value');

if simult
    per_roi_det = handles.evdet_hdls.per_roi_det;
    ephysca = handles.evdet_hdls.ephysca;
    switch onlysim
        case 1
            validcanums = ceil(find(abs(per_roi_det-ephysca(wavenum)) < 0.01)...
                /size(per_roi_det,1));
        case 0
            validcanums = 1:size(normed_ca,1);
    end
else
    validcanums = 1:size(normed_ca,1);
end

validcanums = unique(validcanums);
validpos = find(validcanums==canum);
if ~isempty(validpos)
    validpos = validpos(1);
end

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

evdet_hdls = handles.evdet_hdls;
wavenum = handles.wavenum;
% linkaxes([handles.dogaxes,handles.caaxes,handles.instpowaxes],'x');
linkstate = 1;

if evdet_hdls.simult && any(abs(evdet_hdls.per_roi_det(:,:,handles.canum)-evdet_hdls.ephysca(wavenum))<0.01)
    linkaxes([handles.dogaxes,handles.caaxes,handles.instpowaxes],'off');
    linkaxes([handles.dogaxes,handles.instpowaxes],'x');
    linkstate = 0;
    set(handles.catstamp,'Visible','on');
    set(handles.cadelay,'Visible','on');
    set(handles.caevlen,'Visible','on');
else
    set(handles.catstamp,'Visible','off');
    set(handles.cadelay,'Visible','off');
    set(handles.caevlen,'Visible','off');
end

if evdet_hdls.simult
    cadelay = evdet_hdls.cadelay;
    ephysca = evdet_hdls.ephysca;
    supreme = evdet_hdls.supreme;
    
    ephysaw = evdet_hdls.ephys_allwidths;
    ephysleadch = evdet_hdls.ephysleadch;
    canum = handles.canum;
    caaw = evdet_hdls.ca_allwidths;
end

if evdet_hdls.gotVRdata.Value
    vrpos = handles.evdet_hdls.vrpos;
    vrtime = handles.evdet_hdls.vrtime;
%     plot(handles.vrposaxes,zeros(size(vrpos)),vrpos); 
%     title(handles.vrposaxes,'Position in VR');
%     ylabel(handles.vrposaxes,'Position');
    hold(handles.vrposaxes,'on')
    switch evdet_hdls.simult
        case 0
            switch evdet_hdls.caorephys
                case 1
                    vrtstamppos = find(abs(vrtime - evdet_hdls.ephyscons_onlyT(wavenum)) < 0.1);
                    vrtstamppos = vrtstamppos(1);
                case 2
                    vrtstamppos = find(abs(vrtime - evdet_hdls.cacons_onlyT(handles.canum,wavenum)) < 0.1);
                    vrtstamppos = vrtstamppos(1);
            end
        case 1
            vrtstamppos = find(abs(vrtime - ephysca(wavenum)) < 0.1);
            if ~isempty(vrtstamppos)
                vrtstamppos = vrtstamppos(1);
            end
    end
    scaler = handles.vrpic_size(1)/abs(max(vrpos)-min(vrpos));
    handles.posdots.XData = handles.vrpic_size(2)/2;
    if ~isempty(vrtstamppos)
        handles.posdots.YData = vrpos(vrtstamppos)*scaler;
    else
        handles.posdots.XData = [];
        handles.posdots.YData = [];
    end
%     posdots = plot(handles.vrposaxes,handles.vrpic_size(2)/2,vrpos(vrtstamppos)*scaler,'ro','MarkerFaceColor','r');
    hold(handles.vrposaxes,'on')
%     axis(handles.vrposaxes,[-1 1 min(vrpos) max(vrpos)]); 
    handles.vrposaxes.XTick = [];
    hold(handles.vrposaxes,'off')
end

if evdet_hdls.simult
% % % % % %
%     if evdet_hdls.gotVRdata.Value
%         vrpos = handles.evdet_hdls.vrpos;
%         vrtime = handles.evdet_hdls.vrtime;
%         plot(handles.vrposaxes,zeros(size(vrpos)),vrpos); 
%         hold(handles.vrposaxes,'on')
%         vrtstamppos = find(abs(vrtime - ephysca(wavenum)) < 0.1);
%         vrtstamppos = vrtstamppos(1);
%         plot(handles.vrposaxes,0,vrtime(vrtstamppos),'go');
%         hold(handles.vrposaxes,'on')
%         axis(handles.vrposaxes,[-1 1 min(vrpos) max(vrpos)]); 
%         handles.vrposaxes.XTick = [];
%         hold(handles.vrposaxes,'off')
%     end
% % % % % %     
    switch supreme
        case 1
            ephyspos = find(abs(ephysaw(:,1,ephysleadch)-ephysca(wavenum)) < 0.01);
            if ~isempty(ephyspos)
                ephyspos = ephyspos(1);
                set(handles.ephyststamp,'String',num2str(ephysaw(ephyspos,1,ephysleadch)*1000));
            end
            capos = find(((caaw(:,1,canum)-ephysca(wavenum)) < cadelay) ...
                & ((caaw(:,1,canum)-ephysca(wavenum)) >= 0));
            if ~isempty(capos)
                capos = capos(1);
                set(handles.cadelay,'String',num2str((caaw(capos,1,canum)-ephysca(wavenum))*1000));
                set(handles.catstamp,'String',num2str(caaw(capos,1,canum)*1000));
            end
        case 2
            ephyspos = find(((ephysaw(:,1,ephysleadch)-ephysca(wavenum)) >= -cadelay) ...
                & ((ephysaw(:,1,ephysleadch)-ephysca(wavenum)) <= 0 ));
            if ~isempty(ephyspos)
                ephyspos = ephyspos(1);
                set(handles.ephyststamp,'String',num2str(ephysaw(ephyspos,1,ephysleadch)*1000));
            end
            capos = find(abs(caaw(:,1,canum)-ephysca(wavenum)) < 0.01);
            if ~isempty(capos)
                capos = capos(1);
                set(handles.cadelay,'String',num2str(abs(caaw(capos,1,canum)-ephysca(wavenum))*1000));
                set(handles.catstamp,'String',num2str(caaw(capos,1,canum)*1000));
            end
    end
    set(handles.ephysevlen,'String',num2str(ephysaw(ephyspos,2,ephysleadch)));
    set(handles.caevlen,'String',num2str(caaw(capos,2,canum)));
end

if evdet_hdls.simult || (evdet_hdls.caorephys == 1)
    dog = evdet_hdls.dog;
    instpow = evdet_hdls.instpow;
    ephys_t_scale = evdet_hdls.ephys_t_scale;
    ephysleadch = evdet_hdls.ephysleadch;
    ephyssrate = evdet_hdls.ephyssrate;
    ephyscons_onlyT = evdet_hdls.ephyscons_onlyT;
    
    leaddog = dog(:,ephysleadch);
    leadinstpow = instpow(:,ephysleadch);
    ephysxscala = ephys_t_scale(1):(ephys_t_scale(2)-ephys_t_scale(1)):...
    (ephys_t_scale(2)-ephys_t_scale(1))*(size(dog,1)-1)+ephys_t_scale(1);

    if wavenum ~= 0
        switch evdet_hdls.simult
            case 0
                ephyscurrev_pos = find(abs(ephysxscala-ephyscons_onlyT(wavenum))<=(1/ephyssrate));
                set(handles.ephyststamp,'String',num2str(ephysxscala(ephyscurrev_pos)*1000));
            case 1
                ephyscurrev_pos = find(abs(ephysxscala-ephysca(wavenum))<=(1/ephyssrate));
        end
        ephyssurround = round(handles.ephyswinsize*ephyssrate);
        
        leaddog = leaddog(ephyscurrev_pos-ephyssurround:ephyscurrev_pos+ephyssurround);
        leadinstpow = leadinstpow(ephyscurrev_pos-ephyssurround:ephyscurrev_pos+ephyssurround);
        
        ephysxscala = ephysxscala(ephyscurrev_pos-ephyssurround:ephyscurrev_pos+ephyssurround);
    end
    
    dogplot = plot(handles.dogaxes,ephysxscala*1000,leaddog);
    instpowplot = plot(handles.instpowaxes,ephysxscala*1000,leadinstpow);
    if wavenum ~= 0
        if ~evdet_hdls.simult
            dogline = line(handles.dogaxes,[ephyscons_onlyT(wavenum)*1000 ephyscons_onlyT(wavenum)*1000],...
                    [min(leaddog)-abs(min(leaddog)) max(leaddog)+abs(max(leaddog))],'Color','r');
            instpowline = line(handles.instpowaxes,[ephyscons_onlyT(wavenum)*1000 ephyscons_onlyT(wavenum)*1000],...
                [min(leadinstpow)-abs(min(leadinstpow)) max(leadinstpow)+abs(max(leadinstpow))],'Color','r');
            
            handles.dogline = dogline;
            handles.instpowline = instpowline;
        end
    end
    axis(handles.dogaxes,[ephysxscala(1)*1000 ephysxscala(end)*1000 min(leaddog)-abs(min(leaddog)) max(leaddog)+abs(max(leaddog))]);
    axis(handles.instpowaxes,[ephysxscala(1)*1000 ephysxscala(end)*1000 min(leadinstpow)-abs(min(leadinstpow)) max(leadinstpow)+abs(max(leadinstpow))]);

    ephyspos = find(abs(evdet_hdls.ephys_allwidths(:,1,ephysleadch)-ephyscons_onlyT(wavenum)) < 0.01);
    set(handles.ephysevlen,'String',num2str(evdet_hdls.ephys_allwidths(ephyspos,2,ephysleadch)));
    
    handles.dogplot = dogplot;
    handles.instpowplot = instpowplot;
end

if evdet_hdls.simult || (evdet_hdls.caorephys == 2)
    normed_ca = evdet_hdls.normed_ca;
    ca_t_scale = evdet_hdls.ca_t_scale;
    casrate = evdet_hdls.casrate;
    caaw = evdet_hdls.ca_allwidths;
    cacons_onlyT = evdet_hdls.cacons_onlyT;
    
    canum = handles.canum;
    currca = normed_ca(canum,:);
    caxscala = ca_t_scale(1):(ca_t_scale(2)-ca_t_scale(1)):...
        (ca_t_scale(2)-ca_t_scale(1))*(size(normed_ca,2)-1)+ca_t_scale(1);

    if wavenum ~= 0
        switch evdet_hdls.simult
            case 0
                cacurrev_pos = find(abs(caxscala-cacons_onlyT(canum,wavenum))<=(1/casrate));
            case 1
                switch linkstate
                    case 0
                        cacurrev_pos = find(abs(caxscala-caaw(capos,1,canum))<=(1/casrate)); 
                    case 1
                        cacurrev_pos = find(abs(caxscala-ephysca(wavenum))<=(1/casrate));
                end
        end
        switch linkstate
            case 0
                casurround = round(handles.cawinsize*casrate);
            case 1
                casurround = round(handles.ephyswinsize*casrate);
        end
        if cacurrev_pos <= casurround
            currca = currca(1:2*casurround);
            caxscala = caxscala(1:2*casurround);
        elseif cacurrev_pos+casurround > length(currca)
            currca = currca(end-2*casurround:end);
            caxscala = caxscala(end-2*casurround:end);
        else
            currca = currca(cacurrev_pos-casurround:cacurrev_pos+casurround);
            caxscala = caxscala(cacurrev_pos-casurround:cacurrev_pos+casurround);
        end
    end
    
    caplot = plot(handles.caaxes,caxscala*1000,currca);
    if ~evdet_hdls.simult
        if wavenum ~= 0
            try
                caline = line(handles.caaxes,...
                    [cacons_onlyT(canum,wavenum)*1000,...
                    cacons_onlyT(canum,wavenum)*1000],...
                    [min(currca)-abs(min(currca)) max(currca)+abs(max(currca))],'Color','r');
            catch
                caline = 0;
            end
            handles.caline = caline;
        end
    end
    axis(handles.caaxes,[caxscala(1)*1000 caxscala(end)*1000 min(currca)-abs(min(currca)) max(currca)+abs(max(currca))]);
    
    handles.caplot = caplot;
end

if evdet_hdls.simult
    if wavenum ~= 0
        dogline = line(handles.dogaxes,[ephysca(wavenum)*1000 ephysca(wavenum)*1000],...
                    [min(leaddog)-abs(min(leaddog)) max(leaddog)+abs(max(leaddog))],'Color','r');
        instpowline = line(handles.instpowaxes,[ephysca(wavenum)*1000 ephysca(wavenum)*1000],...
            [min(leadinstpow)-abs(min(leadinstpow)) max(leadinstpow)+abs(max(leadinstpow))],'Color','r');
        handles.dogline = dogline;
        handles.instpowline = instpowline;
        
        try
            caline = line(handles.caaxes,[caaw(capos,1,canum)*1000 caaw(capos,1,canum)*1000],...
                [min(currca)-abs(min(currca)) max(currca)+abs(max(currca))],'Color','r');
        catch
            caline = 0;
        end
        
        handles.caline = caline;
    end
end

xlabel(handles.dogaxes,'Time [ms]');
ylabel(handles.dogaxes,'Voltage [\muV]');
xlabel(handles.instpowaxes,'Time [ms]');
ylabel(handles.instpowaxes,'Power [\muV^2]');
xlabel(handles.caaxes,'Time [ms]');
ylabel(handles.caaxes,'dF/F');
title(handles.dogaxes,'Difference of Gaussians');
title(handles.instpowaxes,'Instantaneous Power');
try
    title(handles.caaxes,['Normed Ca2+ ROI #',num2str(canum-1)]);
catch
    title(handles.caaxes,'Normed Ca2+');
end
% axis(handles.dogaxes,[ephysxscala(1)*1000 ephysxscala(end)*1000 min(leaddog)-abs(min(leaddog)) max(leaddog)+abs(max(leaddog))]);
% axis(handles.instpowaxes,[ephysxscala(1)*1000 ephysxscala(end)*1000 min(leadinstpow)-abs(min(leadinstpow)) max(leadinstpow)+abs(max(leadinstpow))]);
% axis(handles.caaxes,[caxscala(1)*1000 caxscala(end)*1000 min(currca)-abs(min(currca)) max(currca)+abs(max(currca))]);

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
        if handles.evdet_hdls.simult || handles.evdet_hdls.caorephys==2
            prevca_Callback(hObject,eventdata,handles);
        end
    case 's'
        if handles.evdet_hdls.simult || handles.evdet_hdls.caorephys==2
            nextca_Callback(hObject,eventdata,handles);
        end
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

lim1 = axis(handles.dogaxes);
lim2 = axis(handles.instpowaxes);
lim3 = axis(handles.caaxes);
assignin('base','lim3',lim3);
definp = {num2str(round(((lim1(2)-lim1(1))*0.1)/5)*5),num2str(round(((lim3(2)-lim3(1))*0.1)/5)*5),...
    num2str(round(((lim1(4)-lim1(3))*0.2)/5)*5),num2str(round(((lim2(4)-lim2(3))*0.2)/5)*5),...
    sprintf('%1.1f',(lim3(4)-lim3(3))*0.1)};

opts.Interpreter = 'tex';
opts.Resize = 'on';
scalebarspecs = inputdlg({'Time bar size for ephys(ms)',...
    'Time bar size for Ca2+(ms)','DoG bar size(\muV)','Instpow bar size(\muV^2)',...
    'Ca2+ bar size(dF/F)'},'Scalebar settings',[1 30],definp,opts);
if isempty(scalebarspecs)
    return
end

if handles.evdet_hdls.simult || handles.evdet_hdls.caorephys==1
    ephysannowin = figure('Name','Annotation Window','NumberTitle','off');
    ephysannowin.ToolBar = 'figure';
    ephysannowin.Units = 'normalized';

    tb = findall(ephysannowin,'Type','uitoolbar');

    copy_button = uipushtool(tb,'TooltipString','Copy figure',...
                     'ClickedCallback','print(''-clipboard'',''-dmeta'')',...
                     'Separator','on');
    [img,map] = imread(fullfile(matlabroot,...
    'toolbox','matlab','icons','pagesicon.gif'));
    icon = ind2rgb(img,map);
    copy_button.CData = icon;
    
    dogsub = subplot(2,1,1);

    disableDefaultInteractivity(dogsub);
    dogx = get(handles.dogplot,'XData');
    dogy = get(handles.dogplot,'YData');
    
    assignin('base','dogy',dogy)
    
    annot_dog = plot(dogx,dogy);
    line(dogsub,handles.dogline.XData,handles.dogline.YData,'Color','r');

    instpowsub = subplot(2,1,2);
    
    disableDefaultInteractivity(instpowsub);
    instpowx = get(handles.instpowplot,'XData');
    instpowy = get(handles.instpowplot,'YData');
    annot_instpow = plot(instpowx,instpowy);
    line(instpowsub,handles.instpowline.XData,handles.instpowline.YData,'Color','r');
    
    xlabel(dogsub,'Time [ms]');
    ylabel(dogsub,'Voltage [\muV]');
    xlabel(instpowsub,'Time [ms]');
    ylabel(instpowsub,'Power [\muV^2]');
    title(dogsub,'Difference of Gaussians');
    title(instpowsub,'Instantaneous Power');
    lim = axis(handles.dogaxes);
    axis(dogsub,lim);
    drawscalebar(dogsub,lim,1,scalebarspecs);
    lim = axis(handles.instpowaxes);
    axis(instpowsub,lim);
    drawscalebar(instpowsub,lim,2,scalebarspecs);
    dogsub.Toolbar.Visible = 'off';
    instpowsub.Toolbar.Visible = 'off';
end

if handles.evdet_hdls.simult || handles.evdet_hdls.caorephys==2
    caannowin = figure('Name','Annotation Window','NumberTitle','off');
    caannowin.ToolBar = 'figure';
    caannowin.Units = 'normalized';

    tb = findall(caannowin,'Type','uitoolbar');

    copy_button = uipushtool(tb,'TooltipString','Copy figure',...
                     'ClickedCallback','print(''-clipboard'',''-dmeta'')',...
                     'Separator','on');
    [img,map] = imread(fullfile(matlabroot,...
    'toolbox','matlab','icons','pagesicon.gif'));
    icon = ind2rgb(img,map);
    copy_button.CData = icon;

    casub = subplot(1,1,1);
    
    disableDefaultInteractivity(casub);
    cax = get(handles.caplot,'XData');
    cay = get(handles.caplot,'YData');
    annot_ca = plot(cax,cay);
    if handles.caline ~= 0
        line(casub,handles.caline.XData,handles.caline.YData,'Color','r');
    end
    
    xlabel(casub,'Time [ms]');
    ylabel(casub,'dF/F');
    title(casub,['Normed Ca2+ ROI #',num2str(handles.canum-1)]);
    lim = axis(handles.caaxes);
    axis(casub,lim);
    casub.Toolbar.Visible = 'off';
    drawscalebar(casub,lim,3,scalebarspecs);
end



% % % -------------- Scalebar maker
function drawscalebar(axes,lim,datatype,scalebarspecs)
xlim = lim(1:2);
ylim = lim(3:4);
switch datatype
    case {1,2}
        xspec = scalebarspecs{1};
    case 3
        xspec = scalebarspecs{2};
end

xlen = xlim(end) - xlim(1);
ylen = max(ylim) - min(ylim);

hbar_orig = xlim(1) + xlen*0.8;
hbar_end = hbar_orig + str2double(xspec);

vbar_orig = min(ylim) + ylen*0.2;
switch datatype
    case 1
        vbar_end = vbar_orig + str2double(scalebarspecs{3});
        yunit = ' \muV';
    case 2
        yunit = ' \muV^2';
        vbar_end = vbar_orig + str2double(scalebarspecs{4});
    case 3
        yunit = ' dF/F';
        vbar_end = vbar_orig + str2double(scalebarspecs{5});
end

line(axes,[hbar_orig hbar_end],[vbar_orig vbar_orig],'Color','k','LineWidth',1.5);
line(axes,[hbar_end hbar_end],[vbar_orig vbar_end],'Color','k','LineWidth',1.5);
text(axes,hbar_orig,vbar_orig-ylen*0.05,[xspec,' ms'],'FontSize',8);
text(axes,hbar_end+(hbar_end-hbar_orig)*0.15,vbar_orig+(vbar_end-vbar_orig)*0.5,...
    [scalebarspecs{datatype+2},yunit],'FontSize',8);


% --- Executes on button press in onlysim_but.
function onlysim_but_Callback(hObject, eventdata, handles)
% hObject    handle to onlysim_but (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of onlysim_but

state = get(hObject,'Value');

wavenum = handles.wavenum;
per_roi_det = handles.evdet_hdls.per_roi_det;
ephysca = handles.evdet_hdls.ephysca;

if state
    validcanums = ceil(find(abs(per_roi_det-ephysca(wavenum)) < 0.01)...
        /size(per_roi_det,1));

    handles.canum = validcanums(1);

    showave(hObject,handles);
end

guidata(hObject,handles);


% --------------------------------------------------------------------
function edit_winsize_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to edit_winsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

inp = inputdlg({'Ephys window size(ms):','Ca2+ window size(ms)'},...
    'Window size',[1 15],{num2str(handles.ephyswinsize*2000),num2str(handles.cawinsize*2000)});
if isempty(inp)
    return
end
inp = str2double(inp);
handles.ephyswinsize = inp(1)/1000/2;
handles.cawinsize = inp(2)/1000/2;
guidata(hObject,handles);
showave(hObject,handles);


% --------------------------------------------------------------------
function cwt_but_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to cwt_but (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dogy = get(handles.dogplot,'YData');

srate = handles.evdet_hdls.ephyssrate;

mid = (size(dogy,2)+1)/2;
dist = str2double(handles.evdet_hdls.ephys_mindist.String)*(srate/1000);

mb = msgbox('Computing wavelet transform...');
if ~handles.cwtpressed
    leaddog = handles.evdet_hdls.dog(:,handles.evdet_hdls.ephysleadch);
    [full_coeffs,~] = cwt(leaddog,srate,'amor','FrequencyLimits',[0 300]);
    full_coeffs = abs(full_coeffs);
    handles.full_coeffs = full_coeffs;
else
    full_coeffs = handles.full_coeffs;
end
avg = mean(mean(full_coeffs));
sd = std(std(full_coeffs));

[coeffs,f] = cwt(dogy,srate,'amor','FrequencyLimits',[0 300]);
coeffs = abs(coeffs);

z_coeffs = (coeffs-avg)/sd;

delete(mb);

t = linspace(-size(z_coeffs,2)/(srate*2),size(z_coeffs,2)/(srate*2),size(z_coeffs,2))*1000;

cwtwin = figure('Name','Wavelet Transform','NumberTitle','off');
cwtwin.ToolBar = 'figure';
cwtwin.Units = 'normalized';

tb = findall(cwtwin,'Type','uitoolbar');

copy_button = uipushtool(tb,'TooltipString','Copy figure',...
                 'ClickedCallback','print(''-clipboard'',''-dbitmap'')',...
                 'Separator','on');
[img,map] = imread(fullfile(matlabroot,...
'toolbox','matlab','icons','pagesicon.gif'));
icon = ind2rgb(img,map);
copy_button.CData = icon;
surf(t,f,z_coeffs);
view(0,90);
colormap(parula(128));
cb = colorbar;
cb.Label.String = 'Z-Score';
shading interp;
axis tight;
ylim([100 300]);
title('Wavelet transform');
ylabel('Frequency [Hz]');
xlabel('Time [ms]');

% % % wavelettel validálni detekciót
if max(max(z_coeffs(:,floor(mid-dist:mid+dist)))) < 20
    warndlg('Probably not a SPW-R!')
end

handles.cwtpressed = 1;
guidata(hObject,handles)



function ephyststamp_Callback(hObject, eventdata, handles)
% hObject    handle to ephyststamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ephyststamp as text
%        str2double(get(hObject,'String')) returns contents of ephyststamp as a double

tstamp = str2double(get(hObject,'String'))/1000;

switch handles.evdet_hdls.simult
    case 0
        if handles.evdet_hdls.caorephys == 1
            [~,ind] = min(abs(handles.evdet_hdls.ephyscons_onlyT - tstamp));
            handles.wavenum = ind;
            showave(hObject,handles);
        end
    case 1
        [~,ind] = min(abs(handles.evdet_hdls.ephysca - tstamp));
        handles.wavenum = ind;
        showave(hObject,handles);
end



function evnumtxt_Callback(hObject, eventdata, handles)
% hObject    handle to evnumtxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of evnumtxt as text
%        str2double(get(hObject,'String')) returns contents of evnumtxt as a double

handles.wavenum = str2double(get(hObject,'String'));
try
    showave(hObject,handles);
catch
    errordlg('The number you entered exceeds the number of events!');
end
