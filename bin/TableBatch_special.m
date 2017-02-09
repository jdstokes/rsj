function TableBatch_special


%load C
C = Study_greco2;

%Load table
tableDir = C.dir.tables;
T = load(fullfile(tableDir,'greco_tables.mat'));


 C.subjects.subj2run={'S23_B'};%%S23_B


%% Modules
   
   CreateModels(C,T);
   BatchMaskBetas(C,T);
   BatchCalcRS(C,T);
% BatchSearchLight(C,T);


%  CreateModelsRis(C,T);

end
%

function CreateModels(C,T)
    numModels = height(T.model);
    
    % Randomize
    subj2run = C.subjects.subj2run(randperm(length(C.subjects.subj2run)));
    for curModel = 78
        model_row = T.model(curModel,:);
        for curSubj = 1:length(subj2run)
            %Setup model parameters using table row
            C = ConfigureModelSpecs(C,model_row);
            disp([subj2run{curSubj}, ' ', model_row.model_ID])
            BuildSPMmodelAllRuns(subj2run{curSubj},C,model_row.model_ID);  
            
        end
    end
end

function CreateModelsRis(C,T)
    numModels = height(T.model);
    subj2run = C.subjects.subj2run;
    for curModel = numModels:-1:1
        model_row = T.model(curModel,:);
        if any(strfind(model_row.spec_name,'STris'))
            model_ID = model_row.model_ID;
        for curSubj = 1:length(subj2run)
            
            disp([subj2run{curSubj},': ', num2str(model_ID)]);
            C = ConfigureModelSpecs(C,model_row);   %Setup model parameters using table row
            BuildSPMmodelAllRuns(subj2run{curSubj},C,model_ID);     
        end
        end
    end
end

function BatchCalcRS(C,T)

    numRS = height(T.rs);
    subjList = C.subjects.subj2run;
    
    %% Loop all RS
      for curRS = 78
%       for curRS = [48]

        
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
           
           try 
         
            disp([rs_row.rs_ID,': ',subjList{curSubj}]);
            %Setup model parameters using table row
            
           
            CalcScores(subjList{curSubj},C,rs_row,model_row);   
        
           end
        end
        
    end
end

function BatchMaskBetas(C,T)
numB = height(T.betas);
subjList = C.subjects.subj2run;

%% Loop all B
 for curB = 78
%        for curB = [47]

    
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

function BatchSearchLight(C,T)

    subjList = C.subjects.subj2run;

    cur_model_ID = 'm00000050';
    
    modelI = strcmp(cur_model_ID,cellstr(T.model.model_ID));
    betaI = strcmp(cur_model_ID,cellstr(T.betas.model_ID));
    rsI = strcmp(T.betas.beta_ID(betaI,:),cellstr(T.rs.beta_ID));
    
    
    model_row = T.model(modelI,:);
    beta_row = T.betas(betaI,:);
    rs_row = T.rs(rsI,:);
    
    for curSubj = 1:length(subjList)
        disp([subjList{curSubj},': ',beta_row.beta_ID])
        C = ConfigureModelSpecs(C,model_row);                
        SL_main_greco(subjList{curSubj},C,beta_row,model_row);
    end

end






