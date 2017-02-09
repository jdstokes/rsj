function CreateReport_STris
%% Create Analysis Report - HPF

% Overview
% --------
%
%   CalcMeans.  Calculate mean betas and ResMS.nii.
%   ChooseModels. Decide which models to compare
%   PlotResults. Filter date by Choose models and plot results
%   GetModelID

%% Initialization
close all;
C = Study_greco2;
T = load(fullfile(C.dir.tables,'greco_tables.mat'));
C.subjects.subj2run= C.subjects.subj2inc;
rois ={
    
'ash_left_CA1.nii'
'ash_left_DG.nii'
% 'ash_left_ERC.nii'

'ash_right_CA1.nii'
'ash_right_DG.nii'
% 'ash_right_ERC.nii'


};

%  rois ={'ash_left_CA1.nii';'ash_left_CA23DG.nii';'ash_right_CA1.nii';'ash_right_CA23DG.nii'};
C = SetupROIs(rois,C);


removeOL =0;
        

filter.Names = {'spec_name','struct_reg','hpf','response_function','roi_mask_name','global_scaling'};
filter.Vals =  { 'STris_20',0,50,'hrf','none',0};
sorter = {'hpf'};


%% Filter Table
 newT = T;
 newT.rs = FilterTableScores(newT,filter);
 newT.rs = SortTableScores(newT,sorter);



AnalysisSD1D2(C,newT, 'rs',filter,removeOL) 
% AnalysisSD1D2(C,newT, 'uni',filter,removeOL) 
% AnalysisSD1D2_Acc(C,newT, 'rs',filter,removeOL) 
%  AnalysisTMN(C,newT,'rs',filter,removeOL) 
 AnalysisT0M0N0(C,newT,'rs',filter,removeOL) 
% AnalysisCT1CN1(C,newT,'rs',filter,removeOL)
% AnalysisPT1PN1(C,newT,'rs',filter,removeOL)
% AnalysisSacc(C,newT,'rs',filter,removeOL);
% AnalysisD1acc(C,newT,'rs',filter,removeOL);
% AnalysisD2acc(C,newT,'rs',filter,removeOL);
end

% Analyses
function AnalysisSD1D2(C,T,mode,filter,removeOL)

      rois = C.masks.maskAll(C.masks.mask2inc); 
        switch mode
            case 'uni'
                C = Configure4uni(C);
            case 'rs'
                C = Configure4rs(C);
            otherwise
                error('incorrect mode argument');
        end
        
        CI_comp{1}.input{1}.var = {'tt_code'};
        CI_comp{1}.input{1}.val = [0];
        CI_comp{2}.input{1}.var = {'tt_code'};
        CI_comp{2}.input{1}.val = [1];
        CI_comp{3}.input{1}.var = {'tt_code'};
        CI_comp{3}.input{1}.val = [2];
        
        legend = CI_comps2Str(CI_comp);
        
        spec_name = 'STris_20';
        subjects = C.subjects.subj2run;
        numRows = height(T.rs);
        
        labels = FixStrings(rois,{'.nii','ash_','_'},{'','',' '});

        
        data =[];
        for cS = 1:numRows
            scoreRow = T.rs(cS,:);
            modelRow = GetModelRow(scoreRow,T);
   
%             try
                newScores = GetImgScores(C,CI_comp,scoreRow.rs_ID,removeOL,0);
                data = newScores;
                figure
                StatBarPlot(data,'within',labels,mode,0,legend);
                title([scoreRow.rs_ID,' AnalysisSD1D2, HPF:', num2str(modelRow.hpf)]);
%            end
            
        end
        
        
end 
function AnalysisSacc(C,T,mode,filter,removeOL)

      rois = C.masks.maskAll(C.masks.mask2inc); 
        switch mode
            case 'uni'
                C = Configure4uni(C);
            case 'rs'
                C = Configure4rs(C);
            otherwise
                error('incorrect mode argument');
        end
        
        CI_comp{1}.input{1}.var = {'tt_code'};
        CI_comp{1}.input{1}.val = [0];
        CI_comp{1}.input{2}.var = {'acc'};
        CI_comp{1}.input{2}.val = [1];
        CI_comp{2}.input{1}.var = {'tt_code'};
        CI_comp{2}.input{1}.val = [0];
        CI_comp{2}.input{2}.var = {'acc'};
        CI_comp{2}.input{2}.val = [0];
        
        
        legend = CI_comps2Str(CI_comp);
        
        spec_name = 'STris_20';
        subjects = C.subjects.subj2run;
        numRows = height(T.rs);
        
        labels = FixStrings(rois,{'.nii','ash_','_'},{'','',' '});

        
        data =[];
        for cS = 1:numRows
            scoreRow = T.rs(cS,:);
            modelRow = GetModelRow(scoreRow,T);
   
