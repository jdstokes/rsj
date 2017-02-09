function Build_analysis_report
% Output rsj report
close all




%% Settings.   General settings
C = Study_greco2;
T = load(fullfile(C.dir.tables,'greco_tables.mat'));
% C.subjects.subj2run= {'S9_A','S16_A'};
 C.subjects.subj2run= C.subjects.subj2inc; 


%% ROIS.    Only run these ROIs
rois ={'ash_left_CA1.nii';'ash_left_DG.nii';'ash_right_CA1.nii';'ash_right_DG.nii'};
C = SetupROIs(rois,C);

%% Outliers.   Outlier removal modes
olOpts = {'none' 'global_2SD' 'global_3SD' 'global_IQR'  'voxel_2SD'...
    'voxel_3SD' 'voxel_IQR','old_3SD','old_2SD' };

%%
Family_ST_rs(C,T)


end



%% Analysis families
function Family_ST_rs(C,T)
rowIndex = 47;
curRow = T.rs(rowIndex,:);
C.scores.rs_ID = curRow.rs_ID;


C.scores.mode = 'rs_pair_runNorm'; %'uni' 'rs_pair' 'rs_pair_runNorm'
C.scores.score_type = 'rsz_runNorm'; %'rs' 'rsz' 'uni_m' 'uni_sd' 'rs_runNorm' 'rsz_runNorm'
C.scores.OL_type = 'global_IQR';



STsameVSdiff(C);
STtrainAll(C);
STtrainD1(C);
STtrainD1_pre(C);

STsameVSdiff_correct(C);
STtrainS_correct(C);
STtrainAll_correct(C);
STsameVSdiff_correct(C);
end




%% Analyses
function STtrainS(C)


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
figure('position',[1062 516 560 420]);
GroupBarPlot(C,CI_comp,'within',tts,C.scores.rs_ID);
title(['T0 M0 N0']);
clear CI_comp

end

function STtrainS_correct(C)


CI_comp{1}.input{1}.var = {'tt_code'};
CI_comp{1}.input{1}.val = 0;
CI_comp{1}.input{2}.var = {'cityTargC'};
CI_comp{1}.input{2}.val = {'T'};
CI_comp{1}.input{3}.var = {'acc'};
CI_comp{1}.input{3}.val = 1;

CI_comp{2}.input{1}.var = {'tt_code'};
CI_comp{2}.input{1}.val = 0;
CI_comp{2}.input{2}.var = {'cityTargC'};
CI_comp{2}.input{2}.val = {'M'};
CI_comp{2}.input{3}.var = {'acc'};
CI_comp{2}.input{3}.val = 1;

CI_comp{3}.input{1}.var = {'tt_code'};
CI_comp{3}.input{1}.val = 0;
CI_comp{3}.input{2}.var = {'cityTargC'};
CI_comp{3}.input{2}.val = {'N'};
CI_comp{3}.input{3}.var = {'acc'};
CI_comp{3}.input{3}.val = 1;

tts = Input2Str(CI_comp);
figure('position',[1062 516 560 420]);
GroupBarPlot(C,CI_comp,'within',tts,C.scores.rs_ID);
title(['T0 M0 N0']);
clear CI_comp

end



function STtrainD1(C)


CI_comp{1}.input{1}.var = {'tt_code'};
CI_comp{1}.input{1}.val = 1;
CI_comp{1}.input{2}.var = {'cityTargC'};
CI_comp{1}.input{2}.val = {'T'};


CI_comp{2}.input{1}.var = {'tt_code'};
CI_comp{2}.input{1}.val = 1;
CI_comp{2}.input{2}.var = {'cityTargC'};
CI_comp{2}.input{2}.val = {'N'};

tts = Input2Str(CI_comp);
figure('position',[1062 516 560 420]);
GroupBarPlot(C,CI_comp,'within',tts,C.scores.rs_ID);
title(['TD1 ND1']);
clear CI_comp

end


function STtrainD1_pre(C)


