function analysis_log =greco_behav_analysis(varargin)
close all %Go ahead and close all open figures
% 
% %Load log file, if it does not exist create analysis_log cell
% behav_results = '/Users/jdstokes/Dropbox/Data/GrecoEnc/data/analysis/behav/behav_analysis_log.mat';
% % if exist(behav_results,'file')
% %     load(behav_results);
% % else
% %     analysis_log ={};
% % end


analysis_log ={};
analysis_log = Allcomps(analysis_log);


function analysis_log =Allcomps(analysis_log)


conds = {'corr all s','incorr all d1'};
subjects = greco_choose_subjects();
[~,data]=greco_behav_dprime(subjects,conds);
filter = Filter_subjects(data,0,3);
sum(filter)
clear conds data

% conds = 'corr all s';
% subjects = greco_choose_subjects();
% [data, ~]=greco_behav_scores(subjects,conds);
% filter = Filter_subjects(data,.7,1);
% sum(filter)
% clear conds data

% 
% conds ={'corr all s'};
% subjects = greco_choose_subjects();
% [data,~]=greco_behav_scores(subjects,conds{1});
% filter = Filter_subjects(data,.7,1);
% sum(filter)
% clear conds data

%% Shape
title = 'Shape: Same performance (T,M,N)';
conds ={'corr all s c1 t','corr all s c3 n'};
% subjects = greco_choose_subjects();
data = cell(1,length(conds));
units = '% correct';
xaxis = {'T','M ','N'};
for i = 1:length(conds)
    [hand,~ ]= greco_behav_scores(subjects(filter),conds{i});
    data{1,i}= hand(~isnan(hand));
    clear hand
end
analysis_log = Analysis(analysis_log,title,conds,subjects(filter),data,units,xaxis);
clear title conds columns  data units


%% Shape
title = 'Shape: d1 performance (T,M,N)';
conds ={'corr all d1 t','corr all d1 tpre','corr all d1 n','corr all d1 npre'};
% subjects = greco_choose_subjects();
data = cell(1,length(conds));
units = '% correct';
xaxis = {'T','tpre','N','npre'};
for i = 1:length(conds)
[data{1,i}, ~]=greco_behav_scores(subjects(filter),conds{i});
end
analysis_log = Analysis(analysis_log,title,conds,subjects(filter),data,units,xaxis);
clear title conds columns data units

%% Shape
title = 'Shape: d1 performance (T,M,N)';
conds ={'corr all d1 t','corr all d1 m','corr all d1 n'};
% subjects = greco_choose_subjects();
data = cell(1,length(conds));
units = '% correct';
xaxis = {'T','tpre','N','npre'};
for i = 1:length(conds)
[data{1,i}, ~]=greco_behav_scores(subjects(filter),conds{i});
end
analysis_log = Analysis(analysis_log,title,conds,subjects(filter),data,units,xaxis);
clear title conds columns data units



%%
% title = 'Shape: Diff performance (T,M,N)';
% conds ={'corr all d1 t','corr all d1 m','corr all d1 n'};
% subjects = greco_choose_subjects();
% data = cell(1,length(conds));
% units = '% correct';
% xaxis = {'T','M','N'};
% for i = 1:length(conds)
% [data{1,i}, ~]=greco_behav_scores(subjects(filter),conds{i});
% end
% analysis_log = Analysis(analysis_log,title,conds,subjects(filter),data,units,xaxis);
% clear title conds columns subjects data units

title = 'Shape: Dprime1 (T,N)';
conds = {{'corr all s t','incorr all d1 torm'},{'corr all s m','incorr all d1 m'},{'corr all s n','incorr all d1 norm'}};
% subjects = greco_choose_subjects('a');
data = cell(1,length(conds));
units = 'dprime';
xaxis = {'T','M','N'};
for i = 1:length(conds)
[~,data{1,i}]=greco_behav_dprime(subjects(filter),conds{i});
end
analysis_log = Analysis(analysis_log,title,conds,subjects(filter),data,units,xaxis);
clear title conds  data units





