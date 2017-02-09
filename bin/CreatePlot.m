function CreatePlot
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
%      'ash_left_35.nii'
%     'ash_left_36.nii'
%     'ash_left_ERC.nii'

    'ash_left_CA1.nii'
    'ash_left_DG.nii'
%     'ash_left_subiculum.nii'
%     'ash_right_35.nii'
%     'ash_right_36.nii'
%     'ash_righ_ERC.nii'

    'ash_right_CA1.nii'
    'ash_right_DG.nii'
%     'ash_right_subiculum.nii'
    };
  
C = SetupROIs(rois,C);



removeOL =1;
        

filter.Names = {'spec_name','struct_reg','hpf','response_function'};
filter.Vals =  { 'STris_20',0,50,'hrf'};
sorter = {'hpf'};


%% Filter Table
 newT = T;
 newT.rs = FilterTableScores(newT,filter);
 newT.rs = SortTableScores(newT,sorter);



AnalysisT0minusN0_ByRun(C,newT, 'rs',filter,removeOL);
AnalysisTminusN_ByRun(C,newT, 'rs',filter,removeOL);
AnalysisSminusD2_ByRun(C,newT, 'rs',filter,removeOL);
AnalysisD1minusD2_ByRun(C,newT, 'rs',filter,removeOL);

end


function AnalysisT0minusN0_ByRun(C,T,mode,filter,removeOL)

      rois = C.masks.maskAll(C.masks.mask2inc); 
        switch mode
            case 'uni'
                C = Configure4uni(C);
            case 'rs'
                C = Configure4rs(C);
            otherwise
                error('incorrect mode argument');
        end
        
        
 
   
cnt =1;

CI_comp{cnt}.input{1}.var = {'cityTargC'};
CI_comp{cnt}.input{1}.val = {'N'};
CI_comp{cnt}.input{2}.var = {'run_num'};
CI_comp{cnt}.input{2}.val = 0;
CI_comp{cnt}.input{3}.var = {'tt_code'};
CI_comp{cnt}.input{3}.val = [0];

cnt = cnt+1;
CI_comp{cnt}.input{1}.var = {'cityTargC'};
CI_comp{cnt}.input{1}.val = {'T'};
CI_comp{cnt}.input{2}.var = {'run_num'};
CI_comp{cnt}.input{2}.val = 0;
CI_comp{cnt}.input{3}.var = {'tt_code'};
CI_comp{cnt}.input{3}.val = [0];


cnt = cnt+1;
CI_comp{cnt}.input{1}.var = {'cityTargC'};
CI_comp{cnt}.input{1}.val = {'N'};
CI_comp{cnt}.input{2}.var = {'run_num'};
CI_comp{cnt}.input{2}.val = 1;
CI_comp{cnt}.input{3}.var = {'tt_code'};
CI_comp{cnt}.input{3}.val = [0];

cnt = cnt+1;
CI_comp{cnt}.input{1}.var = {'cityTargC'};
CI_comp{cnt}.input{1}.val = {'T'};
CI_comp{cnt}.input{2}.var = {'run_num'};
CI_comp{cnt}.input{2}.val = 1;
CI_comp{cnt}.input{3}.var = {'tt_code'};
CI_comp{cnt}.input{3}.val = [0];




cnt = cnt+1;
CI_comp{cnt}.input{1}.var = {'cityTargC'};
CI_comp{cnt}.input{1}.val = {'N'};
CI_comp{cnt}.input{2}.var = {'run_num'};
CI_comp{cnt}.input{2}.val = 2;
CI_comp{cnt}.input{3}.var = {'tt_code'};
CI_comp{cnt}.input{3}.val = [0];

cnt = cnt+1;
CI_comp{cnt}.input{1}.var = {'cityTargC'};
CI_comp{cnt}.input{1}.val = {'T'};   
CI_comp{cnt}.input{2}.var = {'run_num'};
CI_comp{cnt}.input{2}.val = 2;
CI_comp{cnt}.input{3}.var = {'tt_code'};
CI_comp{cnt}.input{3}.val = [0];


