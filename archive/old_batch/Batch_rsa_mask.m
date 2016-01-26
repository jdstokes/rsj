function Batch_rsa_mask
%% load C
C = Study_greco;

conds = {'currCity','currCity'};
values = {3,1};
comp_name = 'C1vsC3';

for i = 1:length(values)
    cb = Category(conds(i),values{i});
    cond{i} = cb.input;
    clear cb
end

%% options
options.spm_smooth = {'s2ra'};
options.spm_mask = {'m8'};
options.spm_hpf ={50};
options.ol_v_method = {'mask'};
%   options.ol_v_method = {'none'};
%   options.ol_v = {'NO'};
  options.ol_v = {'2SDm'};
options.maskType = {'v1a'};
options.spm_modelName = {'standard_ST_mr'};

%%
    if exist('options','var')
    combs = allcombJ(options);
        for i = 1:size(combs,1)
            RunGroup(C,fieldnames(options),combs(i,:),cond,comp_name)
            
        end
        
    else
        RS_batch(C,cond,comp_name);
    end

end


%% Group analysis batch
function RunGroup(C,varNames,mode,cond,comp_name)

 for i = 1:length(varNames)
   ChangeVar(C,varNames{i},mode{i});
 end
 
 RS_batch(C,cond,comp_name);

end

 
%%  RS batch
function RS_batch(C,cond,comp_name)

subjects = GetValue(C,'subjAll');

for i = 1:length(subjects)

    RS_pipeline(subjects{i},C,cond,comp_name)

end

end

%% RSA pipeline 
function RS_pipeline(subj,C,cond,comp_name)

    Voxel_selection(subj,C,cond,comp_name);

end

%% Report errors
function errorfun(S, varargin)  
   warning(S.identifier, S.message);
end

    

    