title = 'Shape: D-1 performance (torm,norm)';
conds ={'corr all d1 torm','corr all d1 norm'};
% subjects = greco_choose_subjects();
data = cell(1,length(conds));
units = '% correct';
xaxis = {'T','N'};
for i = 1:length(conds)
[data{1,i}, ~]=greco_behav_scores(subjects(filter),conds{i});
end
analysis_log = Analysis(analysis_log,title,conds,subjects(filter),data,units,xaxis);
clear title conds  data units




% %% RT
% title = 'Same correct RT (T,M,N)';
% conds ={'corr all s t','corr all s m','corr all s n'};
% subjects = greco_choose_subjects();
% data = cell(1,length(conds));
% units = 'RT(s)';
% xaxis = {'T','M','N'};
% for i = 1:length(conds)
% [data{1,i}, ~]=greco_behav_rt(subjects(filter),conds{i});
% end
% analysis_log = Analysis(analysis_log,title,conds,subjects(filter),data,units,xaxis);
% clear title conds subjects data units




%% Learning
title = 'T: Same performance over time';
conds ={'corr all s t r1','corr all s t r2','corr all s t r3','corr all s t r4'};
subjects = greco_choose_subjects();
data = cell(1,length(conds));
units = '% correct';
xaxis = {'Run1','Run2','Run3','Run4'};
for i = 1:length(conds)
[data{1,i}, ~]=greco_behav_scores(subjects(filter),conds{i});
end
analysis_log = Analysis(analysis_log,title,conds,subjects(filter),data,units,xaxis);
clear title conds columns subjects data units

%% Learning
title = 'N: Same performance over time';
conds ={
    'corr all s n r1'
    'corr all s m r1'
    'corr all s t r1'
    'corr all s n r2'
    'corr all s m r2'
    'corr all s t r2'
    'corr all s n r3'
    'corr all s m r3'
    'corr all s t r3'
    'corr all s n r4'
    'corr all s m r4'
    'corr all s t r4'
    };
subjects = greco_choose_subjects();
data = cell(1,length(conds));
units = '% correct';
xaxis = {'Run1','Run1','Run1','Run2','Run2','Run2','Run3','Run3','Run3','Run4','Run4','Run4'};
for i = 1:length(conds)
[data{1,i}, ~]=greco_behav_scores(subjects(filter),conds{i});
end
analysis_log = Analysis(analysis_log,title,conds,subjects(filter),data,units,xaxis);
clear title conds columns subjects data units


title = 'T: Diff performance over time';
conds ={'corr all d t r1','corr all d t r2','corr all d t r3','corr all d t r4'};
subjects = greco_choose_subjects();
data = cell(1,length(conds));
units = '% correct';
xaxis = {'Run1','Run2','Run3','Run4'};
for i = 1:length(conds)
[data{1,i}, ~]=greco_behav_scores(subjects(filter),conds{i});
end
analysis_log = Analysis(analysis_log,title,conds,subjects(filter),data,units,xaxis);
clear title conds columns subjects data units





title = 'N: Diff performance over time';
conds ={'corr all d n r1','corr all d t r2','corr all d n r3','corr all d n r4'};
subjects = greco_choose_subjects();
data = cell(1,length(conds));
units = '% correct';
xaxis = {'Run1','Run2','Run3','Run4'};
for i = 1:length(conds)
[data{1,i}, ~]=greco_behav_scores(subjects(filter),conds{i});
end
analysis_log = Analysis(analysis_log,title,conds,subjects(filter),data,units,xaxis);
clear title conds columns subjects data units



title = 'Diff performance over time';
conds = {
    {'corr all s t r1','incorr all d t r1'}
    {'corr all s n r1','incorr all d n r1'}
    {'corr all s t r2','incorr all d t r2'}
    {'corr all s n r2','incorr all d n r2'}
    {'corr all s t r3','incorr all d t r3'}
    {'corr all s n r3','incorr all d n r3'}
    {'corr all s t r4','incorr all d t r4'}
    {'corr all s n r4','incorr all d n r4'}
    
    };