cnt = cnt+1;
CI_comp{cnt}.input{1}.var = {'cityTargC'};
CI_comp{cnt}.input{1}.val = {'N'};
CI_comp{cnt}.input{2}.var = {'run_num'};
CI_comp{cnt}.input{2}.val = 3;
CI_comp{cnt}.input{3}.var = {'tt_code'};
CI_comp{cnt}.input{3}.val = [0];

cnt = cnt+1;
CI_comp{cnt}.input{1}.var = {'cityTargC'};
CI_comp{cnt}.input{1}.val = {'T'};
CI_comp{cnt}.input{2}.var = {'run_num'};
CI_comp{cnt}.input{2}.val = 3;
CI_comp{cnt}.input{3}.var = {'tt_code'};
CI_comp{cnt}.input{3}.val = [0];


       
        compNames = Input2Str(CI_comp);
        
        spec_name = 'STris_20';
        subjects = C.subjects.subj2run;
        numRows = height(T.rs);
        
        labels = FixStrings(rois,{'.nii','ash_','_'},{'','',' '});

        
        data =[];
        for cS = 1:numRows
            scoreRow = T.rs(cS,:);
            modelRow = GetModelRow(scoreRow,T);
   
%             try
                newScores = GetImgScores(C,CI_comp,scoreRow.rs_ID,removeOL,1);
                data = newScores;
                figure
             [Dm,Dse]=   StatBarPlot(data,'within',labels,mode,0,[]); %%Mask X Cond
                title([scoreRow.rs_ID,' test, HPF:', num2str(modelRow.hpf)]);
%            end
            hold off
        end
        
        
end 

function AnalysisTminusN_ByRun(C,T,mode,filter,removeOL)

      rois = C.masks.maskAll(C.masks.mask2inc); 
        switch mode
            case 'uni'
                C = Configure4uni(C);
            case 'rs'
                C = Configure4rs(C);
            otherwise
                error('incorrect mode argument');
        end
        
   
cnt =1;
CI_comp{cnt}.input{1}.var = {'cityTargC'};
CI_comp{cnt}.input{1}.val = {'N'};
CI_comp{cnt}.input{2}.var = {'run_num'};
CI_comp{cnt}.input{2}.val = 0;


cnt = cnt+1;
CI_comp{cnt}.input{1}.var = {'cityTargC'};
CI_comp{cnt}.input{1}.val = {'T'};
CI_comp{cnt}.input{2}.var = {'run_num'};
CI_comp{cnt}.input{2}.val = 0;


cnt = cnt+1;
CI_comp{cnt}.input{1}.var = {'cityTargC'};
CI_comp{cnt}.input{1}.val = {'N'};
CI_comp{cnt}.input{2}.var = {'run_num'};
CI_comp{cnt}.input{2}.val = 1;


cnt = cnt+1;
CI_comp{cnt}.input{1}.var = {'cityTargC'};
CI_comp{cnt}.input{1}.val = {'T'};
CI_comp{cnt}.input{2}.var = {'run_num'};
CI_comp{cnt}.input{2}.val = 1;


cnt = cnt+1;
CI_comp{cnt}.input{1}.var = {'cityTargC'};
CI_comp{cnt}.input{1}.val = {'N'};
CI_comp{cnt}.input{2}.var = {'run_num'};
CI_comp{cnt}.input{2}.val = 2;


cnt = cnt+1;
CI_comp{cnt}.input{1}.var = {'cityTargC'};
CI_comp{cnt}.input{1}.val = {'T'};   
CI_comp{cnt}.input{2}.var = {'run_num'};
CI_comp{cnt}.input{2}.val = 2;


cnt = cnt+1;
CI_comp{cnt}.input{1}.var = {'cityTargC'};
CI_comp{cnt}.input{1}.val = {'N'};
CI_comp{cnt}.input{2}.var = {'run_num'};
CI_comp{cnt}.input{2}.val = 3;


cnt = cnt+1;
CI_comp{cnt}.input{1}.var = {'cityTargC'};
CI_comp{cnt}.input{1}.val = {'T'};
CI_comp{cnt}.input{2}.var = {'run_num'};
CI_comp{cnt}.input{2}.val = 3;

       
compNames = Input2Str(CI_comp);

