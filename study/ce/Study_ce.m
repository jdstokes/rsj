classdef Study_ce < Study 
   
    methods 
        function S = Study_ce
            % Directories
            S.dir.dir_main = '/Users';
            S.dir.dir_model =       fullfile(S.dir.dir_main,'/jdstokes/Dropbox/Data/dCER/analysis/rs/ind/');
            S.dir.dir_rs =          fullfile(S.dir.dir_main,'/jdstokes/Dropbox/Data/dCER/analysis/rs/ind/');
            S.dir.dir_analysis =    fullfile(S.dir.dir_main,'/jdstokes/Dropbox/Data/dCER/analysis/models/');
            S.dir.dir_behavioral =  fullfile(S.dir.dir_main,'/jdstokes/Dropbox/Data/dCER/behav/nav_task');
            S.dir.dir_mask =        fullfile(S.dir.dir_main,'/jdstokes/Dropbox/Data/dCER/rois/');
           S.dir.dir_mri=          fullfile(S.dir.dir_main,'/jdstokes/Dropbox/Data/dCER/mri/');
            
            % SPM
            S.spm.spm_funcFold = 'func_run';
            S.spm.spm_funcFile = 'func_run';
            S.spm.spm_hiresFold = 'hires';
            S.spm.spm_hiresFile = 'hires.nii';
            S.spm.spm_matchedFold = 'matched';
            S.spm.spm_matchedFile = 'matched.nii';
            S.spm.spm_motionFile = 'rp_afunc_run';
            S.spm.spm_modelName ='standard_ST_mr';%
            S.spm.spm_hpf = 50;%128
            S.spm.spm_smooth ='s3ra';
            S.spm.spm_mask = 'm8';
            
            % TT
            S.tt.tt_val = 1;
            S.tt.tt_versions = {'TT','TT_rs'};
            S.tt.tt_func = {str2func([S.tt.tt_versions{1},'_ce']),str2func([S.tt.tt_versions{1},'_ce'])};
            S.tt.tt_trials = ones(1,4)*24;
            
            % rsa
            S.rs.rs_calcOpts = {'Get_scores_rs_pair','Get_scores_rs_all','Get_scores_uni'};
            S.rs.rs_calcUnits = {'MPS(pairwise)','MPS(all)','mean Beta'};
            S.rs.rs_calcCurr = 1;
            S.rs.rs_feature_mask = 'none';
            

            % outlier
            S.ol.ol_v_method = 'none';
            S.ol.ol_v = 'NO';
            S.ol.ol_b = 'IQRm';
            S.ol.ol_rs ='IQRm';
            
            
            S.subjects.subjAll  = { 'ce104', 'ce105', 'ce106', 'ce107', 'ce108', 'ce109',...
            'ce111', 'ce112', 'ce113', 'ce114', 'ce115', 'ce116', 'ce117',...
            'ce118', 'ce119', 'ce120'};
            S.subjects.subj2inc =  ones(1,length(S.subjects.subjAll))==1;
            
            
            S.masks.maskType = 'v1a';
            
            S.masks.maskAll ={
                'L_CA1.nii'
                'L_CA3.nii'
                'L_EC.nii'
                'L_PC.nii'
                'L_PHC.nii'
                'L_SUB.nii'
                'R_CA1.nii'
                'R_CA3.nii'
                'R_EC.nii'
                'R_PC.nii'
                'R_PHC.nii'
                'R_SUB.nii'
                };
            
            S.masks.mask2inc = ones(1,length(S.masks.maskAll))==1;
            
%             %other
             S.space = Study_space(S);
%             
             S.tt.tt= Study_trials(S);

                 
        end
    end
end
    
    



    
    
    
    
    
    
    
