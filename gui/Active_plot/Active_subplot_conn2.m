function varargout = Active_subplot_conn2(varargin)
%%
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Active_subplot_conn2_OpeningFcn, ...
                   'gui_OutputFcn',  @Active_subplot_conn2_OutputFcn, ...
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
function Active_subplot_conn2_OpeningFcn(hObject, eventdata, h, varargin) %#ok<*INUSL>

%For testing purposes go ahead and load a fresh study object
if isempty(varargin)
    h.C = Study_greco;
else
    h.C = varargin{1};   
end
h.mask_comp_name={}; 
h.mask_comp=[];

h.popupmenu1.String = h.C.masks.maskAll;
h.cnt = 0;
 numMasks = length(h.C.masks.maskAll);
 cnt=0;
 for i = length(h.radiobutton):-1:1
     cnt=cnt+1;
    if(cnt <= numMasks)
    h.radiobutton(i).String = h.C.masks.maskAll{cnt};
    h.radiobutton(i).Value = h.C.masks.mask2inc(cnt);
    else
        delete(h.radiobutton(i));
    end
 end
  

% h.output = hObject;
 
guidata(hObject, h);
uiwait(h.figure1);

end
%% Output
function varargout = Active_subplot_conn2_OutputFcn(hObject, eventdata, h) 

varargout{1} =  h.mask_comp_name; 
varargout{2} = h.mask_comp;
 delete(h.figure1);
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
% h.output = hObject;
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

 numMasks = length(h.C.masks.maskAll);
 cnt=0;
 for i = length(h.radiobutton):-1:1
     cnt=cnt+1;
    if(cnt <= numMasks)
    if h.radiobutton(i).Value 
       h.cnt = h.cnt+1;
       h.mask_comp(h.cnt,1) = seed_val;
       h.mask_comp(h.cnt,2) = cnt;
       h.mask_comp_name{h.cnt,1} = strrep(strrep([h.C.masks.maskAll{seed_val},'-',h.C.masks.maskAll{cnt}],'.nii',''),'_','');
    end
    end
  
end

h.listbox1.String =[h.mask_comp_name];

end



function done_Callback(hObject, eventdata, h)

uiresume(h.figure1);

end



