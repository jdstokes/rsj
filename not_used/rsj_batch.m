function rsj_batch(varargin)
%|||||||||||||||||||||||||||||||||||||||||||
%%%%%Batch script for the following modules:
%%% 'rsj_spm_smooth' 
%%% 'rsj_spm_model' 
%%% 'SPM_supermask' 
%%% 'Maskbetas'
%%% 'Calcrs'
%%% 'rsj_spm_segment_mprage'
%%% 'rsj_spm_specs' 
%%% 'rsj_spm_model_byRun'
%%% 'rsj_spm_model_byRunNoMR' 'rsj_spm_model_byRunNoMR_FIR',...
%%% 'rsj_spm_model_super_mask' 'rsj_spm_model_noMR_super_mask',...
%%% 'rsj_spm_model_super_mask_ash', 'rsj_spm_model_allRuns'
%%% 'rsj_spm_fixmasks2'
%%% 'ASHS2nii'

% parpool(4);
%%Check rsj_batch input
options = CheckInput(nargin,varargin);

spm_modelName ='standard_ST_mr_super_mask_ash';%

modules = {'rsj_spm_model_super_mask_ash'};

subjects= {
    'S16_A'


                };
            

%% load C
C = Study_greco;
C.subjects.subjAll = subjects;
C.spm.spm_modelName = spm_modelName;


    if ~isempty(options)
    combs = allcombJ(options);
        for i = 1:size(combs,1) 
            RunGroup(C,fieldnames(options),combs(i,:),modules)
        end
        
    else
        RS_batch(C,modules)
    end

end


%% Group analysis batch
function RunGroup(C,varNames,mode,modules)
disp(mode);
 for i = 1:length(varNames)
   
   ChangeVar(C,varNames{i},mode{i});
 end
 
 RS_batch(C,modules);

end

 
%%  RS batch
function RS_batch(C,modules)
   
    subjects = GetValue(C,'subjAll');
   
     for i = 1:length(subjects)
%    parfor i = 1:length(subjects)

        disp(subjects{i});
        RS_pipeline(subjects{i},C,modules)
    end
end

%% RSA pipeline 
function RS_pipeline(subj,C,modules)

for i = 1:length(modules)
    disp(modules{i});
    mod_func = str2func(modules{i});
%     try
    mod_func(subj,C)
%     catch me
%         disp(me);
%     end
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
         options.spm_smooth = {'s2ra'};
         options.spm_mask = {'m0'};
         options.spm_hpf ={128,80};
        
     case 'smooth'
         options.spm_smooth = {'s3ra','s2ra','s1ra'};
     case 'rsa'
         options.spm_smooth = {'s3ra','s2ra','s1ra','ra'};
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
    
         options.spm_mask = {'m8','m3','m1','m0'};
         options.spm_smooth = {'s3ra','s2ra','s1ra','ra',};
         options.rs_feature_mask={'none','Voxel_selection_anova1_effect','Voxel_selection_anova1_noeffect'};


 end
 
 end
 
 
 
% function SetSPMthreshold(C)
%     spm_mask = GetValue(C,'spm_mask');
% 
%     switch spm_mask
%         case 'm8'
%             mask.thresh = 0.8;
%         case 'm3'
%             mask.thresh = 0.3;
%         case 'm1' 
%             mask.thresh = .1;
%         case 'm0' 
%             mask.thresh = -Inf;
%     end
% save('/Users/jdstokes/Documents/MATLAB/my_spm.mat','mask');
% spm_my_defaults;
% 
% end
 
 
%%CheckInput
 function options = CheckInput(N,V)
 if N == 0
     options = [];
 elseif N == 1 && iscellstr(V)
     if any(strcmp(V{1},{'model','smooth','rsa','special','other'}))
         options = getOptions(V{1});
     else
         error('bad input');
     end
 else
     error('bad input')
 end
 end
 






