classdef Study_greco < rsj_study 
   
    methods 
        function S = Study_greco

            S.name = 'greco';
            % Directories
            S.dir.dir_main = '/Users/jdstokes/';
            S.dir.dir_config =      fullfile(S.dir.dir_main,'Dropbox/Repos/projects/sGR/mlb/');
            S.dir.dir_model =       fullfile(S.dir.dir_main,'Dropbox/Data/dGR/analysis/rs/ind/');
            S.dir.dir_rs =          fullfile(S.dir.dir_main,'Dropbox/Data/dGR/analysis/rs/ind/');
            S.dir.dir_analysis =    fullfile(S.dir.dir_main,'Dropbox/Data/dGR/analysis/models/');
            S.dir.dir_behavioral =  fullfile(S.dir.dir_main,'Dropbox/Data/dGR/behav/behav_scan/');
            S.dir.dir_mask =        fullfile(S.dir.dir_main,'Dropbox/Data/dGR/rois/');
            S.dir.dir_mri=          fullfile(S.dir.dir_main,'Dropbox/Data/dGR/mri');
            
            % SPM
            S.spm.spm_funcFold = 'func_run';
            S.spm.spm_funcFile = '0001epihippoperprunX4.nii';
            S.spm.spm_hiresFold = 'hires';
            S.spm.spm_hiresFile = '0001t2tsehippoperp.nii';
            S.spm.spm_matchedFold = 'matched';
            S.spm.spm_matchedFile = '0001epsegsematched.nii';
            S.spm.spm_motionFile = 'rp_a0001epihippoperprunX4.txt';
            S.spm.spm_coregFile = 'func_run1/ra0001epihippoperprunX4.nii,1';
            S.spm.spm_modelName ='standard_ST_mr';%
            S.spm.spm_hpf = 50;%128
            S.spm.spm_smooth ='s2ra';
            S.spm.spm_mask = 'm8';
            
            % TT
             S.tt.tt_trials = ones(1,4)*25;            
%             S.tt.tt_trials = [24,25,25,25];
            S.tt.mode = 'rs_pair';
            S.tt.score_type = 'rsz';
            S.rs.rs_calcOpts = {'Get_scores_rs_pair','Get_scores_rs_all','Get_scores_uni'};

            S.rs.rs_calcUnits = {'MPS(pairwise)','MPS(all)','mean Beta'};
            S.rs.rs_calcCurr = 1;
            S.rs.rs_feature_mask='none';
            
            
            % outlier
            S.ol.ol_v_method = 'mask';
            S.ol.ol_v = 'IQRm';
            S.ol.ol_rs ='IQRm';
            
            
%             S.subjects.subjAll = {'S1_A','S16_A','S4_A','S5_A','S6_A','S7_A','S9_A',...
%                 'S8_B','S10_B','S11_B','S12_B','S15_B','S13_B' ,'S14_B','S2_B','S3_A','S21_B','S22_B','S23_B'};
            S.subjects.subjAll = {
                 'S1_A' %running
                'S16_A' %running
                'S4_A' %ra
                'S5_A' %ra
                'S6_A'
                'S7_A'
                'S9_A'
                'S8_B'
                'S10_B'
                'S11_B'
                'S12_B'
                'S15_B'
                'S13_B'
                'S14_B'
                'S2_B' %done
                'S3_A' %done
                'S21_B'
                'S22_B'
% %                 'S23_B' % 99 trials
% %                  'S24_A'
%                  'S25_A'
%                  'S26_B'
%                     'S27_A'
                };
            
            
            S.subjects.subj2inc =  ones(1,length(S.subjects.subjAll))==1;
            
            
            S.masks.maskType = 'v3';%'v3.0'
            
            S.masks.maskAll ={
                'L_CA1.nii'
                'L_CA3.nii'
                'L_SUB.nii'
                'L_PHC.nii'
                % 'L_EC.nii'
                % 'L_PC.nii'
             
                
                'R_CA1.nii'
                'R_CA3.nii'
                'R_SUB.nii'
                'R_PHC.nii'
                % 'R_EC.nii'
                % 'R_PC.nii'
                
               
                };
            
            S.masks.mask2inc = ones(1,length(S.masks.maskAll))==1;
            
            %other
%             S.space = rsj_get_space(S);
            
            S.tt.unpack= rsj_tt_unpack(S);

        end
    end
end
    
    



    
    
    
    
    
    
    
