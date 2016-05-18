function Voxel_selection_anova1(subj,C)
% Drop/mean voxels showing specified univariate activation patterns


dir_rs = GetValue(C,'dir_rs');
spm_modelName = GetValue(C,'spm_modelName');
spm_smooth = GetValue(C,'spm_smooth');
maskType = GetValue(C,'maskType');

GetTT = str2func(['TT','_',C.name]);
tt_all = GetTT(subj,C); 
spm_mask = GetValue(C,'spm_mask');
spm_hpf = GetValue(C,'spm_hpf');
numMasks = NumMasksAll(C);

data_table = table;
vars = {'run_num','tt_code','cityTargC'};


for i =1:length(vars)
data_table.(vars{i})= tt_all.rs_pair.(vars{i});
end

% data_table.run_num = categorical(data_table.run_num);
% data_table.tt_code = categorical(data_table.tt_code);
data_table.cityTargC = categorical(data_table.cityTargC);

% input
ipDir = fullfile(dir_rs,spm_modelName,['hpf',num2str(spm_hpf)],spm_mask,spm_smooth,maskType,'betas','none');
% output
opDir = fullfile(dir_rs,spm_modelName,['hpf',num2str(spm_hpf)],spm_mask,spm_smooth,maskType,'betas',mfilename);

% Load beta 
load(fullfile(ipDir,[subj, '_betas']));

betas_new_effect = betas_masked;
betas_new_noeffect = betas_masked;


cnt_effect = zeros(numMasks,1);
cnt_noeffect = zeros(numMasks,1);

%Loop through each ROI
for i1 =1:numMasks
    %Loop through each voxel of each ROI
        numVoxels = size(betas_masked{i1},2);

    for i2 =1:numVoxels
    %Add beta data 
    data_table_new = data_table;
    data_table_new.beta =betas_masked{i1}(:,i2); 
    %Remove first trial of each run
    data_table_new(data_table_new.tt_code == 99,:) = [];
%     data_table_new.tt_code= removecats(data_table_new.tt_code);
    
    
[pvals,~,~] = anovan(data_table_new.beta, {data_table_new.run_num data_table_new.tt_code data_table_new.cityTargC}, ...
'model','interaction','varnames',{'Run' 'TT' 'City'},'display','off');
    
    
        
    
        
        
        if any(pvals < .10)
            betas_new_noeffect{i1}(:,i2) = NaN;
            cnt_effect(i1)= cnt_effect(i1) +1;
        else
            betas_new_effect{i1}(:,i2) = NaN;
            cnt_noeffect(i1)= cnt_noeffect(i1) +1;

        end
        clear groupA groupB H P Y GROUP STATS
    end
    

end



%%Save .mat
betas_masked =betas_new_noeffect;
cnt = cnt_noeffect;
if ~exist([opDir,'_noeffect'],'dir'),mkdir([opDir,'_noeffect']);end
save(fullfile([opDir,'_noeffect'],[subj, '_betas']),'betas_masked','roi_key','cnt');  %save betas

%%Save .mat
betas_masked =betas_new_effect;
cnt = cnt_effect;
if ~exist([opDir,'_effect'],'dir'),mkdir([opDir,'_effect']);end
save(fullfile([opDir,'_effect'],[subj, '_betas']),'betas_masked','roi_key','cnt');  %save betas






