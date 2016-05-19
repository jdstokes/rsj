function rsj_batch_group(varargin)
% Batch script for the following modules:
% 'rsj_spm_smooth' 'rsj_spm_model' 'SPM_supermask' 'Maskbetas'
% 'Calcrs'
% 'rsj_spm_segment_mprage'   ,'rsj_spm_specs' , 'rsj_spm_model_byRun'
% 'rsj_spm_model_byRunNoMR' 'rsj_spm_model_byRunNoMR_FIR'
% 'rsj_spm_model_super_mask' 'rsj_spm_model_noMR_super_mask'
if nargin == 0
elseif nargin == 1 && iscellstr(varargin)
    if any(strcmp(varargin{1},{'model','smooth','rsa','special','other'}))
        options = getOptions(varargin{1});
    else
        error('bad input');
    end
else
    error('bad input')
end
    
modules = {'rsj_publish'};

subjects= {
        'S1_A'
        'S16_A'
        'S4_A'
        'S5_A'
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
        'S2_B'
        'S3_A'
        'S21_B'
        'S22_B'
        'S23_B'
        'S24_A'


                };
            

%% load C
C = Study_greco;
C.subjects.subjAll = subjects;

    if exist('options','var')
    combs = allcombJ(options);
        for i = 1:size(combs,1)
            RunGroup(C,fieldnames(options),combs(i,:),modules)
        end
        
    else
        RS_pipeline(C,modules)
    end

end


%% Group analysis batch
function RunGroup(C,varNames,mode,modules)
disp(mode);
 for i = 1:length(varNames)
   
   ChangeVar(C,varNames{i},mode{i});
 end
 
 RS_pipeline(C,modules);

end

 


%% RSA pipeline 
function RS_pipeline(C,modules)

for i = 1:length(modules)
    disp(modules{i});
    mod_func = str2func(modules{i});

    mod_func(C);

end
end

%% Report errors
function errorfun(S, varargin)  
   warning(S.identifier, S.message);
end

 %% Artists
 
 function options = getOptions(opts)
 
 switch opts
     case 'model'
         options.spm_smooth = {'s2ra','s1ra','ra','s3ra'};
         options.spm_mask = {'m3','m1','m0'};
         options.spm_hpf ={50,128};
         options.spm_modelName = {'standard_ST_mr'};
     case 'smooth'
         options.spm_smooth = {};
     case 'rsa'
         options.spm_smooth = {'s3ra','s2ra','s1ra','ra',};
         options.spm_mask = {'m8','m3','m1','m0'};
         options.spm_hpf ={50,128};
         options.spm_modelName = {'standard_ST_mr'};
         options.maskType = {'v3'};
     case 'special'
         options.spm_smooth = {'s1ra'};
         options.spm_mask = {'m8','m3','m1'};
         options.spm_hpf ={50};
         options.spm_modelName = {'standard_ST_mr'};
         options.maskType = {'v3'};
     case 'masks'
        options.maskType = {'v3'};
     case 'other'
%          options.rs_feature_mask={'Voxel_selection_anova1_effect','Voxel_selection_anova1_noeffect'};
        options.spm_hpf ={50,128};
         options.spm_mask = {'m8','m3','m1','m0'};
         options.spm_smooth = {'s3ra','s2ra','s1ra','ra',};
         options.rs_feature_mask={'none','Voxel_selection_anova1_effect','Voxel_selection_anova1_noeffect'};
        
         options.ol_v_method = {'mask','global'};
         options.ol_v = {'2SDm','3SDm','IQRm'};
         options.ol_rs ={'2SDm','3SDm','IQRm'};

 end
 
 end
 







