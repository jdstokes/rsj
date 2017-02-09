function TableBuildModels


%load C
C = Study_greco2;

%Load table
tableDir = C.dir.tables;
T = load(fullfile(tableDir,'greco_tables.mat'));
%Choose subjects (to be modified
C.subjects.subj2run= {'S16_A','S9_A'}; %Override subj2run
%  C.subjects.subj2run= C.subjects.subj2inc; %Override subj2run

%Run models
CreateModels(C,T.model);

end


function CreateModels(C,T)
    numModels = height(T);
    subj2run = C.subjects.subj2run;
    for curModel = 1:numModels
        model_ID = T.model_ID(curModel,:)
        for curSubj = 1:length(subj2run)
            %Setup model parameters using table row
            C = ConfigureModelSpecs(C,T,curModel);
            BuildSPMmodelAllRuns(subj2run{curSubj},C,model_ID);     
        end
    end
end


function CreateModelsST(C,T)
    numModels = height(T);
    subj2run = C.subjects.subj2run;
    for curModel = 1:numModels
        
        spec_name = T.spec_name(curModel,:);
        if ~any(strfind(spec_name,'Basic'))
            model_ID = T.model_ID(curModel,:)
        for curSubj = 1:length(subj2run)
            %Setup model parameters using table row
            C = ConfigureModelSpecs(C,T,curModel);
            BuildSPMmodelAllRuns(subj2run{curSubj},C,model_ID);     
        end
        end
    end
end








