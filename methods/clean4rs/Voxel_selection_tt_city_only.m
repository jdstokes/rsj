function Voxel_selection_tt_city_only(subj,C)
% Drop/mean voxels showing specified univariate activation patterns


dir_rs = GetValue(C,'dir_rs');
spm_modelName = GetValue(C,'spm_modelName');
spm_smooth = GetValue(C,'spm_smooth');
maskType = GetValue(C,'maskType');

GetTT = str2func(['TT','_',C.name]);
tt_all = GetTT(subj,C); 
numTrials = tt_all.numTrials; 
spm_mask = GetValue(C,'spm_mask');
spm_hpf = GetValue(C,'spm_hpf');

numMasks = NumMasksAll(C);

data_table = table;
vars = {'run_num','tt_code','cityTargC'};


for i =1:length(vars)
data_table.(vars{i})= tt_all.rs_pair.(vars{i});
end

data_table.run_num = categorical(data_table.run_num);
data_table.tt_code = categorical(data_table.tt_code);
data_table.cityTargC = categorical(data_table.cityTargC);

% input
ipDir = fullfile(dir_rs,spm_modelName,['hpf',num2str(spm_hpf)],spm_mask,spm_smooth,maskType,'betas','none');
% output
opDir = fullfile(dir_rs,spm_modelName,['hpf',num2str(spm_hpf)],spm_mask,spm_smooth,maskType,'betas',mfilename);

% Load beta 
load(fullfile(ipDir,[subj, '_betas']));
betas_new = betas_masked;


cnt = zeros(numMasks,1);

%Loop through each ROI
for i1 =1:numMasks
    %Loop through each voxel of each ROI
        numVoxels = size(betas_masked{i1},2);

    for i2 =1:numVoxels
    %Add beta data 
    data_table_new = data_table;
    data_table_new.beta =betas_new{i1}(:,i2); 
    %Remove first trial of each run
    data_table_new(data_table_new.tt_code == '99',:) = [];
    data_table_new.tt_code= removecats(data_table_new.tt_code);
    
    lm_city = fitlm(data_table_new,'beta ~ 1 + cityTargC');
    lm_tt =   fitlm(data_table_new,'beta ~ 1 + tt_code');
%     lm_city_tt =   fitlm(data_table_new,'beta ~ 1 + cityTargC + tt_code');
    
    anova_city = anova(lm_city);
    anova_tt = anova(lm_tt);
    

    
    
        
        
        if anova_city.pValue(1) > .1  || anova_tt.pValue(1) > .1
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






