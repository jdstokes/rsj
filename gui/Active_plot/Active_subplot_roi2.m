function varargout = Active_subplot_roi2(varargin)
% ACTIVE_SUBPLOT_ROI2 MATLAB code for Active_subplot_roi2.fig
%      ACTIVE_SUBPLOT_ROI2, by itself, creates a new ACTIVE_SUBPLOT_ROI2 or raises the existing
%      singleton*.
%
%      H = ACTIVE_SUBPLOT_ROI2 returns the handle to a new ACTIVE_SUBPLOT_ROI2 or the handle to
%      the existing singleton*.
%
%      ACTIVE_SUBPLOT_ROI2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ACTIVE_SUBPLOT_ROI2.M with the given input arguments.
%
%      ACTIVE_SUBPLOT_ROI2('Property','Value',...) creates a new ACTIVE_SUBPLOT_ROI2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Active_subplot_roi2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Active_subplot_roi2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Active_subplot_roi2

% Last Modified by GUIDE v2.5 14-Mar-2016 20:16:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Active_subplot_roi2_OpeningFcn, ...
                   'gui_OutputFcn',  @Active_subplot_roi2_OutputFcn, ...
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
end
% End initialization code - DO NOT EDIT


% --- Executes just before Active_subplot_roi2 is made visible.
function Active_subplot_roi2_OpeningFcn(hObject, eventdata, handles, varargin)

if isempty(varargin)
    handles.C = Study_greco;
else
    handles.C = varargin{1};
    
end


 numMasks = length(handles.C.masks.maskAll);
 cnt=0;
 for i = length(handles.radiobutton):-1:1
     cnt=cnt+1;
    if(cnt <= numMasks)
    handles.radiobutton(i).String = handles.C.masks.maskAll{cnt};
    handles.radiobutton(i).Value = handles.C.masks.mask2inc(cnt);
    else
        delete(handles.radiobutton(i));
    end
 end
  

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
end

% --- Outputs from this function are returned to the command line.
function varargout = Active_subplot_roi2_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.C;
end

function radiobutton_Callback(hObject, eventdata, handles)
[handles]=SaveVals(handles,hObject);
guidata(hObject, handles);
end


function close_Callback(hObject, eventdata, handles)
close(handles.figure1);
end


function radiobutton_DeleteFcn(hObject, eventdata, handles)
end

%%
function handles = SaveVals(handles,hObject)

id=strcmp(handles.C.masks.maskAll,hObject.String);
clear hold
handles.C.masks.mask2inc(id) =hObject.Value;
end
