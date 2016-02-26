function rsj_batch(varargin)
% Batch script for the following modules:
% 'rsj_spm_smooth'
% 'rsj_spm_model'
% 'SPM_supermask'

if nargin == 0
elseif nargin == 1 && iscellstr(varargin)
    if any(strcmp(varargin{1},{'model','smooth'}))
        options = getOptions(varargin{1});
    else
        error('bad input');
    end
else
    error('bad input')
end
    
modules = {'rsj_spm_pp'};



%% load C
C = Study_greco;

    if exist('options','var')
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

 for i = 1:length(varNames)
   ChangeVar(C,varNames{i},mode{i});
 end
 
 RS_batch(C,modules);

end

 
%%  RS batch
function RS_batch(C,modules)

subjects = GetValue(C,'subjAll');
for i = 1:length(subjects)
    disp(subjects{i});
    RS_pipeline(subjects{i},C,modules)
end

end

%% RSA pipeline 
function RS_pipeline(subj,C,modules)


for i = 1:length(modules)
    disp(modules{i});
    mod_func = str2func(modules{i});
    mod_func(subj,C)
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
         options.spm_smooth = {'s2ra','s1ra','ra','s3ra'};%%'s2ra','s1ra','ra','s3ra'
         options.spm_mask = {'m8','m3','m1','m0'};
         options.spm_hpf ={50,128};%%50,128
         options.spm_modelName = {'standard_ST_mr'};
     case 'smooth'
         options.spm_smooth = {'s2ra'};
     case 'rsa'
         options.spm_smooth = {'ra'};
         options.spm_mask = {'m8','m3','m1','m0'};
         options.spm_hpf ={50,128};
         options.spm_modelName = {'standard_ST_mr'};
         options.maskType = {'v3.0'};
  
 end
 
 end
 






