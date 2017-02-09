function TableCalcRS(subj,C)



%load C
C = Study_greco2;

%Load table
tableDir = C.dir.tables;
T = load(fullfile(tableDir,'greco_tables.mat'));
%Choose subjects (to be modified
C.subjects.subj2run= {'S16_A','S9_A'}; %Override subj2run
% C.subjects.subj2run= C.subjects.subj2inc; %Override subj2run

%Run models
BatchCalcRS(C,T);

end


function BatchCalcRS(C,T)


    numRS = height(T.rs);
    subjList = C.subjects.subj2run;
    
    %% Loop all RS
%     for curRS = 1:numRS
      for curRS = 46

        
        %Get rs row
        rs_row = T.rs(curRS,:);
        
        %Get betas row
        betaRowInd = strcmp(rs_row.beta_ID,cellstr(T.betas.beta_ID));
        beta_row = T.betas(betaRowInd,:);
        
        %Get model row
        modelRowInd = strcmp(beta_row.model_ID,cellstr(T.model.model_ID));
        model_row = T.model(modelRowInd,:);
        
        for curSubj = 1:length(subjList)
            
            disp([rs_row.rs_ID,': ',subjList{curSubj}]);
            %Setup model parameters using table row
            CalcScores(subjList{curSubj},C,rs_row,model_row);     
        end
    end
end




