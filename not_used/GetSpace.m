function GS = GetSpace(C)


GS.struct={'spm_modelName','spm_hpf','spm_mask',...
    'spm_smooth','maskType','betas','rs_feature_mask',...
    'scores','ol_v_method','ol_v'};
GS.combs_all = cell(size(GS.struct));

path2 = genpath(C.dir.dir_model);

path2 = strrep(path2,[C.dir.dir_model],'');
path_all = strsplit(path2,':');
path_all = path_all(~cellfun('isempty',path_all));
cnt =0;
for i = 1: length(path_all)
    if size(strsplit(path_all{i},'/'),2) ==length(GS.struct)
        cnt = cnt+1;
        GS.combs_all(cnt,1:length(GS.struct)) = strsplit(path_all{i},'/');
    end
end

GS.combs_curr = GS.combs_all;
GS.opts = GetAll(GS);

end
function opts = GetAll(GS)

cnt = 0;
for i = 1: length(GS.struct)
    if strcmp(GS.struct{i},'scores')||strcmp(GS.struct{i},'betas')
        continue
    end
    cnt = cnt+1;
    opts{cnt} = unique(GS.combs_all(:,i));
end
end

function C  = VarFilter(GS,C,var)

curCombs = GS.combs_curr;
val = GetValue(C,var);

if isnumeric(val) || islogical(val)
    val = num2str(val);
end
%             varInd = ~cellfun('isempty',strfind(rspace.struct,var));
varInd = strcmp(GS.struct,var);
space_ind = ~cellfun('isempty',strfind(curCombs(:,varInd),val));
newCombs = curCombs(space_ind,:);
cnt = 0;
for i = 1: length(GS.struct)
    if strcmp(GS.struct{i},'scores')||strcmp(GS.struct{i},'betas')
        continue
    end
    cnt = cnt+1;
    opts{cnt} = unique(newCombs(:,i));
end

GS.combs_curr = newCombs;
GS.opts = opts;
C.space = GS;
end

function C = VarReset(GS,C,var)
curCombs = GS.combs_curr;
allCombs = C.space.combs_all;
all_ind = ones(size(C.space.combs_all));
cnt = 0;
for i1 = 1: length(GS.struct)
    if ~cellfun('isempty',strfind({'score'},GS.struct{i1}))
        continue
    elseif ~cellfun('isempty',strfind({var},GS.struct{i1}))
        cnt = cnt +1;
        continue
    end
    var_opts = unique(curCombs(:,i1));
    var_ind = ones(size(allCombs,1),1);
    for i2 = 1: length(var_opts)
        ind = ~cellfun('isempty',strfind(allCombs(:,i1),var_opts{i2}));
        var_ind = var_ind.*ind;
    end
    cnt = cnt +1;
    space_ind(:,cnt) = var_ind;
end

cnt = 0;
for i = 1: length(GS.struct)
    if strcmp(GS.struct{i},'scores')
        continue
    end
    cnt = cnt+1;
    opts{cnt} = unique(newCombs(:,i));
end

end

        