spec_name = 'STris_20';
subjects = C.subjects.subj2run;
numRows = height(T.rs);

labels = FixStrings(rois,{'.nii','ash_','_'},{'','',' '});


        data =[];
        for cS = 1:numRows
            scoreRow = T.rs(cS,:);
            modelRow = GetModelRow(scoreRow,T);
   
%             try
                newScores = GetImgScores(C,CI_comp,scoreRow.rs_ID,removeOL,1);
                data = newScores;
                figure
             [Dm,Dse]=   StatBarPlot(data,'within',labels,mode,0,[]); %%Mask X Cond
                title([scoreRow.rs_ID,' test, HPF:', num2str(modelRow.hpf)]);
%            end
            hold off
        end
        
        
end 

function AnalysisSminusD2_ByRun(C,T,mode,filter,removeOL)

      rois = C.masks.maskAll(C.masks.mask2inc); 
        switch mode
            case 'uni'
                C = Configure4uni(C);
            case 'rs'
                C = Configure4rs(C);
            otherwise
                error('incorrect mode argument');
        end
        
   
cnt =1;
CI_comp{cnt}.input{1}.var = {'tt_code'};
CI_comp{cnt}.input{1}.val = [0];
CI_comp{cnt}.input{2}.var = {'run_num'};
CI_comp{cnt}.input{2}.val = 0;


cnt = cnt+1;
CI_comp{cnt}.input{1}.var = {'tt_code'};
CI_comp{cnt}.input{1}.val = [2];
CI_comp{cnt}.input{2}.var = {'run_num'};
CI_comp{cnt}.input{2}.val = 0;


cnt = cnt+1;
CI_comp{cnt}.input{1}.var = {'tt_code'};
CI_comp{cnt}.input{1}.val = [0];
CI_comp{cnt}.input{2}.var = {'run_num'};
CI_comp{cnt}.input{2}.val = 1;


cnt = cnt+1;
CI_comp{cnt}.input{1}.var = {'tt_code'};
CI_comp{cnt}.input{1}.val = [2];
CI_comp{cnt}.input{2}.var = {'run_num'};
CI_comp{cnt}.input{2}.val = 1;


cnt = cnt+1;
CI_comp{cnt}.input{1}.var = {'tt_code'};
CI_comp{cnt}.input{1}.val =[0];
CI_comp{cnt}.input{2}.var = {'run_num'};
CI_comp{cnt}.input{2}.val = 2;


cnt = cnt+1;
CI_comp{cnt}.input{1}.var = {'tt_code'};
CI_comp{cnt}.input{1}.val = [2];   
CI_comp{cnt}.input{2}.var = {'run_num'};
CI_comp{cnt}.input{2}.val = 2;


cnt = cnt+1;
CI_comp{cnt}.input{1}.var = {'tt_code'};
CI_comp{cnt}.input{1}.val = [0];
CI_comp{cnt}.input{2}.var = {'run_num'};
CI_comp{cnt}.input{2}.val = 3;


cnt = cnt+1;
CI_comp{cnt}.input{1}.var = {'tt_code'};
CI_comp{cnt}.input{1}.val = [2];
CI_comp{cnt}.input{2}.var = {'run_num'};
CI_comp{cnt}.input{2}.val = 3;

       
compNames = Input2Str(CI_comp);

spec_name = 'STris_20';
subjects = C.subjects.subj2run;
numRows = height(T.rs);

labels = FixStrings(rois,{'.nii','ash_','_'},{'','',' '});


        data =[];
        for cS = 1:numRows
            scoreRow = T.rs(cS,:);
            modelRow = GetModelRow(scoreRow,T);
   
%             try
                newScores = GetImgScores(C,CI_comp,scoreRow.rs_ID,removeOL,1);
                data = newScores;
                figure
             [Dm,Dse]=   StatBarPlot(data,'within',labels,mode,0,[]); %%Mask X Cond
                title([scoreRow.rs_ID,' test, HPF:', num2str(modelRow.hpf)]);
%            end
            hold off
        end
        
        
end 

