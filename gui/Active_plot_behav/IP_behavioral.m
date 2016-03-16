function varargout = IP_behavioral(varargin)
% IP_BEHAVIORAL MATLAB code for IP_behavioral.fig
%      IP_BEHAVIORAL, by itself, creates a new IP_BEHAVIORAL or raises the existing
%      singleton*.
%
%      H = IP_BEHAVIORAL returns the handle to a new IP_BEHAVIORAL or the handle to
%      the existing singleton*.
%
%      IP_BEHAVIORAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IP_BEHAVIORAL.M with the given input arguments.
%
%      IP_BEHAVIORAL('Property','Value',...) creates a new IP_BEHAVIORAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before IP_behavioral_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to IP_behavioral_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help IP_behavioral

% Last Modified by GUIDE v2.5 06-Mar-2016 17:44:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @IP_behavioral_OpeningFcn, ...
                   'gui_OutputFcn',  @IP_behavioral_OutputFcn, ...
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



% --- Executes just before IP_behavioral is made visible.
function IP_behavioral_OpeningFcn(hObject, eventdata, handles, varargin)

handles.C = Study_greco;
config = IP_behavioral_config(handles.C);
handles.listbox_selectTags.String = config.ListBox.SelectTags.String;
handles.scores = struct;





















handles.output = hObject;
guidata(hObject, handles);
% UIWAIT makes IP_behavioral wait for user response (see UIRESUME)
% uiwait(handles.figure1);


end

%% Other
function handles = IPF_getCurrentTag(handles)


 currentTagList = handles.text_filterGroup.String;
 newTag = ...
     handles.listbox_selectTags.String{handles.listbox_selectTags.Value};

handles.listbox_selectTags.String(handles.listbox_selectTags.Value)=[];

if ~isempty(newTag)
if isempty(currentTagList)
currentTagList = newTag;
else
  currentTagList = [currentTagList,'_',newTag]; 
end

handles.text_filterGroup.String = currentTagList;
end

end



%% Output
% --- Outputs from this function are returned to the command line.
function varargout = IP_behavioral_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

%% Widgets
function listbox_selectTags_Callback(hObject, eventdata, handles)
end


function listbox_selectTags_CreateFcn(hObject, eventdata, handles)


% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end




%Select
function pushbutton_tagSelect_Callback(hObject, eventdata, handles)
handles = IPF_getCurrentTag(handles);
guidata(hObject, handles);

end


%Reset
function pushbutton_resetTag_Callback(hObject, eventdata, handles)
config = IP_behavioral_config(handles.C);
handles.listbox_selectTags.String = config.ListBox.SelectTags.String;
handles.text_filterGroup.String = [];
guidata(hObject, handles);

end


%Add tag to TTOIs list
function pushbutton_addTagFilter_Callback(hObject, eventdata, handles)

if(~isempty(handles.text_filterGroup.String))
if(isempty(handles.listbox_trialtypes.String))
cnt =1;
else
cnt =length(handles.listbox_trialtypes.String) +1;
end
handles.listbox_trialtypes.String{cnt} =  handles.text_filterGroup.String;
handles.scores(cnt).name = handles.text_filterGroup.String;
handles.scores(cnt).group = '';

guidata(hObject, handles);
end
end


function listbox_2Plot_Callback(hObject, eventdata, handles)
end

function listbox_2Plot_CreateFcn(hObject, eventdata, handles)

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function pushbutton_Add2Plot_Callback(hObject, eventdata, handles)


handles.listbox_2Plot.String = handles.listbox_selectTags.String;
% handles.listbox_2Plot.String = 'test';

guidata(hObject, handles);
   
end


%% CALC
function pushbutton_calc_Callback(hObject, eventdata, handles)



list = handles.listbox_trialtypes.String;
for i = 1:length(list)  
    if(~isempty(list{i}))
        handles.scores(i).scores = GetScores(list{i},handles);
    end
end


CreateTableWide(handles);

guidata(hObject, handles);
end


function scores = GetScores(score_tags,handles)
subjects_all = handles.C.subjects.subjAll;
scores = nan(size(subjects_all));
for i = 1:length(subjects_all)
subject = subjects_all{i};
tt_all = TT_greco(subject,handles.C);
scores(i)=CalcScoresCorr(score_tags,tt_all.behav);
end


end


function Remove_Callback(hObject, eventdata, handles)
end

function listbox_trialtypes_Callback(hObject, eventdata, handles) %#ok<*INUSL>
if isfield(handles.scores,'group')
Value = hObject.Value;
handles.edit_group.String =   handles.scores(Value).group;
end
guidata(hObject, handles);

end

function listbox_trialtypes_CreateFcn(hObject, eventdata, handles)

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function edit_group_Callback(hObject, eventdata, handles)


Value = handles.listbox_trialtypes.Value;
handles.scores(Value).group=handles.edit_group.String;

guidata(hObject, handles);

end

function edit_group_CreateFcn(hObject,eventdata, handles) %#ok<*INUSD>

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function ttois_clear_pushbutton_Callback(hObject, eventdata, handles)

Value = handles.listbox_trialtypes.Value;

if(~isempty(handles.listbox_trialtypes.String))
    if(~isempty(handles.listbox_trialtypes.String{Value}))

handles.listbox_trialtypes.String(Value) = [];
handles.scores(Value) = [];

    end
end

guidata(hObject, handles);

end

function CreateTableWide(handles)
T = table;
T.subjects = handles.C.subjects.subjAll;
for i = 1:length(handles.scores)
T.(handles.scores(i).name) = handles.scores(i).scores;
end

writetable(T,'table_wide');
end


function CreateTableLong(scores_all)
scores_all(1).group = 'A';
scores_all(2).group = 'A';
%get unique groups
for i =1:length(scores_all)
    groups{i} = scores_all(i).group;
end
groups = unique(groups);
clear i

T = table;
Tnew = table;
for j = 1:length(groups)
    for i = 1:length(scores_all)
        if(strcmp(groups(j),scores_all(i).group))
        scores = scores_all(i).scores;
        name = scores_all(i).name;
        numScores = length(scores);

        if(isempty(T))
        T.score = scores;
        T.(groups{j})= repmat(name,numScores,1);   
        else
       
        Tnew.score = scores;
        Tnew.(groups{j})= repmat(name,numScores,1); 
        
        T =[T;Tnew];
        end
        end
    end
end

writetable(T,'table_long');
end
