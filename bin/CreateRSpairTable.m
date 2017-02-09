function RSPairTables = CreateRSpairTable

C = Study_greco2;
C.subjects.subj2run= C.subjects.subj2inc;
C.scores.mode = 'rs_pair';
C.scores.score_type = 'rsz';
C.scores.OL_type = 'global_IQR';

[C, rois]= SetupROIs(C);

T = load(fullfile(C.dir.tables,'greco_tables.mat'));
filter.Names = {'spec_name','struct_reg','hpf','response_function','global_scaling'};
filter.Vals =  { 'STris_20',0,50,'hrf',0};
newT = T;
scoreRow = FilterTableScores(newT,filter);
if size(scoreRow,1) > 1
    error('Incorrect filter parameters');
end
modelRow = GetModelRow(scoreRow,T);
scores = GetScores;

rois = FixStrings(rois,{'.nii',},{''});

score_tables =struct;
for cS = 1:length(scores)
   

    CI_comp{1}.input = GetfMRITrialCode(scores{cS});
    data = GetImgScores(C,CI_comp,scoreRow.rs_ID,0,0);
    
    for cM =1:length(rois)
        if ~isfield(score_tables,(['rs_pair_',rois{cM}]))
            score_tables.(['rs_pair_',rois{cM}]).subjects = ...
                C.subjects.subj2inc';
        end
        score_tables.(['rs_pair_',rois{cM}]).(scores{cS}) = data{cM}';
    end
    clear data
end


tableNames =fieldnames(score_tables);
for cT = 1:length(tableNames)
    
    RSPairTables.(tableNames{cT}) = ...
        struct2table(score_tables.(tableNames{cT}));
    
end

save(fullfile(C.dir.tables,'RSPairTables'),'RSPairTables')
end



function scores = GetScores
scores ={

    'all'
    'all_r1'
    'all_r2'
    'all_r3'
    'all_r4'
    
    'same'
    'diff_all'
    'diff1'
    'diff2'
    
    'same_T'
    'diff_all_T'
    'diff1_T'
    'diff2_T'
    
    'same_N'
    'diff_all_N'
    'diff1_N'
    'diff2_N'
    
    'same_M'
    'diff1_M'

    
    'T_T'
    'T_M'
    'T_N'
    'M_M'
    'M_T'
    'M_N'
    'N_N'
    'N_M'
    'N_T'
    
    
    'C1_C1'
    'C1_C2'
    'C1_C3'
    'C2_C2'
    'C2_C1'
    'C2_C3'
    'C3_C3'
    'C3_C2'
    'C3_C1'
    
    
 
    
    'same_r1'
    'same_r2'
    'same_r3'
    'same_r4'
    
    'diff1_r1'
    'diff1_r2'
    'diff1_r3'
    'diff1_r4'
    
    'same_T_r1'
    'same_T_r2'
    'same_T_r3'
    'same_T_r4'
    
    'same_M_r1'
    'same_M_r2'
    'same_M_r3'
    'same_M_r4'
    
    'same_N_r1'
    'same_N_r2'
    'same_N_r3'
    'same_N_r4'
    
    'diff1_T_r1'
    'diff1_T_r2'
    'diff1_T_r3'
    'diff1_T_r4'
    
    'diff1_M_r1'
    'diff1_M_r2'
    'diff1_M_r3'
    'diff1_M_r4'
    
    'diff1_N_r1'
    'diff1_N_r2'
    'diff1_N_r3'
    'diff1_N_r4'
    

    };
end


function [C,rois] = SetupROIs(C)
rois ={
%     'ash_left_35.nii'
%     'ash_left_36.nii'
    'ash_left_ERC.nii'
    'ash_left_CA1.nii'
%     'ash_left_DG.nii'
%     'ash_left_subiculum.nii'
%     
%     'ash_right_35.nii'
%     'ash_right_36.nii'
%     'ash_right_ERC.nii'
    'ash_right_CA1.nii'
    'ash_right_DG.nii'
%     'ash_right_subiculum.nii'
    };

C.masks.mask2inc = zeros(1,length(C.masks.maskAll));
for j = 1: length(rois)
    C.masks.mask2inc(strcmp(rois{j},C.masks.maskAll)) = 1;
end
C.masks.mask2inc = logical(C.masks.mask2inc);
end
