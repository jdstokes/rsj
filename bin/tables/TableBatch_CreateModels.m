function TableBatch_CreateModels(varargin)
%TableBatch Creates SPM models based on Table input
%   TableBatch_CreateModels()
%   e.g. TableBatch_CreateModels('subject','S16_A')
%   e.g. TableBatch_CreateModels('model_ID',50)
%   e.g. TableBatch_CreateModels('subject','S16_A','model_ID',50)


%Check varargin
if nargin
for i = 1:2:nargin
    switch varargin{i}
        case 'subject'
            subject = varargin{i+1};
        case 'model_ID'
            model_ID = varargin{i+1};
        otherwise
            error();
    end
end
end

%Load Study properties
C = Study_greco2;

%Load tables
tableDir = C.dir.tables;
T = load(fullfile(tableDir,'greco_tables.mat'));

% Run through all models and all subjects
if nargin ==0
    %Load table
    
    %Build subject list
    C.subjects.subj2run= C.subjects.subj2inc;
    CreateModels(C,T);
    
    % run subject specific + model specific version
elseif exist('subject') && exist('model_ID')
    CreateModels_SM(C,T,subject,model_ID);
    
    % run subject specific
elseif exist('subject')
    CreateModels_S(C,T,subject);
    
    % run model specific
elseif exist('model_ID')
    %Build subject list
    C.subjects.subj2run= C.subjects.subj2inc;
    CreateModels_M(C,T,model_ID);
    
end
end

function CreateModels(C,T)
    numModels = height(T.model);
    subj2run = C.subjects.subj2run;
    for curModel = 1:numModels
        model_row = T.model(curModel,:);
        for curSubj = 1:length(subj2run)
            C = ConfigureModelSpecs(C,model_row);
            disp([subj2run{curSubj}, ' ', model_row.model_ID])
            BuildSPMmodelAllRuns(subj2run{curSubj},C,model_row.model_ID);
        end
    end
end


function CreateModels_SM(C,T,sub,mid)
model_row = T.model(mid,:);
C = ConfigureModelSpecs(C,model_row);
disp([sub, ' ', model_row.model_ID]);
BuildSPMmodelAllRuns(subject,C,model_row.model_ID);
end


function CreateModels_S(C,T,sub)
numModels = height(T.model);
for curModel = 1:numModels
    model_row = T.model(curModel,:);
    
    C = ConfigureModelSpecs(C,model_row);
    disp([sub, ' ', model_row.model_ID])
    BuildSPMmodelAllRuns(sub,C,model_row.model_ID);
    
end
end

function CreateModels_M(C,T,mid)
subj2run = C.subjects.subj2run;
model_row = T.model(mid,:);
for curSubj = 1:length(subj2run)
    C = ConfigureModelSpecs(C,model_row);
    disp([subj2run{curSubj}, ' ', model_row.model_ID])
    BuildSPMmodelAllRuns(subj2run{curSubj},C,model_row.model_ID);
end

end


