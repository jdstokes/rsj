function Batch_rsa
%% load C
C = Study_greco;

modules = {'Maskbetas','Calcrs'};%Maskbetas Calcrs
%% options

% options.rs_feature_mask = {'C1vsC3'};
options.spm_smooth = {'s2ra'};
options.spm_mask = {'m3'};
options.spm_hpf ={50};
options.ol_v_method = {'mask'};

options.ol_v = {'2SDm'};
options.maskType = {'v3.0'};
options.spm_modelName = {'standard_ST_mr'};
%%
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
%     disp(subjects{i});
%       try
    RS_pipeline(subjects{i},C,modules)
%       catch 
%          disp('skip');
%     end
end

end

%% RSA pipeline 
function RS_pipeline(subj,C,modules)
for i = 1:length(modules)
%     disp(modules{i});
    mod_func = str2func(modules{i});
    mod_func(subj,C)
end
end

%% Report errors
function errorfun(S, varargin)  
   warning(S.identifier, S.message);
end

    

    











