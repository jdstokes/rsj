function plot_scratch
close all
M = greco_map_load_coords;
S = study_specs;
subjects = S.subjects;


conds = {'corr all s','incorr all d2'};
[~,data]=greco_behav_dprime(subjects,conds);
filter = Filter_subjects(data,-3,3);
sum(filter)
clear conds data
subjIndex = 1:length(M);


for i = subjIndex(filter)
plot_subj_maps(i)
end


%Plot subjects maps
function plot_subj_maps(subj)

M = greco_map_load_coords;
S=strsplit(M(subj).subj_name,'_');
di_all= get_DI(M(subj).subj_maps);
[DI_high,mapID]=best_perm(di_all,3);
numMaps =length(M(subj).subj_maps);
stores = M(subj).subj_maps.stores;


%Index of City 1 and City 3 for subject map drawings
subj_maps(1) = mapID(1);
subj_maps(2) = mapID(3);

true_maps = [1 3];

figure('Color',[1 1 1])
cmp = summer(9); % create the color maps changed as in jet color map
ha = tight_subplot(2,2,[.06 .1],[.1],[.08]);
for i = 1:2
    
    x = M(subj).subj_maps(1).x(:,true_maps(i)+1);
    y = M(subj).subj_maps(1).y(:,true_maps(i)+1);
    axes(ha(i)); 
    a=gscatter(x,y,stores,cmp,'s',10,'off',[],[]);
    for j=1:length(a)
        set(a(j), 'MarkerFaceColor', cmp(j,:))
    end
    set(gca,'LineWidth',2);
    axis square
    if i == 1 && strcmp(S(2),'A')
        title('trained');
    elseif i == 2 && strcmp(S(2),'B')
        title('trained'); 
    else
         title('novel');
    end
end
for i = 1:2
    
    x = M(subj).subj_maps(subj_maps(i)).x(:,1);
    y = M(subj).subj_maps(subj_maps(i)).y(:,1);
    axes(ha(2+i));
    
    try
    a = gscatter(x,y,stores,cmp,'s',10,'off',[],[]);
    set(gca,'LineWidth',2);
    axis square
    
    xlim=get(gca,'Xlim');
    ylim=get(gca,'ylim');
    ht=text((xlim(1)+xlim(2))/2,(ylim(1)+ylim(2))/2,num2str(DI_high(true_maps(i)),'%.4f'));
    ht.FontSize = 16;
    ht.FontWeight = 'bold';
    end
    
end

subtitle(S(1))
saveas(gcf,S{1},'epsc')


%---------------------------------------------------------------------------

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

function [DI_high, mapID] = best_perm2store(di_all)

plist = nchoosek(1:3,2);
for i = 1:size(plist,1)
   
    hold(i,1)= di_all(plist(i,1),1);
    hold(i,2)= di_all(plist(i,2),3);
    
end

[~,I]=min(mean(hold,2));

DI_high = hold(I,:);
mapID = plist(I,:);




function di_all= get_DI(map_data)

for i = 1:length(map_data)
    data = map_data(i); %#ok<*NASGU>
    
    for ii = 1:3
        bdr_out = bdr(data.x(:,ii+1),data.y(:,ii+1),data.x(:,1),data.y(:,1));
        
        di_all(i,ii) = bdr_out.DI;
    end
    
end


function [ax,h]=subtitle(text)
%
%Centers a title over a group of subplots.
%Returns a handle to the title and the handle to an axis.
% [ax,h]=subtitle(text)
%           returns handles to both the axis and the title.
% ax=subtitle(text)
%           returns a handle to the axis only.
ax=axes('Units','Normal','Position',[.075 .075 .85 .85],'Visible','off');
set(get(ax,'Title'),'Visible','on')
title(text);
h=get(ax,'Title');
h.FontSize = 20;
h.FontWeight = 'bold';
if (nargout < 2)
    return
end


%% Filter by perf
function filter = Filter_subjects(data, thresh_lo, thesh_hi)
filter = data  > thresh_lo & data < thesh_hi;

