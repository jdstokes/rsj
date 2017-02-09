function TableBatch_MaskBetas(varargin)
%TableBatch Creates SPM models based on Table input
%   TableBatch_MaskBetas()
%   e.g. TableBatch_MaskBetas('subject','S16_A')
%   e.g. TableBatch_MaskBetas('model_ID',50)
%   e.g. TableBatch_MaskBetas('subject','S16_A','model_ID',50)


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
    GetBetas(C,T);
    
    % run subject specific + model specific version
elseif exist('subject') && exist('model_ID')
    GetBetas_SM(C,T,subject,model_ID);
    
    % run subject specific
elseif exist('subject')
    GetBetas_S(C,T,subject);
    
    % run model specific
elseif exist('model_ID')
    %Build subject list
    C.subjects.subj2run= C.subjects.subj2inc;
    GetBetas_M(C,T,model_ID);
    
end

end
%




function GetBetas(C,T)
numB = height(T.betas);
subjList = C.subjects.subj2run;

% Loop all B
for curB = 1:numB
    
    %Get betas row
    beta_row = T.betas(curB,:);
    
    %Get model row
    modelRowInd = strcmp(beta_row.model_ID,cellstr(T.model.model_ID));
    model_row = T.model(modelRowInd,:);
    
    for curSubj = 1:length(subjList)
        disp([subjList{curSubj},': ',beta_row.beta_ID])
        C = ConfigureModelSpecs(C,model_row);
        MaskBetas(subjList{curSubj},C,beta_row,model_row);
    end
end
end

function GetBetas_SM(C,T,sub,mid)
beta_row = T.betas(curB,:);
modelRowInd = strcmp(beta_row.model_ID,cellstr(T.model.model_ID));
model_row = T.model(modelRowInd,:);

disp([sub,': ',beta_row.beta_ID])
C = ConfigureModelSpecs(C,model_row);
MaskBetas(sub,C,beta_row,model_row);
end

function GetBetas_S(C,T,sub)
numB = height(T.betas);
subjList = C.subjects.subj2run;
% Loop all B
for curB = 1:numB
    %Get betas row
    beta_row = T.betas(curB,:)
    %Get model row
    modelRowInd = strcmp(beta_row.model_ID,cellstr(T.model.model_ID));
    model_row = T.model(modelRowInd,:);
    disp([sub,': ',beta_row.beta_ID])
    C = ConfigureModelSpecs(C,model_row);
    MaskBetas(sub,C,beta_row,model_row);
    
end
end

function GetBetas_M(C,T,mid)
subjList = C.subjects.subj2run;
%Get betas row
beta_row = T.betas(mid,:);
%Get model row
modelRowInd = strcmp(beta_row.model_ID,cellstr(T.model.model_ID));
model_row = T.model(modelRowInd,:);
for curSubj = 1:length(subjList)
    disp([subjList{curSubj},': ',beta_row.beta_ID])
    C = ConfigureModelSpecs(C,model_row);
    MaskBetas(subjList{curSubj},C,beta_row,model_row);
end
end