%             try
                newScores = GetImgScores(C,CI_comp,scoreRow.rs_ID,removeOL,0);
                data = newScores;
                figure
                StatBarPlot(data,'within',labels,mode,0,legend);
                title([scoreRow.rs_ID,' Same correct vs incorrect']);
%            end
            
        end
        
        
end 
function AnalysisD1acc(C,T,mode,filter,removeOL)

      rois = C.masks.maskAll(C.masks.mask2inc); 
        switch mode
            case 'uni'
                C = Configure4uni(C);
            case 'rs'
                C = Configure4rs(C);
            otherwise
                error('incorrect mode argument');
        end
        
        CI_comp{1}.input{1}.var = {'tt_code'};
        CI_comp{1}.input{1}.val = [1];
        CI_comp{1}.input{2}.var = {'acc'};
        CI_comp{1}.input{2}.val = [1];
        CI_comp{2}.input{1}.var = {'tt_code'};
        CI_comp{2}.input{1}.val = [1];
        CI_comp{2}.input{2}.var = {'acc'};
        CI_comp{2}.input{2}.val = [0];
        
        
        legend = CI_comps2Str(CI_comp);
        
        spec_name = 'STris_20';
        subjects = C.subjects.subj2run;
        numRows = height(T.rs);
        
        labels = FixStrings(rois,{'.nii','ash_','_'},{'','',' '});

        
        data =[];
        for cS = 1:numRows
            scoreRow = T.rs(cS,:);
            modelRow = GetModelRow(scoreRow,T);
   
%             try
                newScores = GetImgScores(C,CI_comp,scoreRow.rs_ID,removeOL,0);
                data = newScores;
                figure
                StatBarPlot(data,'within',labels,mode,0,legend);
                title([scoreRow.rs_ID,' Diff1 correct vs incorrect']);
%            end
            
        end
        
        
end 
function AnalysisD2acc(C,T,mode,filter,removeOL)

      rois = C.masks.maskAll(C.masks.mask2inc); 
        switch mode
            case 'uni'
                C = Configure4uni(C);
            case 'rs'
                C = Configure4rs(C);
            otherwise
                error('incorrect mode argument');
        end
        
        CI_comp{1}.input{1}.var = {'tt_code'};
        CI_comp{1}.input{1}.val = [2];
        CI_comp{1}.input{2}.var = {'acc'};
        CI_comp{1}.input{2}.val = [1];
        CI_comp{2}.input{1}.var = {'tt_code'};
        CI_comp{2}.input{1}.val = [2];
        CI_comp{2}.input{2}.var = {'acc'};
        CI_comp{2}.input{2}.val = [0];
        
        
        legend = CI_comps2Str(CI_comp);
        
        spec_name = 'STris_20';
        subjects = C.subjects.subj2run;
        numRows = height(T.rs);
        
        labels = FixStrings(rois,{'.nii','ash_','_'},{'','',' '});

        
        data =[];
        for cS = 1:numRows
            scoreRow = T.rs(cS,:);
            modelRow = GetModelRow(scoreRow,T);
   
%             try
                newScores = GetImgScores(C,CI_comp,scoreRow.rs_ID,removeOL,0);
                data = newScores;
                figure
                StatBarPlot(data,'within',labels,mode,0,legend);
                title([scoreRow.rs_ID,' Diff2 correct vs incorrect']);
%            end
            
        end
        
        
