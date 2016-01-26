function varargout = Active_subplot_roi(varargin)
%%
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Active_subplot_roi_OpeningFcn, ...
                   'gui_OutputFcn',  @Active_subplot_roi_OutputFcn, ...
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
end

function Active_subplot_roi_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*INUSL>

handles.C = varargin{1};

for i = 1: length(handles.C.masks.maskAll)
 
    button_tag = ['radiobutton',num2str(i)];
    handles.(button_tag).String = handles.C.masks.maskAll{i};
    handles.(button_tag).Value = handles.C.masks.mask2inc(i);
  
end

handles.output = hObject;
guidata(hObject, handles);
end

function varargout = Active_subplot_roi_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.C;
end


function roi_Callback(hObject, eventdata, handles) %#ok<*DEFNU>
[handles]=SaveVals(handles,hObject);
guidata(hObject, handles);
end



function handles = SaveVals(handles,hObject)
hold=strsplit(hObject.Tag,'radiobutton');
id=str2double(hold{2});
clear hold
handles.C.masks.mask2inc(id) =hObject.Value;
end
