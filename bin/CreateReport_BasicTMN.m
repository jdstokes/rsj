function CreateReport_BasicTMN
%% Create Analysis Report...

%% Initialization
close all;
C = Study_greco2;
T = load(fullfile(C.dir.tables,'greco_tables.mat'));
C.subjects.subj2run= C.subjects.subj2inc;
rois ={'ash_left_CA1.nii';'ash_left_DG.nii';'ash_right_CA1.nii';'ash_right_DG.nii'};
C = SetupROIs(rois,C);
removeOL =1;
C.scores.OL_type = 'global_IQR';    
filter.Names = {'spec_name','struct_reg','response_function'};
filter.Vals =  { 'Basic_TMN_20',0,'hrf'};
sorter = {'hpf'};

%% Filter Table
 newT = T;
 newT.rs = FilterTableScores(newT,filter);
 newT.rs = SortTableScores(newT,sorter);
 
 
%% Analysis List. 


 AnalysisRS(C,newT,filter,removeOL) 
 AnalysisUni(C,newT,filter,removeOL) 
end

%% Analysis RS. 
function AnalysisRS(C,T,filter,removeOL)
rois = C.masks.maskAll(C.masks.mask2inc); 

C.scores.score_type = 'rsz';


cond_input = {
    
'T-T'
'M-M'
'N-N'
'T-M'
'N-M'
'T-N'

};



subjects = C.subjects.subj2run;
numScores = height(T.rs);

labels = FixStrings(rois,{'.nii','ash_','_'},{'','',' '});


data =[];
for cS = 1:numScores 
    scoreRow = T.rs(cS,:);
    modelRow = GetModelRow(scoreRow,T);

    
    
        newScores = GetImgScoresBasic(C,cond_input,scoreRow.rs_ID,removeOL);
        data = newScores;
        figure
        StatBarPlot(data,'within',labels,'rs',0,cond_input);
        title([scoreRow.rs_ID,' hpf',num2str(modelRow.hpf)]);
    
    
end
end






%% Analysis Uni. 
function AnalysisUni(C,T,filter,removeOL)
rois = C.masks.maskAll(C.masks.mask2inc); 
C.scores.score_type = 'uni_m';
cond_input = {
    
'T'
'M'
'N'

};


subjects = C.subjects.subj2run;
numScores = height(T.rs);

labels = FixStrings(rois,{'.nii','ash_','_'},{'','',' '});


data =[];
for cS = 1:numScores 
    scoreRow = T.rs(cS,:);
    modelRow = GetModelRow(scoreRow,T);

    
    
        newScores = GetImgScoresBasic(C,cond_input,scoreRow.rs_ID,removeOL);
        data = newScores;
        figure
        StatBarPlot(data,'within',labels,'mean beta',0,cond_input);
        title([scoreRow.rs_ID,' hpf',num2str(modelRow.hpf)]);
    
    
end

end%Function close


function C = SetupROIs(rois,C)
C.masks.mask2inc = zeros(1,length(C.masks.maskAll));
for j = 1: length(rois)
    C.masks.mask2inc(strcmp(rois{j},C.masks.maskAll)) = 1;
end
C.masks.mask2inc = logical(C.masks.mask2inc);
end


function modelRow = GetModelRow(score_row,T)
betaIDCell = cellstr(T.betas.beta_ID);
betaRow = T.betas(strcmp(score_row.beta_ID,betaIDCell),:);
modelIDCell = cellstr(T.model.model_ID);
modelRow = T.model(strcmp(betaRow.model_ID,modelIDCell),:);
end


function newTable = FilterTableScores(T,F)

% Check inputs
if (length(F.Names) ~= length(F.Vals)) || ...
        (~iscell(F.Names) && ~iscell(F.Vals))
    error('colNames and colVals must be equal length cell arrays');
end



numScores = height(T.rs);
rmIndex = [];
for cS = 1:numScores
    scoreRow = T.rs(cS,:);
    modelRow = GetModelRow(scoreRow,T);
    
    %% Build filter rm index
    for curN = 1:length(F.Names)
        switch class(F.Vals{curN})
            case 'char'
                if ~any(strfind(modelRow.(F.Names{curN}),F.Vals{curN}))
                   rmIndex = [rmIndex; cS];
                end
            case 'double'
                if modelRow.(F.Names{curN}) ~= F.Vals{curN}
                   rmIndex = [rmIndex; cS];
                end    
        end 
    end  
    


end

newTable = T.rs;
newTable(rmIndex,:) = [];

end



%% ==================== SortTableScores ===================================

function newTable = SortTableScores(T,S)

numScores = height(T.rs);
newTable = T.rs;

for curS = 1:length(S)
for cS = 1:numScores
    scoreRow = newTable(cS,:);
    modelRow = GetModelRow(scoreRow,T);
    sorterValues(cS,1) = modelRow.(S{curS});
end

    [Y,I]= sort(sorterValues);
    
    newTable = newTable(I,:);
    clear sorterValues
end
end