end 
function AnalysisSD1D2_Acc(C,T,mode,filter,removeOL)

      rois = C.masks.maskAll(C.masks.mask2inc); 
        switch mode
            case 'uni'
                C = Configure4uni(C);
            case 'rs'
                C = Configure4rs(C);
            otherwise
                error('incorrect mode argument');
        end
        
        CI_comp{1}.input{1}.var = {'tt_code'};
        CI_comp{1}.input{1}.val = [0];
        CI_comp{1}.input{2}.var = {'acc'};
        CI_comp{1}.input{2}.val = [1];
        
        
        CI_comp{2}.input{1}.var = {'tt_code'};
        CI_comp{2}.input{1}.val = [1];
        CI_comp{2}.input{2}.var = {'acc'};
        CI_comp{2}.input{2}.val = [1];
        
        
        CI_comp{3}.input{1}.var = {'tt_code'};
        CI_comp{3}.input{1}.val = [2];
        CI_comp{3}.input{2}.var = {'acc'};
        CI_comp{3}.input{2}.val = [1];
        
        
        
        
        legend = CI_comps2Str(CI_comp);
        
        spec_name = 'STris_20';
        subjects = C.subjects.subj2run;
        numRows = height(T.rs);
        
        labels = FixStrings(rois,{'.nii','ash_','_'},{'','',' '});

        
        data =[];
        for cS = 1:numRows
            scoreRow = T.rs(cS,:);
            modelRow = GetModelRow(scoreRow,T);
   
%             try
                newScores = GetImgScores(C,CI_comp,scoreRow.rs_ID,removeOL,0);
                data = newScores;
                figure
                StatBarPlot(data,'within',labels,mode,0,legend);
                title([scoreRow.rs_ID,' AnalysisSD1D2, HPF:', num2str(modelRow.hpf)]);
%            end
            
        end
        
        
end 
function AnalysisTMN(C,T,mode,filter,removeOL)
rois = C.masks.maskAll(C.masks.mask2inc); 
switch mode
    case 'uni'
        C = Configure4uni(C);
    case 'rs'
        C = Configure4rs(C);
    otherwise
        error('incorrect mode argument');
end


CI_comp{1}.input{1}.var = {'cityTargC'};
CI_comp{1}.input{1}.val = {'T'};


CI_comp{2}.input{1}.var = {'cityTargC'};
CI_comp{2}.input{1}.val = {'M'};


CI_comp{3}.input{1}.var = {'cityTargC'};
CI_comp{3}.input{1}.val = {'N'};
legend = CI_comps2Str(CI_comp);

spec_name = 'STris_20';
subjects = C.subjects.subj2run;
numScores = height(T.rs);

labels = FixStrings(rois,{'.nii','ash_','_'},{'','',' '});


data =[];
for cS = 1:numScores 
    scoreRow = T.rs(cS,:);
    modelRow = GetModelRow(scoreRow,T);

    
   
        newScores = GetImgScores(C,CI_comp,scoreRow.rs_ID,removeOL,0);
        data = newScores;
        figure
        StatBarPlot(data,'within',labels,mode,0,legend);
        title([scoreRow.rs_ID,' Mean AnalysisTMN, HPF:', num2str(modelRow.hpf)]);
    
    
end
end
function AnalysisT0M0N0(C,T,mode,filter,removeOL)
rois = C.masks.maskAll(C.masks.mask2inc); 
switch mode
    case 'uni'
        C = Configure4uni(C);
    case 'rs'
        C = Configure4rs(C);
    otherwise
        error('incorrect mode argument');
end


CI_comp{1}.input{1}.var = {'cityTargC'};
CI_comp{1}.input{1}.val = {'T'};
CI_comp{1}.input{2}.var = {'tt_code'};
CI_comp{1}.input{2}.val = [0];


CI_comp{2}.input{1}.var = {'cityTargC'};
CI_comp{2}.input{1}.val = {'M'};
CI_comp{2}.input{2}.var = {'tt_code'};
CI_comp{2}.input{2}.val = [0];

CI_comp{3}.input{1}.var = {'cityTargC'};
CI_comp{3}.input{1}.val = {'N'};
CI_comp{3}.input{2}.var = {'tt_code'};
CI_comp{3}.input{2}.val = [0];


legend = CI_comps2Str(CI_comp);

spec_name = 'STris_20';
subjects = C.subjects.subj2run;
numScores = height(T.rs);

labels = FixStrings(rois,{'.nii','ash_','_'},{'','',' '});


