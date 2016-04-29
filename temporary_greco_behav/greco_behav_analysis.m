function analysis_log =greco_behav_analysis(varargin)
close all %Go ahead and close all open figures

analysis_log ={};
analysis_log = Allcomps(analysis_log);


function analysis_log =Allcomps(analysis_log)



subjects = greco_choose_subjects();




filterTypeList = {'dprime','dprime1','dprime2','dprimeHi','dprime1Hi','dprime2Hi','mapFilter'};

for filterNum = 1:length(filterTypeList)
%% plot
type = filterTypeList{filterNum};
filter=filterType(type);
title = ['Same performance (T,M,N) filter:',type,' n=',int2str(sum(filter))];
conds ={'corr all s t','corr all s m','corr all s n'};
data = cell(1,length(conds));
units = '% correct';
xaxis = {'T','M ','N'};
for i = 1:length(conds)
    [hand,~ ]= greco_behav_scores(subjects(filter),conds{i});
    data{1,i}= hand(~isnan(hand));
    clear hand
end
analysis_log = Analysis(analysis_log,title,conds,subjects(filter),data,units,xaxis);
clear title conds columns  data units type i filter

end

for filterNum = 1:length(filterTypeList)
%% plot
type = filterTypeList{filterNum};
filter=filterType(type);
title = ['Diff performance (T,M,N) filter:',type,' n=',int2str(sum(filter))];
conds ={'corr all d t','corr all d m','corr all d n'};
data = cell(1,length(conds));
units = '% correct';
xaxis = {'T','M ','N'};
for i = 1:length(conds)
    [hand,~ ]= greco_behav_scores(subjects(filter),conds{i});
    data{1,i}= hand(~isnan(hand));
    clear hand
end
analysis_log = Analysis(analysis_log,title,conds,subjects(filter),data,units,xaxis);
clear title conds columns  data units type i filter

end


for filterNum = 1:length(filterTypeList)
%% plot
type = filterTypeList{filterNum};
filter=filterType(type);
title = ['Diff1 performance (T,M,N) filter:',type,' n=',int2str(sum(filter))];
conds ={'corr all d1 t','corr all d1 m','corr all d1 n'};
data = cell(1,length(conds));
units = '% correct';
xaxis = {'T','M ','N'};
for i = 1:length(conds)
    [hand,~ ]= greco_behav_scores(subjects(filter),conds{i});
    data{1,i}= hand(~isnan(hand));
    clear hand
end
analysis_log = Analysis(analysis_log,title,conds,subjects(filter),data,units,xaxis);
clear title conds columns  data units type i filter

end


for filterNum = 1:length(filterTypeList)
%% plot
type = filterTypeList{filterNum};
filter=filterType(type);
title = ['Diff1 performance (T,N) filter:',type,' n=',int2str(sum(filter))];
conds ={'corr all d2 t','corr all d2 n'};
data = cell(1,length(conds));
units = '% correct';
xaxis = {'T','N'};
for i = 1:length(conds)
    [hand,~ ]= greco_behav_scores(subjects(filter),conds{i});
    data{1,i}= hand(~isnan(hand));
    clear hand
end
analysis_log = Analysis(analysis_log,title,conds,subjects(filter),data,units,xaxis);
clear title conds columns  data units type i filter

end

%% plot
for filterNum = 1:length(filterTypeList)

type = filterTypeList{filterNum};
filter=filterType(type);
title = ['Dprime1 (T,M,N) filter:',type,' n=',int2str(sum(filter))];
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

end


%% plot
for filterNum = 1:length(filterTypeList)

type = filterTypeList{filterNum};
filter=filterType(type);
title = ['Dprime (T,N) filter:',type,' n=',int2str(sum(filter))];
conds = {{'corr all s t','incorr all d torm'},{'corr all s n','incorr all d norm'}};
% subjects = greco_choose_subjects('a');
data = cell(1,length(conds));
units = 'dprime';
xaxis = {'T','N'};
for i = 1:length(conds)
[~,data{1,i}]=greco_behav_dprime(subjects(filter),conds{i});
end
analysis_log = Analysis(analysis_log,title,conds,subjects(filter),data,units,xaxis);
clear title conds  data units

end

%% plot
for filterNum = 1:length(filterTypeList)

type = filterTypeList{filterNum};
filter=filterType(type);
title = ['Dprime 2 (T,N) filter:',type,' n=',int2str(sum(filter))];
conds = {{'corr all s t','incorr all d2 t'},{'corr all s n','incorr all d2 n'}};
% subjects = greco_choose_subjects('a');
data = cell(1,length(conds));
units = 'dprime';
xaxis = {'T','N'};
for i = 1:length(conds)
[~,data{1,i}]=greco_behav_dprime(subjects(filter),conds{i});
end
analysis_log = Analysis(analysis_log,title,conds,subjects(filter),data,units,xaxis);
clear title conds  data units

end




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


function filter = Filter_subjects_byMap
           subjects = greco_choose_subjects();
           for i = 1: length(subjects)
            scores=greco_map_subj(subjects{i});
            filter(i,1) = scores.D1_T < scores.D1_N;
           end



function filter=filterType(type)

switch type
    case 'none'
        
    case 'dprime'
        conds = {'corr all s','incorr all d'};
        subjects = greco_choose_subjects();
        [~,data]=greco_behav_dprime(subjects,conds);
        filter = Filter_subjects(data,0,3);
     
    case 'dprimeHi'
        conds = {'corr all s','incorr all d'};
        subjects = greco_choose_subjects();
        [~,data]=greco_behav_dprime(subjects,conds);
        filter = data >= mean(data);
        
        
    case 'dprime1'
        conds = {'corr all s','incorr all d1'};
        subjects = greco_choose_subjects();
        [~,data]=greco_behav_dprime(subjects,conds);
        filter = Filter_subjects(data,0,3);
    case 'dprime1Hi'
        conds = {'corr all s','incorr all d1'};
        subjects = greco_choose_subjects();
        [~,data]=greco_behav_dprime(subjects,conds);
        filter = data >= mean(data);        
    case 'dprime2'
        conds = {'corr all s','incorr all d2'};
        subjects = greco_choose_subjects();
        [~,data]=greco_behav_dprime(subjects,conds);
        filter = Filter_subjects(data,0,3);
        
    case 'dprime2Hi'
        conds = {'corr all s','incorr all d2'};
        subjects = greco_choose_subjects();
        [~,data]=greco_behav_dprime(subjects,conds);
        filter = data >= mean(data);
    case 'mapFilter'
        filter = Filter_subjects_byMap;
end