function AnalysisD1minusD2_ByRun(C,T,mode,filter,removeOL)

      rois = C.masks.maskAll(C.masks.mask2inc); 
        switch mode
            case 'uni'
                C = Configure4uni(C);
            case 'rs'
                C = Configure4rs(C);
            otherwise
                error('incorrect mode argument');
        end
        
   
cnt =1;
CI_comp{cnt}.input{1}.var = {'tt_code'};
CI_comp{cnt}.input{1}.val = [1];
CI_comp{cnt}.input{2}.var = {'run_num'};
CI_comp{cnt}.input{2}.val = 0;


cnt = cnt+1;
CI_comp{cnt}.input{1}.var = {'tt_code'};
CI_comp{cnt}.input{1}.val = [2];
CI_comp{cnt}.input{2}.var = {'run_num'};
CI_comp{cnt}.input{2}.val = 0;


cnt = cnt+1;
CI_comp{cnt}.input{1}.var = {'tt_code'};
CI_comp{cnt}.input{1}.val = [1];
CI_comp{cnt}.input{2}.var = {'run_num'};
CI_comp{cnt}.input{2}.val = 1;


cnt = cnt+1;
CI_comp{cnt}.input{1}.var = {'tt_code'};
CI_comp{cnt}.input{1}.val = [2];
CI_comp{cnt}.input{2}.var = {'run_num'};
CI_comp{cnt}.input{2}.val = 1;


cnt = cnt+1;
CI_comp{cnt}.input{1}.var = {'tt_code'};
CI_comp{cnt}.input{1}.val =[1];
CI_comp{cnt}.input{2}.var = {'run_num'};
CI_comp{cnt}.input{2}.val = 2;


cnt = cnt+1;
CI_comp{cnt}.input{1}.var = {'tt_code'};
CI_comp{cnt}.input{1}.val = [2];   
CI_comp{cnt}.input{2}.var = {'run_num'};
CI_comp{cnt}.input{2}.val = 2;


cnt = cnt+1;
CI_comp{cnt}.input{1}.var = {'tt_code'};
CI_comp{cnt}.input{1}.val = [1];
CI_comp{cnt}.input{2}.var = {'run_num'};
CI_comp{cnt}.input{2}.val = 3;


cnt = cnt+1;
CI_comp{cnt}.input{1}.var = {'tt_code'};
CI_comp{cnt}.input{1}.val = [2];
CI_comp{cnt}.input{2}.var = {'run_num'};
CI_comp{cnt}.input{2}.val = 3;

       
compNames = Input2Str(CI_comp);

spec_name = 'STris_20';
subjects = C.subjects.subj2run;
numRows = height(T.rs);

labels = FixStrings(rois,{'.nii','ash_','_'},{'','',' '});


        data =[];
        for cS = 1:numRows
            scoreRow = T.rs(cS,:);
            modelRow = GetModelRow(scoreRow,T);
   
%             try
                newScores = GetImgScores(C,CI_comp,scoreRow.rs_ID,removeOL,1);
                data = newScores;
                figure
             [Dm,Dse]=   StatBarPlot(data,'within',labels,mode,0,[]); %%Mask X Cond
                title([scoreRow.rs_ID,' test, HPF:', num2str(modelRow.hpf)]);
%            end
            hold off
        end
        
        
end 




%% ==================== Local Functions ====================
function tts = Input2Str(comp)

for i = 1:length(comp)
    s = '';
    input=comp{i}.input;
for j = 1: length(input)
    if ~isempty(input{j})
        s = [s,input{j}.var{1}];
        if isnumeric(input{j}.val) || islogical(input{j}.val)
            s = [s,'_',num2str(input{j}.val)','_'];
        elseif iscell(input{j}.val)
            s = [s,'_', input{j}.val{:},'_'];
        end
    end
end
tts{i} = s(1:end-1);
end
end



function C = SetupROIs(rois,C)
C.masks.mask2inc = zeros(1,length(C.masks.maskAll));
for j = 1: length(rois)
    C.masks.mask2inc(strcmp(rois{j},C.masks.maskAll)) = 1;
end
C.masks.mask2inc = logical(C.masks.mask2inc);
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