CI_comp{1}.input{1}.var = {'tt_code'};
CI_comp{1}.input{1}.val = 1;
CI_comp{1}.input{2}.var = {'cityTargP'};
CI_comp{1}.input{2}.val = {'T'};


CI_comp{2}.input{1}.var = {'tt_code'};
CI_comp{2}.input{1}.val = 1;
CI_comp{2}.input{2}.var = {'cityTargP'};
CI_comp{2}.input{2}.val = {'N'};

tts = Input2Str(CI_comp);
figure('position',[1062 516 560 420]);
GroupBarPlot(C,CI_comp,'within',tts,C.scores.rs_ID);
title(['TpreD1 NpreD1']);
clear CI_comp

end


function STtrainAll(C)



CI_comp{1}.input{1}.var = {'cityTargC'};
CI_comp{1}.input{1}.val = {'T'};


CI_comp{2}.input{1}.var = {'cityTargC'};
CI_comp{2}.input{1}.val = {'M'};


CI_comp{3}.input{1}.var = {'cityTargC'};
CI_comp{3}.input{1}.val = {'N'};

tts = Input2Str(CI_comp);
figure('position',[1062 516 560 420]);
GroupBarPlot(C,CI_comp,'within',tts,C.scores.rs_ID);
title(['T M N']);

clear CI_comp

end

function STtrainAll_correct(C)

CI_comp{1}.input{1}.var = {'cityTargC'};
CI_comp{1}.input{1}.val = {'T'};
CI_comp{1}.input{2}.var = {'acc'};
CI_comp{1}.input{2}.val = 1;


CI_comp{2}.input{1}.var = {'cityTargC'};
CI_comp{2}.input{1}.val = {'M'};
CI_comp{2}.input{2}.var = {'acc'};
CI_comp{2}.input{2}.val = 1;


CI_comp{3}.input{1}.var = {'cityTargC'};
CI_comp{3}.input{1}.val = {'N'};
CI_comp{3}.input{2}.var = {'acc'};
CI_comp{3}.input{2}.val = 1;

tts = Input2Str(CI_comp);
figure('position',[1062 516 560 420]);
GroupBarPlot(C,CI_comp,'within',tts,C.scores.rs_ID);
title(['Correct only: T M N']);

clear CI_comp

end

function STsameVSdiff(C)


CI_comp{1}.input{1}.var = {'tt_code'};
CI_comp{1}.input{1}.val = 0;
CI_comp{2}.input{1}.var = {'tt_code'};
CI_comp{2}.input{1}.val = 1;
CI_comp{3}.input{1}.var = {'tt_code'};
CI_comp{3}.input{1}.val = 2;
tts = Input2Str(CI_comp);
figure('position',[1062 516 560 420]);
GroupBarPlot(C,CI_comp,'within',tts,C.scores.rs_ID);
title(['S D1 D2']);
clear CI_comp

end

function STsameVSdiff_correct(C)


CI_comp{1}.input{1}.var = {'tt_code'};
CI_comp{1}.input{1}.val = 0;
CI_comp{1}.input{2}.var = {'acc'};
CI_comp{1}.input{2}.val = 1;
CI_comp{2}.input{1}.var = {'tt_code'};
CI_comp{2}.input{1}.val = 1;
CI_comp{2}.input{2}.var = {'acc'};
CI_comp{2}.input{2}.val = 1;
CI_comp{3}.input{1}.var = {'tt_code'};
CI_comp{3}.input{1}.val = 2;
CI_comp{3}.input{2}.var = {'acc'};
CI_comp{3}.input{2}.val = 1;
tts = Input2Str(CI_comp);
figure('position',[1062 516 560 420]);
GroupBarPlot(C,CI_comp,'within',tts,C.scores.rs_ID);
title(['Correct only: S D1 D2']);
clear CI_comp

end



function BasicAll(C)
C.scores.measure = 'MPS(pw)';
C.scores.OL_type = 'none';
figure('position',[1062 516 560 420]);
GroupBarPlot_BasicAll(C,C.scores.rs_ID);
title(['']);
clear CI_comp

end



%% Local functions
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