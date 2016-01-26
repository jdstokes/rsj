function Voxel_selection(subj,C,cond,comp_name)
% Drop/mean voxels showing specified univariate activation patterns


dir_rs = GetValue(C,'dir_rs');
spm_modelName = GetValue(C,'spm_modelName');
spm_smooth = GetValue(C,'spm_smooth');
maskType = GetValue(C,'maskType');
tt = C.tt.tt_func{1}(subj,C);
numTrials = tt.NumTrials;
spm_mask = GetValue(C,'spm_mask');
spm_hpf = GetValue(C,'spm_hpf');

numMasks = NumMasksAll(C);

% input
ipDir = fullfile(dir_rs,spm_modelName,['hpf',num2str(spm_hpf)],spm_mask,spm_smooth,maskType,'betas','none');
% output
opDir = fullfile(dir_rs,spm_modelName,['hpf',num2str(spm_hpf)],spm_mask,spm_smooth,maskType,'betas',comp_name);

% Start process
load(fullfile(ipDir,[subj, '_betas']));

   
for i = 1:length(cond)
T = RSA_trial_config(tt,cond{i});
index{i} = RSA_get_index(T,tt,numTrials,'uni');
end
betas_new = betas_masked;
cnt = zeros(numMasks,1);
for i1 =1:numMasks
    numVoxels = size(betas_masked{i1},2);
    
    for i2 =1:numVoxels
        if length(cond) ==2
        groupA = betas_masked{i1}(index{1},i2);
        groupB = betas_masked{i1}(index{2},i2);
        [~,P,~,STATS] =ttest2(groupA,groupB);
        elseif length(cond) > 2
            for i = 1:length(cond)
                
            end
        end
        if P < .1
            betas_new{i1}(:,i2) = NaN;
            cnt(i1)= cnt(i1) +1;
        end
        clear groupA groupB H P Y GROUP STATS
    end
    

end




betas_masked =betas_new;

%%Save .mat
if ~exist(opDir,'dir'),mkdir(opDir);end
save(fullfile(opDir,[subj, '_betas']),'betas_masked','roi_key','cnt');  %save betas






