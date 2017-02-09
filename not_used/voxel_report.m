
function voxel_report
%% Number of voxels per ROI analysis as a function of feature selection type
% 'none' : no removal
% 'anova 1 : {'TT' 'City', 'Run'}
% 'anova 2 : {'TT' 'City'}
warning ('off','all');




% Configure study
C = Study_greco;
% Analysis setup
table_summary = table;

%% 1) number of voxels x ROI
 VST = {'none','Voxel_selection_anova1_effect','Voxel_selection_anova1_noeffect', ...
     'Voxel_selection_anova2_effect','Voxel_selection_anova2_noeffect'};


for i = 1:length(VST)
    table_summary = vst2summaryTable(C,table_summary,VST{i});
end



% %Anova2 effect
% analysis_cnt = analysis_cnt +1;
% C.spm.spm_modelName = 'standard_ST_mr';
% C.spm.spm_smooth = 's2ra';
% C.spm.spm_mask = 'm3';
% C.spm.spm_hpf = 50;
% data_tables = voxel_selection_table(C,'none');
% 
% 
% for i = 2:size(data_tables.data_table_wide,2)
%     table_summary.(data_tables.data_table_wide.Properties.VariableNames{i})=mean(data_tables.data_table_wide{:,i});
% end
% 
% %Anova2 no effect
% analysis_cnt = analysis_cnt +1;
% C.spm.spm_modelName = 'standard_ST_mr';
% C.spm.spm_smooth = 's2ra';
% C.spm.spm_mask = 'm3';
% C.spm.spm_hpf = 50;
% data_tables = voxel_selection_table(C,'none');
% 
% 
% for i = 2:size(data_tables.data_table_wide,2)
%     table_summary.(data_tables.data_table_wide.Properties.VariableNames{i})=mean(data_tables.data_table_wide{:,i});
% end
% 

table_summary
% %% 2 number of voxels x ROI x subject
% C.spm.spm_modelName = 'standard_ST_mr';
% C.spm.spm_smooth = 's2ra';
% C.spm.spm_mask = 'm8';
% C.spm.spm_hpf = 50;
% data_tables = voxel_selection_table(C,'none');
% display(data_tables.data_table_wide);

end



%% methods
%vst2summaryTable
function table_summary = vst2summaryTable(C,table_summary,voxel_selection_type)
    C.spm.spm_modelName = 'standard_ST_mr';
    C.spm.spm_smooth = 's2ra';
    C.spm.spm_mask = 'm3';
    C.spm.spm_hpf = 50;
    data_tables = voxel_selection_table(C,voxel_selection_type);
    if(isempty(table_summary))
        rowNum = 1;
    else
        rowNum = size(table_summary,1)+1;
        
    end
    

    for i = 2:size(data_tables.data_table_wide,2)
        table_summary.([strrep(data_tables.data_table_wide.Properties.VariableNames{i},'_nii',''),'_mean'])(rowNum,1)=mean(data_tables.data_table_wide{:,i});
        table_summary.([strrep(data_tables.data_table_wide.Properties.VariableNames{i},'_nii',''),'_std'])(rowNum,1)=std(data_tables.data_table_wide{:,i});

    end
        table_summary.Properties.RowNames{rowNum} = voxel_selection_type;

   

end
