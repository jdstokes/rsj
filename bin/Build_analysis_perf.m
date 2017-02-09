function Build_analysis_perf


%% Settings.   General settings
C = Study_greco2;
T = load(fullfile(C.dir.tables,'greco_tables.mat'));
% C.subjects.subj2run= {'S9_A','S16_A'};
 C.subjects.subj2run= C.subjects.subj2inc; 


%% ROIS.    Only run these ROIs
rois ={'ash_left_CA1.nii';'ash_left_DG.nii';'ash_right_CA1.nii';'ash_right_DG.nii'};
C = SetupROIs(rois,C);

%% Behav. Get behav scores
conditions = {'corr all t','incorr all d1 torm'};
 [~, score_behav1] = GetDprime(C,conditions); 

 conditions = {'corr all n','incorr all d1 norm'};
 [~, score_behav2] = GetDprime(C,conditions); 
mu = mean([score_behav1,score_behav2],2);
score_behav_final = (score_behav1 - score_behav2);


%% fMRI. Get fmri scores
rowIndex = 47;
curRow = T.rs(rowIndex,:);
C.scores.rs_ID = curRow.rs_ID;


C.scores.mode = 'rs_pair_runNorm'; %'uni' 'rs_pair' 'rs_pair_runNorm'
C.scores.score_type = 'rsz_runNorm'; %'rs' 'rsz' 'uni_m' 'uni_sd' 'rs_runNorm' 'rsz_runNorm'
C.scores.OL_type = 'global_IQR';



CI_comp{1}.input{1}.var = {'tt_code'};
CI_comp{1}.input{1}.val = 0;
CI_comp{1}.input{2}.var = {'cityTargC'};
CI_comp{1}.input{2}.val = {'T'};

CI_comp{2}.input{1}.var = {'tt_code'};
CI_comp{2}.input{1}.val = 0;
CI_comp{2}.input{2}.var = {'cityTargC'};
CI_comp{2}.input{2}.val = {'M'};

CI_comp{3}.input{1}.var = {'tt_code'};
CI_comp{3}.input{1}.val = 0;
CI_comp{3}.input{2}.var = {'cityTargC'};
CI_comp{3}.input{2}.val = {'N'};

tts = Input2Str(CI_comp);
data_img = GetImgScores(C,CI_comp,C.scores.rs_ID);







end




%% Local functions
function PlotBehav(rois,scoref,scoreb)

for curMask = 1:length(rois)
   
    [R,P] = corr([scoref,scoreb]);
    disp(['r: ',num2str(R(2))])
    
    figure
    scatter(score_img,score_behav_final)
    lsline(gca)
    title(rois{curMask}) 
end
end








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