subjects = greco_choose_subjects();
data = cell(1,length(conds));
units = '% correct';
xaxis = {'Run1 T','Run1 N','Run2 T','Run2 N','Run3 T','Run3 N','Run4 T','Run4 N'};
for i = 1:length(conds)
[~,data{1,i}]=greco_behav_dprime(subjects(filter),conds{i});
end
analysis_log = Analysis(analysis_log,title,conds,subjects(filter),data,units,xaxis);
clear title conds columns subjects data units





%% Behavior analyis log
function analysis_log = Analysis(varargin)
%Use arguments to specific variables
args_new = {'analysis_log','title','conds','subjects','data','units','xaxis'};
args_old = {'analysis_log','title'};
if nargin == length(args_new)
       analysis_log =varargin{1};
       title = varargin{2};
       conds = varargin{3};
       subjects = varargin{4};
       data = varargin{5};
       units = varargin{6};
       xaxis = varargin{7};
elseif nargin ==length(args_old)
     analysis_log =varargin{1};
       title = varargin{2};
      %Check if Title exists
        log_cell =squeeze(struct2cell(analysis_log));
        all_titles = log_cell(strcmp('title',fieldnames(analysis_log)),:);
        annum = find(strcmp(title,all_titles));
        if isempty(annum)
            error('Invalid argument(s)')
        else
            title = analysis_log(annum).title;
            conds = analysis_log(annum).conds;
            subjects = analysis_log(annum).subjects;
            data = analysis_log(annum).data;
            units = analysis_log(annum).units;
            xaxis = analysis_log(annum).xaxis;
            
        end
else
    error('Invalid argument(s)')
end

%First graph
if isempty(analysis_log)
    annum = 1;
    analysis_log(annum).title = title;
    analysis_log(annum).conds = conds;
    analysis_log(annum).subjects = subjects;
    analysis_log(annum).data = data;
    analysis_log(annum).units = units;
    analysis_log(annum).xaxis = xaxis;

    sig = Behav_plot(data,title,xaxis,units);
    analysis_log(annum).h_tag = sig;
else
    %Old graph:
    if exist('annum','var')
       sig = Behav_plot(data,title,xaxis,units);
    else
    %New graph:
    %Check if title exists
    log_cell =squeeze(struct2cell(analysis_log));
    all_titles = log_cell(strcmp('title',fieldnames(analysis_log)),:);
    annum = find(strcmp(title,all_titles));
    %If title does not exist, add entry to analysis_log
    if isempty(annum)
        annum = length(analysis_log) + 1;
        analysis_log(annum).title = title;
        analysis_log(annum).conds = conds;
        analysis_log(annum).subjects = subjects;
        analysis_log(annum).data = data;
        analysis_log(annum).units = units;
        analysis_log(annum).xaxis = xaxis;
        sig = Behav_plot(data,title,xaxis,units);
        analysis_log(annum).h_tag = sig;
    else
        sig = Behav_plot(data,title,xaxis,units);
    end
        

    end
end

%% Behav plot
function sig = Behav_plot(Data,Title,Cond_names,Units)
figure('Color',[1 1 1],'Position',[2450         225         560         420])
sig = greco_statbarplot(Data,'all');
plotmin=mean2(cell2mat(Data))-(std2(cell2mat(Data))*2);
plotmax=mean2(cell2mat(Data))+(std2(cell2mat(Data))*2);
ylim([plotmin plotmax]);
set(gca,'XTickLabel',Cond_names);
set(gca,'LineWidth',2);
set(gca,'FontSize',20);
set(gca,'FontWeight','bold');
ylabel(Units);
title(Title);
% export_fig(gcf,'file_name',Title);

%% Filter by perf
function filter = Filter_subjects(data, thresh_lo, thesh_hi)
filter = data  > thresh_lo & data < thesh_hi;








