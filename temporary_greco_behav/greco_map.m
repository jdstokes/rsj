
function greco_map

close all
%Load coordinates for all subjects
M = greco_map_load_coords;
S = study_specs;
subjects = S.subjects;
conds = {'corr all s','incorr all d2'};

[~,data]=greco_behav_dprime(subjects,conds);
filter = Filter_subjects(data,-3,3);
sum(filter)
clear conds data
subjIndex = 1:length(M);
%% Analysis 1
%get high DI scores fore each subject
cnt = 0;
for i = subjIndex(filter)
cnt = cnt+1;
di_all= get_di_all(M(i).subj_maps);
data_all(cnt,1:3) = min(di_all); %#ok<*AGROW>
subj_names{cnt} =M(i).subj_name;
end




%Sort by T,M,N
for i = 1:size(data_all,1) 
   S=strsplit(subj_names{i},'_');
   
   if strcmp(S(2),'A')
       dataT(i) = data_all(i,1);
       dataN(i) = data_all(i,3);
   elseif strcmp(S(2),'B')
       dataT(i) = data_all(i,3);
       dataN(i) = data_all(i,1);
   end
   dataM(i) = data_all(i,2);
end


title = 'MapDrawing peformance';
units = 'DI';
xaxis = {'T','N'};
plot_data{1} = dataT;
plot_data{2} = dataN;
Behav_plot(plot_data,title,xaxis,units);

clear di_all data_all dataT dataN dataM plot_data



%% Analysis 2
%get high DI scores fore each subject

cnt=0;
for i = subjIndex(filter)
cnt = cnt+1;
di_all= get_di_all(M(i).subj_maps);
[DI_high,~]=best_perm(di_all,3);
data_all(cnt,1:3) =DI_high; %#ok<*AGROW>
subj_names{cnt} =M(i).subj_name;
end


%Sort by T,M,N
for i = 1:size(data_all,1) 
   S=strsplit(subj_names{i},'_');
   
   if strcmp(S(2),'A')
       dataT(i) = data_all(i,1);
       dataN(i) = data_all(i,3);
   elseif strcmp(S(2),'B')
       dataT(i) = data_all(i,3);
       dataN(i) = data_all(i,1);
   end
   dataM(i) = data_all(i,2);
end

title = 'MapDrawing peformance';
units = 'DI';
xaxis = {'T','M','N'};
plot_data{1} = dataT;
plot_data{2} = dataM;
plot_data{3} = dataN;
Behav_plot(plot_data,title,xaxis,units);
clear di_all data_all dataT dataN dataM plot_data



%% Analysis 3
%get high DI scores fore each subject

cnt = 0;
for i = subjIndex(filter)
cnt = cnt+1;
di_all= get_di_all(M(i).subj_maps);
[DI_high,~]=best_perm2store(di_all);
data_all(cnt,1:2) =DI_high; %#ok<*AGROW>
subj_names{cnt} =M(i).subj_name;
end


%Sort by T,N
for i = 1:size(data_all,1) 
   S=strsplit(subj_names{i},'_');
   
   if strcmp(S(2),'A')
       dataT(i) = data_all(i,1);
       dataN(i) = data_all(i,2);
   elseif strcmp(S(2),'B')
       dataT(i) = data_all(i,2);
       dataN(i) = data_all(i,1);
   end
end

title = 'MapDrawing peformance';
units = 'DI';
xaxis = {'T','N'};
plot_data{1} = dataT;
plot_data{2} = dataN;
Behav_plot(plot_data,title,xaxis,units);
clear di_all data_all dataT dataN dataM plot_data


function di_all= get_di_all(map_data)

for i = 1:length(map_data)
    data = map_data(i); %#ok<*NASGU>
    
    for ii = 1:3
        
        di_all(i,ii) = get_di(data.x(:,ii+1),data.y(:,ii+1),data.x(:,1),data.y(:,1),'jared'); 

    end
    
end

function di = get_di(X,Y,A,B,type)
    switch type
        case 'bdr'
            data = bdr(X,Y,A,B);
            di=data.DI;
        case 'jared'
            TFORM = cp2tform([A B],[X Y],'affine');
            [A1,B1] = tformfwd(TFORM,A,B);

            MAP_poly = roipoly(ones(4000),round(X*10),round(Y*10));
            DRAW_poly = roipoly(ones(4000),round(A1*10),round(B1*10));
            overlap = MAP_poly == 1 & DRAW_poly ==1;
            map_sub = MAP_poly-DRAW_poly;
            MAPxs = map_sub == 1;
            DRAWxs = map_sub == -1;

            sh_perc_orig = (sum2(MAPxs+DRAWxs))/(sum2(MAP_poly));
            %                 sh_perc_xs  = (sum2(MAPxs+DRAWxs))/(sum2(overlap));
            di =sh_perc_orig;
    end
                


function [DI_high,mapID]=best_perm(di_all,num_maps)

plist = perms(1:num_maps);
for i = 1:size(plist,1)
    for j = 1:num_maps
    hold(i,j)= di_all(plist(i,j),j);
    end
    
end

[~,I]=min(mean(hold,2));

DI_high = hold(I,:);
mapID = plist(I,:);

function [DI_high, mapID] =best_perm2store(di_all)

plist = nchoosek(1:3,2);
for i = 1:size(plist,1)
   
    hold(i,1)= di_all(plist(i,1),1);
    hold(i,2)= di_all(plist(i,2),3);
    
end

[~,I]=min(mean(hold,2));

DI_high = hold(I,:);
mapID = plist(I,:);
    





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




