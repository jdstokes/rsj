function varargout = Active_modelX(varargin)
% ACTIVE_MODELX MATLAB code for Active_modelX.fig
%      ACTIVE_MODELX, by itself, creates a new ACTIVE_MODELX or raises the existing
%      singleton*.
%
%      H = ACTIVE_MODELX returns the handle to a new ACTIVE_MODELX or the handle to
%      the existing singleton*.
%
%      ACTIVE_MODELX('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ACTIVE_MODELX.M with the given input arguments.
%
%      ACTIVE_MODELX('Property','Value',...) creates a new ACTIVE_MODELX or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Active_modelX_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Active_modelX_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Active_modelX

% Last Modified by GUIDE v2.5 24-Jul-2016 14:41:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Active_modelX_OpeningFcn, ...
                   'gui_OutputFcn',  @Active_modelX_OutputFcn, ...
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

% --- Executes just before Active_modelX is made visible.
function Active_modelX_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Active_modelX (see VARARGIN)

% Choose default command line output for Active_modelX

InitiateTable(handles);
IntiateButtons(handles);

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Active_modelX wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = Active_modelX_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes during object creation, after setting all properties.
function uitable1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns calle

end


function type_popup_Callback(hObject, eventdata, handles)
end


function type_popup_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in smooth_popup.
function smooth_popup_Callback(hObject, eventdata, handles)
end


function smooth_popup_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function spec_popup_Callback(hObject, eventdata, handles)
end

function spec_popup_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function mr_toggle_Callback(hObject, eventdata, handles)
end

function response_popup_Callback(hObject, eventdata, handles)
end

function response_popup_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function fir_length_edit_Callback(hObject, eventdata, handles)
end


function fir_length_edit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function fir_order_edit_Callback(hObject, eventdata, handles)
end

function fir_order_edit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function roimask_popup_Callback(hObject, eventdata, handles)
end

function roimask_popup_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function togglebutton4_Callback(hObject, eventdata, handles)
end

function exit_button_Callback(hObject, eventdata, handles)

load('model_table.mat');
numOldRows = size(T,1);
newT =  handles.uitable1.Data(:,2:end);
T = [T;newT];
T(1:numOldRows,:)=[];

save('model_table.mat','T');
close(ancestor(hObject,'figure'))
end

function build_button_Callback(hObject, eventdata, handles)

handles = AddModel(handles);

end
function delete_button_Callback(hObject, eventdata, handles)

uiT = handles.uitable1;
checkColumn = find(strcmp('Include',uiT.ColumnName));
checkIndex = cell2mat(uiT.Data(:,1));
uiT.Data(checkIndex,:) = [];

end
function sr_toggle_Callback(hObject, eventdata, handles)
end
function all_runs_toggle_Callback(hObject, eventdata, handles)
end
function art_repair_toggle_Callback(hObject, eventdata, handles)
end
function spm_mask_popup_Callback(hObject, eventdata, handles)
end
function spm_mask_popup_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function figure1_CloseRequestFcn(hObject, eventdata, handles)

delete(hObject);
end




%Initiate table
function InitiateTable(H)

%Set up table
load('model_table.mat');
ColumnName = T.Properties.VariableNames;
data =   table2cell(T);

zeros(size(data,1))

% Create num column Include
data = [num2cell(logical(zeros(size(data,1),1))),data];
H.uitable1.Data = data;
H.uitable1.ColumnName = [{'Include'},ColumnName];
end


function IntiateButtons(H)
%Study specs
C = Study_greco2;

%Set up table
load('model_table.mat');

% Read options for popup models
H.spec_popup.String = C.spm.modelName_all;
H.type_popup.String = C.spm.model_type_all;
H.smooth_popup.String = C.spm.smooth_all; %SPM Smooth options
H.roimask_popup.String = C.spm.roi_mask_name_all;
H.response_popup.String = C.spm.response_function_all;
H.spm_mask_popup.String = C.spm.mask_all; %SPM Masking options


% Setup current input values based on last model
numModels = size(T,1);
modelType = T.spec_name{numModels}(1:5);

H.spec_popup.Value = ...
    find(strcmp(T.spec_name(numModels,:),C.spm.modelName_all));
H.type_popup.Value = ...
    find(strcmp(modelType,C.spm.model_type_all));
H.smooth_popup.Value = ...
    find(strcmp(T.smooth(numModels,:),C.spm.smooth_all));
H.roimask_popup.Value = ...
    find(strcmp(T.roi_mask_name(numModels,:),C.spm.roi_mask_name_all));
H.response_popup.Value = ...
    find(strcmp(T.response_function(numModels,:),C.spm.response_function_all));
H.spm_mask_popup.Value = ...
    find(strcmp(T.mask(numModels,:),C.spm.mask_all));


%setup toggle buttons
H.art_repair_toggle.Value =T.art_repair(numModels,:);
H.all_runs_toggle.Value = T.all_runs(numModels,:);
H.mr_toggle.Value = T.movement_reg(numModels,:);
H.sr_toggle.Value = T.struct_reg(numModels,:);

%setup edit fields
H.fir_order_edit.String = T.fir_length(numModels,:);
H.fir_length_edit.String = T.fir_order(numModels,:);
H.hpf_edit.String = T.hpf(numModels,:);

%add delete column




end



function hpf_edit_Callback(hObject, eventdata, handles)
end

function hpf_edit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function H = AddModel(H)


uiT = H.uitable1;
numColumns = size(uiT.Data,2);
numRows = size(uiT.Data,1);
newRow = cell(1,numColumns);


for i = 1:length(uiT.ColumnName)
    
    switch uiT.ColumnName{i}
        case 'Include'
            newRow{1,i} = false;
        case 'model_ID'
            newRow{1,i} = CreateModelID(uiT.Data(:,i));
        case 'spec_name'
            newRow{1,i} = H.spec_popup.String{H.spec_popup.Value};
        case 'smooth'
            newRow{1,i} =  H.smooth_popup.String{H.smooth_popup.Value};
        case 'mask'
            newRow{1,i} =  H.spm_mask_popup.String{H.spm_mask_popup.Value};
        case 'all_runs'
            newRow{1,i} = H.all_runs_toggle.Value;
        case 'movement_reg'
            newRow{1,i} = H.mr_toggle.Value;
        case 'struct_reg'
            newRow{1,i} = H.sr_toggle.Value;
        case 'response_function'
            newRow{1,i} = H.response_popup.String{H.response_popup.Value};
        case 'fir_length'
            newRow{1,i} = str2num(H.fir_length_edit.String{1});
        case 'fir_order'
            newRow{1,i} = str2num(H.fir_order_edit.String{1});
        case 'roi_mask_name'
            newRow{1,i} = H.roimask_popup.String{H.roimask_popup.Value};
        case 'hpf'
            newRow{1,i} = str2num(H.hpf_edit.String{1});
        case 'art_repair'
            newRow{1,i} = H.art_repair_toggle.Value;
    end
    
end


uiT.Data = [uiT.Data;newRow];
H.uitable1 = uiT;



% 
% load('model_table.mat');
% ColumnName = T.Properties.VariableNames;
% data =   table2cell(T);
% 
% zeros(size(data,1))
% 
% % Create num column Include
% data = [num2cell(logical(zeros(size(data,1),1))),data];
% H.uitable1.Data = data;
% H.uitable1.ColumnName = [{'Include'},ColumnName];
end


%%Create a unique model ID
function newID = CreateModelID(all_ID)

numModels = length(all_ID);
all_ID = unique(all_ID);
numDigits = 8;
       
            for i = numModels+1:1000
               modelID = ['m',sprintf('%08d', i)];
               if ~strcmp(modelID,all_ID)
                    %Add ID to table
                     newID= modelID;
                break
               end
            end  
       
   

end
