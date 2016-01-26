function Batch_spm_supermask

%% load C
C = Study_cw;
modules = {'SPM_supermask'};

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
    RS_pipeline(subjects{i},C,modules);
end

% NC = length(subjects);
% cellfun(@RS_pipeline,subjects,repmat({C},1,NC),repmat({modules},1,NC),...
%     'ErrorHandler', @errorfun)
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

    











