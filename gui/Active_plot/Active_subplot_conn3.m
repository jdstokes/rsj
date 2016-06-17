function varargout = Active_subplot_conn3(varargin)
%%
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Active_subplot_conn3_OpeningFcn, ...
                   'gui_OutputFcn',  @Active_subplot_conn3_OutputFcn, ...
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


%% Opening
function Active_subplot_conn3_OpeningFcn(hObject, eventdata, h, varargin) %#ok<*INUSL>

%For testing purposes go ahead and load a fresh study object

    h.C = varargin{1};   
    h.cnt = 0;
    h.mask_comp_name={}; 
    h.mask_comp=[];
    h.maskAll = FixStrings(h.C.masks.maskAll,{'.nii','ash_','_'},{'','',' '});

    h.pp_seed.String  = h.maskAll;
    h.pp_target.String  = h.maskAll;


    guidata(hObject, h);
    uiwait(h.figure1);

end
%% Output
function varargout = Active_subplot_conn3_OutputFcn(hObject, eventdata, h) 


varargout{1} =  h.mask_comp_name; 
varargout{2} =  h.mask_comp;

delete(hObject);
end


%% Close request
function figure1_CloseRequestFcn(hObject, eventdata, h)
uiresume(h.figure1);
end



%% Widgets
%% Roi popup menu
function pp_seed_Callback(hObject, eventdata, h)
guidata(hObject, h);
end

function pp_target_Callback(hObject, eventdata, h)
guidata(hObject, h);
end
%% Build callback
function Build_Callback(hObject, eventdata, h)
    seed_val = h.pp_seed.Value;
    target_val = h.pp_target.Value;
    h = BuildMaskComp(seed_val,target_val,h);
    guidata(hObject, h);
end

%% Undo
function Undo_Callback(hObject, eventdata, h)
h.listbox1.String = 'Listbox';
h.mask_comp_name ={};
h.mask_comp =[];
h.cnt = 0;
guidata(hObject, h);
end

%% Other
function h = BuildMaskComp(seed_val,target_val,h)

 h.cnt = h.cnt+1;
 h.mask_comp(h.cnt,1) = seed_val;
 h.mask_comp(h.cnt,2) = target_val;
 h.mask_comp_name{h.cnt,1} = [h.maskAll{seed_val},'-',h.maskAll{target_val}];
 h.listbox1.String = h.mask_comp_name;

end



function done_Callback(hObject, eventdata, h)

uiresume(h.figure1);
guidata(hObject, h);

end
