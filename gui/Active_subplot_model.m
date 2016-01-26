function varargout = Active_subplot_model(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Active_subplot_model_OpeningFcn, ...
                   'gui_OutputFcn',  @Active_subplot_model_OutputFcn, ...
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
function Active_subplot_model_OpeningFcn(hObject, eventdata, h, varargin) %#ok<*INUSL>

h.C = varargin{1};


h = UpdateOptions(h,h.C.space.opts);
h.output = hObject;
guidata(hObject, h);
end
%% Ouput

function varargout = Active_subplot_model_OutputFcn(hObject, eventdata, h) 
varargout{1} = h.C;
end

%% popup callback
function popupmenu_Callback(hObject, eventdata, h) 
contents = cellstr(get(hObject,'String'));

spec_num = str2double(hObject.Tag(end));
ChangeC(hObject,h,contents,spec_num);
guidata(hObject, h);
end


%% ChangeC
function ChangeC(hObject,h,contents,spec_num)
    value = contents{get(hObject,'Value')};
    ChangeVar(h.C,h.spec_names{spec_num},value);

end

function h =  UpdateOptions(h,opts)

h.all_putag = {'popupmenu1','popupmenu2','popupmenu3','popupmenu4','popupmenu5','popupmenu6','popupmenu7','popupmenu8'};
h.spec_names = {'spm_modelName','spm_hpf','spm_mask','spm_smooth','maskType','rs_feature_mask','ol_v_method','ol_v'};



for i1 =1:length(h.spec_names)
   curr = GetValue(h.C,h.spec_names{i1});
   if isa(curr,'logical') || isa(curr,'double')
       curr = num2str(curr);
   end
   
   options = opts{i1};
   
   str2rm = {'OLSv_method_','OLSv_','hpf'};
   for i2 = 1: length(str2rm)
      options = strrep(options,str2rm{i2},'');
   end
   h.(h.all_putag{i1}).String = options;
   h.(h.all_putag{i1}).Value = find(strcmp(curr,options));
end
end

%% 
function filter1_Callback(hObject, eventdata, h) %#ok<*INUSD,*DEFNU>
[h.C.space.opts,h.C.space.combs_curr]  = VarFilter(h.C.space,h.C.space.combs_curr,h.C,h.spec_names{1});
h = UpdateOptions(h,h.C.space.opts);
guidata(hObject, h);
end

function reset1_Callback(hObject, eventdata, h)
h.C.space.opts = GetAll(h.C.space);
h.C.space.combs_curr = h.C.space.combs_all;
h = UpdateOptions(h,h.C.space.opts);
guidata(hObject, h);
end

function filter2_Callback(hObject, eventdata, h)
[h.C.space.opts,h.C.space.combs_curr]  = VarFilter(h.C.space,h.C.space.combs_curr,h.C,h.spec_names{2});
h = UpdateOptions(h,h.C.space.opts);
guidata(hObject, h);

end

function filter3_Callback(hObject, eventdata, h)
[h.C.space.opts,h.C.space.combs_curr]  = VarFilter(h.C.space,h.C.space.combs_curr,h.C,h.spec_names{3});
h = UpdateOptions(h,h.C.space.opts);
guidata(hObject, h);


end



function filter4_Callback(hObject, eventdata, h)
[h.C.space.opts,h.C.space.combs_curr]  = VarFilter(h.C.space,h.C.space.combs_curr,h.C,h.spec_names{4});
h = UpdateOptions(h,h.C.space.opts);
guidata(hObject, h);

end



function filter5_Callback(hObject, eventdata, h)
[h.C.space.opts,h.C.space.combs_curr]  = VarFilter(h.C.space,h.C.space.combs_curr,h.C,h.spec_names{5});
h = UpdateOptions(h,h.C.space.opts);
guidata(hObject, h);

end



function filter6_Callback(hObject, eventdata, h)
[h.C.space.opts,h.C.space.combs_curr]  = VarFilter(h.C.space,h.C.space.combs_curr,h.C,h.spec_names{6});
h = UpdateOptions(h,h.C.space.opts);
guidata(hObject, h);

end


function filter7_Callback(hObject, eventdata, h)
[h.C.space.opts,h.C.space.combs_curr]  = VarFilter(h.C.space,h.C.space.combs_curr,h.C,h.spec_names{7});
h = UpdateOptions(h,h.C.space.opts);
guidata(hObject, h);

end


% --- Executes on button press in filter8.
function filter8_Callback(hObject, eventdata, handles)

[h.C.space.opts,h.C.space.combs_curr]  = VarFilter(h.C.space,h.C.space.combs_curr,h.C,h.spec_names{8});
h = UpdateOptions(h,h.C.space.opts);
guidata(hObject, h);

end
