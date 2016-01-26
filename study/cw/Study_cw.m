classdef Study_cw < rsj_study 
   
    methods 
        function S = Study_cw
            
            S.name = 'cw';
                        
            % Directories
            S.dir.dir_main = '/Users';
            S.dir.dir_model =       fullfile(S.dir.dir_main,'/jdstokes/Dropbox/Data/dCW/analysis/rs/ind/');
            S.dir.dir_rs =          fullfile(S.dir.dir_main,'/jdstokes/Dropbox/Data/dCW/analysis/rs/ind/');
            S.dir.dir_analysis =    fullfile(S.dir.dir_main,'/jdstokes/Dropbox/Data/dCW/analysis/models/');
            S.dir.dir_behavioral =  fullfile(S.dir.dir_main,'/jdstokes/Dropbox/Data/dCW/behav/AB_param/');
            S.dir.dir_mask =        fullfile(S.dir.dir_main,'/jdstokes/Dropbox/Data/dCW/rois/');
            S.dir.dir_mri=          fullfile(S.dir.dir_main,'/jdstokes/Dropbox/Data/dCW/mri');
            
            % SPM
            S.spm.spm_funcFold = 'BLOCK';
            S.spm.spm_funcFile = 'BLOCK';
            S.spm.spm_hiresFold = 'HIGHSIGNAL';
            S.spm.spm_hiresFile = 'HIGHSIGNAL.nii';
            S.spm.spm_matchedFold = 'MATCHED';
            S.spm.spm_matchedFile = 'MATCHED.nii';
            S.spm.spm_motionFile = 'rp_aBLOCK';
            S.spm.spm_modelName ='standard_ST_mr';%standard_ST_mr
            S.spm.spm_hpf = 128;%50
            S.spm.spm_smooth ='s3ra';
            S.spm.spm_mask = 'm3';
            S.spm.spm_coregFile = 'BLOCK1/raBLOCK1.nii,1';
            
            % TT
            S.tt.tt_trials =  ones(1,8)*24;
            S.tt.mode = 'rs_pair';
            S.tt.score_type = 'rsz';
            
            % rsa
            S.rs.rs_calcOpts = {'Get_scores_rs_pair','Get_scores_rs_all','Get_scores_uni'};
            S.rs.rs_calcUnits = {'MPS(pairwise)','MPS(all)','mean Beta'};
            S.rs.rs_calcCurr = 1;
            S.rs.rs_feature_mask = 'none';
            
            
            
            % outlier
            S.ol.ol_v_method = 'mask';
            S.ol.ol_v = '2SDm';
            S.ol.ol_b = 'IQRm';
            S.ol.ol_rs ='IQRm';
            
            
            S.subjects.subjAll = {'cw03','cw04','cw05','cw06','cw07','cw08',...
                'cw09','cw10','cw11','cw12','cw13','cw14','cw15','cw16',...
                'cw17'};
            
            
            S.subjects.subj2inc =  ones(1,length(S.subjects.subjAll))==1;
            
            
            S.masks.maskType = 'v2';
            
            S.masks.maskAll ={
                'Left_CAant.nii'
                'Left_CA1.nii'
                'Left_CA3.nii'
                'Left_Sub.nii'
                
                'Left_EC.nii'
                'Left_PC.nii'
                'Left_PHC.nii'
                
                'Right_CAant.nii'
                'Right_CA1.nii'
                'Right_CA3.nii'
                'Right_Sub.nii'
                
                'Right_EC.nii'
                'Right_PC.nii'
                'Right_PHC.nii'
                
                };
            
            S.masks.mask2inc = ones(1,length(S.masks.maskAll))==1;
            
            %other
            S.space = rsj_get_space(S);
            
%             
            S.tt.unpack= rsj_tt_unpack(S);
        end
    end
end
    
    



    
    
    
    
    
    
    
