function varargout = Active_behav(varargin)
% ACTIVE_BEHAV MATLAB code for Active_behav.fig
%      ACTIVE_BEHAV, by itself, creates a new ACTIVE_BEHAV or raises the existing
%      singleton*.
%
%      H = ACTIVE_BEHAV returns the handle to a new ACTIVE_BEHAV or the handle to
%      the existing singleton*.
%
%      ACTIVE_BEHAV('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ACTIVE_BEHAV.M with the given input arguments.
%
%      ACTIVE_BEHAV('Property','Value',...) creates a new ACTIVE_BEHAV or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Active_behav_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Active_behav_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Active_behav

% Last Modified by GUIDE v2.5 27-Oct-2015 15:37:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Active_behav_OpeningFcn, ...
                   'gui_OutputFcn',  @Active_behav_OutputFcn, ...
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


% --- Executes just before Active_behav is made visible.
function Active_behav_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Active_behav (see VARARGIN)

% Choose default command line output for Active_behav
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Active_behav wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Active_behav_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
