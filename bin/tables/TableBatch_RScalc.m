function TableBatch_RScalc(varargin)
%TableBatch Creates SPM models based on Table input
%   TableBatch_TableBatch_TableBatch_RScalc()
%   e.g. TableBatch_TableBatch_TableBatch_RScalc('subject','S16_A')
%   e.g. TableBatch_TableBatch_TableBatch_RScalc('model_ID',50)
%   e.g. TableBatch_TableBatch_TableBatch_RScalc('subject','S16_A','model_ID',50)


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
    RScalc(C,T);
    
    % run subject specific + model specific version
elseif exist('subject') && exist('model_ID')
    RScalc_SM(C,T,subject,model_ID);
    
    % run subject specific
elseif exist('subject')
    RScalc_S(C,T,subject);
    
    % run model specific
elseif exist('model_ID')
    %Build subject list
    C.subjects.subj2run= C.subjects.subj2inc;
    RScalc_M(C,T,model_ID);
    
end

end
%




function RScalc(C,T)
    numRS = height(T.rs);
    subjList = C.subjects.subj2run;
   
    %% Loop all RS
      for curRS = 1 : numRS
        %Get rs row
        rs_row = T.rs(curRS,:);
        
        %Get betas row
        betaRowInd = strcmp(rs_row.beta_ID,cellstr(T.betas.beta_ID));
        beta_row = T.betas(betaRowInd,:);
        
        %Get model row
        modelRowInd = strcmp(beta_row.model_ID,cellstr(T.model.model_ID));
        model_row = T.model(modelRowInd,:);
     
        spec_name = model_row.spec_name;
        for curSubj = 1:length(subjList)
                    
            disp([rs_row.rs_ID,': ',subjList{curSubj}]);
            %Setup model parameters using table row
            CalcScores(subjList{curSubj},C,rs_row,model_row);   
        end        
      end
end

function RScalc_SM(C,T,sub,rid)
%Get rs row
rs_row = T.rs(rid,:);

%Get betas row
betaRowInd = strcmp(rs_row.beta_ID,cellstr(T.betas.beta_ID));
beta_row = T.betas(betaRowInd,:);

%Get model row
modelRowInd = strcmp(beta_row.model_ID,cellstr(T.model.model_ID));
model_row = T.model(modelRowInd,:);

spec_name = model_row.spec_name;

disp([rs_row.rs_ID,': ',sub]);
%Setup model parameters using table row
CalcScores(sub,C,rs_row,model_row);
end

function RScalc_S(C,T,sub)
    subjList = C.subjects.subj2run;
   
    %% Loop all RS
      for curRS = 1 : numRS
        %Get rs row
        rs_row = T.rs(curRS,:);
        
        %Get betas row
        betaRowInd = strcmp(rs_row.beta_ID,cellstr(T.betas.beta_ID));
        beta_row = T.betas(betaRowInd,:);
        
        %Get model row
        modelRowInd = strcmp(beta_row.model_ID,cellstr(T.model.model_ID));
        model_row = T.model(modelRowInd,:);
     
        spec_name = model_row.spec_name;
                    
            disp([rs_row.rs_ID,': ',sub]);
            %Setup model parameters using table row
            CalcScores(sub,C,rs_row,model_row);   
                
      end
end

function RScalc_M(C,T,rid)
    subjList = C.subjects.subj2run;

    %% Loop all RS
        %Get rs row
        rs_row = T.rs(rid,:);
        
        %Get betas row
        betaRowInd = strcmp(rs_row.beta_ID,cellstr(T.betas.beta_ID));
        beta_row = T.betas(betaRowInd,:);
        
        %Get model row
        modelRowInd = strcmp(beta_row.model_ID,cellstr(T.model.model_ID));
        model_row = T.model(modelRowInd,:);
     
        spec_name = model_row.spec_name;
        for curSubj = 1:length(subjList)
                    
            disp([rs_row.rs_ID,': ',subjList{curSubj}]);
            %Setup model parameters using table row
            CalcScores(subjList{curSubj},C,rs_row,model_row);   
        end        
end



