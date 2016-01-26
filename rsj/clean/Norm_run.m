function Norm_run(subj,C)
% Normalizes values across run and city


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


conds = {'run_num','run_num','run_num','run_num','currCity','currCity','currCity'};
values = {0,1,2,3,1,2,3};

for i = 1:length(conds)
    cb = Category(conds(i),values{i});
    cond{i} = cb.input;
    clear cb
end

 

for i1 =1:numMasks
    scores{i1}.rsz_norm = scores{i1}.rsz;
    for i2 = 1:length(conds)
        T = RSA_trial_config(tt,cond{i2});
        index = RSA_get_index(T,tt,numTrials,'rs_pair');
        
        scores{i1}.rsz_norm(index) =zscore(scores{i1}.rsz(index));
        clear T index
    end
end


save(fullfile(opDir,[subj, '_scores']),'scores','outlier_perc');  







