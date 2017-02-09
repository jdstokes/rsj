function CreateReport_Basic_SD1D2
%% Create Analysis Report - HPF

% Overview
% --------
%
%   CalcMeans.  Calculate mean betas and ResMS.nii.
%   ChooseModels. Decide which models to compare
%   PlotResults. Filter date by Choose models and plot results
%   GetModelID

%% Initialization
close all; clc;
C = Study_greco2;
T = load(fullfile(C.dir.tables,'greco_tables.mat'));
C.subjects.subj2run= C.subjects.subj2inc(1:2);



        rois ={'ash_right_CA1.nii';'ash_right_DG.nii'};
        C = SetupROIs(rois,C);
        

        CI_comp{1}.input{1}.var = {'tt_code'};
        CI_comp{1}.input{1}.val = [0 1 2];
        
        
        spec_name = 'Basic_SD1D2';
        subjects = C.subjects.subj2run;
        numScores = height(T.rs);
        
        
        data =[];
        legend = {};
         hpfList = [];
        for cS = 1:numScores
            scoreRow = T.rs(cS,:);
            modelRow = GetModelRow(scoreRow,T);
            if ~any(strfind(modelRow.spec_name,spec_name))          %Skip models
                continue
            end
            
            
         
                GetImgScoresBasic(C,scoreRow.rs_ID);
                data = [data, newScores];
                legend = [legend;num2str(modelRow.hpf)];
                hpfList = [hpfList,modelRow.hpf];

         
            
            
        end
        [~, I]=sort(hpfList);
        legend = legend(I);
        data= data(:,I);
        
        labels = FixStrings(rois,{'.nii','ash_','_'},{'','',' '});
        figure
        StatBarPlot(data,'within',labels,'mean beta',0,legend);
        title('Mean betas X HPF');
  


end

%% ==================== Analysis All  ====================


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





