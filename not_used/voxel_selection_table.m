function data_tables = voxel_selection_table(C,voxel_selection_type)
% Prints out number of voxels x ROI x subject


%__ Choose voxel selection/screen type
% voxel_selection_type = 'Voxel_selection_anova2_effect';



%_Load Study configure specs
% C = Study_greco;
dir_rs = GetValue(C,'dir_rs');
spm_modelName = GetValue(C,'spm_modelName');
spm_smooth = GetValue(C,'spm_smooth');
maskType = GetValue(C,'maskType');
spm_mask = GetValue(C,'spm_mask');
spm_hpf = GetValue(C,'spm_hpf');
numMasks = NumMasksAll(C);



%_Setup input directory
ipDir = fullfile(dir_rs,spm_modelName,['hpf',num2str(spm_hpf)],spm_mask,spm_smooth,maskType,'betas',voxel_selection_type);

cnter = 0; %counter
for i = 1:length(C.subjects.subjAll);
    subj_name = C.subjects.subjAll{i};
   
   betas = load(fullfile(ipDir,[subj_name, '_betas']));
   for j = 1:numMasks
    
    mask_name = C.masks.maskAll{j};
    
    cnter = cnter+1;
    subject{cnter,1} = subj_name;
    mask{cnter,1} = mask_name;
    if isfield(betas,'cnt')
    voxel_count(cnter,1) = betas.cnt(j);
    else
            voxel_count(cnter,1) = size(betas.betas_masked{j},2);
    end
    
   end
end

data_table_long = table(subject,mask,voxel_count);
data_table_wide = unstack(data_table_long,'voxel_count','mask');
data_tables.data_table_long=data_table_long;
data_tables.data_table_wide=data_table_wide;


end