data =[];
for cS = 1:numScores 
    scoreRow = T.rs(cS,:);
    modelRow = GetModelRow(scoreRow,T);

    
    try
        newScores = GetImgScores(C,CI_comp,scoreRow.rs_ID,removeOL,0);
        data = newScores;
        figure
        StatBarPlot(data,'within',labels,mode,0,legend);
        title([scoreRow.rs_ID,' Mean AnalysisT0M0N0, HPF:', num2str(modelRow.hpf)]);
    end
    
end
end
function AnalysisPT1PN1(C,T,mode,filter,removeOL)
rois = C.masks.maskAll(C.masks.mask2inc); 

switch mode
    case 'uni'
        C = Configure4uni(C);
    case 'rs'
        C = Configure4rs(C);
    otherwise
        error('incorrect mode argument');
end


CI_comp{1}.input{1}.var = {'tt_code'};
CI_comp{1}.input{1}.val = 1;
CI_comp{1}.input{2}.var = {'cityTargP'};
CI_comp{1}.input{2}.val = {'T'};


CI_comp{2}.input{1}.var = {'tt_code'};
CI_comp{2}.input{1}.val = 1;
CI_comp{2}.input{2}.var = {'cityTargP'};
CI_comp{2}.input{2}.val = {'N'};



legend = CI_comps2Str(CI_comp);

spec_name = 'STris_20';
subjects = C.subjects.subj2run;
numScores = height(T.rs);

labels = FixStrings(rois,{'.nii','ash_','_'},{'','',' '});


data =[];
for cS = 1:numScores 
    scoreRow = T.rs(cS,:);
    modelRow = GetModelRow(scoreRow,T);

    
    try
        newScores = GetImgScores(C,CI_comp,scoreRow.rs_ID,removeOL,0);
        data = newScores;
        figure
        StatBarPlot(data,'within',labels,mode,0,legend);
        title([scoreRow.rs_ID,' Mean AnalysisPT1PN1, HPF:', num2str(modelRow.hpf)]);
    end
    
end
end
function AnalysisCT1CN1(C,T,mode,filter,removeOL)
rois = C.masks.maskAll(C.masks.mask2inc); 
switch mode
    case 'uni'
        C = Configure4uni(C);
    case 'rs'
        C = Configure4rs(C);
    otherwise
        error('incorrect mode argument');
end


CI_comp{1}.input{1}.var = {'tt_code'};
CI_comp{1}.input{1}.val = 1;
CI_comp{1}.input{2}.var = {'cityTargC'};
CI_comp{1}.input{2}.val = {'T'};


CI_comp{2}.input{1}.var = {'tt_code'};
CI_comp{2}.input{1}.val = 1;
CI_comp{2}.input{2}.var = {'cityTargC'};
CI_comp{2}.input{2}.val = {'N'};



legend = CI_comps2Str(CI_comp);

spec_name = 'STris_20';
subjects = C.subjects.subj2run;
numScores = height(T.rs);

labels = FixStrings(rois,{'.nii','ash_','_'},{'','',' '});


data =[];
for cS = 1:numScores 
    scoreRow = T.rs(cS,:);
    modelRow = GetModelRow(scoreRow,T);

    
    try
        newScores = GetImgScores(C,CI_comp,scoreRow.rs_ID,removeOL,0);
        data = newScores;
        figure
        StatBarPlot(data,'within',labels,mode,0,legend);
        title([scoreRow.rs_ID,' Mean AnalysisCT1CN1, HPF:', num2str(modelRow.hpf)]);
    end
    
end
end






function modelRow = GetModelRow(score_row,T)
betaIDCell = cellstr(T.betas.beta_ID);
betaRow = T.betas(strcmp(score_row.beta_ID,betaIDCell),:);
modelIDCell = cellstr(T.model.model_ID);
modelRow = T.model(strcmp(betaRow.model_ID,modelIDCell),:);
end



function C = Configure4uni(C)
C.scores.mode = 'uni';
C.scores.score_type = 'uni_m';
C.scores.OL_type = 'global_IQR';

end
function C = Configure4rs(C)
C.scores.mode = 'rs_pair';
C.scores.score_type = 'rsz';
C.scores.OL_type = 'global_IQR';


end


%% ==================== FilterTableScores =================================
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

