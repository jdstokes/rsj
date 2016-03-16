function varargout = Active_subplot_conn(varargin)
%%
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Active_subplot_conn_OpeningFcn, ...
                   'gui_OutputFcn',  @Active_subplot_conn_OutputFcn, ...
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
function Active_subplot_conn_OpeningFcn(hObject, eventdata, h, varargin) %#ok<*INUSL>
h.C = varargin{1};
h.popupmenu1.String = h.C.masks.maskAll;
h.cnt = 0;
for i = 1: length(h.C.masks.maskAll)
 
    button_tag = ['radiobutton',num2str(i)];
    h.(button_tag).String = h.C.masks.maskAll{i};
    h.(button_tag).Value = h.C.masks.mask2inc(i);
  
end

h.output = hObject;
guidata(hObject, h);
uiwait(h.figure1);

end
%% Output
function varargout = Active_subplot_conn_OutputFcn(hObject, eventdata, h) 
varargout{1} =  h.mask_comp_name; 
varargout{2} = h.mask_comp;
end




%% Widgets
%% Comp list
function listbox1_Callback(hObject, eventdata, h) %#ok<*DEFNU,*INUSD>
end

%% Roi popup menu
function popupmenu1_Callback(hObject, eventdata, h)
guidata(hObject, h);
end
%% Build callback
function Build_Callback(hObject, eventdata, h)

seed_val = h.popupmenu1.Value;
h = BuildMaskComp(seed_val,h);
h.output = hObject;
guidata(hObject, h);

end
%% Roi callback
function roi_Callback(hObject, eventdata, h)

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

function h = BuildMaskComp(seed_val,h)

for i = 1: length(h.C.masks.maskAll)
 
    button_tag = ['radiobutton',num2str(i)];
   
    if h.(button_tag).Value 
       h.cnt = h.cnt+1;
       h.mask_comp(h.cnt,1) = seed_val;
       h.mask_comp(h.cnt,2) = i;
       h.mask_comp_name{h.cnt,1} = strrep(strrep([h.C.masks.maskAll{seed_val},'-',h.C.masks.maskAll{i}],'.nii',''),'_','');
    end
  
end

h.listbox1.String =[h.mask_comp_name];

end



function done_Callback(hObject, eventdata, h)

uiresume(h.figure1);
end
