function Batch_rsa_norm
%% load C
C = Study_greco;


%% options
options.spm_smooth = {'s2ra'};
options.spm_mask = {'m8','m3'};
options.spm_hpf ={50};
options.ol_v_method = {'mask'};
options.rs_feature_mask = {'C1vsC3'};
%   options.ol_v_method = {'none'};
%   options.ol_v = {'NO'};
  options.ol_v = {'2SDm'};
options.maskType = {'v1a'};
options.spm_modelName = {'standard_ST_mr'};

%%
    if exist('options','var')
    combs = allcombJ(options);
        for i = 1:size(combs,1)
            RunGroup(C,fieldnames(options),combs(i,:))
            
        end
        
    else
        RS_batch(C,cond);
    end

end


%% Group analysis batch
function RunGroup(C,varNames,mode)

 for i = 1:length(varNames)
   ChangeVar(C,varNames{i},mode{i});
 end
 
 RS_batch(C);

end

 
%%  RS batch
function RS_batch(C)

subjects = GetValue(C,'subjAll');

for i = 1:length(subjects)
%     disp(subjects{i});
      
    RS_pipeline(subjects{i},C)
    
%           disp('skip');
   
end

end

%% RSA pipeline 
function RS_pipeline(subj,C)

    Norm_run(subj,C);

end

%% Report errors
function errorfun(S, varargin)  
   warning(S.identifier, S.message);
end

    

    











