function varargout = Active_plot(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Active_plot_OpeningFcn, ...
    'gui_OutputFcn',  @Active_plot_OutputFcn, ...
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

%% Open Plot
function Active_plot_OpeningFcn(hObj, ed, h, varargin)
h = SetupStudy(h,1);
h.output = hObj;
guidata(hObj, h);
end
%% Output
function varargout = Active_plot_OutputFcn(hObj, ed, h) %#ok<*INUSL>
varargout{1} = h.output;
end
%% Close request
function figure1_CloseRequestFcn(hObj, ed, h)
delete(hObj);
end

%% .......................................................................%
%                           Widget methods
%.........................................................................%
%% GetScores
function update_pb_Callback(hObj, ed, h) %#ok<*DEFNU>

cla(h.axes1,'reset');
axes(h.axes1);
axis off
if ~length(h.listboxComp.String)==0
rsj_rsa_group(h.C,h.CI_comp,h.stat_mode,h.measure_func,h.listboxComp.String(2:end,1));
end
hold off
guidata(hObj, h);
end
%% GetConnectivity
function pushbutton10_Callback(hObj, ed, h)
axes(h.axes2);
rsj_rsa_group_corr(h.C,h.CI_comp,h.stat_mode,h.mask_comp,h.mask_comp_name,h.measure_func,h.listboxComp.String(2:end,1));
hold off
guidata(hObj, h);
end



%%
function model_pb_Callback(hObj, ed, h)
h.C = Active_subplot_model(h.C);
guidata(hObj, h);
end

function subject_pb_Callback(hObj, ed, h) %#ok<*INUSD>
h.C=Active_subplot_subj(h.C);
guidata(hObj, h);
end

function roi_pb_Callback(hObj, ed, h)
h.C=Active_subplot_roi(h.C);
guidata(hObj, h);
end


function conn_pb_Callback(hObj, ed, h)
[h.mask_comp_name, h.mask_comp] =Active_subplot_conn(h.C);
guidata(hObj, h);
end
%% Build/fill in ListBoxes
function build_pb_Callback(hObj, ed, h)
h=CompileTT(h);

if isempty(h.listboxComp.String)
    tts{1} = 'New comp';
else
tts = h.listboxComp.String;
end

if h.listboxComp.Value ==1
tts = Input2Str(h.CI_comp{h.comp_num-1}.input,h.comp_num,tts);
else
tts = Input2Str(h.CI_comp{h.listboxComp.Value-1}.input,...
    h.listboxComp.Value,tts);
end
h.listboxComp.String = tts;
guidata(hObj, h);
end

function build_corr_Callback(hObj, ed, h)
h=CompileCORR(h);

if isempty(h.listboxCorr.String)
    tts{1} = 'New comp';
else
tts = h.listboxCorr.String;
end

if h.listboxCorr.Value ==1
tts = Input2Str(h.CI_corr{h.corr_num-1}.input,h.corr_num,tts);
else
tts = Input2Str(h.CI_corr{h.listboxCorr.Value-1}.input,...
    h.listboxCorr.Value,tts);
end
h.listboxCorr.String = tts;
guidata(hObj, h);
end


%%
function tt_reset_pb_Callback(hObj, ed, h)

for i =1:length(h.pumtag)
h.(h.pumtag{i}).Value = 1;
h = GetLBString('null',h,h.pumtag{i});
end
guidata(hObj, h);

end


function comp_reset_pb_Callback(hObj, ed, h)
h.listboxComp.String = '';
h.listboxComp.Value =1;
h.comp_num = 1;
h.CI_comp ={};
guidata(hObj, h);
end

function corr_reset_pb_Callback(hObj, ed, h)

h.listboxCorr.String = '';
h.listboxCorr.Value =1;
h.corr_num = 1;
h.CI_corr ={};
guidata(hObj, h);
end

%% Undo
function comp_undo_pb_Callback(hObj, ed, h)

cn =h.listboxComp.Value;
if ~isempty(h.CI_comp) && h.listboxComp.Value ~=1

    h.CI_comp{cn-1}.input{end}= rmfield(...
        h.CI_comp{cn-1}.input{end},{'val','var'});
    
    h.CI_comp{cn-1}.input= h.CI_comp{cn-1}.input(...
        ~cellfun(@(x) isempty(fieldnames(x)),h.CI_comp{cn-1}.input));
    
    tts = h.listboxComp.String;
    tts = Input2Str(h.CI_comp{cn-1}.input,...
        cn,tts);
    h.listboxComp.String = tts;
    
    h.CI_comp=h.CI_comp(~cellfun(@(x) isempty(x.input),h.CI_comp));

    guidata(hObj, h);
end
end
%% Select trial conditions
function tt_pm1_Callback(hObj, ed, h)
var_name = hObj.String{hObj.Value};
h = GetLBString(var_name,h,hObj.Tag);
guidata(hObj, h);
end
function tt_pm1_CreateFcn(hObj,ed,h)

end
%% ChangeMeasure Callback
function pu_Measure_Callback(hObj, ed, h)
measure = hObj.String{hObj.Value};
switch measure
    case  'MPS(pw)'
        h.C.tt.score_type = 'rsz';
        h.C.tt.mode = 'rs_pair';
    case  'MPS(all)'
         h.C.tt.score_type = 'rsz';
         h.C.tt.mode ='rs_all';
    case  'mean Beta'
         h.C.tt.score_type = 'uni_m';
         h.C.tt.mode = 'uni';

end
SetTTnames(h)

    
guidata(hObj, h);
end

%% .......................................................................%                        
%                           Other methods
%.........................................................................%
%% Setup study
function h = SetupStudy(h,val)
h.study_opts = {'Study_greco','Study_cw','Study_ce'};
study_func = str2func(h.study_opts{val});
h.C = study_func();
h.measure_func = 1;
h.measure_func_options = {'standard','subtraction','corr'};
h.measure_func_pop.String = h.measure_func_options;
h.popupmenu_study.String = h.study_opts;
h.popupmenu_study.Value = val;
h.stat_opts = {'within','all','none'};
h.stats.String = h.stat_opts;
h.stats.Value = 1;
h.stat_mode = h.stat_opts{h.stats.Value};
h.ol_options = {'IQRm','NO','2SDm','3SDm'};
h.ol_v.String =h.ol_options;
h.ol_rs.String = h.ol_options;

h.lbtag =  {'tt_lb1','tt_lb2','tt_lb3'};
h.pumtag = {'tt_pm1','tt_pm2','tt_pm3'};


h.CI_comp ={};
h.comp_num =1;

h.CI_corr ={};
h.corr_num =1;

h = SetTTRB(h);

h = SetTTnames(h);
end
 


function performance_Callback(hObj, ed, h)

end


% --- Executes on button press in Save3.
function Save3_Callback(hObj, ed, h)
% hObj    handle to Save3 (see GCBO)
% ed  reserved - to be defined in a future version of MATLAB
% h    structure with h and user data (see GUIDATA)
end


% --- Executes on button press in measure_func_pop.
function measure_func_pop_Callback(hObj, ed, h)
h.measure_func = hObj.String{hObj.Value};
guidata(hObj, h);
end


% --- Executes on selection change in stats.
function stats_Callback(hObj, ed, h)

h.stat_mode = hObj.String{hObj.Value};
guidata(hObj, h);
end


% --- Executes on button press in test_reg.
function test_reg_Callback(hObj, ed, h)
% hold off
% axes(h.axes2);
% hold off

% rsj_rsa_group_cum(h.C,h.CI_comp,h.stat_mode,h.measure_func,h.listboxComp.String(2:end,1));
rsj_rsa_group_cum_cw(h.C,h.CI_comp,h.listboxComp.String(2:end,1))
guidata(hObj, h);


end
%% CompileTT
function h = CompileTT(h)

if h.listboxComp.Value == 1
h.comp_num = h.comp_num +1;
cn = h.comp_num -1;
else
cn = h.listboxComp.Value -1;
end

if isempty(h.CI_comp) || h.listboxComp.Value ==1
    cnt = 0;
else
    cnt = length(h.CI_comp{cn}.input);
end

for i1 = 1:3
    cnt = cnt+1;
    pum_name = h.pumtag{i1};
    pum_cnt = h.(pum_name).Value;
    lb_name = h.lbtag{i1};
    lb_cnt = h.(lb_name).Value;
    
    if ~strcmp(h.(pum_name).String(pum_cnt),'null')
        tt = h.(pum_name).String{pum_cnt};
        h.CI_comp{cn}.input{cnt}.var = {tt};
        vals = h.C.tt.unpack.vals.(tt);
        h.CI_comp{cn}.input{cnt}.val = vals(lb_cnt);
    else
        h.CI_comp{cn}.input{cnt}=[];
    end
end
h.CI_comp{cn}.input = h.CI_comp{cn}.input(~cellfun('isempty',h.CI_comp{cn}.input));
end
%% CompileCORR
function h = CompileCORR(h)

if h.listboxCorr.Value == 1
h.corr_num = h.corr_num +1;
cn = h.corr_num -1;
else
cn = h.listboxCorr.Value -1;
end

if isempty(h.CI_corr) || h.listboxCorr.Value ==1
    cnt = 0;
else
    cnt = length(h.CI_corr{cn}.input);
end

for i1 = 1:3
    cnt = cnt+1;
    pum_name = h.pumtag{i1};
    pum_cnt = h.(pum_name).Value;
    lb_name = h.lbtag{i1};
    lb_cnt = h.(lb_name).Value;
    
    if ~strcmp(h.(pum_name).String(pum_cnt),'null')
        tt = h.(pum_name).String{pum_cnt};
        h.CI_corr{cn}.input{cnt}.var = {tt};
        vals = h.C.tt.unpack.vals.(tt);
        h.CI_corr{cn}.input{cnt}.val = vals(lb_cnt);
    else
        h.CI_corr{cn}.input{cnt}=[];
    end
end
h.CI_corr{cn}.input = h.CI_corr{cn}.input(~cellfun('isempty',h.CI_orr{cn}.input));
end



%% Input2Str
function tts = Input2Str(input,cn,tts)

s = '';

for i1 = 1: length(input)
    if ~isempty(input{i1})
        s = [s,input{i1}.var{1}];
        if isnumeric(input{i1}.val) || islogical(input{i1}.val)
            s = [s,'_',num2str(input{i1}.val)','_'];
        else iscell(input{i1}.val)
            s = [s,'_', input{i1}.val{:},'_'];
        end
    end
end
tts{cn} = s(1:end-1);
end

%% Set TT radio buttons
function h = SetTTRB(h)
h.rb_tt1.Value = 1;
h.rb_tt2.Value = 0;
% if h.C.tt.mode ==1
%     h.rb_tt1.Value = 1;
%     h.rb_tt2.Value = 0;
% elseif h.C.tt.mode ==2
%       h.rb_tt1.Value = 0;
%     h.rb_tt2.Value = 1;
% end

end
%% Get TT names
function h = SetTTnames(h)
for i1 = 1:length(h.pumtag)
    if strcmp(h.C.tt.mode,'rs_pair')||strcmp(h.C.tt.mode,'uni')
     h.(h.pumtag{i1}).String = h.C.tt.unpack.menu;
    else
     h.(h.pumtag{i1}).String = h.C.tt.unpack.menu_rs;
    end
    h.(h.pumtag{i1}).Value = 1;
    h.(h.lbtag{i1}).String ={};
end
end
%% GetLBString
function h = GetLBString(var_name,h,tag)

lbind = strcmp(tag,h.pumtag);
if ~ strcmp(var_name,'null')
    vals =h.C.tt.unpack.vals.(var_name);
    if isnumeric(vals) || islogical(vals)
        h.(h.lbtag{lbind}).String = cellstr(num2str(vals));
    else
        h.(h.lbtag{lbind}).String = vals;
    end
else
    h.(h.lbtag{lbind}).String = {};
end
    h.(h.lbtag{lbind}).Value = 1;
end
%% GetStudies
function study_func = GetStudies
study_func = {'Study_greco','Study_ce','Study_cw'};
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% .......................................................................%                        
%                           New methods
%.........................................................................%

function rb_tt1_Callback(hObj, ed, h)
tt_reset_pb_Callback(hObj, ed, h);
h.rb_tt2.Value = ~ hObj.Value;
if hObj.Value ==1
    ChangeTT(h.C,1)
end
guidata(hObj, h);
h = SetTTnames(h);
end


function rb_tt2_Callback(hObj, ed, h)
tt_reset_pb_Callback(hObj, ed, h);
h.rb_tt1.Value = ~ hObj.Value;
if hObj.Value ==1
   ChangeTT(h.C,2)
end
guidata(hObj, h);
h = SetTTnames(h);
end




%%
function Save1_Callback(hObj, ed, h)
keyboard

end



function Save2_Callback(hObj, ed, h)

end



function ol_rs_Callback(hObj, ed, h)
h.C.ol.ol_rs = h.ol_options{hObj.Value};                      
guidata(hObj, h);
end


function ol_v_Callback(hObj, ed, h)
h.C.ol.ol_b = h.ol_options{hObj.Value};
guidata(hObj, h);
end

function popupmenu_study_Callback(hObj, ed, h)
 h = SetupStudy(h,hObj.Value);
guidata(hObj, h);
end



%% PLOTLY
function plotly_standard_Callback(hObject, eventdata, h)


rsj_rsa_group(h.C,h.CI_comp,'plotly',h.measure_func,h.listboxComp.String(2:end,1));

end

function plotly_conn_Callback(hObject, eventdata, h)
rsj_rsa_group_corr(h.C,h.CI_comp,'plotly',h.mask_comp,h.mask_comp_name,h.measure_func,h.listboxComp.String(2:end,1));



end
%% Get CorrMat
function plotly_mat_Callback(hObject, eventdata, h)

rsj_rsa_group_corr_matrix(h.C,h.CI_comp,h.listboxComp.String(2:end,1))
end


