function Norm_run2(subj,C)


dir_rs = GetValue(C,'dir_rs');
spm_modelName = GetValue(C,'spm_modelName');
spm_smooth = GetValue(C,'spm_smooth');
maskType = GetValue(C,'maskType');
tt = C.tt.tt_func{1}(subj,C);
numTrials = tt.NumTrials;
spm_mask = GetValue(C,'spm_mask');
spm_hpf = GetValue(C,'spm_hpf');
feature_mask = GetValue(C,'rs_feature_mask');
ol_v_method = GetValue(C,'ol_v_method');
ol_v = GetValue(C,'ol_v');

numMasks = NumMasksAll(C);

% input
ipDir = fullfile(dir_rs,spm_modelName,['hpf',num2str(spm_hpf)],spm_mask,spm_smooth,maskType,'betas',feature_mask,'scores',...
    ['OLSv_method_',ol_v_method],['OLSv_',ol_v]); 
% output
opDir = ipDir;
% Start process
load(fullfile(ipDir,[subj, '_scores']));


% conds = {'run_num','run_num','run_num','run_num','currCity','currCity','currCity'};
conds{1} = {'currCity','currCity','currCity'};
conds{2} = {'run_num','run_num','run_num','run_num'};

v.val1 = {1,2,3};
v.val2 = {0,1,2,3};
combs=allcombJ(v);

for i = 1:size(combs,1)
for j = 1:length(conds)
%     cb = Category(conds(i),values{i});
%     cond{i} = cb.input;
    input{i,j}.var = conds{j}(1);
    input{i,j}.val = combs{i,j};
    clear cb
end
end
%   RSA_group(h.C,h.CI_comp,h.stat_mode,h.measure_func);

 

for i1 =1:numMasks
    scores{i1}.rsz_norm= scores{i1}.rsz;
    all_scores = [];
    regressor1 = [];
    regressor2 = [];
    for i2 = 1:size(input,1)
        T = RSA_trial_config(tt,input(i2,:));
        index = RSA_get_index(T,tt,numTrials,'rs_pair'); 
        all_scores = [all_scores;scores{i1}.rsz(index)];
        regressor1 = [regressor1;repmat(num2str(T.(conds{1}{1})),sum(index),1)];
        regressor2 = [regressor2;repmat(num2str(T.(conds{2}{1})),sum(index),1)];
        clear T index
    end
        [~,~,stats]=glmfit([regressor1,regressor2],all_scores);
       for i2 = 1:size(input,1)
        T = RSA_trial_config(tt,input(i2,:));
        index = RSA_get_index(T,tt,numTrials,'rs_pair'); 
        scores{i1}.rsz_norm(index) = stats.resid(regressor1 ...
            == T.(conds{1}{1}) & regressor2 == T.(conds{2}{1}));
   
        clear T index 
       end
       clear stats regressor1
end


save(fullfile(opDir,[subj, '_scores']),'scores','outlier_perc');  







