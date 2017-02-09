classdef Study_greco < Study 
   
    methods 
        function S = Study_greco

            S.name = 'greco';
            % Directories
            
            if exist('/Volumes/jdstokes/Studies','dir')
                S.dir.dir_main = '/Volumes/jdstokes/Studies';
            elseif exist('/Users/jdstokes/Studies','dir')
                S.dir.dir_main = '/Users/jdstokes/Studies';
            else 
                error('no directory set');
            end
%             S.dir.dir_config =      fullfile(S.dir.dir_main,'Studies/Repos/projects/sGR/mlb/');
            S.dir.dir_model =       fullfile(S.dir.dir_main,'/Data/dGR/analysis/rs/ind/');
            S.dir.dir_rs =          fullfile(S.dir.dir_main,'/Data/dGR/analysis/rs/ind/');
            S.dir.dir_analysis =    fullfile(S.dir.dir_main,'/Data/dGR/analysis/models/models_new');
            S.dir.dir_behavioral =  fullfile(S.dir.dir_main,'/Data/dGR/behav/behav_scan/');
            S.dir.dir_mask =        fullfile(S.dir.dir_main,'/Data/dGR/rois/');
            S.dir.dir_mri=          fullfile(S.dir.dir_main,'/Data/dGR/mri');
            S.dir.dir_reports=      fullfile(S.dir.dir_main,'/Data/dGR/reports');
            
            % SPM
            S.spm.spm_funcFold = 'func_run';
            S.spm.spm_funcFile = '0001epihippoperprunX4.nii';
            S.spm.spm_mprageFold = 'mprage';
            S.spm.spm_mprageFile = '0001mpragesagNS.nii';
            S.spm.spm_hiresFold = 'hires';
            S.spm.spm_hiresFile = '0001t2tsehippoperp.nii';
            S.spm.spm_matchedFold = 'matched';
            S.spm.spm_matchedFile = '0001epsegsematched.nii';
            S.spm.spm_motionFile = 'rp_a0001epihippoperprunX4.txt';
            S.spm.spm_coregFile = 'func_run1/ra0001epihippoperprunX4.nii,1';
            S.spm.spm_modelName ='GR_standard_all';%
            S.spm.spm_hpf = 128;%128
            S.spm.spm_smooth ='s2ra';
            S.spm.spm_mask = 'm0';
            S.spm.spm_roi_mask = 'super_mask_ash';
%             S.spm.spm_response_function = 'fir';%'none', 'hrf', 'fir'
%             S.spm.spm_ste = 'mumford'; %Single trial estimation: 'none' 'mumford' 'rissman'
            
            % TT
%           S.tt.tt_trials = ones(1,4)*25;            
%           S.tt.tt_trials = [24,25,25,25];
            S.tt.mode = 'rs_pair';
            S.tt.score_type = 'rsz';
            S.rs.rs_calcOpts = {'Get_scores_rs_pair','Get_scores_rs_all','Get_scores_uni'};

            S.rs.rs_calcUnits = {'MPS(pairwise)','MPS(all)','mean Beta'};
            S.rs.rs_calcCurr = 1;
            S.rs.rs_feature_mask='none';
            
            
            % outlier
            S.ol.ol_v_method = 'mask';
            S.ol.ol_v = '2SDm';
            S.ol.ol_rs ='IQRm';
            
            
%             S.subjects.subjAll = {'S1_A','S16_A','S4_A','S5_A','S6_A','S7_A','S9_A',...
%                 'S8_B','S10_B','S11_B','S12_B','S15_B','S13_B' ,'S14_B','S2_B','S3_A','S21_B','S22_B','S23_B'};
            S.subjects.subjAll = {
                 'S1_A' 
                 'S2_B' 
                 'S3_A'        
                'S4_A'
                'S5_A' 
                'S6_A'
                'S7_A'
                'S8_B'
                'S9_A'
                'S10_B'
                'S11_B'
                'S12_B'
                'S13_B'
                'S14_B'
                'S15_B'
                'S16_A' 
                'S21_B'
                'S22_B'
                'S23_B' % 99 trials
                'S24_A'
%                  'S25_A'
%                   'S26_B'
%                   'S27_A'
               };
            
            
            S.subjects.subj2inc =  ones(1,length(S.subjects.subjAll))==1;
            
            
            S.masks.maskType = 'ash_lfseg_corr_usegray';% 'ash_lfseg_heur' 'ash_lfseg_corr_usegray' 'ash_lfseg_corr_nogray'
            
%             S.masks.maskAll ={
%                 'L_CA1.nii'
%                 'L_CA3.nii'
%                 'L_SUB.nii'
%                 'L_PHC.nii'
%              
%                 
%                 'R_CA1.nii'
%                 'R_CA3.nii'
%                 'R_SUB.nii'
%                 'R_PHC.nii'
%   };
S.masks.maskAll ={
    'ash_left_35.nii'
    'ash_left_36.nii'
    'ash_left_CA1.nii'
    'ash_left_CA2.nii'
    'ash_left_CA3.nii'
    'ash_left_CS.nii'
    'ash_left_DG.nii'
    'ash_left_ERC.nii'
    'ash_left_MISC.nii'
    'ash_left_head.nii'
    'ash_left_subiculum.nii'
    'ash_left_tail.nii'
    'ash_right_35.nii'
    'ash_right_36.nii'
    'ash_right_CA1.nii'
    'ash_right_CA2.nii'
    'ash_right_CA3.nii'
    'ash_right_CS.nii'
    'ash_right_DG.nii'
    'ash_right_ERC.nii'
    'ash_right_MISC.nii'
    'ash_right_head.nii'
    'ash_right_subiculum.nii'
    'ash_right_tail.nii'
    };
              
            
  S.masks.mask2inc = ones(1,length(S.masks.maskAll))==1;
            
         
%              S.space = rsj_get_space(S);
            
%             S.tt.unpack= rsj_tt_unpack(S);

        end
    end
end
    
    



    
    
    
    
    
    
    
